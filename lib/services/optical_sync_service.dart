import 'dart:convert';
import 'dart:math';

import 'package:mantra_japa_counter/models/optical_sync_frame.dart';

/// Progress state of receiving and reconstructing an optical QR stream.
class OpticalSyncReceiveProgress {
  final String sessionId;
  final int totalOriginalChunks;
  final int totalPayloadLength;
  final int reconstructedChunksCount;

  /// Number of different frames read so far (shows the scan is working even
  /// before a chunk is solved).
  final int framesReceived;
  final double completionPercentage;
  final bool isComplete;
  final String? decodedJsonPayload;

  const OpticalSyncReceiveProgress({
    required this.sessionId,
    required this.totalOriginalChunks,
    required this.totalPayloadLength,
    required this.reconstructedChunksCount,
    this.framesReceived = 0,
    required this.completionPercentage,
    required this.isComplete,
    this.decodedJsonPayload,
  });
}

/// Service implementing Luby Transform (LT) Fountain Code encoding and decoding
/// for 100% offline screen-to-camera optical QR stream synchronization.
class OpticalSyncService {
  /// Target chunk size in bytes. Kept small so each QR code has fewer,
  /// larger squares that a phone camera can focus on and read. Receivers read
  /// the chunk count and length from each frame, so changing this is safe.
  static const int chunkSize = 120;

  /// Returns the first [maxFramesToGenerate] frames of the endless stream
  /// made by [OpticalSyncEncoder].
  static List<OpticalSyncFrame> generateFrames(
    String jsonPayload, {
    required String sessionId,
    int maxFramesToGenerate = 100,
  }) {
    if (jsonPayload.isEmpty) return [];
    final encoder = OpticalSyncEncoder(jsonPayload, sessionId: sessionId);
    final count = max(maxFramesToGenerate, encoder.totalOriginalChunks);
    return [for (int i = 0; i < count; i++) encoder.frameAt(i)];
  }

  /// Bitwise XOR of two byte lists
  static List<int> _xorBytes(List<int> a, List<int> b) {
    final len = max(a.length, b.length);
    final result = List<int>.filled(len, 0);
    for (int i = 0; i < len; i++) {
      final valA = i < a.length ? a[i] : 0;
      final valB = i < b.length ? b[i] : 0;
      result[i] = valA ^ valB;
    }
    return result;
  }
}

/// Makes an endless stream of frames for one payload, on demand.
///
/// - Frames `0 … N-1` are the plain ("systematic") chunks, once, in order.
/// - After that the stream repeats a pattern of 3: one plain chunk (cycling
///   through all chunks), then two mix ("parity") frames.
/// - Each mix frame XORs 2 chunks most of the time, sometimes 3 or 4. Its
///   chunks come from a random generator seeded with the session and the
///   frame number, so the same frame number always gives the same frame and
///   every new number gives a new mix.
///
/// Every frame lists its own chunk numbers, so any receiver of the
/// `AIRQR|LT1` format can use it, whichever frame it starts on.
class OpticalSyncEncoder {
  /// Frame numbers wrap here, so they can never overflow.
  static const int maxFrameIndex = 1000000;

  final String sessionId;
  final int totalPayloadLength;
  final List<List<int>> _chunks;
  final int _seed;

  OpticalSyncEncoder._(
    this.sessionId,
    this.totalPayloadLength,
    this._chunks,
    this._seed,
  );

  /// Splits [jsonPayload] into chunks. Throws [ArgumentError] when empty.
  factory OpticalSyncEncoder(String jsonPayload, {required String sessionId}) {
    final bytes = utf8.encode(jsonPayload);
    if (bytes.isEmpty) {
      throw ArgumentError.value(jsonPayload, 'jsonPayload', 'is empty');
    }
    final chunks = <List<int>>[
      for (
        int start = 0;
        start < bytes.length;
        start += OpticalSyncService.chunkSize
      )
        bytes.sublist(
          start,
          min(start + OpticalSyncService.chunkSize, bytes.length),
        ),
    ];
    return OpticalSyncEncoder._(
      sessionId,
      bytes.length,
      chunks,
      OpticalSyncFrame.computeCrc32(sessionId),
    );
  }

  int get totalOriginalChunks => _chunks.length;

  /// The frame at [index] (wrapped at [maxFrameIndex]).
  OpticalSyncFrame frameAt(int index) {
    final i = index % maxFrameIndex;
    final n = _chunks.length;

    final List<int> indices;
    if (i < n) {
      indices = [i];
    } else if (n == 1) {
      indices = [0];
    } else {
      final k = i - n;
      if (k % 3 == 0) {
        indices = [(k ~/ 3) % n];
      } else {
        indices = _mixIndices(i, n);
      }
    }

    List<int> data = _chunks[indices.first];
    for (final idx in indices.skip(1)) {
      data = OpticalSyncService._xorBytes(data, _chunks[idx]);
    }

    return OpticalSyncFrame.create(
      sessionId: sessionId,
      frameIndex: i,
      totalOriginalChunks: n,
      totalPayloadLength: totalPayloadLength,
      chunkIndices: indices,
      dataBytes: data,
    );
  }

  /// Picks 2 chunks (60%), 3 (30%) or 4 (10%), never more than [n].
  List<int> _mixIndices(int frameIndex, int n) {
    final random = Random((_seed ^ frameIndex) & 0x7fffffff);
    final roll = random.nextInt(10);
    final degree = min(n, roll < 6 ? 2 : (roll < 9 ? 3 : 4));
    final picked = <int>{};
    while (picked.length < degree) {
      picked.add(random.nextInt(n));
    }
    return picked.toList()..sort();
  }
}

/// State solver for reconstructing payload from incoming LT frames.
class OpticalSyncDecoder {
  String? sessionId;
  int? totalOriginalChunks;
  int? totalPayloadLength;

  final Map<int, List<int>> _resolvedChunks = {};

  /// Frame numbers seen so far, for the "frames received" count.
  final Set<int> _seenFrames = {};

  /// Pending unresolved parity equations: Map of frameIndex -> (chunkIndices, dataBytes)
  final Map<int, _ParityEquation> _pendingEquations = {};

  bool get isComplete =>
      totalOriginalChunks != null &&
      _resolvedChunks.length == totalOriginalChunks;

  double get completionPercentage {
    if (totalOriginalChunks == null || totalOriginalChunks == 0) return 0.0;
    return min(1.0, _resolvedChunks.length / totalOriginalChunks!);
  }

  /// Process an incoming frame parsed from QR scan.
  /// Returns updated progress state.
  OpticalSyncReceiveProgress processFrame(OpticalSyncFrame frame) {
    if (sessionId == null) {
      sessionId = frame.sessionId;
      totalOriginalChunks = frame.totalOriginalChunks;
      totalPayloadLength = frame.totalPayloadLength;
    } else if (frame.sessionId != sessionId) {
      // Ignore frames from different sessions
      return currentProgress();
    }

    if (isComplete) return currentProgress();

    // A frame already seen adds nothing new.
    if (!_seenFrames.add(frame.frameIndex)) return currentProgress();

    // 1. Add frame to solver
    _addFrame(frame);

    // 2. Perform belief propagation / Gaussian elimination over GF(2)
    _solvePending();

    return currentProgress();
  }

  void _addFrame(OpticalSyncFrame frame) {
    // Clean indices of already resolved chunks
    final remainingIndices = frame.chunkIndices
        .where((idx) => !_resolvedChunks.containsKey(idx))
        .toList();

    if (remainingIndices.isEmpty) {
      // All chunks in this frame already resolved
      return;
    }

    List<int> currentData = frame.dataBytes;
    for (final idx in frame.chunkIndices) {
      if (_resolvedChunks.containsKey(idx)) {
        currentData = OpticalSyncService._xorBytes(
          currentData,
          _resolvedChunks[idx]!,
        );
      }
    }

    if (remainingIndices.length == 1) {
      final resolvedIdx = remainingIndices.first;
      _resolvedChunks[resolvedIdx] = currentData;
    } else {
      _pendingEquations[frame.frameIndex] = _ParityEquation(
        chunkIndices: remainingIndices.toSet(),
        dataBytes: currentData,
      );
    }
  }

  void _solvePending() {
    bool progressMade = true;

    while (progressMade) {
      progressMade = false;

      final eqKeys = _pendingEquations.keys.toList();
      for (final key in eqKeys) {
        final eq = _pendingEquations[key];
        if (eq == null) continue;

        // Substitute known chunks
        final toRemove = <int>[];
        for (final idx in eq.chunkIndices) {
          if (_resolvedChunks.containsKey(idx)) {
            toRemove.add(idx);
            eq.dataBytes = OpticalSyncService._xorBytes(
              eq.dataBytes,
              _resolvedChunks[idx]!,
            );
          }
        }

        for (final idx in toRemove) {
          eq.chunkIndices.remove(idx);
        }

        if (eq.chunkIndices.isEmpty) {
          _pendingEquations.remove(key);
          progressMade = true;
        } else if (eq.chunkIndices.length == 1) {
          final resolvedIdx = eq.chunkIndices.first;
          _resolvedChunks[resolvedIdx] = eq.dataBytes;
          _pendingEquations.remove(key);
          progressMade = true;
        }
      }
    }
  }

  /// Reset decoder state
  void reset() {
    sessionId = null;
    totalOriginalChunks = null;
    totalPayloadLength = null;
    _resolvedChunks.clear();
    _pendingEquations.clear();
    _seenFrames.clear();
  }

  OpticalSyncReceiveProgress currentProgress() {
    String? jsonPayload;
    if (isComplete && totalPayloadLength != null) {
      final concatenatedBytes = <int>[];
      for (int i = 0; i < totalOriginalChunks!; i++) {
        final chunk = _resolvedChunks[i];
        if (chunk != null) {
          concatenatedBytes.addAll(chunk);
        }
      }
      final trimmedBytes = concatenatedBytes.sublist(0, totalPayloadLength!);
      jsonPayload = utf8.decode(trimmedBytes, allowMalformed: true);
    }

    return OpticalSyncReceiveProgress(
      sessionId: sessionId ?? '',
      totalOriginalChunks: totalOriginalChunks ?? 0,
      totalPayloadLength: totalPayloadLength ?? 0,
      reconstructedChunksCount: _resolvedChunks.length,
      framesReceived: _seenFrames.length,
      completionPercentage: completionPercentage,
      isComplete: isComplete,
      decodedJsonPayload: jsonPayload,
    );
  }
}

class _ParityEquation {
  Set<int> chunkIndices;
  List<int> dataBytes;

  _ParityEquation({required this.chunkIndices, required this.dataBytes});
}
