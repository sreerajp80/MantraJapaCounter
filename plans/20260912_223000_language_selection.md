# Plan: In-App Language Selection (English, Malayalam, Sanskrit)

**Status:** completed

Date: 2026-09-12 22:30:00
Slug: language-selection

## Summary of the Issue

The app currently follows the device language strictly with no in-app language picker: if the device is in Malayalam, it displays Malayalam; otherwise, it falls back to English. There is no Sanskrit (`sa`) localization file, and no way for the user to switch languages within the app.

The user requested:
1. By default, the app adheres to the system language.
2. If the system language is anything other than Malayalam or Sanskrit, it defaults to English.
3. Users can switch between English, Malayalam, and Sanskrit inside the app.

## Proposed Solution

1. **Translations**:
   - Add new translation keys in `lib/l10n/app_en.arb` for language selection (`sectionLanguage`, `sectionLanguageSub`, `appLanguage`, `systemDefault`, `englishLanguage`, `malayalamLanguage`, `sanskritLanguage`, `selectLanguageTitle`).
   - Add matching translations in `lib/l10n/app_ml.arb`.
   - Create `lib/l10n/app_sa.arb` with all 444+ keys translated into Sanskrit (Devanagari script), preserving all ICU placeholder tokens.
   - Run `flutter gen-l10n` to generate Sanskrit localization bindings.

2. **Locale Resolution & Fallback Delegates**:
   - Update `lib/core/locale/locale_config.dart`:
     - Add `Locale sanskrit = Locale('sa')` to supported locales.
     - Implement system language resolution: Malayalam (`ml`) -> `ml`, Sanskrit (`sa`) -> `sa`, any other system language -> `en`.
     - Implement user preference resolution: explicit language code ('en', 'ml', 'sa') overrides system language; 'system' or null adheres to system language.
     - Provide `FallbackMaterialLocalizationsDelegate` and `FallbackCupertinoLocalizationsDelegate` for `sa` because Flutter's bundled `flutter_localizations` does not include default Material translations for Sanskrit.
   - Update `lib/core/constants/app_constants.dart` with `prefsLanguageCodeKey = 'app_language_code'`.

3. **State Management & Persistence**:
   - `lib/repositories/settings_repository.dart`: add `languageCode` getter and `setLanguageCode(String? code)` setter in `SharedPreferences`.
   - `lib/providers/settings_provider.dart`: add `languageCode` field to `AppSettings` and `setLanguageCode` action to `SettingsNotifier`.
   - `lib/main.dart`: update `MantraJapaCounterApp` to watch `settingsNotifierProvider` and apply the active locale to `MaterialApp.router`.

4. **Settings UI**:
   - In `lib/screens/settings/settings_screen.dart`, add a Language section with a row showing the active language.
   - Tapping opens a bottom sheet with radio options for System Default, English, Malayalam, and Sanskrit, styled consistently with the Temple theme.
   - Selecting an option updates the setting immediately.

5. **Tests**:
   - Add unit tests in `test/core/locale/locale_config_test.dart`.
   - Add settings persistence tests in `test/repositories/settings_repository_test.dart`.
   - Update settings screen tests in `test/screens/settings_screen_test.dart`.

## Files to Change

- `lib/core/constants/app_constants.dart`
- `lib/core/locale/locale_config.dart`
- `lib/repositories/settings_repository.dart`
- `lib/providers/settings_provider.dart`
- `lib/l10n/app_en.arb`
- `lib/l10n/app_ml.arb`
- `lib/l10n/app_sa.arb` [NEW]
- `lib/main.dart`
- `lib/screens/settings/settings_screen.dart`
- `test/core/locale/locale_config_test.dart` [NEW]
- `test/repositories/settings_repository_test.dart`
- `test/screens/settings_screen_test.dart`

## Verification Plan

- Run `flutter gen-l10n` to ensure all 3 locales compile cleanly.
- Run `flutter analyze` to ensure zero warnings or errors.
- Run `flutter test` to ensure all tests pass.
- Verify locale resolution:
  - System default with Malayalam device locale resolves to Malayalam.
  - System default with Sanskrit device locale resolves to Sanskrit.
  - System default with any other device locale (English, French, Hindi, etc.) resolves to English.
  - Explicit selection of English, Malayalam, or Sanskrit displays the respective language regardless of device locale.
