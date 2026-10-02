# Plan: Meru pause, pacing hint, Sadhana Flow heat-map, optical sync brightness slider

**Status:** completed
**Date:** 2026-09-29

---

## 1. What we are adding

Four changes, taken from `docs/improvements.md` and the user's request:

1. **Meru pause** — a short, gentle pause after each full mala (108).
2. **Pacing hint** — a soft hint when the user taps faster than a natural chanting pace. It never blocks a count.
3. **Sadhana Flow heat-map** — a calendar of practice days on the History screen, with kind messages and no streaks.
4. **Optical sync brightness** — sending uses the normal screen brightness, with a slider to make it brighter if needed.

---

## 2. The issues today

- After bead 108 the count rolls straight into the next mala. There is no moment to pause and breathe.
- The app gives no feedback when the user rushes through the taps.
- History is only a list of days. There is no overview of practice over time.
- Optical sync send mode always forces the screen to 75% brightness. That can be too bright (glare, battery) or not bright enough, and the user cannot change it.

---

## 3. The fix

### 3.1 Meru pause

- New setting **"Meru pause after each mala"**. It is **off by default**, so current behaviour does not change until the user turns it on. Pause length choices: **3 s, 5 s (default), 10 s**.
- Logic goes in `CountingNotifier` (provider), not in the widget:
  - When a tap completes a mala (same check as the mala chime: `tapCount ~/ 108` goes up) and the setting is on, set `CountingState.isMeruPause = true` and start a timer for the chosen time.
  - While the pause is on, `tap()` ignores taps (they are **not counted**). This matches the tradition of not crossing the Meru bead.
  - The pause ends by itself when the timer runs out. Undo (two-finger swipe) also ends it.
  - The timer is cancelled on pause/dispose, so nothing runs in the background.
- UI on the counting screen: a soft overlay inside the mala circle, with a lotus icon, the text "Pause · Breathe" and a thin ring that runs down over the pause time. It works in both normal and dimmed mode.
- The mala sound and vibration still play exactly as today.

### 3.2 Pacing hint (anti-rushing)

- New setting **"Gentle pacing hint"**, **on by default**.
- Logic goes in `CountingNotifier`. It keeps the times of the last 5 taps. If those taps average **faster than 3 taps per second** (constant in `AppConstants`), `CountingState.isRushing = true`. The flag clears 3 seconds after the last fast tap.
- UI: a warm amber glow around the mala circle and a small pill under it: *"Slow down, breathe, feel the mantra."* It fades in and out. There is no sound, no vibration, and **the count is never blocked**.

### 3.3 Sadhana Flow heat-map (History screen)

- `DailySummary` gets a new `DateTime day` field (the calendar day, local time). The repository sets it. The model stays pure Dart.
- New pure-Dart helper `lib/core/utils/sadhana_flow.dart`:
  - Builds a map of day → count for the **last 16 weeks** (a 7 × 16 grid).
  - Gives each day a glow level 0–4. When a daily goal is known (history of one counter), levels are based on the daily goal. Otherwise they are based on the busiest day in the grid.
  - Counts **practice days this year**.
  - Decides whether to show a **welcome back** message: the last practice day (before today) was 3 or more days ago.
- New widget `lib/screens/history/sadhana_flow_card.dart`, shown under the hero and above "Recent offerings":
  - The grid of small rounded squares. Empty days are soft cream. Practice days glow from light sandal to deep saffron, like diyas.
  - A small "Less ▢▢▢▢ More" legend.
  - The message *"{n} days of sacred remembrance this year"*.
  - When it applies: *"Welcome back to your sacred space. Every mantra offered is eternal."*
  - **No streak counts and no red "missed day" marks.**
- It works for "All counters" and for a single counter.

### 3.4 Optical sync send brightness

- Native (`MainActivity.kt`):
  - `setSendMode(true)` now only **keeps the screen on**. It no longer changes brightness, so the screen stays at the user's normal brightness.
  - New method `setSendBrightness(value)`. It sets the window brightness while sending; a negative value goes back to normal. The value is dropped when send mode ends, so the user's own brightness always comes back.
  - New method `getCurrentBrightness()`. It returns the current brightness (the in-app brightness setting if one is set, otherwise the system brightness read from Android settings, from 0.0 to 1.0). This is used as the slider's starting point.
  - The `sendModeBrightness = 0.75f` constant is removed.
- `ScreenService`: add `setSendBrightness(double)` and `getCurrentBrightness()`. Both are safe when there is no native side (tests).
- Send screen (`optical_sync_screen.dart`): a **brightness slider** under the stream speed chips, with a sun icon. It goes from "Normal" (left, the current brightness) up to full (right). It starts at Normal each time. It is applied again when the app comes back from the background.

### 3.5 Text, settings, docs

- New ARB keys in `app_en.arb`, `app_ml.arb` and `app_sa.arb`, each with an `@key` description. Then run `flutter gen-l10n`.
- New prefs keys in `AppConstants`, with getters and setters in `SettingsRepository` and `SettingsNotifier`/`AppSettings`.
- New toggles in **Settings → Display**: Meru pause (with 3/5/10 s choice chips) and Gentle pacing hint.
- Short help lines in the Counting help screen for Meru pause and the pacing hint.
- Docs: `docs/features.md` and `docs/architecture.md` (the send brightness and the new features). In `docs/improvements.md`, mark Meru pause, pacing hint and Sadhana Flow ✅.

---

## 4. Files to change

| File | Change |
|---|---|
| `lib/core/constants/app_constants.dart` | Prefs keys; pacing constants; Meru pause defaults |
| `lib/repositories/settings_repository.dart` | Getters/setters for Meru pause on/off + seconds, pacing hint |
| `lib/providers/settings_provider.dart` | Expose the new settings |
| `lib/providers/counting_provider.dart` | `isMeruPause`, `isRushing` state; tap-time tracking; pause timer |
| `lib/screens/counting_screen.dart` | Meru overlay, pacing glow + pill |
| `lib/screens/settings/display_settings_screen.dart` | New toggles and seconds chips |
| `lib/screens/help/counting_help_screen.dart` | Two short help lines |
| `lib/models/daily_summary.dart` | Add `DateTime day` |
| `lib/repositories/japa_counter_repository.dart` | Fill `day` in `getDailySummaries` |
| `lib/core/utils/sadhana_flow.dart` | **New** — pure heat-map logic |
| `lib/screens/history/sadhana_flow_card.dart` | **New** — heat-map widget |
| `lib/screens/history/history_screen.dart` | Show the card |
| `lib/services/screen_service.dart` | New methods; doc comment |
| `lib/screens/optical_sync_screen.dart` | Brightness slider |
| `android/app/src/main/kotlin/com/sreerajp/mantrajapacounter/MainActivity.kt` | Send mode keeps screen on only; new brightness methods |
| `lib/l10n/app_en.arb`, `app_ml.arb`, `app_sa.arb` (+ generated files) | New strings |
| `test/helpers/fake_japa_counter_repository.dart` | Fill `day` if it builds summaries |
| `test/providers/counting_provider_test.dart` | Tests: Meru pause ignores taps and ends; undo ends it; off = no pause; rushing flag |
| `test/core/utils/sadhana_flow_test.dart` | **New** — levels, year count, welcome-back rule |
| `test/services/screen_service_test.dart` | Tests for new methods |
| `test/providers/settings_provider_test.dart` / `test/repositories/settings_repository_test.dart` | New settings defaults and saving |
| `docs/features.md`, `docs/architecture.md`, `docs/improvements.md` | Doc updates |

No database schema change. No change to the JSON export format. No new packages. Still fully offline.

---

## 5. Checks

1. `flutter gen-l10n`
2. `dart format .`
3. `flutter analyze` — must be clean.
4. `flutter test` — all tests pass, including the new ones.
5. Not checked on a real device by me. Please try the slider, the Meru pause and the pacing hint on a phone.

---

## 6. Open choices (defaults used unless you say otherwise)

- Meru pause is **off** by default; taps during the pause are **not counted**.
- Pacing hint is **on** by default; the limit is 3 taps per second.
- The heat-map shows the **last 16 weeks**.
- The brightness slider resets to Normal each time the send screen opens (it is not saved).
