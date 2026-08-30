# Implementation Plan: Automate Build Metadata and Display Build Date

**Status:** Completed

## 1. Issue Description

Currently:
- The build date is hardcoded in `assets/config/app_config.json` as `"Last Build Date": "24-08-2026"`.
- When running `flutter build apk` or building Android targets, there is no automatic build step that extracts the version from `pubspec.yaml` and the current build date, logs them in the console, and writes them into generated Dart files.

We need to:
1. Automatically update and log `app_version.g.dart` and `build_date.g.dart` whenever building the Android app.
2. Remove the hardcoded `Last Build Date` from `assets/config/app_config.json`.
3. Display the dynamically generated build date in the About screen (`AboutScreen`) with English and Malayalam translations.

## 2. Files to Modify and Create

- `tool/generate_app_version.dart` (New): Dart script to parse `pubspec.yaml` and generate `lib/utils/app_version.g.dart`.
- `tool/generate_build_date.dart` (New): Dart script to generate `lib/utils/build_date.g.dart` containing today's date in `YYYY-MM-DD` format.
- `android/app/build.gradle.kts` (Modify): Register `generateBuildMetadata` Gradle task and wire it to run before `preBuild` and `compileFlutterBuild*`.
- `assets/config/app_config.json` (Modify): Remove hardcoded `"Last Build Date": "24-08-2026"` from `details`.
- `lib/l10n/app_en.arb` (Modify): Add `aboutBuildDate` localized key with `@aboutBuildDate` metadata.
- `lib/l10n/app_ml.arb` (Modify): Add `aboutBuildDate` translation.
- `lib/screens/about_screen.dart` (Modify): Display the build date from `lib/utils/build_date.g.dart`.
- `lib/utils/app_version.g.dart` (New generated): Initial generated version file.
- `lib/utils/build_date.g.dart` (New generated): Initial generated build date file.
- `test/screens/about_screen_test.dart` (New): Widget tests for `AboutScreen` including build date display.

## 3. Step-by-Step Implementation Steps

1. Create `tool/generate_app_version.dart` and `tool/generate_build_date.dart`.
2. Generate initial `lib/utils/app_version.g.dart` and `lib/utils/build_date.g.dart`.
3. Add `generateBuildMetadata` Gradle task in `android/app/build.gradle.kts`.
4. Remove `"Last Build Date"` from `assets/config/app_config.json`.
5. Add `aboutBuildDate` in `lib/l10n/app_en.arb` and `lib/l10n/app_ml.arb`, then run `flutter gen-l10n`.
6. Update `lib/screens/about_screen.dart` to display `aboutBuildDate(kBuildDate)`.
7. Add `test/screens/about_screen_test.dart` to test About screen rendering.
8. Format all Dart files with `dart format .`.
9. Run `flutter analyze` and `flutter test` to verify everything is clean and all tests pass.
10. Test Gradle metadata generation task.
11. Write a change log in `change_log/`.

## 4. Verification

- Run `dart run tool/generate_app_version.dart` and `dart run tool/generate_build_date.dart` to verify console output.
- Run `flutter gen-l10n`.
- Run `flutter analyze` (must have 0 warnings/errors).
- Run `flutter test` (all tests must pass).
- Verify Gradle task triggers during build.
