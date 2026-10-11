# Keep the "Unfinished mala" banner visible until the mala is done

**Status:** completed

## Issue

On the counting screen, the "Unfinished mala from an earlier day: N/108" banner with the
**Start new** button only shows when the screen opens, and it hides on the very first tap.

The user may start counting without seeing it. Then the chance to start a fresh mala is gone
from view, and they keep adding to yesterday's mala without knowing.

There is a second gap: after the first tap today, the session's `startTime` moves to today.
So if the user leaves mid-mala and comes back later the same day, the banner does not come
back, even though the mala still holds taps from an earlier day.

## Wanted behaviour

The banner stays on screen while the current mala still holds taps from an earlier day.
It goes away only when:

1. the user taps **Start new** on the banner, or
2. the user picks **Finish & start new** from the menu, or
3. the mala reaches 108. (After that, leaving and coming back does not show it again,
   because the new mala has no earlier-day taps.)

While shown, the banner keeps its live "N/108" progress as the user counts.

**Choice to confirm:** when the count reaches 108 during the same visit, I plan to hide the
banner at that moment. Keeping it after 108 would show "0/108 from an earlier day" for the
new mala, which is wrong. Leaving and coming back will also not show it, as you asked.

## Files to change

- `lib/providers/counting_provider.dart`
- `test/providers/counting_provider_test.dart`
- `docs/architecture.md`

## Plan for the fix

1. **`counting_provider.dart`** — add one small helper that decides if the current mala holds
   earlier-day taps:
   - `tapCount % 108 != 0` (the mala is not finished), and
   - either the session still starts on an earlier day (nothing tapped today yet), or
     `carriedCount % 108 != 0` and `tapCount ~/ 108 == carriedCount ~/ 108`
     (the taps carried from earlier days are part of the mala now in progress).
   - Uses only data already saved in `ActiveSession` (`carriedCount`), so no new
     storage, no schema change, no export change.
2. In `init()`, set `resumedFromEarlierDay` from this helper (instead of only the
   "starts on an earlier day" check). This makes the banner come back after leaving and
   returning on the same day.
3. In `tap()` and in `_startNewDayRow()`, stop forcing `resumedFromEarlierDay` to `false`.
   Instead, `tap()` sets it from the same helper after the count changes, so it turns off
   exactly when the mala reaches 108.
4. `decrement()`: also refresh the flag from the helper (undo cannot go below the carried
   count, so in practice it stays on, but this keeps the state correct).
5. `finishAndStartNew()` already builds a fresh `CountingState` with the flag `false` —
   no change needed. Same for reset.
6. Update the doc comment on `CountingState.resumedFromEarlierDay`.
7. **Tests** (`counting_provider_test.dart`):
   - Update "today's taps go into a new row dated today": the banner stays on after the
     first tap and during counting, and is off once the count reaches 108.
   - Update "leaving mid-mala again keeps the carry-over on resume": the banner is shown
     again on reopen (`isTrue` instead of `isFalse`).
   - Add a test: finish the mala (108), leave, reopen → banner not shown.
   - Existing "Start new" test already checks the flag becomes `false`.
8. **`docs/architecture.md`** — add one line saying the banner stays until the mala is
   finished or the user starts a new one.
9. Run `dart format .`, `flutter analyze`, `flutter test`.
10. Write the change log in `change_log/`.

No UI text changes, so no `.arb` changes are needed.
