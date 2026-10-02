# Change log: UI package clean-up, safer UI upgrades, and golden tests

**Plan:** `plans/20261002_235208_ui-packages-cleanup-upgrade-process-goldens.md`

## Part 1 — Clean-ups

- `pubspec.yaml`: removed the unused `cupertino_icons` dependency (no code used
  `CupertinoIcons`). Changed the localization comment to
  "English + Malayalam + Sanskrit".
- `pubspec.lock`: updated by `flutter pub get` (only the `cupertino_icons` entry was
  removed).
- `docs/dependencies.md`: replaced the `cupertino_icons` row with a row for
  `material_ui` / `cupertino_ui`.
- `docs/features.md`: removed the `cupertino_icons` mention.
- `cupertino_ui` and `flutter_localizations` were kept, as planned.

## Part 2 — Safer UI upgrades

- `pubspec.yaml`: pinned `material_ui: 1.5.0` and `cupertino_ui: 1.1.1` (the versions
  already in `pubspec.lock`), with a comment pointing to the upgrade checklist.
- `docs/release_process.md`:
  - New section 16, "UI Package Upgrades", with the upgrade checklist and a note that
    golden images are made and updated on Windows only.
  - New release checklist line in section 8: "Golden tests pass
    (`flutter test --tags golden`)."
- `docs/dependencies.md`: the new row says the packages are pinned and links to the
  checklist.

## Part 3 — Golden tests

- `dart_test.yaml` (new): declares the `golden` tag.
- `test/helpers/golden_helpers.dart` (new):
  - `loadAppFonts()` loads every font in the app's font manifest (EB Garamond, Inter,
    Noto Sans Malayalam, Material icons), so text is drawn with real fonts, not boxes.
  - `setGoldenSurface()` sets a fixed 411 × 891 surface at pixel ratio 1.0.
  - `goldenApp()` wraps a widget in `MaterialApp` with the real app theme,
    `LocaleConfig.localizationsDelegates` and a fixed locale.
- New golden tests (12 images in total):

  | Test file | Images |
  |---|---|
  | `test/widgets/counter_card_golden_test.dart` | normal, locked, goal reached, Malayalam |
  | `test/widgets/temple_mala_circle_golden_test.dart` | empty, part filled, goal reached |
  | `test/widgets/goal_progress_bar_golden_test.dart` | in progress, complete |
  | `test/widgets/passphrase_dialog_golden_test.dart` | export dialog |
  | `test/screens/settings_screen_golden_test.dart` | English, Malayalam |

- Reference images saved in `test/widgets/goldens/` and `test/screens/goldens/`.
- `.gitignore`: added `test/**/failures/`.
- No dark-mode images: the app uses only a light theme.

## Small changes from the plan

- The counter card and goal bar tests show the widget inside a `ListView`, like the real
  counter list. Inside a fixed-height box, the card stretched to fill the whole screen.
- Malayalam images were added for the counter card and settings screen (the plan said
  "Malayalam where text matters").

## Notes found while doing this

- `GoalProgressBar` (`lib/widgets/goal_progress_bar.dart`) is not used anywhere in the
  app. Its golden test was still added as planned. Removing the widget could be a
  separate change.
- In the "goal reached" counter card image, the "✓" after "lifetime · 100%" shows as
  a small box. None of the bundled fonts has this character. On a real phone, Android
  draws it with a system font, but tests have no system fonts. This is expected in the
  test image and is not a bug in the app.
- `dart format --set-exit-if-changed .` reports 26 older files that would be
  reformatted (not files from this change). This was not fixed here.

## Checks

- Images checked by eye: real fonts, icons and Malayalam text render correctly.
- `flutter analyze`: no issues.
- `flutter test`: all 228 tests pass, run twice with the same result.
