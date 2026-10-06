# Keep the unfinished mala after the daily goal is met

**Status:** completed

## The issue

When the user leaves the counting screen in the middle of a mala (count not a multiple
of 108), the session is normally **paused**. Next time the counter opens, it resumes from
the same bead (for example 30/108).

But `completeSession()` in `lib/providers/counting_provider.dart` has a special rule:

```dart
final subMalaDailyGoalMet =
    _dailyGoal > 0 && _dailyGoal < 108 && state.liveTodayTotal >= _dailyGoal;
final shouldPause = session.tapCount > 0 &&
    session.tapCount % 108 != 0 && !subMalaDailyGoalMet;
```

So when the counter has a daily goal smaller than one mala (for example 50 or 54) and
that goal is already met today, leaving mid-mala does **not** pause. The session is
closed and the saved active session is cleared. The counts stay in history, but the
counting screen opens at 0 next time instead of the leftover count.

This is the bug the user sees: after the daily goal is reached, the left-over count is
lost from the counting screen. When the goal is not yet met, the rule does not apply,
so the pause works as expected.

This rule was added on purpose earlier (see `docs/features.md`, "Smart Session
Finalization"), but it now goes against what the user wants. There is also now a
**Finish & start new** menu item, so the user can close an unfinished mala by choice.
The automatic close is no longer needed.

## Files to change

- `lib/providers/counting_provider.dart` — remove the `subMalaDailyGoalMet` rule; always
  pause on a mid-mala exit. Update the doc comment of `completeSession()`.
- `docs/features.md` — remove the "Exception: sub-mala daily goal …" line; mention that
  "Finish & start new" closes an unfinished mala.
- `test/providers/counting_provider_test.dart` — add a test: counter with daily goal 50,
  count 60 (goal met), exit, open again → counting screen resumes at 60, not 0.

## The fix

1. In `completeSession()`:
   - Delete the `subMalaDailyGoalMet` variable.
   - `shouldPause = session.tapCount > 0 && session.tapCount % 108 != 0`.
   - Remove the "Special case" paragraph from the doc comment.
2. `_dailyGoal` is still used for the daily goal alert, so it stays.
3. Update `docs/features.md` as above.
4. Add the new test.
5. Run `dart format`, `flutter analyze` and `flutter test`.
6. Write a change log in `change_log/`.

## Not changed

- Daily goal alert, mala chime, Meru pause, and history totals work as before.
- No database, prefs format, or export format change.
