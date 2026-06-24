# Change Log: Larger back arrow on the Counting screen

Implements plan `plans/20260623_103000_counting-back-button-larger.md`.

## Changes
- `mantra_japa_counter/lib/screens/counting_screen.dart` — in `_topBar()`, the back
  `TempleIconButton`:
  - Added explicit `size: 48` (was the default 38 px) for a bigger, wider tap target.
  - Increased `Icons.arrow_back` size from 18 → 22 to match the larger button.

`TempleIconButton` itself was not modified (other usages keep the 38 px default).
`_saveAndExit` behavior is unchanged (still auto-saves silently on tap).
