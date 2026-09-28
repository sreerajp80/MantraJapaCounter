# Fix bottom sheet button hidden behind the system navigation bar

**Status:** completed

## Issue

On the Optical Sync send screen, the "Select counters" bottom sheet shows a
"Continue" button at the bottom. On phones with edge-to-edge display (Android 15+,
targetSdk 36), the system navigation bar (back / home / recents) draws on top of
the button. The button is half hidden and hard to tap.

Cause: the sheet is opened with `isScrollControlled: true` and a transparent
background. The sheet widget uses a fixed bottom padding (24 px) and does not add
the space taken by the system navigation bar. Flutter does not add this space for
us in this setup.

The same problem exists in the Optical Sync receive "Import preview" sheet, which
is built the same way (fixed 24 px padding, no nav bar space).

Other bottom sheets (language picker, sound pickers, counter options) already wrap
their content in `SafeArea`, so they are fine.

## Files to change

- `lib/widgets/counter_selection_sheet.dart`
- `lib/widgets/optical_sync_import_preview_sheet.dart`

## Fix plan

1. In `counter_selection_sheet.dart`, change the container bottom padding from a
   fixed `24` to `24 + MediaQuery.viewPaddingOf(context).bottom`. The sheet's
   cream background will still reach the screen edge (behind the nav bar), but the
   button will sit above the nav bar.
2. In `optical_sync_import_preview_sheet.dart`, do the same: keep 24 px on the
   left, top and right, and use `24 + MediaQuery.viewPaddingOf(context).bottom`
   at the bottom.
3. Run `dart format`, `flutter analyze`, and `flutter test`.
4. Write a change log in `change_log/`.

No new strings, no logic changes, no data changes.
