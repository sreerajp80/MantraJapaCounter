# Plan: UI package clean-up, safer UI upgrades, and golden tests

**Status:** completed

## Background

The app now gets its Material and Cupertino widgets from the `material_ui` and
`cupertino_ui` packages, not from the Flutter SDK (see
`plans/20261002_202809_migrate-material-ui-packages.md`). This means Material can now
change every week through `flutter pub upgrade`, without a Flutter SDK upgrade. This plan
covers three follow-up items:

1. Remove a dependency we no longer use.
2. Add a documented, safe way to upgrade the UI packages.
3. Add golden (screenshot) tests that catch visual changes after an upgrade.

## Part 1 — Quick clean-ups

### The issue

- `cupertino_icons` is listed in `pubspec.yaml`, but no Dart file in `lib/` or `test/`
  uses `CupertinoIcons`. It adds an unused icon font to the app.
- Its entries in `docs/dependencies.md` and `docs/features.md` are out of date (they say
  `^1.0.8` / v1.0.8, but `pubspec.yaml` has `^2.0.0`).
- The comment `# Localization (English + Malayalam)` in `pubspec.yaml` is out of date.
  The app also ships Sanskrit.

### The fix

- Remove `cupertino_icons` (and its comment) from `pubspec.yaml`, then run
  `flutter pub get` so `pubspec.lock` is updated.
- Remove the `cupertino_icons` row/mention from `docs/dependencies.md` and
  `docs/features.md`.
- Change the comment to `# Localization (English + Malayalam + Sanskrit)`.
- **Keep `cupertino_ui`.** It is still needed for the Sanskrit fallback delegates in
  `lib/l10n/sa_material_localizations.dart`.
- **Keep `flutter_localizations`.** The generated `lib/l10n/app_localizations.dart`
  imports it, and the widgets-level delegate still lives there. The comments inside the
  generated file are not ours to edit.

## Part 2 — Safer, separate UI upgrades (process)

### The issue

There is no written rule for how to upgrade `material_ui` / `cupertino_ui`. With
`^1.5.0`, any `flutter pub upgrade` can quietly bring in a newer Material version on the
same day as other upgrades. If the look changes, it is hard to tell why.

### The fix

1. **Pin exact versions** in `pubspec.yaml`:
   - `material_ui: 1.5.0`
   - `cupertino_ui: 1.1.1`

   A comment above them will say: "Pinned on purpose. Upgrade only via the UI package
   upgrade checklist in docs/release_process.md." (The exact versions will be the ones
   in `pubspec.lock` at the time of the change. If they are newer than above, I will use
   the lock-file versions and note it in the change log.)
2. **Add a new section to `docs/release_process.md`**: "UI package upgrades
   (material_ui / cupertino_ui)", with this checklist:
   - Upgrade the UI packages in their own change. Never in the same change as a Flutter
     SDK upgrade or other package upgrades.
   - Read the package changelog on pub.dev, and note any visual or breaking changes in
     the plan.
   - Change the pinned version in `pubspec.yaml`, then run `flutter pub get`.
   - Run `flutter analyze` (0 warnings) and `flutter test`.
   - If golden tests fail, look at the failure images in `test/**/failures/`. If the
     change is expected, run `flutter test --update-goldens --tags golden` and commit the
     new images. If not, stay on the old version.
   - Check by hand on a device: counting screen, counter list, bottom sheets, dialogs,
     settings, and in all three languages (en, ml, sa).
3. **Add one line to the release checklist** (§8 "Code And Quality") in
   `docs/release_process.md`: "Golden tests pass (`flutter test --tags golden`)."
4. **Update `docs/dependencies.md`**: change the `material_ui` / `cupertino_ui` rows to
   say they are pinned, and point to the new checklist.

## Part 3 — Golden tests

A golden test draws a widget in a test and compares it, pixel by pixel, to a saved
reference image (the "golden" file). If Material changes how something looks, the test
fails and shows the difference.

### The issue

The project has widget tests but no golden tests. A visual change from a Material upgrade
would only be found by hand.

### The fix

**a) Real fonts in tests.** By default, Flutter tests draw text as plain boxes, which
hides font and spacing changes. A new test helper will load the app's own fonts from
`assets/fonts/` (EB Garamond, Inter, Noto Sans Malayalam) and the Material icon font, so
the golden images look like the real app.

**b) Test setup files.**
- `dart_test.yaml` (new, project root) — declares a `golden` tag so golden tests can be
  run alone (`flutter test --tags golden`) or skipped.
- `test/helpers/golden_helpers.dart` (new) — font loading, plus a helper that wraps a
  widget in `MaterialApp` with the app theme, `LocaleConfig.localizationsDelegates`, a
  fixed locale, and a fixed phone-sized surface (for example 411 × 891, pixel ratio 1.0)
  so every run is the same.

**c) First set of golden tests** (one light-theme image each, English, plus Malayalam
where text matters):

| Test file (new) | What it captures |
|---|---|
| `test/widgets/counter_card_golden_test.dart` | `CounterCard` — normal, locked, and goal-reached states |
| `test/widgets/temple_mala_circle_golden_test.dart` | `TempleMalaCircle` — empty, part-filled, goal reached |
| `test/widgets/goal_progress_bar_golden_test.dart` | `GoalProgressBar` — in progress and complete |
| `test/widgets/passphrase_dialog_golden_test.dart` | Export passphrase dialog |
| `test/screens/settings_screen_golden_test.dart` | Settings screen (reusing the setup from `settings_screen_test.dart`) |

Golden images are saved next to each test in a `goldens/` folder and committed to git.

The app uses only a light theme (`themeMode: ThemeMode.light` in `lib/main.dart`), so
there are no dark-mode images.

**d) `.gitignore`** — add `test/**/failures/` so the "difference" images from failed
runs are never committed.

**e) Note on platforms.** Text drawing differs a little between Windows, macOS and
Linux. The golden images will be made on this Windows machine and should be updated on
Windows only. I will write this in `docs/release_process.md` and in a comment in
`golden_helpers.dart`.

**Out of scope for now:** the counting screen. It needs timers, sound, vibration and
database providers to be faked, which is a bigger job. It can come in a later plan once
this setup is proven.

## Files to be changed

| File | Change |
|---|---|
| `pubspec.yaml` | Remove `cupertino_icons`; pin `material_ui` / `cupertino_ui`; fix localization comment |
| `pubspec.lock` | Updated by `flutter pub get` |
| `docs/dependencies.md` | Remove `cupertino_icons`; mark UI packages as pinned |
| `docs/features.md` | Remove `cupertino_icons` mention |
| `docs/release_process.md` | New "UI package upgrades" section; golden test line in §8; Windows-only golden note |
| `.gitignore` | Ignore `test/**/failures/` |
| `dart_test.yaml` (new) | Declare the `golden` tag |
| `test/helpers/golden_helpers.dart` (new) | Font loading + golden test wrapper |
| `test/widgets/counter_card_golden_test.dart` (new) | Golden test |
| `test/widgets/temple_mala_circle_golden_test.dart` (new) | Golden test |
| `test/widgets/goal_progress_bar_golden_test.dart` (new) | Golden test |
| `test/widgets/passphrase_dialog_golden_test.dart` (new) | Golden test |
| `test/screens/settings_screen_golden_test.dart` (new) | Golden test |
| `test/widgets/goldens/*.png`, `test/screens/goldens/*.png` (new) | Reference images |

No file under `lib/` changes. No new packages are added (golden tests use
`flutter_test`, which we already have). No network code is added.

## Steps

1. Part 1: edit `pubspec.yaml`, run `flutter pub get`, update the two docs.
2. Run `flutter analyze` and `flutter test` to confirm nothing broke.
3. Part 2: pin versions, update `docs/release_process.md` and `docs/dependencies.md`.
4. Part 3: add `dart_test.yaml`, `golden_helpers.dart`, the five test files, and the
   `.gitignore` line.
5. Run `flutter test --update-goldens --tags golden` once to create the images.
6. Look at each image to check that it really shows the widget with real fonts (not
   boxes).
7. Run `flutter test` (all tests, goldens included) twice to confirm the results are
   stable, then `flutter analyze` and `dart format .`.
8. Write the change log and set this plan to `completed`.

## Risks

- **Flaky goldens** (tests that sometimes pass and sometimes fail) caused by animations
  or the clock. The fix is to use fixed counts and dates and to `pumpAndSettle` before
  each capture.
- **Font loading fails** for the variable fonts. If that happens, I will fall back to
  the default test font for that test and note it, instead of blocking the whole plan.
