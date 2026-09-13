# Plan: Localize All App Config Fields in English, Malayalam, and Sanskrit

**Status:** Proposed
**Date:** 2026-09-13
**Author:** AI Agent

---

## 1. Objective

Provide complete multilingual coverage (`en`, `ml`, `sa`) in `assets/config/app_config.json` for:
- `appName`
- `details.author`
- `details.aiUsed`
- `details.ideUsed`

This ensures that every field in the About configuration is fully translated in English, Malayalam, and Sanskrit rather than falling back to English proper nouns.

---

## 2. Issues & Current State

1. `appName` in `lib/core/config/app_config.dart` is currently typed as `String`. In `assets/config/app_config.json`, it is a plain English string `"SreerajP MantraJapa Counter"`.
2. `details.author`, `details.aiUsed`, and `details.ideUsed` are plain English strings.
3. In `lib/screens/about_screen.dart`, `_resolveAppName` expects a `String configAppName` rather than resolving via `LocalizedText`.

---

## 3. Files to Change

### Modify:
- `lib/core/config/app_config.dart`:
  - Change `final String appName` to `final LocalizedText appName`.
  - Update `AppConfig.fallback` to use `LocalizedText.plain('SreerajP MantraJapa Counter')` or locale map.
  - In `AppConfig.fromJson`, parse `appName` via `LocalizedText.fromJson(json['appName'], fallback: fallback.appName.resolve('en'))`.
- `assets/config/app_config.json`:
  - Add locale maps for `appName`, `author`, `aiUsed`, and `ideUsed`.
- `lib/screens/about_screen.dart`:
  - Update `_resolveAppName` to accept `LocalizedText configAppName` and active `lang` code.
- `test/core/config/config_service_test.dart`:
  - Update tests to assert `config.appName.resolve('en')`.
- `test/screens/about_screen_test.dart`:
  - Update tests to provide mock `appName` as `LocalizedText` or map and verify proper locale resolution.

---

## 4. Proposed Translations

### `appName`:
- `en`: `"SreerajP MantraJapa Counter"`
- `ml`: `"ശ്രീരാജ് പി മന്ത്രജപ കൗണ്ടർ"`
- `sa`: `"श्रीराज् पि मन्त्रजपगणकः"`

### `author`:
- `en`: `"Sreeraj P"`
- `ml`: `"ശ്രീരാജ് പി"`
- `sa`: `"श्रीराज् पि"`

### `aiUsed`:
- `en`: `"Google Gemini / Anthropic Claude"`
- `ml`: `"ഗൂഗിൾ ജെമിനി / ആന്ത്രോപിക് ക്ലോഡ്"`
- `sa`: `"गूगल जेमिनी / एन्थ्रोपिक क्लाउड"`

### `ideUsed`:
- `en`: `"VS Code / Antigravity IDE"`
- `ml`: `"വിഎസ് കോഡ് / ആന്റിഗ്രാവിറ്റി ഐഡിഇ"`
- `sa`: `"वीएस कोड / एन्टीग्रैविटी आईडीई"`

---

## 5. Verification Plan

- Run `flutter analyze` — verify 0 errors and 0 warnings.
- Run `flutter test` — verify all unit and widget tests pass.
- Run `dart format .` — ensure formatting standards.
