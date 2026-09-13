# Implementation Plan — Localize Android App Name for Malayalam and Sanskrit

**Status:** completed
**Date:** 2026-09-13
**Slug:** localized-app-name

---

## 1. Summary of the Issue

Currently, the Android app name (shown on the Android home screen, app drawer, and system settings) is hardcoded in English inside `android/app/build.gradle.kts` using `resValue("string", "app_name", ...)`.

Because `resValue` only generates default (unlocalized) strings, Android always displays the English name (`SreerajP MantraJapa Counter` or `SreerajP MantraJapa Counter Dev`), even when the Android device system language is set to Malayalam or Sanskrit.

The user requested that the app name shown in Android depend on the system language:
- If Malayalam (`ml`) -> show Malayalam name (`മന്ത്ര ജപ കൗണ്ടർ`)
- If Sanskrit (`sa`) -> show Sanskrit name (`मन्त्रजपगणकः`)
- If anything other than Malayalam or Sanskrit -> default to English (`SreerajP MantraJapa Counter`)

---

## 2. Proposed Solution

### Android Native Localization
Android uses resource qualifiers for system language localization:
- `values/strings.xml`: Default fallback (English)
- `values-ml/strings.xml`: Malayalam
- `values-sa/strings.xml`: Sanskrit

When the device system language is Malayalam, Android picks `values-ml/strings.xml`.
When the device system language is Sanskrit, Android picks `values-sa/strings.xml`.
When the device system language is anything else, Android falls back to `values/strings.xml` (English).

To support this cleanly with our build flavors (`dev` and `prod`):
1. Remove `resValue("string", "app_name", ...)` from `android/app/build.gradle.kts`.
2. Add flavor-specific resource XML files:
   - For `prod`:
     - `android/app/src/prod/res/values/strings.xml`: `SreerajP MantraJapa Counter`
     - `android/app/src/prod/res/values-ml/strings.xml`: `മന്ത്ര ജപ കൗണ്ടർ`
     - `android/app/src/prod/res/values-sa/strings.xml`: `मन्त्रजपगणकः`
   - For `dev`:
     - `android/app/src/dev/res/values/strings.xml`: `SreerajP MantraJapa Counter Dev`
     - `android/app/src/dev/res/values-ml/strings.xml`: `മന്ത്ര ജപ കൗണ്ടർ Dev`
     - `android/app/src/dev/res/values-sa/strings.xml`: `मन्त्रजपगणकः Dev`

### Flutter Recent Apps Title (`lib/main.dart`)
Update `MaterialApp.router` in `lib/main.dart` from static `title: AppFlavorConfig.appName` to dynamic `onGenerateTitle: (context) => ...` using `AppLocalizations.of(context).appTitle` (appending `Dev` for dev flavor). This ensures the Android Recent Apps / task switcher title also matches the localized app name.

---

## 3. Files to Change

- `android/app/build.gradle.kts` [MODIFY]
- `android/app/src/prod/res/values/strings.xml` [NEW]
- `android/app/src/prod/res/values-ml/strings.xml` [NEW]
- `android/app/src/prod/res/values-sa/strings.xml` [NEW]
- `android/app/src/dev/res/values/strings.xml` [NEW]
- `android/app/src/dev/res/values-ml/strings.xml` [NEW]
- `android/app/src/dev/res/values-sa/strings.xml` [NEW]
- `lib/main.dart` [MODIFY]

---

## 4. Verification Plan

1. Run `flutter analyze` to ensure 0 warnings/errors.
2. Run `flutter test` to ensure all existing unit and widget tests pass.
3. Verify Android build configuration merges resources cleanly for both `dev` and `prod` flavors.
