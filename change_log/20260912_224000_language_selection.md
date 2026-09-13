# Change Log: In-App Language Selection (English, Malayalam, Sanskrit)

**Plan reference:** `plans/20260912_223000_language_selection.md`  
**Date:** 2026-09-12 22:40:00  

## Summary of Changes

Added in-app language selection supporting English, Malayalam, and Sanskrit. By default, the app follows the system language: if the system language is Malayalam, it uses Malayalam; if Sanskrit, it uses Sanskrit; if anything else, it uses English. Users can also select English, Malayalam, or Sanskrit directly in the app.

## Key Changes

1. **Localization Files (`lib/l10n/`)**:
   - `lib/l10n/app_en.arb`: Added keys for language selection (`sectionLanguage`, `sectionLanguageSub`, `appLanguage`, `systemDefault`, `englishLanguage`, `malayalamLanguage`, `sanskritLanguage`, `selectLanguageTitle`) with description metadata.
   - `lib/l10n/app_ml.arb`: Added corresponding Malayalam translations.
   - `lib/l10n/app_sa.arb` [NEW]: Added complete Sanskrit translations (in Devanagari script) covering all 452 app keys with matching ICU placeholders.
   - Ran `flutter gen-l10n` to generate `app_localizations_sa.dart`.

2. **Locale Configuration & Fallbacks (`lib/core/locale/locale_config.dart`)**:
   - Added `Locale sanskrit = Locale('sa')` to `supportedLocales`.
   - Updated `resolve(deviceLocale)`: Malayalam (`ml`) -> Malayalam, Sanskrit (`sa`) -> Sanskrit, any other language -> English fallback.
   - Added `resolveAppLocale({languageCode, deviceLocale})`: handles explicit user choice vs system default.
   - Added `FallbackMaterialLocalizationsDelegate` and `FallbackCupertinoLocalizationsDelegate` for Sanskrit (`sa`) so standard Flutter widgets do not crash due to missing Sanskrit Material translations in the Flutter SDK.

3. **Storage & Preferences (`lib/core/constants/app_constants.dart`, `lib/repositories/settings_repository.dart`)**:
   - Added `prefsLanguageCodeKey = 'app_language_code'`.
   - Added `languageCode` getter and `setLanguageCode(String? code)` in `SettingsRepository`.

4. **State Management (`lib/providers/settings_provider.dart`, `lib/main.dart`)**:
   - Added `languageCode` field to `AppSettings` and `setLanguageCode` action to `SettingsNotifier`.
   - Updated `MantraJapaCounterApp` in `lib/main.dart` to watch `settingsNotifierProvider`, bind active `locale`, and install the Sanskrit fallback delegates in `MaterialApp.router`.

5. **Settings UI (`lib/screens/settings/settings_screen.dart`, `lib/screens/settings/language_picker.dart` [NEW])**:
   - Added a "Language" section with an "App language" row in `SettingsScreen`.
   - Created `language_picker.dart` providing a modal bottom sheet allowing users to choose between System Default, English, Malayalam, and Sanskrit.

6. **Tests (`test/core/locale/locale_config_test.dart` [NEW], `test/repositories/settings_repository_test.dart` [NEW], `test/screens/settings_screen_test.dart`)**:
   - Added unit tests for device locale resolution, user preference overrides, and fallback delegates.
   - Added unit tests for settings repository and notifier language persistence.
   - Added widget tests for the Settings screen language row and bottom sheet selection.

## Verification

- `flutter gen-l10n` generated localizations cleanly.
- `flutter analyze` passed with 0 issues.
- `flutter test` passed all 114 unit and widget tests.
