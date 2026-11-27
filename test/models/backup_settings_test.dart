import 'package:flutter_test/flutter_test.dart';
import 'package:mantra_japa_counter/models/backup_settings.dart';

void main() {
  group('BackupSettings JSON', () {
    test('round-trips every field', () {
      const s = BackupSettings(
        screenBrightness: 0.5,
        dailyGoalNotificationsEnabled: false,
        lifetimeGoalNotificationsEnabled: true,
        malaNotificationsEnabled: true,
        malaSound: 'conch',
        vibrationEnabled: false,
        tapVibrationEnabled: true,
        feedbackVolumePercent: 40,
        vibrationStrengthPercent: 70,
        languageCode: 'sa',
        dndEnabled: true,
        dimmedChantingMode: true,
        meruPauseEnabled: true,
        meruPauseSeconds: 10,
        meruPauseMode: 'taps',
        meruPauseTaps: 3,
        pacingHintEnabled: false,
        dailyReminderEnabled: true,
        dailyReminderMinutes: 300,
      );

      final r = BackupSettings.fromJson(s.toJson());

      expect(r.toJson(), s.toJson());
      expect(r.screenBrightness, 0.5);
      expect(r.meruPauseTaps, 3);
      expect(r.languageCode, 'sa');
    });

    test('writes only the fields that are set', () {
      const s = BackupSettings(meruPauseEnabled: true);
      expect(s.toJson(), {'meruPauseEnabled': true});
    });

    test('missing fields read as null', () {
      final s = BackupSettings.fromJson(const {});
      expect(s.meruPauseEnabled, isNull);
      expect(s.languageCode, isNull);
      expect(s.dailyReminderMinutes, isNull);
    });

    test('unknown fields are ignored', () {
      final s = BackupSettings.fromJson(const {
        'pacingHintEnabled': true,
        'someFutureSetting': 42,
      });
      expect(s.pacingHintEnabled, isTrue);
    });

    test('a whole-number double is read as an int', () {
      final s = BackupSettings.fromJson(const {'meruPauseTaps': 4.0});
      expect(s.meruPauseTaps, 4);
    });

    test('a field with the wrong type throws', () {
      expect(
        () => BackupSettings.fromJson(const {'vibrationEnabled': 'yes'}),
        throwsA(anything),
      );
      expect(
        () => BackupSettings.fromJson(const {'meruPauseTaps': 2.5}),
        throwsA(isA<FormatException>()),
      );
    });
  });
}
