# Meru pause, pacing hint, Sadhana Flow heat-map, optical sync brightness slider

Implements plan: `plans/20260929_212719_meru-pause-pacing-flow-sync-brightness.md`

## What changed

### 1. Meru pause (after each mala)

- `lib/core/constants/app_constants.dart`: pause choices (3, 5, 10 s), default 5 s, and prefs keys.
- `lib/repositories/settings_repository.dart`, `lib/providers/settings_provider.dart`: new
  settings `meruPauseEnabled` (default **off**) and `meruPauseSeconds`. An unknown saved length
  falls back to 5 s.
- `lib/providers/counting_provider.dart`:
  - `CountingState` has new fields `isMeruPause` and `meruPauseSeconds`.
  - When a tap completes a mala and the setting is on, the pause starts with a timer.
  - `tap()` ignores taps during the pause (they are not counted).
  - New public `endMeruPause()`. It is called by the timer, by undo (`decrement()`), by
    `onPause()`, and by the reset actions. The timer is cancelled in `dispose()`.
- `lib/screens/counting_screen.dart`: new `_MeruPauseOverlay`, a soft circle inside the mala with
  a lotus, "Pause · Breathe", a short line, and a countdown ring. It works in dimmed mode too.

### 2. Gentle pacing hint

- `AppConstants`: 3 taps per second over the last 5 taps; the hint stays for 3 s after the last
  fast tap.
- New setting `pacingHintEnabled` (default **on**).
- `CountingNotifier` keeps the last 5 tap times and sets `CountingState.isRushing`. The clock is
  read through the new `countingClockProvider`, so tests can control time.
- `CountingScreen`: an amber glow around the medallion (`AnimatedContainer` shadow) and a
  `_PacingHintPill` that fades in under the mala. The pill ignores touches. **Counting is never
  blocked.**

### 3. Sadhana Flow heat-map (History)

- `lib/models/daily_summary.dart`: new `day` getter (the calendar day of the summary's sessions).
  - *Small change from the plan:* the plan said a new `day` field set by the repository. A getter
    worked out from the sessions gives the same result with no changes to the repository or the
    test fake, so it was used instead.
- New `lib/core/utils/sadhana_flow.dart` (pure Dart): builds a 7 × 16 grid (Monday at the top,
  current week last), glow levels 0–4 (based on the daily goal when one is set, otherwise on the
  busiest day), practice days this year, and the "welcome back" rule (last practice before today
  was 3 or more days ago). Day gaps are counted in UTC, so daylight-saving changes don't break them.
- New `lib/screens/history/sadhana_flow_card.dart`: the grid (today outlined, future days hidden),
  a Less/More legend, the yearly line, and the welcome-back line. No streaks.
- `lib/screens/history/history_screen.dart`: shows the card under the hero.

### 4. Optical sync send brightness

- `MainActivity.kt`:
  - Removed the fixed 75% send brightness (`sendModeBrightness`).
  - `setSendMode(true)` now only keeps the screen on. The normal brightness stays.
  - New `setSendBrightness(value)`, a boost used only while sending. A negative value means no
    boost.
  - New `getCurrentBrightness()`, which returns the in-app setting, or the system level (0–255
    scaled to 0–1). It returns 0.5 if the level cannot be read.
  - Turning send mode off drops the boost and puts back the user's brightness. `setAppBrightness`
    now applies the effective level.
- `lib/services/screen_service.dart`: new `setSendBrightness()` and `getCurrentBrightness()`. They
  are safe without a native side.
- `lib/screens/optical_sync_screen.dart`: a brightness slider under the stream speed chips. It
  goes from Normal (left) to full (right) and starts at Normal each time. It is applied again
  when the app comes back to the front.

### 5. Text, settings UI, help, docs

- 24 new strings in `app_en.arb` (each with an `@` description), `app_ml.arb` and `app_sa.arb`,
  plus the regenerated `app_localizations*.dart`.
- `lib/screens/settings/display_settings_screen.dart`: new "Mindful counting" section with the
  Meru pause switch, the 3/5/10 s chips (shown when the switch is on), and the pacing hint switch.
- `lib/screens/help/counting_help_screen.dart`: new "Mindful counting" help section.
- `docs/features.md`, `docs/architecture.md`: new features and send brightness.
  `docs/improvements.md`: Meru pause, pacing hint and Sadhana Flow marked ✅.
- `lib/core/utils/build_date.g.dart`: the build hook updated it automatically during the check
  build.

### Tests

- `test/providers/counting_provider_test.dart`: 6 new tests. The Meru pause is off by default.
  When on, it starts at 108, ignores taps, and ends with `endMeruPause`. Undo ends the pause. Fast
  taps show the hint and still count. A natural pace shows no hint. With the setting off there is
  no hint. These tests call `onPause()` before clean-up so the DB writes they don't wait for can
  finish.
- New `test/core/utils/sadhana_flow_test.dart`: 6 tests covering grid shape, levels (with and
  without a goal), the year count, and the welcome-back rule.
- `test/repositories/settings_repository_test.dart`: 4 tests for the new settings.
- `test/services/screen_service_test.dart`: 4 tests for the new methods.
- `test/screens/history_screen_test.dart`: the diya check now looks only inside the hero (the new
  card has a diya too). It also checks that the Sadhana Flow card is shown.

No database schema change, no export format change, no new packages. Still fully offline.

## Checks

- `flutter gen-l10n`: done.
- `dart format`: done.
- `flutter analyze`: no issues.
- `flutter test`: all 209 tests passed (was 189).
- `flutter build apk --flavor dev --debug`: built successfully (the Kotlin changes compile).
- Not yet checked on a real device: the slider's feel, the Meru overlay and the pacing hint.
