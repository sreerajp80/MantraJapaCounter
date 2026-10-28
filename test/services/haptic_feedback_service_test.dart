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
  test('tap pulse asks the platform for a light haptic', () async {
    final calls = <MethodCall>[];
    messenger.setMockMethodCallHandler(SystemChannels.platform, (call) async {
      calls.add(call);
      return null;
    });
    addTearDown(
      () => messenger.setMockMethodCallHandler(SystemChannels.platform, null),
    );

    await service.tapPulse();

    expect(calls, hasLength(1));
    expect(calls.single.method, 'HapticFeedback.vibrate');
    expect(calls.single.arguments, 'HapticFeedbackType.lightImpact');
  });

  test('tap pulse never throws on a platform error', () async {
    messenger.setMockMethodCallHandler(SystemChannels.platform, (call) async {
      throw PlatformException(code: 'FAIL');
    });
    addTearDown(
      () => messenger.setMockMethodCallHandler(SystemChannels.platform, null),
    );

    await expectLater(service.tapPulse(), completes);
  });
}
