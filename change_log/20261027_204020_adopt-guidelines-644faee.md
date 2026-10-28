# Change log: Make the project follow the updated guidelines (submodule 644faee)

Implements: [plans/20261027_201740_adopt-guidelines-644faee.md](../plans/20261027_201740_adopt-guidelines-644faee.md)

User decisions (2026-10-27): the repo is public, so the privacy-policy URL is the GitHub link to
`PRIVACY_POLICY.md`; profiles are `Core Baseline` + `Production App Extension` (no
`Sensitive Data Extension`); channels are Google Play and direct APK; the badge stays as it is;
the Sanskrit launcher name follows `app_config.json`; the ARB key-prefix rename is a separate plan
later.

**Security impact:** positive only. Cleartext traffic is now off explicitly, backup import checks
the file size before reading, `.env` files are git-ignored, logs no longer print raw exception
text, and the Security Baseline is recorded. No permission added, no dependency added, no control
weakened.

Nothing in `docs/guidelines/` was changed. The backup JSON format (`exportVersion` 1) and the
database schema are unchanged.

## Code and config

| File | Change |
|---|---|
| `docs/PROJECT_PROFILE.md` | **New.** Filled in from the template with the intake answers above. |
| `android/app/src/{prod,dev}/res/values/strings.xml` | English launcher name now "SreerajP MantraJapa Counter" (was "Sreeraj P …"), matching `app_config.json`. |
| `android/app/src/{prod,dev}/res/values-sa/strings.xml` | Sanskrit launcher name now "श्रीराज् पि मन्त्रजपगणकः" (dev keeps its existing suffix). |
| `android/app/src/main/AndroidManifest.xml` | `android:usesCleartextTraffic="false"`. |
| `.gitignore` | `.env`, `.env.*`. |
| `assets/config/app_config.json` | New `privacyPolicy` row (plain string — a technical value). |
| `lib/core/flavor/flavor_config.dart` | `appName` (hard-coded name) replaced by `nameSuffix`. |
| `lib/main.dart` | Loads `app_config.json` before `runApp`; the task title is `appName` for the active language + `nameSuffix`. |
| `lib/screens/about_screen.dart` | App name and description come straight from `app_config.json`; removed the ARB fallbacks and the English literal; label for the `privacyPolicy` row. |
| `lib/l10n/app_{en,ml,sa}.arb` (+ generated files) | Removed `appTitle` (second app-name key) and the now-unused `aboutDescription`. Added `aboutDetailPrivacyPolicy`, `tooltipPreviewSound`, `errorBackupTooLarge`. |
| `lib/core/logging/app_logger.dart` | **New** `AppLogger` (six levels, `dart:developer`, no package, no log file). `trace` / `debug` are silent in prod. Only the error type is written, never the message. |
| `lib/core/config/config_service.dart`, `lib/services/screen_service.dart`, `lib/services/time_zone_service.dart`, `lib/providers/settings_provider.dart`, `lib/widgets/qr_camera_view.dart` | All 16 `debugPrint` calls replaced by `AppLogger`; raw `$e` text no longer logged. |
| `lib/screens/settings/mala_sound_picker.dart`, `lib/screens/settings/notification_sound_picker.dart` | `'Preview'` literal tooltip → `tooltipPreviewSound`. |
| `lib/core/constants/app_constants.dart` | `maxBackupImportBytes` (10 MB). |
| `lib/services/export_service.dart` | New `readBackupFile()` that checks the size before reading, and `BackupTooLargeException`. |
| `lib/screens/counter_list/import_export_dialog.dart`, `lib/screens/settings/backup_settings_screen.dart` | Read the picked file through `readBackupFile()` (no `File` in widget code) and show `errorBackupTooLarge`. |

No change to `android/app/build.gradle.kts`: its `proguardFiles(...)` line names a file that
exists, which the flavors guide allows.

## Tests

| File | Change |
|---|---|
| `test/l10n/translation_parity_test.dart` | Badge test replaced by the standard §8.7 version (both keys, exactly one `{heart}`, no heart emoji); new "plain string in `details`" check; `appTitle` removed from the allow-list. |
| `test/core/config/app_name_consistency_test.dart` | **New.** Each prod `strings.xml` name equals `appName`; each dev name is `appName` + a suffix. |
| `test/core/logging/app_logger_test.dart` | **New.** Prod silence for trace/debug, error type only, a broken sink never throws. |
| `test/services/export_service_test.dart` | `readBackupFile` size-limit tests. |
| `test/screens/about_screen_test.dart` | Expect the app name from the config (locale map), not the old ARB `appTitle`. |

## Docs

| File | Change |
|---|---|
| `docs/security.md` | Profiles now include `Production App Extension`. New §1.1 Security Baseline table, §3.1 Entry Points, Third-Party SDKs table, §5 transit rules, §7.1 Usability Balance, string-literal note in §8.1, new §10 Android lines (cleartext, exported components, `PendingIntent`, `FileProvider`), new OWASP wording and MUST in §12, new rows in §15 and §18. Also fixed old text that said Android backup was on (the manifest has it off) and that M10 had no encryption. |
| `docs/release_process.md` | `flutter-apk` paths; tag `v<X.Y.Z>` once per release; "no new warnings"; no code generation in this project; size-analysis build moved before the hardened build; keystore backup rule (two backups, one offline); signing-config location; new §6.5–§6.7; new Security checklist items; OWASP MUST; direct-APK developer-verification step and §12 row; `material_ui` / `cupertino_ui` caret wording; Dependabot section replaced by "updated by hand". |
| `docs/architecture.md` | `core/logging/` in the layout; `hidden` lifecycle row; `aapt2 dump permissions` with the `flutter-apk` path and the merged-manifest note; app-name rule in §15; `AppLogger` in §17; minimum OS points to `PROJECT_PROFILE.md` §3; Dependabot lines removed. |
| `docs/GUIDELINES_MANIFEST.md` | Replaced with an exact copy of the submodule file. |
| `docs/implementation_progress.md` | `**Last updated:**` line (now a Living doc). |
| `docs/workflow_rules.md` | Plan status values and the "Security impact" line rule. |
| `docs/project_structure.md`, `docs/dependencies.md` | `core/logging/`; dependency table brought up to date with `pubspec.yaml` (no `logger`, `mobile_scanner` → `camera`, caret UI packages); no Dependabot. |
| `CLAUDE.md`, `AGENTS.md` | New template lines: `PROJECT_PROFILE.md` row, `core/logging/`, keystore backup rule, Security Baseline lines, longer literals list, `app_config.json` second-source line, badge line, "no new warnings", no fixed coverage %, "Security impact" in rule 1, CI rule 5 without Dependabot. `AGENTS.md` now matches `CLAUDE.md` except the tool-specific wording. |
| `README.md` | APK output path. |

## Needs native-reader review

- Malayalam: `tooltipPreviewSound` "കേൾക്കുക", `errorBackupTooLarge` "ഈ ഫയൽ വളരെ വലുതാണ്; ഇത് ഈ ആപ്പിന്റെ ബാക്കപ്പ് അല്ല."
- Sanskrit: `tooltipPreviewSound` "श्रूयताम्", `errorBackupTooLarge` "इयं सञ्चिका अतिबृहती, अस्य अनुप्रयोगस्य प्रतिलिपिः न भवति।"
- The privacy-policy labels come from the language-pack glossary ("സ്വകാര്യതാ നയം", "गोपनीयतानीतिः").

## Not done (separate work)

- ARB key prefixes (`action…`, `label…`, `title…`, `tooltip…`, …) for the existing 926 keys —
  a separate plan, as the user decided.

## Checks done

- `flutter gen-l10n`; `dart format --set-exit-if-changed` — no changes needed.
- `flutter analyze` — no issues.
- `flutter test` — all 410 tests pass, golden tests included.
- Search for leftovers (`appTitle`, `AppFlavorConfig.appName`, `debugPrint(`, `tooltip: '`,
  `apk/prod/release`, old Dependabot text, `git tag v<version>`): none left outside plans and
  change logs.
- `flutter build apk --flavor dev --debug` — builds. Afterwards `gradlew --stop` ran and no
  `GradleDaemon` or `KotlinCompileDaemon` process is left. The build-date file the build rewrote
  was restored.
