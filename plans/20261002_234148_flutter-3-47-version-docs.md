# Update project version info to Flutter 3.47 / Dart 3.13

**Status:** completed

## Files to be changed

| File | Change |
|------|--------|
| `pubspec.yaml` | `environment: sdk: ^3.12.2` → `sdk: ^3.13.0` |
| `CLAUDE.md` | Project identity table: Flutter SDK and Dart SDK rows |
| `AGENTS.md` | Same identity table rows as `CLAUDE.md` |
| `README.md` | Prerequisites table: Flutter SDK and Dart SDK rows |
| `docs/implementation_progress.md` | "Flutter SDK" status line |
| `docs/features.md` | Framework row: `sdk ^3.12.2` → `sdk ^3.13.0` |

## The issue

The app has already moved to Flutter 3.47. The code and build files show this:

- Installed SDK: Flutter 3.47.6 / Dart 3.13.5.
- `pubspec.yaml` already uses `material_ui` / `cupertino_ui` and `flutter_lints ^6.0.0`.
- Android build: AGP 9.1.0, Kotlin 2.4.0, Gradle 9.3.1 (already right in `CLAUDE.md`).
- `pubspec.lock` says the packages need Dart `>=3.13.0` and Flutter `>=3.47.0`.

But the text in the project still says Flutter 3.44.8 / Dart 3.12.2. Also, the
`pubspec.yaml` lower bound `^3.12.2` is wrong: the app cannot build on Dart 3.12, because
`material_ui` and other locked packages need Dart 3.13.

The updated guidelines (`docs/guidelines/CLAUDE_MD_GUIDELINE.md`) also say the Flutter / Dart
rows should show the project's pinned version, taken from `flutter --version`, not a guess.

## Plan for the fix

1. `pubspec.yaml`: set `sdk: ^3.13.0` so the lower bound matches what the app really needs.
2. `CLAUDE.md` and `AGENTS.md` identity table:
   - Flutter SDK → `3.47.6 or higher (pinned — check with flutter --version)`
   - Dart SDK → `^3.13.0` (Dart 3.13.5 ships with Flutter 3.47.6)
3. `README.md` prerequisites: Flutter SDK → `3.47.6 or higher (stable channel)`,
   Dart SDK → `^3.13.0`.
4. `docs/implementation_progress.md`: `Flutter SDK: 3.47.6+ / Dart 3.13.5+`.
5. `docs/features.md`: `sdk ^3.13.0`.
6. Run `flutter pub get`, `flutter analyze`, and `flutter test`. All must pass and analyze
   must be clean.
7. Write a change log in `change_log/` and set this plan to `completed`.

## Out of scope

- The Android toolchain line in `CLAUDE.md` (Java 17, AGP 9.1.0, Gradle 9.3.1, Kotlin 2.4.0)
  is already correct. No change.
- No Gradle, Kotlin or Dart code changes. The app is already migrated.
- Other new guideline items (for example `AI_AGENT_START_HERE.md`, the project profile
  template, `platform_store_readiness.md`) are not handled here. They can be checked in a
  separate plan if wanted.
- No commit unless asked.
