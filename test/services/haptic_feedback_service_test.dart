import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mantra_japa_counter/services/haptic_feedback_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const channel = MethodChannel('com.sreerajp.mantrajapacounter/haptic');
  final service = HapticFeedbackService();
  final messenger =
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger;

  tearDown(() => messenger.setMockMethodCallHandler(channel, null));

  test('each feedback event calls its native method', () async {
    final methods = <String>[];
    messenger.setMockMethodCallHandler(channel, (call) async {
      methods.add(call.method);
      return null;
    });

    await service.playMalaTone();
    await service.vibrateMala();
    await service.vibrateDailyGoal();

    expect(methods, ['playMalaTone', 'vibrateMala', 'vibrateDailyGoal']);
  });

  test('feedback never throws on a platform error', () async {
    messenger.setMockMethodCallHandler(channel, (call) async {
      throw PlatformException(code: 'FAIL');
    });

    await expectLater(service.playMalaTone(), completes);
    await expectLater(service.vibrateMala(), completes);
    await expectLater(service.vibrateDailyGoal(), completes);
  });

  test('feedback never throws with no native side', () async {
    await expectLater(service.playMalaTone(), completes);
    await expectLater(service.vibrateMala(), completes);
    await expectLater(service.vibrateDailyGoal(), completes);
  });
  test('levels are sent to the native side; 1.0 by default', () async {
    final calls = <MethodCall>[];
    messenger.setMockMethodCallHandler(channel, (call) async {
      calls.add(call);
      return null;
    });

    await service.playMalaTone();
    await service.playMalaTone(volume: 0.3);
    await service.vibrateMala(strength: 0.5);
    await service.vibrateDailyGoal(strength: 0.6);

    expect(calls[0].arguments, {'volume': 1.0});
    expect(calls[1].arguments, {'volume': 0.3});
    expect(calls[2].arguments, {'strength': 0.5});
    expect(calls[3].arguments, {'strength': 0.6});
  });

  test('tap and undo pulses go to the app, never the system haptics', () async {
    final appCalls = <MethodCall>[];
    final phoneCalls = <MethodCall>[];
    messenger.setMockMethodCallHandler(channel, (call) async {
      appCalls.add(call);
      return null;
    });
    messenger.setMockMethodCallHandler(SystemChannels.platform, (call) async {
      phoneCalls.add(call);
      return null;
    });
    addTearDown(
      () => messenger.setMockMethodCallHandler(SystemChannels.platform, null),
    );

    await service.tapPulse();
    await service.tapPulse(strength: 0.4);
    await service.undoPulse(strength: 0.7);

    expect(phoneCalls, isEmpty);
    expect(appCalls.map((c) => c.method), [
      'vibrateTap',
      'vibrateTap',
      'vibrateUndo',
    ]);
    expect(appCalls[0].arguments, {'strength': 1.0});
    expect(appCalls[1].arguments, {'strength': 0.4});
    expect(appCalls[2].arguments, {'strength': 0.7});
  });

  test('openPhoneVibrationSettings calls the native side', () async {
    final methods = <String>[];
    messenger.setMockMethodCallHandler(channel, (call) async {
      methods.add(call.method);
      return null;
    });

    await service.openPhoneVibrationSettings();

    expect(methods, ['openPhoneVibrationSettings']);
  });

  test('hasAmplitudeControl reads the native answer, false on error', () async {
    messenger.setMockMethodCallHandler(channel, (call) async => true);
    expect(await service.hasAmplitudeControl(), isTrue);

    messenger.setMockMethodCallHandler(channel, (call) async {
      throw PlatformException(code: 'FAIL');
    });
    expect(await service.hasAmplitudeControl(), isFalse);
  });

  test('tap pulse never throws on a platform error', () async {
    messenger.setMockMethodCallHandler(SystemChannels.platform, (call) async {
      throw PlatformException(code: 'FAIL');
    });
    addTearDown(
      () => messenger.setMockMethodCallHandler(SystemChannels.platform, null),
    );

    await expectLater(service.tapPulse(), completes);
    await expectLater(service.undoPulse(), completes);
    await expectLater(service.openPhoneVibrationSettings(), completes);
  });
}
