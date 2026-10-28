# Plan: Make the project follow the updated guidelines (submodule 644faee)

**Status:** completed

**Security impact:** Yes, small and positive. Adds an explicit "no cleartext traffic" flag to the
Android manifest, adds a size check before a backup file is read, ignores `.env` files in git, and
records the new Security Baseline in `docs/security.md`. No permission is added. No control is
weakened. No new dependency.

---

## 1. What the issue is

The guidelines submodule moved from `41fa45b` to `644faee`. The new version adds a mandatory
**Security Baseline** for every app, a new rule for **the app name** (`guideline.md` §1.8), stricter
**About screen** rules (privacy-policy row, About text only from `app_config.json`), a new
**badge test**, and many doc-template changes. I checked the app against the new text. These are the
gaps:

### A. Code and config gaps

| # | Gap | Rule |
|---|---|---|
| A1 | `docs/PROJECT_PROFILE.md` does not exist. It is the first of the 9 required docs. | `DOCS_FOLDER_GUIDELINE.md` §6; standard §22.1 (run the intake, get approval) |
| A2 | Android launcher name does not match `appName` in `assets/config/app_config.json`. English `strings.xml` says "Sreeraj P MantraJapa Counter" (space), config says "SreerajP MantraJapa Counter". Sanskrit `strings.xml` says "श्रीराज् पि जपगणकः", config says "श्रीराज् पि मन्त्रजपगणकः". | `guideline.md` §1.8 |
| A3 | A second app-name key `appTitle` exists in the ARB files, with different text from `appName` (Malayalam "മന്ത്ര ജപ കൗണ്ടർ"). `main.dart` uses it for the task title; the About screen falls back to it. | §1.8 "Do not add a second app-name key in ARB" |
| A4 | `AppFlavorConfig.appName` hard-codes the app name in Dart. | standard §5.2 (`nameSuffix`), §1.8 |
| A5 | About screen ignores `app_config.json` when its English value equals a hard-coded literal, and shows ARB text (`appTitle`, `aboutDescription`) instead. It also holds an English literal in Dart. | standard §8.2 "One second source of user-visible text"; §1.8 |
| A6 | No `privacyPolicy` row in `app_config.json`. The app is on Google Play, so this is a MUST. | `guideline.md` §1.6; store gate §1 |
| A7 | Badge parity test is the old version (checks only `{heart}`). The new test also needs `madeWithLoveA11y`, exactly one `{heart}`, and no heart emoji. The config test also needs the "plain string in a multi-language app" check. (The ARB texts themselves already pass.) | standard §8.7 |
| A8 | 16 `debugPrint` calls in committed code (`settings_provider`, `screen_service`, `time_zone_service`, `qr_camera_view`, `config_service`). Some print the raw exception text. No `AppLogger` and no `lib/core/logging/`. | standard §14.2, §14.3; `guideline.md` lib layout |
| A9 | Two icon buttons use a raw string tooltip `'Preview'` (`mala_sound_picker.dart`, `notification_sound_picker.dart`). | standard §7.8, §8.2 |
| A10 | Backup import reads the whole picked file with no size check first. | standard §15.1 "Imported files: check size and type before parsing" |
| A11 | Manifest does not set `android:usesCleartextTraffic="false"` explicitly. | standard §15.1 Network; `release_process.md` §6.5 |
| A12 | `.gitignore` does not ignore `.env` / `.env.*`. | standard §20.4 |

### B. Doc gaps

| # | File | Gap |
|---|---|---|
| B1 | `docs/security.md` | Missing §1.1 Security Baseline table, §3.1 Entry Points, Third-Party SDKs table (§4), HTTPS/pinning lines (§5), §7.1 Usability Balance, string-literal note (§8.1), new Android lines in §10 (cleartext, exported components, `PendingIntent`, `FileProvider`), new OWASP wording (§12), new test rows (§15), new checklist items (§18). Scope lists only `Core Baseline`, but the app ships to Play, so `Production App Extension` applies and the OWASP sign-off is a MUST. Old APK path. |
| B2 | `docs/release_process.md` | Old APK paths (`apk/prod/release` → `flutter-apk`); tag must be `v<X.Y.Z>` once per release; "zero warnings" → "no new warnings (zero is the goal)"; `build_runner` steps must say "only if the project uses code generation" (this app does not); keystore backup wording (two backups, one offline); signing-config location line; new Security checklist items; OWASP is a MUST; cleartext wording; §17 still describes Dependabot, which was removed and is not allowed (standard §19.2). |
| B3 | `docs/architecture.md` | §6 lifecycle table lacks the `hidden` row; §7 old `aapt2` path and fixed merged-manifest path; minimum OS must point to `PROJECT_PROFILE.md` §3; §17 logging must name `AppLogger`; §19 still records Dependabot as a deviation. |
| B4 | `docs/GUIDELINES_MANIFEST.md` | Must be an unchanged copy of the submodule file. It differs. |
| B5 | `docs/implementation_progress.md` | Is now a Living doc: needs a `**Last updated:**` line instead of `**Date:**`. |
| B6 | `docs/workflow_rules.md` | Needs the "Security impact" line rule. |
| B7 | `docs/project_structure.md`, `docs/dependencies.md` | Add `lib/core/logging/`; remove any Dependabot mention. |
| B8 | `CLAUDE.md`, `AGENTS.md` | Bring in the new template lines: layout with `core/logging/`; keystore backup rule; three new Security lines and the `docs/security.md` §10 backup line; extended literals list and the `app_config.json` second-source line; "no new warnings" wording; "no fixed coverage percentage"; "Security impact" line in workflow rule 1; rule 5 must not mention Dependabot. |

---

## 2. Questions you must answer before I start

These come from the project intake (`AI_AGENT_START_HERE.md` §3). I filled in what I could find in
the repo. Please confirm or correct each one.

1. **Is the GitHub repo public?** If yes, the privacy-policy URL will be
   `https://github.com/sreerajp80/MantraJapaCounter/blob/main/PRIVACY_POLICY.md`. If not, give me
   the public URL you use in Play Console. (It must be the same URL everywhere.)
2. **Profiles:** I propose `Core Baseline` + `Production App Extension`, and **not** the
   `Sensitive Data Extension` (data sensitivity is `low`; the only encryption is the optional
   passphrase on export files). Agree?
3. **Distribution channels:** Google Play only, or Google Play + direct APK download?
   (Direct APK adds the developer-verification check, store gate §2.5A.)
4. **Badge:** keep it on, with the current text ("Made with {heart} from India" and the existing
   Malayalam / Sanskrit text)?
5. **Sanskrit app name:** the launcher shows "श्रीराज् पि जपगणकः" but `app_config.json` has
   "श्रीराज् पि मन्त्रजपगणकः". I plan to use the `app_config.json` text everywhere. Agree?
6. **ARB key prefixes (not in this plan):** the standard says every ARB key should start with a
   category prefix (`action…`, `label…`, `title…`, `tooltip…`, …). This app has 926 keys and most
   do not follow it. Renaming them touches every ARB file and most screens. This rule is older than
   this update, so I propose a **separate plan** for it later. In this plan, only the new keys I add
   follow the prefixes. Agree?

---

## 3. The fix

### 2.1 Answers so far (2026-10-27)

1. Repo is public → privacy URL is
   `https://github.com/sreerajp80/MantraJapaCounter/blob/main/PRIVACY_POLICY.md`.
2. Profiles → `Core Baseline` + `Production App Extension`; no `Sensitive Data Extension`.
3. Channels → **Google Play and direct APK download.** So `PROJECT_PROFILE.md` lists both;
   `docs/release_process.md` §12 gets a "Direct APK" row that points to the Android developer
   verification check (store gate §2.5A), and §9 gets a step to do that check before each
   direct-APK release.
4. Badge → keep it as it is.

Plan approved by the user on 2026-10-27.
5. Sanskrit launcher name → use the `app_config.json` name.
6. ARB key prefixes → separate plan later.

### 3.1 New project profile (A1)
- Create `docs/PROJECT_PROFILE.md` from `docs/guidelines/PROJECT_PROFILE_TEMPLATE.md`, filled in
  with the facts from `CLAUDE.md`, `pubspec.yaml`, `app_config.json`, the manifest, and your
  answers above. It records: product brief, data and privacy (offline, no SDKs, permissions and
  why), identity, profiles, platform Android only with `minSdk 29` and its reason (§3 is the one
  home for minimum OS), languages `en` / `ml` / `sa` with the Sanskrit + Malayalam language pack,
  About options (privacy URL, badge text and screen-reader text), tools (GitHub, CI on GitHub).

### 3.2 App name (A2, A3, A4, A5)
- `android/app/src/prod/res/values/strings.xml` → "SreerajP MantraJapa Counter".
- `android/app/src/dev/res/values/strings.xml` → "SreerajP MantraJapa Counter Dev".
- `android/app/src/prod/res/values-sa/strings.xml` → "श्रीराज् पि मन्त्रजपगणकः".
- `android/app/src/dev/res/values-sa/strings.xml` → "श्रीराज् पि मन्त्रजपगणकः निर्माण" (the dev
  suffix is kept as it is today).
- Malayalam files already match; no change.
- `lib/core/flavor/flavor_config.dart`: replace `appName` with `nameSuffix` (`' Dev'` or `''`).
- `lib/main.dart`: `onGenerateTitle` uses `appName` from `ConfigService`, resolved for the active
  language, plus `AppFlavorConfig.nameSuffix`.
- `lib/screens/about_screen.dart`: show `appName` and `description` straight from the config
  (resolved for the language). Remove the fallbacks to ARB and the English literal.
- Remove the `appTitle` key (and `@appTitle`) from all three ARB files; run `flutter gen-l10n`.
  If `aboutDescription` is no longer used anywhere, remove it too.
- Add a test (`test/core/config/app_name_consistency_test.dart`) that reads `app_config.json` and
  the six `strings.xml` files and checks that each language's launcher name equals `appName`
  (dev files: `appName` + the dev suffix).

### 3.3 Privacy-policy row (A6)
- `assets/config/app_config.json`: add `"privacyPolicy": "<URL from question 1>"` to `details`
  (a technical value, so a plain string is allowed).
- Add `aboutDetailPrivacyPolicy` to all three ARB files, with the language-pack wording:
  "Privacy policy" / "സ്വകാര്യതാ നയം" / "गोपनीयतानीतिः", each with an `@` description.
- Check that `ConfigService` / `AppConfig` and the About screen render the new row; add a
  label case if the label mapping needs it. Update `about_screen_test.dart` if needed.
- Bump nothing in `version` / `build` (that is a release step).

### 3.4 Parity test (A7)
- `test/l10n/translation_parity_test.dart`: replace the badge test with the standard §8.7
  version (both keys present in every language, exactly one `{heart}`, no heart emoji); add the
  "plain string in `details`" check with the technical keys `email`, `website`, `privacyPolicy`;
  remove `appTitle` from the allow-list.

### 3.5 Logging (A8)
- New `lib/core/logging/app_logger.dart`: a small `AppLogger` with the six levels
  (`trace`, `debug`, `info`, `warning`, `error`, `fatal`). It writes with `dart:developer` `log`
  (no new package, no log file — the app is offline and keeps nothing it does not need).
  `trace` / `debug` print nothing in prod (gated by `AppFlavorConfig`). `error` / `fatal` take
  `error` and `stackTrace`.
- Replace all 16 `debugPrint` calls with `AppLogger` calls. Log the operation name and the error
  **type** only, never the raw exception text (it can hold user data).
- Add `test/core/logging/app_logger_test.dart` (calls never throw; debug is silent in prod).

### 3.6 Tooltip (A9)
- Add `tooltipPreviewSound` to the three ARB files ("Preview" / "കേൾക്കുക" / "श्रूयताम्"),
  and use it in both pickers. The Malayalam and Sanskrit words need a native-reader check; I will
  list them in the change log.

### 3.7 Import size check (A10)
- `lib/core/constants/app_constants.dart`: add `maxBackupImportBytes` (10 MB; a full backup today
  is far smaller).
- Move the file read out of the two widgets into one service method
  (`ExportService.readBackupFile(path)`) that checks the file size first and throws a typed
  error when it is too big. Widgets show a new localized message `errorBackupTooLarge`
  (3 languages). This also removes file-path knowledge from widget code.
- Add a test for the size limit in `test/services/export_service_test.dart`.

### 3.8 Android and git (A11, A12)
- `android/app/src/main/AndroidManifest.xml`: add `android:usesCleartextTraffic="false"` to
  `<application>`.
- `.gitignore`: add `.env` and `.env.*`.
- No change to `build.gradle.kts`: its `proguardFiles(...)` line names a file that exists, which
  the guide allows.

### 3.9 Docs (B1–B8)
- Update each file in table B as listed. `docs/security.md` gets real values, for example:
  §1.1 — Secrets `verified` (none shipped), Network `verified` (no network; `INTERNET` removed;
  cleartext off), Tokens / Sign-in / Deep links / WebView `n/a` (none), Outside input `verified`
  (backup import, QR frames, platform channels), Platform hardening `verified` (only
  `MainActivity` exported, as the launcher), Randomness `verified` (`Random.secure()` for salt and
  IV; the seeded `Random` in optical sync is not security-related), Release build `verified`,
  Third-party SDKs `n/a` (none), Data minimization `verified`. §3.1 lists: backup file import,
  camera QR frames, boot / package-replaced broadcast, notification tap, platform channels.
- `docs/GUIDELINES_MANIFEST.md`: replace with an exact copy of
  `docs/guidelines/GUIDELINES_MANIFEST.md`.
- Nothing inside `docs/guidelines/` is touched.

---

## 4. Files to change

| File | Change |
|---|---|
| `docs/PROJECT_PROFILE.md` | **New** |
| `android/app/src/prod/res/values/strings.xml` | App name |
| `android/app/src/dev/res/values/strings.xml` | App name |
| `android/app/src/prod/res/values-sa/strings.xml` | App name |
| `android/app/src/dev/res/values-sa/strings.xml` | App name |
| `android/app/src/main/AndroidManifest.xml` | `usesCleartextTraffic="false"` |
| `.gitignore` | `.env`, `.env.*` |
| `assets/config/app_config.json` | `privacyPolicy` row |
| `lib/core/flavor/flavor_config.dart` | `appName` → `nameSuffix` |
| `lib/core/logging/app_logger.dart` | **New** |
| `lib/core/constants/app_constants.dart` | `maxBackupImportBytes` |
| `lib/core/config/config_service.dart` | `AppLogger` |
| `lib/main.dart` | Title from config |
| `lib/screens/about_screen.dart` | Name / description from config; privacy row |
| `lib/screens/settings/mala_sound_picker.dart` | Tooltip |
| `lib/screens/settings/notification_sound_picker.dart` | Tooltip |
| `lib/screens/settings/backup_settings_screen.dart` | Use service read + size error |
| `lib/screens/counter_list/import_export_dialog.dart` | Use service read + size error |
| `lib/services/export_service.dart` | `readBackupFile` with size check |
| `lib/services/screen_service.dart`, `lib/services/time_zone_service.dart`, `lib/providers/settings_provider.dart`, `lib/widgets/qr_camera_view.dart` | `debugPrint` → `AppLogger` |
| `lib/l10n/app_en.arb`, `app_ml.arb`, `app_sa.arb` + generated `app_localizations*.dart` | Remove `appTitle` (and unused `aboutDescription`); add `aboutDetailPrivacyPolicy`, `tooltipPreviewSound`, `errorBackupTooLarge` |
| `test/l10n/translation_parity_test.dart` | New badge + config checks |
| `test/core/config/app_name_consistency_test.dart` | **New** |
| `test/core/logging/app_logger_test.dart` | **New** |
| `test/services/export_service_test.dart` | Size-limit test |
| `test/screens/about_screen_test.dart`, other tests that use `appTitle` / `AppFlavorConfig.appName` | Follow the changes |
| `docs/security.md`, `docs/release_process.md`, `docs/architecture.md`, `docs/GUIDELINES_MANIFEST.md`, `docs/implementation_progress.md`, `docs/workflow_rules.md`, `docs/project_structure.md`, `docs/dependencies.md` | Doc updates (table B) |
| `CLAUDE.md`, `AGENTS.md` | New template lines (B8) |

Not changed: anything in `docs/guidelines/`; the backup JSON format (`exportVersion` 1 stays, no
field renamed or removed); the database schema.

---

## 5. How I will check it

1. `flutter gen-l10n`, `dart format .`, `flutter analyze` (no new warnings), `flutter test`
   (including the golden tests locally, since screen text may move).
2. Search the repo for leftovers: `appTitle`, `AppFlavorConfig.appName`, `debugPrint(`,
   `tooltip: '`, `apk/prod/release`, `Dependabot`, `zero warnings`.
3. One `flutter build apk --flavor dev --debug` to confirm the manifest and resources build, then
   `android\gradlew --stop` and check that no `GradleDaemon` / `KotlinCompileDaemon` is left.
4. Write the change log in `change_log/`.
