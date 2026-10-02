import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mantra_japa_counter/services/screen_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const channel = MethodChannel('test/screen');
  const service = ScreenService(channel: channel);
  final messenger =
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger;

  tearDown(() => messenger.setMockMethodCallHandler(channel, null));

  test('setAppBrightness sends the value', () async {
    MethodCall? received;
    messenger.setMockMethodCallHandler(channel, (call) async {
      received = call;
      return null;
    });

    await service.setAppBrightness(0.4);
    expect(received!.method, 'setAppBrightness');
    expect((received!.arguments as Map)['value'], 0.4);
  });

  test('setAppBrightness sends -1 to follow the system', () async {
    MethodCall? received;
    messenger.setMockMethodCallHandler(channel, (call) async {
      received = call;
      return null;
    });

    await service.setAppBrightness(-1.0);
    expect((received!.arguments as Map)['value'], -1.0);
  });

  test('setAppBrightness does not throw on a platform error', () async {
    messenger.setMockMethodCallHandler(channel, (call) async {
      throw PlatformException(code: 'FAIL');
    });

    await expectLater(service.setAppBrightness(0.5), completes);
  });

  test('setAppBrightness does not throw with no native side', () async {
    // No handler set → MissingPluginException.
    await expectLater(service.setAppBrightness(0.5), completes);
  });

  test('setSendMode sends the on flag', () async {
    MethodCall? received;
    messenger.setMockMethodCallHandler(channel, (call) async {
      received = call;
      return null;
    });

    await service.setSendMode(true);
    expect(received!.method, 'setSendMode');
    expect((received!.arguments as Map)['on'], isTrue);
  });

  test('setSendBrightness sends the value', () async {
    MethodCall? received;
    messenger.setMockMethodCallHandler(channel, (call) async {
      received = call;
      return null;
    });

    await service.setSendBrightness(0.8);
    expect(received!.method, 'setSendBrightness');
    expect((received!.arguments as Map)['value'], 0.8);
  });

  test('setSendBrightness does not throw with no native side', () async {
    await expectLater(service.setSendBrightness(0.8), completes);
  });

  test('getCurrentBrightness returns the native value', () async {
    messenger.setMockMethodCallHandler(channel, (call) async {
      expect(call.method, 'getCurrentBrightness');
      return 0.42;
    });

    expect(await service.getCurrentBrightness(), 0.42);
  });

  test('getCurrentBrightness falls back on errors', () async {
    expect(await service.getCurrentBrightness(fallback: 0.3), 0.3);

    messenger.setMockMethodCallHandler(channel, (call) async {
      throw PlatformException(code: 'FAIL');
    });
    expect(await service.getCurrentBrightness(fallback: 0.3), 0.3);
  });
}
