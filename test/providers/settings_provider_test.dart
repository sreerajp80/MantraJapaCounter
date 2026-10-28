import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mantra_japa_counter/core/constants/app_constants.dart';
import 'package:mantra_japa_counter/providers/settings_provider.dart';
import 'package:mantra_japa_counter/repositories/settings_repository.dart';
import 'package:mantra_japa_counter/services/screen_service.dart';

import '../helpers/fake_notification_service.dart';

/// Records brightness values instead of calling the native side.
class _FakeScreenService extends ScreenService {
  final List<double> applied = [];

  @override
  Future<void> setAppBrightness(double value) async => applied.add(value);
}

void main() {
  group('SettingsNotifier - screen brightness', () {
    late _FakeScreenService screen;

    setUp(() => screen = _FakeScreenService());

    Future<SettingsRepository> repoWith(Map<String, Object> values) async {
      SharedPreferences.setMockInitialValues(values);
      return SettingsRepository(await SharedPreferences.getInstance());
    }

    test('applies the saved brightness on creation', () async {
      final repo = await repoWith({AppConstants.prefsBrightnessKey: 0.3});
      SettingsNotifier(repo, null, screen);
      expect(screen.applied, [0.3]);
    });

    test('applies "follow system" (-1) when nothing is saved', () async {
      final repo = await repoWith({});
      SettingsNotifier(repo, null, screen);
      expect(screen.applied, [-1.0]);
    });

    test('setScreenBrightness saves and applies the value', () async {
      final repo = await repoWith({});
      final notifier = SettingsNotifier(repo, null, screen);

      await notifier.setScreenBrightness(0.8);
      expect(repo.screenBrightness, 0.8);
      expect(notifier.state.screenBrightness, 0.8);
      expect(screen.applied.last, 0.8);

      await notifier.setScreenBrightness(-1.0);
      expect(repo.screenBrightness, -1.0);
      expect(screen.applied.last, -1.0);
    });
  });

  group('SettingsNotifier - tap vibration', () {
    test('starts off and setTapVibrationEnabled saves the value', () async {
      SharedPreferences.setMockInitialValues({});
      final repo = SettingsRepository(await SharedPreferences.getInstance());
      final notifier = SettingsNotifier(repo);
      expect(notifier.state.tapVibrationEnabled, isFalse);

      await notifier.setTapVibrationEnabled(true);
      expect(notifier.state.tapVibrationEnabled, isTrue);
      expect(repo.tapVibrationEnabled, isTrue);

      // The existing Vibration switch is separate.
      expect(notifier.state.vibrationEnabled, isTrue);
    });
  });

  group('SettingsNotifier - daily reminder', () {
    late FakeNotificationService notifications;
    late SettingsRepository repo;

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      repo = SettingsRepository(await SharedPreferences.getInstance());
      notifications = FakeNotificationService();
    });

    SettingsNotifier build() => SettingsNotifier(
      repo,
      () => notifications,
      null,
      const FakeTimeZoneService(),
    );

    test('turning it on asks permission, saves and schedules', () async {
      final notifier = build();

      expect(await notifier.setDailyReminderEnabled(true), isTrue);
      expect(notifications.permissionRequests, 1);
      expect(repo.dailyReminderEnabled, isTrue);
      expect(notifier.state.dailyReminderEnabled, isTrue);
      expect(notifications.scheduled.single.minutes, 360);
      expect(notifications.scheduled.single.timeZoneId, 'Asia/Kolkata');
    });

    test('turning it off saves and cancels', () async {
      final notifier = build();
      await notifier.setDailyReminderEnabled(true);

      expect(await notifier.setDailyReminderEnabled(false), isTrue);
      expect(repo.dailyReminderEnabled, isFalse);
      expect(notifier.state.dailyReminderEnabled, isFalse);
      expect(notifications.cancelReminderCalls, 1);
    });

    test('a refused permission leaves it off and schedules nothing', () async {
      notifications.permissionGranted = false;
      final notifier = build();

      expect(await notifier.setDailyReminderEnabled(true), isFalse);
      expect(repo.dailyReminderEnabled, isFalse);
      expect(notifier.state.dailyReminderEnabled, isFalse);
      expect(notifications.scheduled, isEmpty);
    });

    test('changing the time schedules again when it is on', () async {
      final notifier = build();
      await notifier.setDailyReminderEnabled(true);

      await notifier.setDailyReminderTime(20 * 60 + 45);
      expect(repo.dailyReminderMinutes, 20 * 60 + 45);
      expect(notifier.state.dailyReminderMinutes, 20 * 60 + 45);
      expect(notifications.scheduled.last.minutes, 20 * 60 + 45);
    });

    test('changing the time while off only saves it', () async {
      final notifier = build();

      await notifier.setDailyReminderTime(7 * 60);
      expect(repo.dailyReminderMinutes, 7 * 60);
      expect(notifications.scheduled, isEmpty);
    });

    test('changing the language schedules again in that language', () async {
      final notifier = build();
      await notifier.setDailyReminderEnabled(true);

      await notifier.setLanguageCode('ml');
      expect(notifications.scheduled.last.languageCode, 'ml');
    });

    test('sync schedules only when it is on', () async {
      await build().syncDailyReminder();
      expect(notifications.scheduled, isEmpty);

      await repo.setDailyReminderEnabled(true);
      await build().syncDailyReminder();
      expect(notifications.scheduled, hasLength(1));
    });

    test('uses UTC when no time-zone service is given', () async {
      await repo.setDailyReminderEnabled(true);
      await SettingsNotifier(repo, () => notifications).syncDailyReminder();
      expect(notifications.scheduled.single.timeZoneId, 'UTC');
    });
  });
}
