# Change log: Meru pause by tap count

Implements plan: `plans/20261114_151118_meru-pause-by-taps.md`

## What changed

The Meru pause can now end after a set number of taps instead of a set time. In Settings the
user picks **Time** or **Taps**. In Taps mode the user sets any number from 1 to 19 (default 2)
with a − / + stepper. After a mala, that many taps are not counted; then counting starts again.

### Code

- `lib/models/meru_pause_mode.dart` (new): `MeruPauseMode { time, taps }` with stable string ids
  and `fromId()` (unknown → `time`).
- `lib/core/constants/app_constants.dart`: `meruPauseMinTaps` (1), `meruPauseMaxTaps` (19),
  `meruPauseDefaultTaps` (2), prefs keys `meru_pause_mode` and `meru_pause_taps`.
- `lib/repositories/settings_repository.dart`: `meruPauseMode` and `meruPauseTaps` getters and
  setters. Saved tap values outside 1–19 fall back to 2; the setter clamps to 1–19.
- `lib/providers/settings_provider.dart`: both values in `AppSettings`, plus
  `setMeruPauseMode` and `setMeruPauseTaps`.
- `lib/providers/counting_provider.dart`: `CountingState` gets `meruPauseMode`,
  `meruPauseTapsTotal` and `meruPauseTapsLeft`. In Taps mode the pause starts with no timer.
  A tap during the pause is never counted; in Taps mode it lowers taps-left, and the last one
  ends the pause. Undo and leaving the screen still end the pause.
- `lib/screens/settings/display_settings_screen.dart`: Time / Taps chips, then either the
  seconds chips or the new `_MeruTapStepper` (buttons disabled at 1 and 19).
- `lib/screens/counting_screen.dart`: `_MeruPauseOverlay` in Taps mode steps the ring down per
  pause tap and shows "N taps left".

### Text (en, ml, sa)

- New keys: `meruPauseModeTime`, `meruPauseModeTaps`, `tapsShort`, `meruPauseTapsLeft`,
  `meruPauseTapsDecreaseA11y`, `meruPauseTapsIncreaseA11y`.
- Updated: `tutorialStep16Desc`, `helpCountingMindfulBullet1`, `helpDisplayMindfulBullet1`.
- Regenerated `lib/l10n/app_localizations*.dart`.

### Tests

- `test/models/meru_pause_mode_test.dart` (new): id round trip and fallback.
- `test/repositories/settings_repository_test.dart`: defaults (time, 2 taps), save/load for
  1, 7, 19, fallback to 2 for 0, −3, 20, 500, unknown mode → time, setter clamping, notifier.
- `test/providers/counting_provider_test.dart`: with 2 pause taps, taps 1 and 2 are not
  counted and the 3rd counts; undo ends a Taps pause.

### Docs

- `docs/features.md` and `docs/architecture.md` describe the Taps mode.

## Checks

- `dart format .` — done.
- `flutter analyze` — no issues.
- `flutter test` — all 429 tests pass.
- Not yet checked on a phone.

## Security impact

None. Two new local SharedPreferences keys only. No network, permission or backup format change.
