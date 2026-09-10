# Plan — Fix Delete and Disable confirm dialogs on the counter options sheet

**Status:** completed — see `change_log/20260910_191931_fix_options_sheet_dialog_context.md`

**Found by:** the new safety-net test in `test/screens/counter_list_screen_test.dart`
("Delete asks first and then removes the counter"), written for
`plans/20260910_190800_split_large_screens.md`.

---

## 1. The issue

On the home screen, long-press a counter → options sheet → **Delete** (or **Disable**). A confirm
dialog opens. Tapping the confirm button does nothing useful:

- the dialog stays open,
- the counter is **not** deleted (or disabled),
- in a debug build Flutter reports "Looking up a deactivated widget's ancestor is unsafe".

**Why:** in `lib/screens/counter_list_screen.dart`, `_CounterOptionsSheet._confirmDelete` and
`_confirmDisable` build the dialog with `builder: (_) => AlertDialog(...)` and the buttons call
`Navigator.pop(context)`. That `context` belongs to the options sheet, which was already closed
before the dialog opened. A closed widget has no parent, so `Navigator.of(context)` finds no
navigator and throws. Because `Navigator.pop` comes first in the button handler, the
`deleteCounter` / `disableCounter` line after it never runs. This happens in release builds too,
not only debug.

The Edit option is not affected: its dialog closes itself with its own context.

---

## 2. The fix

In both methods, give the dialog builder its own context and use it for closing:

```dart
builder: (dialogContext) => AlertDialog(
  ...
  TextButton(
    onPressed: () => Navigator.pop(dialogContext),
    ...
  ),
  TextButton(
    onPressed: () {
      Navigator.pop(dialogContext);
      ref.read(countersNotifierProvider.notifier).deleteCounter(counter.id);
    },
    ...
  ),
```

`ref` stays as it is — it belongs to the counter list item, which is still on screen.

No other change. No new strings.

---

## 3. Files to change

| File | Change |
|------|--------|
| `lib/screens/counter_list_screen.dart` | `_confirmDelete` and `_confirmDisable`: use the dialog's own context for `Navigator.pop` (4 call sites) |
| `test/screens/counter_list_screen_test.dart` | Add a test for Disable: confirm with a reason → counter status becomes `disabledSuccess` with that reason |

The existing "Delete asks first and then removes the counter" test must go from failing to
passing without any change to its body.

---

## 4. Order with the split plan

Do this fix **first**, on the current unsplit file. The split plan then moves already-correct code,
and its "test bodies must not change" rule stays true.

---

## 5. Verification

- `flutter test` — all tests pass, including the Delete test that fails today and the new Disable test.
- `flutter analyze` — 0 issues.
- Write a change log to `change_log/` for this fix.
