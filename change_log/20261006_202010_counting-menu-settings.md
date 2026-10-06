# Change log: Settings item in the counting screen menu

Implements plan: `plans/20261006_201846_counting-menu-settings.md`

## What changed

- `lib/screens/counting_screen.dart`
  - Added a "Settings" item to the three-dot menu, right after "About".
    It uses the existing `menuSettings` text (English, Malayalam, Sanskrit).
  - `_onMenu` now handles `'settings'` by opening `/settings` with `context.push`.
    The counting screen stays on the stack, so back returns to the current session.

No `.arb` files changed.

## Checks

- `dart format`: done.
- `flutter analyze`: no issues.
- `flutter test`: all 242 tests passed.
