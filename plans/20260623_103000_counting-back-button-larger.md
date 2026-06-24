# Plan: Make the back arrow on the Counting screen larger / easier to tap

## Issue
On the Counting screen, the back arrow (top-left) is small and hard to tap. It is a
`TempleIconButton` rendered at the default size of 38×38 px with an 18 px icon, giving a
tap target below the comfortable ~48 px minimum.

## Files to change
- `mantra_japa_counter/lib/screens/counting_screen.dart` — the back button usage in
  `_topBar()` (around lines 224–231).

## Plan for the fix
1. Pass an explicit larger `size` to the `TempleIconButton` for the back arrow (48 px), so
   the circular tap target is bigger and wider.
2. Increase the `Icons.arrow_back` icon size from 18 → 22 to match the larger button.

No change to `TempleIconButton` itself (keeps its 38 px default for all other usages).
No behavioral change to `_saveAndExit` — still auto-saves silently on tap.
