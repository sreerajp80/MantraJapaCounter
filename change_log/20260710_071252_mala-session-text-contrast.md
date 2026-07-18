# Change log — Fix low-contrast "mala this session" text

Implements plan: `plans/20260710_071252_mala-session-text-contrast.md`.

## What was changed

- `mantra_japa_counter/lib/screens/counting_screen.dart` — in `_centerNumber(...)`,
  the `malaThisSession` caption ("+N mala this session") shown at the centre of the
  mala circle now uses `TempleColors.vermillionDeep` (`0xFF9A2C10`) instead of
  `TempleColors.sandal` (`0xFFD8A13A`).

## Why

The `sandal` golden colour on the light peach medallion gave only about a 2:1
contrast ratio, well below the WCAG AA minimum of 4.5:1 for small text, making the
caption very hard to read. `vermillionDeep` raises the contrast to about 6.6:1 and
matches the app's existing "achievement / goal reached" accent, which fits a
"mala completed" message.

## Verification

- `flutter analyze lib/screens/counting_screen.dart` — No issues found.
- Colour change only; no logic or layout changed.
