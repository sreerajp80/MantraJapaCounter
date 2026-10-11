# Change log: backspace needed two presses in the counter dialog

Implements plan: `plans/20261011_125201_fix_double_backspace_counter_dialog.md`

## What changed

- `lib/screens/counter_list/counter_dialog.dart`
  - The five number fields (initial count, increment step, lifetime goal,
    daily goal, mala count) now set `autocorrect: false` and
    `enableSuggestions: false`. This stops keyboards such as Microsoft SwiftKey
    from holding the text in a "composing" state, which made the first
    backspace do nothing.
  - The same fields now use `FilteringTextInputFormatter.digitsOnly`, so stray
    `-`, `.` or `,` characters are dropped.
  - The name field is unchanged. Word predictions stay on (user decision).
- `test/screens/counter_list/counter_dialog_test.dart`
  - New test: number fields have suggestions and autocorrect off; the name
    field keeps suggestions on.
  - New test: number fields drop non-digit characters, and the dialog still
    saves the right value.
  - `dart format` re-wrapped one existing test line (no logic change).

## Checks

- `flutter analyze`: no issues.
- `flutter test`: all 316 tests pass.
- Still to do: try backspace on a real phone with SwiftKey (the on-screen
  keyboard cannot be tested automatically).
