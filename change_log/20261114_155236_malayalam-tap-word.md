# Change log: One Malayalam word for "tap" — തട്ടുക / തട്ടൽ

Implements plan: `plans/20261114_155236_malayalam-tap-word.md`

## What changed

The Malayalam text now uses one word for "tap" everywhere in the app:

- tap (verb) → **തട്ടുക**
- tapping / a tap (noun) → **തട്ടൽ**

63 strings in `lib/l10n/app_ml.arb` were reworded. The words replaced were തൊടുക, തൊടൽ and its
forms (തൊടലുകൾ, തൊടലിൽ, തൊടലും …), തൊട്ട്, തൊട്ടാൽ, തൊട്ട, തൊടുമ്പോൾ, the loan word ടാപ്പ്,
and സ്പർശനം / സ്പർശിക്കുക where they meant a tap. The full mapping is in the plan.

Not changed: `featCat4Name` and `featImmersionH2`. They use സ്പർശന പ്രതികരണം for vibration
(haptic) feedback, which is not a tap.

`lib/l10n/app_localizations_ml.dart` was regenerated with `flutter gen-l10n`. English, Sanskrit
and the Dart code did not change, and no keys were added or removed.

## Checks

- No തൊട or ടാപ്പ് words are left in `app_ml.arb`. The only സ്പർശ words left are the two
  haptic strings.
- `dart format .` — no changes.
- `flutter analyze` — no issues.
- `flutter test` — all 429 tests pass (includes the translation parity test).
- Not yet read in the app on a phone.

## Security impact

None. Text only.
