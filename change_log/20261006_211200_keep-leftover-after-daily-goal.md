# Keep the unfinished mala after the daily goal is met

Implements plan: `plans/20261006_210329_keep-leftover-after-daily-goal.md`

## Problem

With a daily goal below one mala (under 108), once the goal was met, leaving the counting
screen mid-mala closed the session instead of pausing it. The counting screen then opened
at 0 instead of the leftover count.

## Changes

- `lib/providers/counting_provider.dart`
  - `completeSession()`: removed the `subMalaDailyGoalMet` rule. Leaving mid-mala now
    always pauses the session, whether the daily goal is met or not.
  - Updated the doc comment. It now points to `finishAndStartNew()` for closing an
    unfinished mala on purpose (the ⋮ menu item "Finish & start new").
- `docs/features.md`: replaced the old "sub-mala daily goal" exception with the new rule.
- `test/providers/counting_provider_test.dart`: new test. Daily goal 50, count 60, leave,
  open again: the session resumes at 60 and the database total stays 60.

## Checks

- `dart format`: done.
- `flutter analyze`: no issues.
- `flutter test`: all 243 tests passed.
