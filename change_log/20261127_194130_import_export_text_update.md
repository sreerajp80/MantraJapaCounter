# Change log: Import/export texts for settings and unfinished malas

Implements plan: `plans/20261127_193800_import_export_text_update.md` (including its amendment)

## What changed

Two texts still described the old backup (only counters and history). They now say that a
backup also holds the app settings and each counter's unfinished mala, and that import replaces
settings too. Only the values changed, in all three languages; no key was added, renamed or
removed.

| Key | Where it shows |
|-----|----------------|
| `importExportBody` | Import / Export dialog |
| `tutorialStep25Desc` | App tutorial step 25 |

Left unchanged on purpose: the import warnings ("Import replaces ALL current data…") are still
true, and `helpFaqQ10Answer` (Optical Sync only adds or updates the chosen counters) is still
true, because the QR import sheet always imports selected counters and a selected import never
changes settings.

## Files

| File | Change |
|------|--------|
| `lib/l10n/app_en.arb`, `lib/l10n/app_ml.arb`, `lib/l10n/app_sa.arb` | New text for the two keys. |
| `lib/l10n/app_localizations.dart`, `lib/l10n/app_localizations_en.dart`, `lib/l10n/app_localizations_ml.dart`, `lib/l10n/app_localizations_sa.dart` | Regenerated with `flutter gen-l10n`. |
| `test/screens/counter_list_screen_test.dart` | (Amendment) The test looked for the old words `'Export backs up'`; it now looks for `'Export saves'`. Same check: the dialog opens with its text and closes on Cancel. |

## Checks

- `flutter gen-l10n`: done.
- `dart format`: no changes.
- `flutter analyze`: no issues.
- `flutter test`: all 481 tests pass (includes translation parity).
- Not checked by hand on a phone.

## Note

The Malayalam and Sanskrit text should be read by a native reader before release.

## Security impact

None. Text only.
