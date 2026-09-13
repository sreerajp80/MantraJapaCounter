# Change Log — Localize Android App Name for Malayalam and Sanskrit

**Date:** 2026-09-13
**Plan:** `plans/20260913_115300_localized_app_name.md`

---

## 1. Problem

The Android launcher and home screen showed the app name in English only (`SreerajP MantraJapa Counter` or `SreerajP MantraJapa Counter Dev`). This happened even when the user set the phone system language to Malayalam or Sanskrit.

---

## 2. Changes Made

### Android Native Localization
1. **Removed unlocalized Gradle string resource**:
   - In `android/app/build.gradle.kts`, removed `resValue("string", "app_name", ...)` from both `dev` and `prod` product flavors.
2. **Added localized XML string resources for prod flavor**:
   - `android/app/src/prod/res/values/strings.xml`: English / default fallback (`SreerajP MantraJapa Counter`).
   - `android/app/src/prod/res/values-ml/strings.xml`: Malayalam (`മന്ത്ര ജപ കൗണ്ടർ`).
   - `android/app/src/prod/res/values-sa/strings.xml`: Sanskrit (`मन्त्रजपगणकः`).
3. **Added localized XML string resources for dev flavor**:
   - `android/app/src/dev/res/values/strings.xml`: English / default fallback (`SreerajP MantraJapa Counter Dev`).
   - `android/app/src/dev/res/values-ml/strings.xml`: Malayalam (`മന്ത്ര ജപ കൗണ്ടർ Dev`).
   - `android/app/src/dev/res/values-sa/strings.xml`: Sanskrit (`मन्त्रजपगणकः Dev`).

### Dynamic App Switcher Title
- In `lib/main.dart`, changed `MaterialApp.router` from static `title: AppFlavorConfig.appName` to dynamic `onGenerateTitle` using `AppLocalizations.of(context).appTitle` (appending ` Dev` for the dev flavor).

---

## 3. Verification

- `flutter analyze`: Completed with 0 issues.
- `flutter test`: All 114 unit and widget tests passed.
- `gradlew tasks --dry-run`: Completed with exit code 0; verified Android build configurations and resource merging without errors.
