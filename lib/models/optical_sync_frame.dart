import 'dart:convert';

/// Represents a frame in the Optical Air-Gap QR stream (AIRQR|LT1 protocol).
///
/// Frames can be systematic (direct original chunk) or Fountain Parity (XOR combination over GF(2)).
class OpticalSyncFrame {
  static const String protocolHeader = 'AIRQR|LT1';

  final int version;
  final String sessionId;
  final int frameIndex;
  final int totalOriginalChunks;
  final int totalPayloadLength;
  final List<int> chunkIndices;
  final String dataBase64;
  final int crc32;

  const OpticalSyncFrame({
    required this.version,
    required this.sessionId,
    required this.frameIndex,
    required this.totalOriginalChunks,
    required this.totalPayloadLength,
    required this.chunkIndices,
    required this.dataBase64,
    required this.crc32,
  });

  /// Is this a systematic frame (representing a single raw original chunk index)?
  bool get isSystematic =>
      chunkIndices.length == 1 && chunkIndices.first == frameIndex;

  /// Decode binary data from Base64 string
  List<int> get dataBytes => base64Decode(dataBase64);

  /// Serialize frame to a compact JSON string for QR code generation
  String serialize() {
    final map = {
      'v': version,
      's': sessionId,
      'i': frameIndex,
      't': totalOriginalChunks,
      'l': totalPayloadLength,
      'p': chunkIndices,
      'd': dataBase64,
      'c': crc32,
    };
    return '$protocolHeader|${jsonEncode(map)}';
  }

  /// Parse frame from QR code text string. Returns null if malformed or invalid CRC32.
  static OpticalSyncFrame? parse(String rawText) {
    try {
      if (!rawText.startsWith('$protocolHeader|')) return null;
      final jsonPart = rawText.substring(protocolHeader.length + 1);
      final Map<String, dynamic> map = jsonDecode(jsonPart);

      final version = map['v'] as int?;
      final sessionId = map['s'] as String?;
      final frameIndex = map['i'] as int?;
      final totalOriginalChunks = map['t'] as int?;
      final totalPayloadLength = map['l'] as int?;
      final chunkIndices = (map['p'] as List?)?.cast<int>();
      final dataBase64 = map['d'] as String?;
      final crc32 = map['c'] as int?;

      if (version == null ||
          sessionId == null ||
          frameIndex == null ||
          totalOriginalChunks == null ||
          totalPayloadLength == null ||
          chunkIndices == null ||
          dataBase64 == null ||
          crc32 == null) {
        return null;
      }

      // Verify CRC32 checksum
      final expectedCrc = computeCrc32('$sessionId|$frameIndex|$dataBase64');
      if (crc32 != expectedCrc) {
        return null;
      }

      return OpticalSyncFrame(
        version: version,
        sessionId: sessionId,
        frameIndex: frameIndex,
        totalOriginalChunks: totalOriginalChunks,
        totalPayloadLength: totalPayloadLength,
        chunkIndices: chunkIndices,
        dataBase64: dataBase64,
        crc32: crc32,
      );
    } catch (_) {
      return null;
    }
  }

  /// Helper factory to build a frame with computed CRC32 checksum
  static OpticalSyncFrame create({
    int version = 1,
    required String sessionId,
    required int frameIndex,
    required int totalOriginalChunks,
    required int totalPayloadLength,
    required List<int> chunkIndices,
    required List<int> dataBytes,
  }) {
    final dataBase64 = base64Encode(dataBytes);
    final crc32 = computeCrc32('$sessionId|$frameIndex|$dataBase64');
    return OpticalSyncFrame(
      version: version,
      sessionId: sessionId,
      frameIndex: frameIndex,
      totalOriginalChunks: totalOriginalChunks,
      totalPayloadLength: totalPayloadLength,
      chunkIndices: chunkIndices,
      dataBase64: dataBase64,
      crc32: crc32,
    );
  }

  /// Standard IEEE 802.3 CRC32 implementation
  static int computeCrc32(String input) {
    final bytes = utf8.encode(input);
    int crc = 0xFFFFFFFF;
    for (final byte in bytes) {
      crc ^= byte;
      for (int i = 0; i < 8; i++) {
        if ((crc & 1) != 0) {
          crc = (crc >> 1) ^ 0xEDB88320;
        } else {
          crc >>= 1;
        }
      }
    }
    return (crc ^ 0xFFFFFFFF) & 0xFFFFFFFF;
  }
}
