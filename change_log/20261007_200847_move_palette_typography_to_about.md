# Move palette and typography info from Appearance to About

Implements plan: `plans/20261007_200559_move_palette_typography_to_about.md`

## Why

Users thought the "Sacred Temple Palette" and "Typography & Scripts" cards on the
Appearance settings screen were tappable settings. They are only information.

## What changed

- `lib/screens/appearance_screen.dart` — removed the palette and typography sections and
  their private widgets (`_ColorPaletteCard`, `_ColorRow`, `_TypographyCard`,
  `_TypeSample`). The screen now has only the header card and the brightness setting.
- `lib/screens/about_screen.dart` — added two read-only info blocks after the Backup note,
  in the same style as the other info rows: the five temple colours (small dot, name, use)
  and the three fonts (name shown in its own font, use). No cards or borders. Added helpers
  `_infoSection`, `_colorLine`, `_nameAndUse`.
- `lib/l10n/app_en.arb`, `app_ml.arb`, `app_sa.arb` — new `appearanceHeaderSub` text that
  talks only about brightness. Existing palette/typography keys are reused; no new keys.
- `lib/l10n/app_localizations*.dart` — regenerated with `flutter gen-l10n`.
- `test/screens/appearance_screen_test.dart` — palette and typography headings must now be
  absent.
- `test/screens/about_screen_test.dart` — checks the palette and typography headings and
  one colour and font name appear.

## Checks

- `flutter analyze` — no issues.
- `flutter test` — all 280 tests passed.
