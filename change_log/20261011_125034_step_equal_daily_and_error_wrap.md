# Allow increment step equal to daily goal, and show full error messages

Implements plan: `plans/20261011_124925_step_equal_daily_and_error_wrap.md`

## What changed

- `lib/screens/counter_list/counter_dialog.dart`
  - The step check is now `daily > 0 && step > daily` (was `>=`). A step equal to the
    daily goal (for example step 1, daily goal 1) can now be saved.
  - Added `errorMaxLines: 3` to the step, daily goal and mala count fields, so long
    error messages (for example in Malayalam) wrap instead of being cut off with "…".
- `lib/l10n/app_en.arb`, `app_ml.arb`, `app_sa.arb`: reworded `stepExceedsDaily` to
  "cannot exceed" to match the new rule, and updated the English `@` description.
- Generated localization files were rebuilt with `flutter gen-l10n`.
- `test/screens/counter_list_screen_test.dart`: new widget test. Step 2 with daily
  goal 1 shows the error; step 1 with daily goal 1 saves.

## Checks

- `flutter analyze`: no issues.
- `flutter test`: all 314 tests passed.
