# Change Log: Elongated (pill-shaped) back button on the Counting screen

Implements plan `plans/20260623_104500_counting-back-button-elongated.md`.

## Changes
- `mantra_japa_counter/lib/screens/counting_screen.dart` — in `_topBar()`, replaced the
  back `TempleIconButton` (circular, 48×48) with an inline `Material` + `InkWell`:
  - `StadiumBorder` pill shape, 64 px wide × 44 px tall (elongated width-wise).
  - Same temple styling: `TempleColors.card` fill, `TempleColors.line` border.
  - `Icons.arrow_back`, size 22, `TempleColors.ink`, centered.
  - `onTap: () => _saveAndExit(context)` — unchanged behavior.

`TempleIconButton` itself was not modified; all other usages keep their circular shape.
`_saveAndExit` behavior is unchanged (still auto-saves silently on tap).
