# Change Log: Fix Delete and Disable confirm dialogs on the counter options sheet

**Date:** 2026-09-10

**Plan Reference:** [../plans/20260910_191700_fix_options_sheet_dialog_context.md](../plans/20260910_191700_fix_options_sheet_dialog_context.md)

**Result:** Delete and Disable from the long-press options sheet work again. `flutter analyze`
reports 0 issues and all 97 tests pass.

---

## 1. The bug

On the home screen: long-press a counter → **Delete** or **Disable** → tap the confirm button.
The dialog stayed open and the counter was **not** deleted or disabled.

The confirm dialogs closed themselves with `Navigator.pop(context)`, where `context` was the
options sheet's context. The sheet was already closed by then, so that context had no parent
and `Navigator.of` could not find a navigator. It threw before the `deleteCounter` /
`disableCounter` line could run. This affected release builds too, not only debug.

It was found by the new safety-net widget test written for
[../plans/20260910_190800_split_large_screens.md](../plans/20260910_190800_split_large_screens.md).

## 2. What changed

- `lib/screens/counter_list_screen.dart` — in `_CounterOptionsSheet._confirmDelete` and
  `_confirmDisable`, the dialog builder now names its own context (`dialogContext`) and all four
  `Navigator.pop` calls use it. Nothing else changed.
- `test/screens/counter_list_screen_test.dart` — added "Disable (success) asks for a reason and
  disables the counter". It checks the status becomes `disabledSuccess`, the reason is trimmed
  and saved, and `disabledAt` is set.

The existing "Delete asks first and then removes the counter" test failed before the fix and
passes after it, with no change to its body.

## 3. Verification

| Check | Result |
|-------|--------|
| `flutter analyze` | 0 issues |
| `dart format` | clean |
| `flutter test` | 97 passing |
