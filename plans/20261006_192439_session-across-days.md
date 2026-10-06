# Unfinished sessions across days: count taps on the right day, and let the user start fresh

**Status:** completed

## The issue

1. **Taps go to the wrong day.** A session is one row in `japa_sessions`. The row's
   `timestamp` is the time the session *started*. If the user stops before 108, the
   session is paused and comes back next time, even on a later day. Every tap made today
   is then saved into the old row, so it counts for the old day. Today's daily total and
   daily goal do not move. History shows the taps on the old day.
2. **The Daily card on the counting screen jumps.** The Daily card is "today's DB total +
   taps not yet saved". When yesterday's session is continued, the card goes up while
   taps are unsaved, then drops back after each batch save (every 20 taps or 30 seconds),
   because the saved taps land in yesterday's row. The same happens when counting goes
   past midnight without stopping.
3. **No way to start fresh without losing counts.** The only option today is "Reset
   session", which deletes the unfinished counts. A user who does not want to finish
   yesterday's mala has no clean way to keep those counts and begin a new session.

## What we will do

### Part 1 — Split the session at the day change (fixes issues 1 and 2)

The *session* (the mala in progress) still continues across days, so the mala ring still
shows e.g. 45 → 108 and the user still finishes the mala. But the database gets **one row
per day**:

- Yesterday's row keeps only yesterday's taps (e.g. 45).
- A new row is created for today's taps (e.g. 63), dated today.

How:

- `ActiveSession` gets two new fields, saved in SharedPreferences only:
  - `carriedCount` — taps already stored in earlier-day rows of this same session.
  - `carriedDurationMs` — active time already stored in those rows.
  - Old saved data without these fields reads them as 0, so nothing breaks.
- `tapCount` stays the **whole session** total (so mala ring, 108 checks, Meru pause,
  mala chime and "pause on exit if mid-mala" keep working as now).
- The DB row for the current day stores `count = tapCount − carriedCount` and
  `duration = duration − carriedDurationMs`. `malas`/`chants` in the row are worked out
  from that row count, same formula as now.
- **When the split happens:** on a tap, if the current row's start day is before today
  (checked with the local date, same way as the `today` query):
  1. Save any unsaved taps into the old row first.
  2. Start a new segment: new row id, `startTime = now`, `carriedCount = tapCount`,
     `carriedDurationMs = duration`. The new row is inserted with this tap.
  - If the current row has no taps yet in this segment, nothing is split.
  - Simply opening and leaving the counter without tapping creates no new row.
- The "first tap inserts a row" check changes from `tapCount == 0` to "this segment's row
  is not in the DB yet".
- `_lastDbWrittenCount` keeps measuring in whole-session units, so the Daily card's
  "unsaved taps" maths stays right. With today's taps now in today's row, the Daily card
  no longer jumps, and the daily goal alert fires correctly.
- **Undo:** undo stops at `carriedCount`. Taps that are already stored on an earlier day
  cannot be undone from today. (Undo to zero in a normal one-day session works as now.)
- **Crash recovery (`init`)** compares the saved prefs with the DB row using the row count
  (`tapCount − carriedCount`), not the whole-session count.
- **Exit (`completeSession`)**: same rules as now (pause if mid-mala). If today's segment
  has no taps, it does not insert an empty row.

### Part 2 — "Start new" banner (Option A)

- When the counting screen opens and the restored session's current row is from an
  earlier day (and has taps), show a small, non-blocking banner above the mala:
  "Unfinished mala from an earlier day: 45/108" with a **Start new** button.
- No pop-up, no "are you sure" step (keeps the no-extra-prompts rule).
- The banner hides after the first tap (the user chose to continue) or after Start new.
- **Start new** calls a new notifier method `finishAndStartNew()`:
  1. Save any unsaved taps into the current row (the old counts are **kept** in history
     on their own day).
  2. Clear the saved active session from SharedPreferences.
  3. Start a fresh session at 0.

### Part 3 — "Finish & start new" menu item (Option B)

- Add a menu item **Finish & start new** in the counting screen's ⋮ menu, next to
  "Reset session". It calls the same `finishAndStartNew()`.
- It works any time (not only for old-day sessions), so the user can close an unfinished
  mala and keep its counts.
- Shown only when the session has taps. No confirmation dialog, since nothing is deleted.

### Session card on the counting screen

- The **Session** card keeps showing the whole session (`tapCount`, e.g. 45 + today's
  63 = 108), matching the mala ring. The **Daily** card shows only today's taps.
  (Default chosen — tell me if you want the Session card to show only today's part.)

### Notes

- **No DB schema change** (stays v4). **JSON export format is unchanged** — it is just
  normal session rows, so import/export compatibility is kept.
- A mala finished across two days is stored as two partial rows (e.g. 45 and 63), so
  neither row alone says "1 mala". Lifetime and daily mala numbers are worked out from
  total counts, so they stay correct.
- Sessions saved before this change keep their old rows; only new taps follow the new rule.

## Files to change

- `lib/models/active_session.dart` — add `carriedCount`, `carriedDurationMs`; row-count
  and row-duration getters; `copyWith`, `toMap`, `fromMap` (default 0 when missing).
- `lib/providers/counting_provider.dart` — day-split on tap, row count/duration in
  insert/update, first-tap check, undo floor, `init` recovery check, `completeSession`
  empty-segment check, new `finishAndStartNew()`, new state flag for the banner
  (`resumedFromEarlierDay`) in `CountingState`.
- `lib/core/utils/` — small pure helper to check "is this time on an earlier local day
  than now" (only if no existing helper fits), with tests.
- `lib/screens/counting_screen.dart` — the banner widget and the new menu item.
- `lib/l10n/app_en.arb`, `app_ml.arb`, `app_sa.arb` — new keys with `@` descriptions:
  `unfinishedMalaBanner` (with chants placeholder), `startNewSession`,
  `finishAndStartNew`. Then run `flutter gen-l10n`.
- `lib/screens/help/counting_help_screen.dart` (+ its ARB text) — one short line
  explaining that an unfinished mala carries over and how to start new, if the screen
  already covers pause/resume.
- `docs/architecture.md` — describe the per-day row split and `finishAndStartNew`.
- `test/providers/counting_provider_test.dart` — new tests:
  - continuing yesterday's paused session puts today's taps in a new row dated today;
    yesterday's row keeps its count;
  - Daily total includes today's taps and does not drop after a batch save;
  - counting across midnight splits the rows;
  - finishing 108 across two days: mala ring hits 108, rows are 45 + 63, lifetime = 108;
  - undo cannot go below the carried count;
  - `finishAndStartNew()` keeps the old row and starts a fresh session at 0;
  - crash recovery with a carried count does not double-count;
  - old prefs JSON without the new fields still loads.
- `test/models/active_session_test.dart` (or the existing model test) — round-trip of the
  new fields and defaults.

## Checks after the change

- `flutter gen-l10n`, `dart format .`, `flutter analyze` (0 issues), `flutter test`.
- Write the change log in `change_log/`.
