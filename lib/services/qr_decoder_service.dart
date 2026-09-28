import 'package:flutter/services.dart';

/// Thrown when there is no native QR decoder on this platform.
class QrScannerUnavailableException implements Exception {
  const QrScannerUnavailableException();

  @override
  String toString() => 'QrScannerUnavailableException';
}

/// Reads a QR code from one camera frame through the Android host, which
/// uses the ZXing core library.
///
/// ZXing is plain Java maths with no network code and no Play Services, so
/// decoding stays 100% on the device.
class QrDecoderService {
  const QrDecoderService({this.channel = _defaultChannel});

  static const MethodChannel _defaultChannel = MethodChannel(
    'com.sreerajp.mantrajapacounter/qr_decoder',
  );

  final MethodChannel channel;

  /// Decodes the brightness ("Y") plane of one camera frame.
  ///
  /// [rowStride] is the number of bytes per row, which can be larger than
  /// [width] because of padding. When [crop] is given, only that part of the
  /// frame is searched, which is much faster. Returns the QR text, or `null`
  /// when the frame holds no readable QR code.
  Future<String?> decodeFrame({
    required Uint8List bytes,
    required int width,
    required int height,
    required int rowStride,
    QrCropRect? crop,
  }) async {
    try {
      final text = await channel.invokeMethod<String>(
        'decodeFrame',
        <String, dynamic>{
          'bytes': bytes,
          'width': width,
          'height': height,
          'rowStride': rowStride,
          if (crop != null) ...{
            'cropLeft': crop.left,
            'cropTop': crop.top,
            'cropWidth': crop.width,
            'cropHeight': crop.height,
          },
        },
      );
      if (text == null || text.isEmpty) return null;
      return text;
    } on MissingPluginException catch (_) {
      throw const QrScannerUnavailableException();
    }
  }
}

/// A rectangle inside a camera frame, in frame pixels.
class QrCropRect {
  final int left;
  final int top;
  final int width;
  final int height;

  const QrCropRect({
    required this.left,
    required this.top,
    required this.width,
    required this.height,
  });
}
