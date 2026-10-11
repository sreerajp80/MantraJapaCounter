# Allow increment step equal to daily goal, and show full error messages

**Status:** completed

## The issue

In the Edit Counter dialog (seen in Malayalam), with increment step = 1 and daily goal = 1:

1. **Save does not work.** The dialog checks `daily > 0 && step >= daily`. A step of 1
   and a daily goal of 1 fails this check, so Save shows an error and stops. But this
   setting is valid: one tap reaches the daily goal. The old Kotlin app had no such rule.
2. **The error message is cut off.** Error text under a field shows only one line by
   default. The longer Malayalam message ends with "…", so the user cannot read why
   Save failed.

## Files to change

- `lib/screens/counter_list/counter_dialog.dart`
- `lib/l10n/app_en.arb`, `lib/l10n/app_ml.arb`, `lib/l10n/app_sa.arb`
- generated `lib/l10n/app_localizations*.dart` (via `flutter gen-l10n`)
- `test/screens/counter_list_screen_test.dart`

## The fix

1. In `counter_dialog.dart`, change the check to `daily > 0 && step > daily`. Step equal
   to the daily goal is now allowed.
2. Update the `stepExceedsDaily` message to match the new rule ("cannot exceed" instead
   of "must be less than"):
   - en: "Increment step cannot exceed daily goal" (and update the `@` description)
   - ml: "വർദ്ധന ഘട്ടം ദൈനംദിന ലക്ഷ്യത്തേക്കാൾ കൂടാൻ പാടില്ല"
   - sa: "वृद्धिपदं दैनिकलक्ष्यात् अधिकं न भवेत्"
3. Add `errorMaxLines: 3` to every `InputDecoration` in the dialog that shows an error
   (step, daily goal, mala count), so long messages wrap instead of being cut off.
4. Run `flutter gen-l10n`.
5. Tests: add a widget test that step == daily goal saves, and step > daily goal shows
   the error.
6. Run `dart format .`, `flutter analyze`, `flutter test`.
7. Write the change log.
