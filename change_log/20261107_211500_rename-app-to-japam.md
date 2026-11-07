# Change log — Rename the app to "Japam"

**Plan:** [plans/20261107_204505_rename-app-to-japam.md](../plans/20261107_204505_rename-app-to-japam.md)

## What changed

The app's display name changed from "SreerajP MantraJapa Counter" to a short name that fits
the phone launcher. The package id did not change.

| Place | en | ml | sa |
|-------|----|----|----|
| prod launcher + About screen | Japam | ജപം | जपम् |
| dev launcher | Japam Dev | ജപം നിർമാണം | जपम् निर्माण |

### App name
- `android/app/src/prod/res/values*/strings.xml` and `android/app/src/dev/res/values*/strings.xml`
  (6 files): `app_name`.
- `assets/config/app_config.json`: `appName` for en, ml and sa.
- `lib/core/config/app_config.dart`: fallback `appName` is now `Japam`.

### In-app texts
- `lib/l10n/app_en.arb`: `backupShareSubject` ("Japam Backup"), `settingsFeaturesSub`
  ("Explore all features of Japam"), `featuresHeaderTitle` ("Japam Features"), `helpPrivacyIntro`.
- `lib/l10n/app_ml.arb`, `lib/l10n/app_sa.arb`: `helpPrivacyIntro` now starts with ജപം / जपम्.
- `lib/l10n/app_localizations*.dart`: regenerated with `flutter gen-l10n`.

### Tests
- `test/core/config/config_service_test.dart`, `test/screens/features_screen_test.dart`: expect the
  new name.
- `test/screens/about_screen_test.dart`: sample data uses the new en/ml/sa names.
- `test/screens/goldens/settings_screen_en.png`: updated. **Not listed in the plan.** The shorter
  Features subtitle now fits on one line, so the cards below move up. The diff image was checked:
  this was the only change.

### Docs
- `CLAUDE.md`, `AGENTS.md`, `README.md`, `docs/PROJECT_PROFILE.md`, `docs/features.md`,
  `docs/release_process.md`: new app name.
- `PRIVACY_POLICY.md`, `pubspec.yaml` (`description`): "Japam – Mantra Japa Counter", the same as
  the planned Play Store name.

## Checks
- `flutter gen-l10n`: done.
- `dart format .`: 1 file reformatted (`config_service_test.dart`).
- `flutter analyze`: no issues.
- `flutter test`: all 419 tests pass.
- Not yet checked on a device: launcher name in each language (user to run the dev flavor).

## Still to do by hand
- Play Console: set the app name to "Japam – Mantra Japa Counter".
- Update the hosted privacy policy, if there is one.

## Security impact
None. Only display text changed. No permission, manifest attribute, package id, signing, storage
or backup-format change.
