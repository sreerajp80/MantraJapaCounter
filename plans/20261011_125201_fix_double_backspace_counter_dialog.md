# Fix: backspace must be pressed twice in the counter dialog

**Status:** completed

## Files to change

- `lib/screens/counter_list/counter_dialog.dart`
- `test/screens/counter_list/counter_dialog_test.dart` (new — small widget test)

## The issue

In the "New counter" and "Edit counter" dialogs, every text field needs two
backspace presses to delete one character.

What I checked:

- The dialog code itself is simple. Each field has its own controller, kept in
  the dialog state. Nothing rebuilds or replaces the fields while you type.
- The app has no custom key handling anywhere (no key listeners, no shortcuts,
  no native `onKeyDown` / `dispatchKeyEvent` in `MainActivity.kt`).
- Both test phones use the **Microsoft SwiftKey** keyboard (version 9.13).
  SwiftKey is known to clash with Flutter text fields. It keeps the current
  word in a "composing" (still-being-typed, underlined) state. When a field has
  word suggestions turned on, the first backspace only ends this composing
  state, and the second backspace really deletes the character.

So the most likely cause is SwiftKey's word-suggestion (composing) mode, not a
bug in our own logic.

## The fix

1. Turn off keyboard suggestions and autocorrect on the five number fields
   (initial count, increment step, lifetime goal, daily goal, mala count):
   `autocorrect: false` and `enableSuggestions: false`. Number fields never
   need word suggestions, so nothing is lost. This stops SwiftKey from using
   the composing mode on these fields.
2. Also add `inputFormatters: [FilteringTextInputFormatter.digitsOnly]` to the
   number fields. This blocks stray characters (like `-`, `.`, `,`) that some
   keyboards still show on the number pad. It is a small safety gain.
3. Name field: no change. Word predictions stay on (decided by the user).
4. Add a small widget test that checks the number fields reject non-digits
   and that the dialog still saves the right values.

## How we confirm it works

- Run `flutter analyze` and `flutter test`.
- Install the dev build on your phone and try backspace in each field.
- Honest note: I cannot reproduce the SwiftKey behaviour from here (the
  emulator / adb key events skip the on-screen keyboard). If backspace still
  needs two presses after this change, the next step is to test with Gboard to
  confirm it is SwiftKey-specific, and report it to Flutter.

## Side note (not part of this fix)

In `counter_options_sheet.dart`, the Edit action closes the bottom sheet and
then opens the dialog using the sheet's own `context`, which is already
closing. It works today, but it is fragile. I can fix this in a separate plan
if you want.
