import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mantra_japa_counter/core/constants/app_constants.dart';
import 'package:mantra_japa_counter/repositories/settings_repository.dart';
import 'package:mantra_japa_counter/models/active_session.dart';
import 'package:mantra_japa_counter/models/mala_sound.dart';
import 'package:mantra_japa_counter/providers/settings_provider.dart';

void main() {
  group('SettingsRepository - languageCode', () {
    late SharedPreferences prefs;
    late SettingsRepository repo;

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      prefs = await SharedPreferences.getInstance();
      repo = SettingsRepository(prefs);
    });

    test('defaults to null when no preference is stored', () {
      expect(repo.languageCode, isNull);
    });

    test('saves and retrieves explicit language codes', () async {
      await repo.setLanguageCode('ml');
      expect(repo.languageCode, equals('ml'));
      expect(prefs.getString(AppConstants.prefsLanguageCodeKey), equals('ml'));

      await repo.setLanguageCode('sa');
      expect(repo.languageCode, equals('sa'));

      await repo.setLanguageCode('en');
      expect(repo.languageCode, equals('en'));
    });

    test('setting null or system clears the preference', () async {
      await repo.setLanguageCode('sa');
      expect(repo.languageCode, equals('sa'));

      await repo.setLanguageCode('system');
      expect(repo.languageCode, isNull);
      expect(prefs.containsKey(AppConstants.prefsLanguageCodeKey), isFalse);

      await repo.setLanguageCode('en');
      expect(repo.languageCode, equals('en'));

      await repo.setLanguageCode(null);
      expect(repo.languageCode, isNull);
      expect(prefs.containsKey(AppConstants.prefsLanguageCodeKey), isFalse);
    });
  });

  group('SettingsNotifier - languageCode', () {
    late SharedPreferences prefs;
    late SettingsRepository repo;
    late SettingsNotifier notifier;

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      prefs = await SharedPreferences.getInstance();
      repo = SettingsRepository(prefs);
      notifier = SettingsNotifier(repo);
    });

    test('initial state has null languageCode', () {
      expect(notifier.state.languageCode, isNull);
    });

    test('setLanguageCode updates state and repository', () async {
      await notifier.setLanguageCode('sa');
      expect(notifier.state.languageCode, equals('sa'));
      expect(repo.languageCode, equals('sa'));

      await notifier.setLanguageCode('system');
      expect(notifier.state.languageCode, isNull);
      expect(repo.languageCode, isNull);
    });
  });

  group('SettingsRepository - malaSound', () {
    late SharedPreferences prefs;
    late SettingsRepository repo;

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      prefs = await SharedPreferences.getInstance();
      repo = SettingsRepository(prefs);
    });

    test('defaults to templeBell when no preference is stored', () {
      expect(repo.malaSound, equals(MalaSound.templeBell));
    });

    test('saves and retrieves chosen mala soundscapes', () async {
      await repo.setMalaSound(MalaSound.singingBowl);
      expect(repo.malaSound, equals(MalaSound.singingBowl));
      expect(
        prefs.getString(AppConstants.prefsMalaSoundKey),
        equals('singing_bowl'),
      );

      await repo.setMalaSound(MalaSound.synthesizedTone);
      expect(repo.malaSound, equals(MalaSound.synthesizedTone));
      expect(
        prefs.getString(AppConstants.prefsMalaSoundKey),
        equals('synthesized_tone'),
      );

      await repo.setMalaSound(MalaSound.templeBell);
      expect(repo.malaSound, equals(MalaSound.templeBell));
      expect(
        prefs.getString(AppConstants.prefsMalaSoundKey),
        equals('temple_bell'),
      );
    });
  });

  group('SettingsNotifier - malaSound', () {
    late SharedPreferences prefs;
    late SettingsRepository repo;
    late SettingsNotifier notifier;

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      prefs = await SharedPreferences.getInstance();
      repo = SettingsRepository(prefs);
      notifier = SettingsNotifier(repo);
    });

    test('initial state has templeBell malaSound', () {
      expect(notifier.state.malaSound, equals(MalaSound.templeBell));
    });

    test('setMalaSound updates state and repository', () async {
      await notifier.setMalaSound(MalaSound.singingBowl);
      expect(notifier.state.malaSound, equals(MalaSound.singingBowl));
      expect(repo.malaSound, equals(MalaSound.singingBowl));
    });
  });

  group('SettingsRepository - dndEnabled & dimmedChantingMode', () {
    late SharedPreferences prefs;
    late SettingsRepository repo;
    late SettingsNotifier notifier;

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      prefs = await SharedPreferences.getInstance();
      repo = SettingsRepository(prefs);
      notifier = SettingsNotifier(repo);
    });

    test('defaults to false for dnd and dimmed mode', () {
      expect(repo.dndEnabled, isFalse);
      expect(repo.dimmedChantingMode, isFalse);
      expect(notifier.state.dndEnabled, isFalse);
      expect(notifier.state.dimmedChantingMode, isFalse);
    });

    test('setDndEnabled updates state and repository', () async {
      await notifier.setDndEnabled(true);
      expect(notifier.state.dndEnabled, isTrue);
      expect(repo.dndEnabled, isTrue);
      expect(prefs.getBool(AppConstants.prefsDndKey), isTrue);

      await notifier.setDndEnabled(false);
      expect(notifier.state.dndEnabled, isFalse);
      expect(repo.dndEnabled, isFalse);
    });

    test('setDimmedChantingMode updates state and repository', () async {
      await notifier.setDimmedChantingMode(true);
      expect(notifier.state.dimmedChantingMode, isTrue);
      expect(repo.dimmedChantingMode, isTrue);
      expect(prefs.getBool(AppConstants.prefsDimmedChantingKey), isTrue);

      await notifier.setDimmedChantingMode(false);
      expect(notifier.state.dimmedChantingMode, isFalse);
      expect(repo.dimmedChantingMode, isFalse);
    });
  });

  group('SettingsRepository - clearAllActiveSessions', () {
    ActiveSession session(String counterId) => ActiveSession(
      sessionId: 's-$counterId',
      counterId: counterId,
      counterName: 'Counter $counterId',
      startTime: 1000,
      tapCount: 10,
      incrementStep: 1,
      lastResumeTimeMs: 1000,
    );

    test('removes every saved session and keeps other settings', () async {
      SharedPreferences.setMockInitialValues({AppConstants.prefsDndKey: true});
      final prefs = await SharedPreferences.getInstance();
      final repo = SettingsRepository(prefs);
      await repo.saveActiveSession(session('a'));
      await repo.saveActiveSession(session('b'));

      await repo.clearAllActiveSessions();

      expect(repo.getAllActiveSessions(), isEmpty);
      expect(repo.dndEnabled, isTrue);
    });
  });

  group('SettingsRepository - notificationPermissionAsked', () {
    test('is false by default and true once set', () async {
      SharedPreferences.setMockInitialValues({});
      final repo = SettingsRepository(await SharedPreferences.getInstance());

      expect(repo.notificationPermissionAsked, isFalse);
      await repo.setNotificationPermissionAsked();
      expect(repo.notificationPermissionAsked, isTrue);
    });
  });

  group('SettingsRepository - Meru pause & pacing hint', () {
    late SharedPreferences prefs;
    late SettingsRepository repo;

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      prefs = await SharedPreferences.getInstance();
      repo = SettingsRepository(prefs);
    });

    test('defaults: Meru pause off at 5 s, pacing hint on', () {
      expect(repo.meruPauseEnabled, isFalse);
      expect(repo.meruPauseSeconds, AppConstants.meruPauseDefaultSeconds);
      expect(repo.pacingHintEnabled, isTrue);
    });

    test('saves and reads the values', () async {
      await repo.setMeruPauseEnabled(true);
      await repo.setMeruPauseSeconds(10);
      await repo.setPacingHintEnabled(false);
      expect(repo.meruPauseEnabled, isTrue);
      expect(repo.meruPauseSeconds, 10);
      expect(repo.pacingHintEnabled, isFalse);
    });

    test('an unknown saved pause length falls back to the default', () async {
      await prefs.setInt(AppConstants.prefsMeruPauseSecondsKey, 42);
      expect(repo.meruPauseSeconds, AppConstants.meruPauseDefaultSeconds);
    });

    test('SettingsNotifier exposes and updates the values', () async {
      final notifier = SettingsNotifier(repo);
      expect(notifier.state.meruPauseEnabled, isFalse);
      expect(notifier.state.pacingHintEnabled, isTrue);

      await notifier.setMeruPauseEnabled(true);
      await notifier.setMeruPauseSeconds(3);
      await notifier.setPacingHintEnabled(false);
      expect(notifier.state.meruPauseEnabled, isTrue);
      expect(notifier.state.meruPauseSeconds, 3);
      expect(notifier.state.pacingHintEnabled, isFalse);
      expect(repo.meruPauseSeconds, 3);
    });
  });
}
