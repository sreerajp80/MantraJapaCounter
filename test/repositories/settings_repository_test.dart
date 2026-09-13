import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mantra_japa_counter/core/constants/app_constants.dart';
import 'package:mantra_japa_counter/repositories/settings_repository.dart';
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
}
