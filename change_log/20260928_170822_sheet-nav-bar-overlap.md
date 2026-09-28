# Change log: bottom sheet button hidden behind the navigation bar

Implements plan: `plans/20260928_170626_sheet-nav-bar-overlap.md`

## What changed

- `lib/widgets/counter_selection_sheet.dart` — the sheet's bottom padding is now
  `24 + MediaQuery.viewPaddingOf(context).bottom` instead of a fixed `24`. The
  "Continue" button now sits above the system navigation bar.
- `lib/widgets/optical_sync_import_preview_sheet.dart` — same fix. Padding changed
  from `EdgeInsets.all(24)` to 24 on left/top/right and
  `24 + MediaQuery.viewPaddingOf(context).bottom` at the bottom.

The sheet background still reaches the bottom edge of the screen. No new strings,
no logic changes, no data changes.

## Checks

- `dart format` — no changes needed.
- `flutter analyze` — no issues.
- `flutter test` — all 170 tests passed.
