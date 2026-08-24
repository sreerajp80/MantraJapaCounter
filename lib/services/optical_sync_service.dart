import 'dart:convert';
import 'dart:math';

import '../models/optical_sync_frame.dart';

/// Progress state of receiving and reconstructing an optical QR stream.
class OpticalSyncReceiveProgress {
  final String sessionId;
  final int totalOriginalChunks;
  final int totalPayloadLength;
  final int reconstructedChunksCount;
  final double completionPercentage;
  final bool isComplete;
  final String? decodedJsonPayload;

  const OpticalSyncReceiveProgress({
    required this.sessionId,
    required this.totalOriginalChunks,
    required this.totalPayloadLength,
    required this.reconstructedChunksCount,
    required this.completionPercentage,
    required this.isComplete,
    this.decodedJsonPayload,
  });
}

/// Service implementing Luby Transform (LT) Fountain Code encoding and decoding
/// for 100% offline screen-to-camera optical QR stream synchronization.
class OpticalSyncService {
  /// Target chunk size in bytes (clamped to ensure QR codes remain low density and easy to scan)
  static const int chunkSize = 180;

  /// Generate continuous frames (systematic first, followed by LT parity combinations).
  static List<OpticalSyncFrame> generateFrames(
    String jsonPayload, {
    required String sessionId,
    int maxFramesToGenerate = 100,
  }) {
    final payloadBytes = utf8.encode(jsonPayload);
    final totalPayloadLength = payloadBytes.length;
    final totalOriginalChunks = (totalPayloadLength / chunkSize).ceil();

    if (totalOriginalChunks == 0) return [];

    final originalChunks = <int, List<int>>{};
    for (int i = 0; i < totalOriginalChunks; i++) {
      final start = i * chunkSize;
      final end = min(start + chunkSize, totalPayloadLength);
      originalChunks[i] = payloadBytes.sublist(start, end);
    }

    final frames = <OpticalSyncFrame>[];

    // 1. Generate Systematic Frames (0 to totalOriginalChunks - 1)
    for (int i = 0; i < totalOriginalChunks; i++) {
      frames.add(
        OpticalSyncFrame.create(
          sessionId: sessionId,
          frameIndex: i,
          totalOriginalChunks: totalOriginalChunks,
          totalPayloadLength: totalPayloadLength,
          chunkIndices: [i],
          dataBytes: originalChunks[i]!,
        ),
      );
    }

    // 2. Generate LT Parity Fountain Frames (totalOriginalChunks onwards)
    if (totalOriginalChunks > 1) {
      final random = Random(sessionId.hashCode);
      for (
        int fIndex = totalOriginalChunks;
        fIndex < maxFramesToGenerate;
        fIndex++
      ) {
        // Pick degree 2 or 3
        final degree = min(totalOriginalChunks, 2 + random.nextInt(2));
        final selectedIndices = <int>{};
        while (selectedIndices.length < degree) {
          selectedIndices.add(random.nextInt(totalOriginalChunks));
        }

        final indexList = selectedIndices.toList()..sort();
        List<int>? parityBytes;
        for (final idx in indexList) {
          if (parityBytes == null) {
            parityBytes = List<int>.from(originalChunks[idx]!);
          } else {
            parityBytes = _xorBytes(parityBytes, originalChunks[idx]!);
          }
        }

        frames.add(
          OpticalSyncFrame.create(
            sessionId: sessionId,
            frameIndex: fIndex,
            totalOriginalChunks: totalOriginalChunks,
            totalPayloadLength: totalPayloadLength,
            chunkIndices: indexList,
            dataBytes: parityBytes!,
          ),
        );
      }
    }

    return frames;
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

/// State solver for reconstructing payload from incoming LT frames.
class OpticalSyncDecoder {
  String? sessionId;
  int? totalOriginalChunks;
  int? totalPayloadLength;

  final Map<int, List<int>> _resolvedChunks = {};

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
