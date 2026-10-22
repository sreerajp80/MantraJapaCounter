import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mantra_japa_counter/services/dnd_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const channel = MethodChannel('com.sreerajp.mantrajapacounter/haptic');
  final service = DndService();
  final messenger =
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger;

  tearDown(() => messenger.setMockMethodCallHandler(channel, null));

  test('isDndAccessGranted returns the native answer', () async {
    messenger.setMockMethodCallHandler(channel, (call) async {
      expect(call.method, 'isDndAccessGranted');
      return true;
    });

    expect(await service.isDndAccessGranted(), isTrue);
  });

  test('isDndAccessGranted is false with no native side', () async {
    expect(await service.isDndAccessGranted(), isFalse);
  });

  test('setDndEnabled sends the enabled flag', () async {
    MethodCall? received;
    messenger.setMockMethodCallHandler(channel, (call) async {
      received = call;
      return true;
    });

    expect(await service.setDndEnabled(true), isTrue);
    expect(received!.method, 'setDndEnabled');
    expect((received!.arguments as Map)['enabled'], isTrue);
  });

  test('setDndEnabled is false on a platform error', () async {
    messenger.setMockMethodCallHandler(channel, (call) async {
      throw PlatformException(code: 'NO_ACCESS');
    });

    expect(await service.setDndEnabled(true), isFalse);
  });

  test('restoreDnd calls the native side', () async {
    final methods = <String>[];
    messenger.setMockMethodCallHandler(channel, (call) async {
      methods.add(call.method);
      return null;
    });

    await service.restoreDnd();
    expect(methods, ['restoreDnd']);
  });

  test('restoreDnd and openDndSettings never throw', () async {
    messenger.setMockMethodCallHandler(channel, (call) async {
      throw PlatformException(code: 'FAIL');
    });

    await expectLater(service.restoreDnd(), completes);
    await expectLater(service.openDndSettings(), completes);
  });
}
