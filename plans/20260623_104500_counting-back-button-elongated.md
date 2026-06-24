# Plan: Make the Counting screen back button elongated (pill-shaped)

## Issue
The back button is now bigger (48×48) but still a circle. The user wants it elongated
width-wise so it better covers the finger tip when tapped.

## Files to change
- `mantra_japa_counter/lib/screens/counting_screen.dart` — the back button usage in
  `_topBar()` (around lines 224–232).

## Plan for the fix
`TempleIconButton` is a shared widget that draws a fixed circle (`CircleBorder`, single
`size`), so it cannot produce a wider-than-tall shape without affecting every other usage.

Replace the back button's `TempleIconButton` with an inline `Material` + `InkWell` that
mirrors the temple styling (card color, line border) but uses a **stadium / pill shape**
with separate width and height:
- width: 64 px, height: 44 px (wider than tall = elongated)
- `StadiumBorder` with `BorderSide(color: TempleColors.line)`
- `Icons.arrow_back`, size 22, `TempleColors.ink`, centered
- `onTap: () => _saveAndExit(context)` (unchanged behavior)

No change to `TempleIconButton` itself, so all other usages keep their circular shape.
`_saveAndExit` behavior is unchanged (still auto-saves silently on tap).
