# Change log — Unfinished sessions across days

Implements plan: [plans/20261006_192439_session-across-days.md](../plans/20261006_192439_session-across-days.md)

## Summary

- Taps are now stored on the day they are made. An unfinished mala still continues across
  days, but each day gets its own `japa_sessions` row.
- The Daily card on the counting screen no longer jumps back after a batch save when an
  earlier day's mala is continued, or when counting goes past midnight.
- New "Start new" banner and "Finish & start new" menu item let the user close an
  unfinished mala without losing its counts.

## What changed

### Model
- `lib/models/active_session.dart` — new fields `carriedCount` and `carriedDurationMs`
  (saved in SharedPreferences only; old saved data reads them as 0). New getters
  `rowCount` and `rowDuration` give the part that belongs in the current DB row.
  `tapCount` stays the whole-session total.

### Logic
- `lib/core/utils/day.dart` (new) — `isEarlierLocalDay()` helper.
- `lib/providers/counting_provider.dart`
  - On a tap, if the current row is from an earlier day, `_startNewDayRow()` saves any
    unsaved taps into the old row, then starts a new row dated today with the old total
    carried over. The switch happens before any `await`, so fast taps cannot split twice.
  - DB rows store `rowCount` / `rowDuration`. Empty rows are never inserted.
  - The "first tap inserts the row" check now means "this row is not in the DB yet".
  - Undo stops at `carriedCount`, and is blocked until today's first tap. If all of
    today's taps are undone, today's row is dropped but the unfinished mala is kept.
  - `init()` crash-recovery compares the DB row with `rowCount`, and sets the
    unsaved-taps baseline correctly for carried sessions.
  - New `CountingState.resumedFromEarlierDay` flag (drives the banner).
  - New `finishAndStartNew()` — keeps the counts made so far, clears the saved active
    session, and starts a fresh session at 0.
- `lib/services/session_recovery_service.dart` — app-start recovery now writes only
  `rowCount` / `rowDuration`, so a carried session is not counted twice. (This file was
  not in the plan's file list, but the same row-count rule had to apply here too.)

### UI and text
- `lib/screens/counting_screen.dart` — `_UnfinishedMalaBanner` under the mantra title
  (non-blocking, hides after the first tap), and a "Finish & start new" menu item, shown
  only when the session has taps. No confirmation dialog, since nothing is deleted.
- `lib/screens/help/counting_help_screen.dart` — one new help bullet about the
  unfinished mala.
- `lib/l10n/app_en.arb`, `app_ml.arb`, `app_sa.arb` — new keys
  `unfinishedMalaBanner`, `startNewSession`, `finishAndStartNew`,
  `helpCountingCarryBold`, `helpCountingCarryBullet` (with `@` descriptions in English).
  Regenerated `app_localizations*.dart` with `flutter gen-l10n`.
- The **Session** card still shows the whole mala (carried + today). The **Daily** card
  shows only today.

### Docs
- `docs/architecture.md` — new "Unfinished Mala Across Days" section and an updated
  `ActiveSession` row.

### Tests
- `test/providers/counting_provider_test.dart` — new group "Unfinished mala across
  days": banner and today starting at 0; today's taps going into a new row (Daily never
  drops, 45 + 63 = 108); resuming again after a second stop; counting past midnight;
  undo floor; Start new; Finish & start new on a same-day session; crash recovery with a
  carried count.
- `test/models/active_session_test.dart` (new) — old JSON defaults and round-trip.
- `test/core/utils/day_test.dart` (new) — day comparison cases.

## Not changed

- Database schema (still v4) and the JSON export/import format.
- Sessions saved before this change keep their existing rows.

## Checks

- `flutter gen-l10n`, `dart format .` — done.
- `flutter analyze` — no issues.
- `flutter test` — all 242 tests pass.
