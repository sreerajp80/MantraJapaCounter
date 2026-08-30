# Change Log: Automate Build Metadata and Display Build Date

**Date:** 2026-08-29  
**Plan Reference:** [plans/20260829_050500_automate_build_metadata_and_display_build_date.md](../plans/20260829_050500_automate_build_metadata_and_display_build_date.md)

## Summary of Changes

1. **Build Metadata Generator Scripts**:
   - Created `tool/generate_app_version.dart` to read `version` from `pubspec.yaml` and generate `lib/utils/app_version.g.dart`.
   - Created `tool/generate_build_date.dart` to get current build date and generate `lib/utils/build_date.g.dart`.

2. **Gradle Build Integration**:
   - Registered `generateBuildMetadata` Gradle task in `android/app/build.gradle.kts` hooked before `preBuild` and `compileFlutterBuild*` tasks to automatically run the metadata generation scripts and log updates during Android builds.

3. **Configuration & Localization**:
   - Removed the hardcoded `"Last Build Date"` entry from `assets/config/app_config.json`.
   - Added `aboutBuildDate` localized string in `lib/l10n/app_en.arb` and `lib/l10n/app_ml.arb`, followed by `flutter gen-l10n`.

4. **About Screen UI**:
   - Updated `lib/screens/about_screen.dart` to display the dynamic build date (`kBuildDate`) underneath the version label.

5. **Automated Testing**:
   - Added `test/screens/about_screen_test.dart` to verify About screen rendering including app name, version, and dynamic build date.

## Created and Modified Files

- `tool/generate_app_version.dart` (New)
- `tool/generate_build_date.dart` (New)
- `lib/utils/app_version.g.dart` (New)
- `lib/utils/build_date.g.dart` (New)
- `android/app/build.gradle.kts` (Modified)
- `assets/config/app_config.json` (Modified)
- `lib/l10n/app_en.arb` (Modified)
- `lib/l10n/app_ml.arb` (Modified)
- `lib/screens/about_screen.dart` (Modified)
- `test/screens/about_screen_test.dart` (New)
- `plans/20260829_140500_automate_build_metadata_and_display_build_date.md` (Modified)

## Verification Results

- `gradlew generateBuildMetadata`: Passed (printed `app_version.g.dart updated → 6.10.3+20` and `build_date.g.dart updated → 2026-08-29`).
- `dart format .`: Passed (0 unformatted files).
- `flutter analyze`: Passed (0 issues found).
- `flutter test`: Passed (all 56 unit and widget tests passed).
