import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mantra_japa_counter/services/qr_decoder_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const channel = MethodChannel('test/qr_decoder');
  const service = QrDecoderService(channel: channel);
  final messenger =
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger;

  tearDown(() => messenger.setMockMethodCallHandler(channel, null));

  Future<String?> decode() => service.decodeFrame(
    bytes: Uint8List(16),
    width: 4,
    height: 4,
    rowStride: 4,
  );

  test('sends the frame and returns the QR text', () async {
    MethodCall? received;
    messenger.setMockMethodCallHandler(channel, (call) async {
      received = call;
      return 'hello';
    });

    expect(await decode(), 'hello');
    expect(received!.method, 'decodeFrame');
    final args = received!.arguments as Map;
    expect(args['width'], 4);
    expect(args['height'], 4);
    expect(args['rowStride'], 4);
    expect(args['bytes'], isA<Uint8List>());
  });

  test('sends the crop rectangle when given', () async {
    MethodCall? received;
    messenger.setMockMethodCallHandler(channel, (call) async {
      received = call;
      return null;
    });

    await service.decodeFrame(
      bytes: Uint8List(16),
      width: 4,
      height: 4,
      rowStride: 4,
      crop: const QrCropRect(left: 1, top: 0, width: 2, height: 3),
    );
    final args = received!.arguments as Map;
    expect(args['cropLeft'], 1);
    expect(args['cropTop'], 0);
    expect(args['cropWidth'], 2);
    expect(args['cropHeight'], 3);
  });

  test('sends no crop keys without a crop', () async {
    MethodCall? received;
    messenger.setMockMethodCallHandler(channel, (call) async {
      received = call;
      return null;
    });

    await decode();
    final args = received!.arguments as Map;
    expect(args.containsKey('cropLeft'), isFalse);
  });

  test('returns null when no QR code is found', () async {
    messenger.setMockMethodCallHandler(channel, (call) async => null);
    expect(await decode(), isNull);
  });

  test('returns null for empty text', () async {
    messenger.setMockMethodCallHandler(channel, (call) async => '');
    expect(await decode(), isNull);
  });

  test('throws QrScannerUnavailableException with no native side', () async {
    // No handler set → MissingPluginException.
    await expectLater(decode(), throwsA(isA<QrScannerUnavailableException>()));
  });
}
