# Update project version info to Flutter 3.47 / Dart 3.13

Implements plan: `plans/20261002_234148_flutter-3-47-version-docs.md`

## What changed

| File | Change |
|------|--------|
| `pubspec.yaml` | `sdk: ^3.12.2` → `sdk: ^3.13.0` (matches what `pubspec.lock` already needs) |
| `CLAUDE.md` | Flutter SDK row → `3.47.6 or higher (pinned — check with flutter --version)`; Dart SDK row → `^3.13.0` |
| `AGENTS.md` | Same two rows as `CLAUDE.md` |
| `README.md` | Prerequisites: Flutter SDK → `3.47.6 or higher`; Dart SDK → `^3.13.0` |
| `docs/implementation_progress.md` | `Flutter SDK: 3.47.6+ / Dart 3.13.5+` |
| `docs/features.md` | Framework row: `sdk ^3.13.0` |

## Why

The app was already migrated to Flutter 3.47.6 / Dart 3.13.5 (`material_ui` / `cupertino_ui`,
AGP 9.1.0, Kotlin 2.4.0, Gradle 9.3.1), but the docs still said 3.44.8 / 3.12.2. The updated
guidelines say each project pins its own versions in its own files, read from
`flutter --version`. The version numbers in the guidelines are only a reference snapshot.

## Not changed

- Android toolchain line in `CLAUDE.md` (already correct).
- No Gradle, Kotlin or Dart code.

## Verification

- `flutter pub get`: OK.
- `flutter analyze`: no issues found.
- `flutter test`: all 216 tests passed.
