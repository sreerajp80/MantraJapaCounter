# CLAUDE.md — Mantra Japa Counter

This file is read by Claude Code at the start of every session in this repository. Read it in full before making any changes. See the docs table below for full detail.

---

## Project identity

| Field | Value |
|-------|-------|
| App name (prod) | `SreerajP MantraJapa Counter` |
| App name (dev) | `SreerajP MantraJapa Counter Dev` |
| Package / org id (prod) | `com.sreerajp.mantrajapacounter` |
| Package / org id (dev) | `com.sreerajp.mantrajapacounter.dev` |
| Platform(s) | Android (minSdk 29, targetSdk 36, compileSdk 37) |
| Flutter SDK | 3.47.6 or higher (pinned — check with `flutter --version`) |
| Dart SDK | `^3.13.0` (Dart 3.13.5 ships with Flutter 3.47.6) |
| Android toolchain | Java 17, AGP 9.4.1, Gradle 9.8.0, Kotlin 2.4.10 (`android.builtInKotlin=false` until all plugins support built-in Kotlin) |
| State management | `flutter_riverpod` |
| Navigation | `go_router` |
| Database | `sqflite` (schema v5) |
| Key-value storage | `shared_preferences` |
| Orientation | Portrait only |
| Connectivity | Fully offline — no INTERNET permission |

---

## Read these docs before working

| Document | Read when |
|----------|-----------|
| [docs/PROJECT_PROFILE.md](docs/PROJECT_PROFILE.md) | Always first — declared platforms, channels, languages, profiles, About options |
| [docs/architecture.md](docs/architecture.md) | Changing structure, screens, state, services, models, repositories |
| [docs/security.md](docs/security.md) | Touching permissions, logging, storage, crypto, manifest |
| [docs/release_process.md](docs/release_process.md) | Building a release, versioning, release checklist |
| [docs/guidelines/flutter_build_flavors_guide.md](docs/guidelines/flutter_build_flavors_guide.md) | Build config, signing, flavors, Gradle, ProGuard |
| [docs/guidelines/flutter_project_engineering_standard.md](docs/guidelines/flutter_project_engineering_standard.md) | Any code change — layers, naming, testing standards |
| [docs/GUIDELINES_MANIFEST.md](docs/GUIDELINES_MANIFEST.md) | The shared Flutter guidelines index |

---

## Hard rules (must follow — these override convenience)

1. **Offline-first & zero telemetry**: The app is strictly offline. No network requests, no analytics SDKs, no cloud sync, no tracking.
2. **Zero data loss**: SharedPreferences crash-recovery write every 5 taps or 5 seconds; sqflite batch write every 30 seconds or 20 taps.
3. **Import compatibility**: Every app version must import backups made by any earlier version of this app (export format `exportVersion` 1). Never rename or remove a JSON field; new fields must be optional, with a default when missing (locked by `test/repositories/backup_format_test.dart`).
4. **Never crash on malformed input**: Parser failures during import must fail gracefully with descriptive error messages without corrupting state.
5. **Portrait orientation lock**: Enforced programmatically in `main.dart` before `runApp`.

---

## Architecture rules

- **Layout**: Tier 1 layer-first under `lib/` (`core/config/`, `core/constants/`, `core/flavor/`, `core/locale/`, `core/logging/`, `core/routing/`, `core/utils/`, `l10n/`, `models/`, `providers/`, `repositories/`, `screens/`, `services/`, `theme/`, `widgets/`, `main.dart`). `core/config/` holds only `AppConfig` + `ConfigService`; `core/logging/` holds `AppLogger`. Do not restructure without instruction.
- **Layer boundaries**:
  - Widgets must not know SQL, SharedPreferences keys, file paths, or notification channel IDs.
  - Services must not know BuildContext, navigation routes, or UI strings.
  - Models must remain pure Dart without Flutter or sqflite dependencies.
- **Dependency direction**: `screens` → `providers` → `repositories`/`services` → `database`/`preferences` → `models`.
- **State management**: Riverpod providers for app state; keep `main.dart` thin.

---

## Build & run commands

```bash
flutter pub get                        # install dependencies
flutter run --flavor dev               # daily development
flutter run --flavor prod              # production build with debug tooling
flutter analyze                        # static analysis (no new warnings; zero is the goal)
flutter test                           # run all unit tests
dart format .                          # format code

# Production release APK (split per ABI). Replace <version> with the
# pubspec.yaml version without the build number (e.g. 6.13.6).
flutter build apk --flavor prod --release \
  --obfuscate --split-debug-info=build/symbols/android-prod-<version>/ --split-per-abi
```

Production Play Store bundle — **use this command for Google Play uploads** (Windows
PowerShell). It reads the version from `pubspec.yaml`, so each release keeps its own debug
symbols folder (e.g. `build/symbols/android-prod-6.13.6/`):

```powershell
$version = ((Select-String -Path pubspec.yaml -Pattern '^version:\s*(.+)$').Matches[0].Groups[1].Value -split '\+')[0]
flutter build appbundle --flavor prod --release --obfuscate "--split-debug-info=build/symbols/android-prod-$version/"
```

---

## Build flavors

| Flavor | App ID | Display name | Signing |
|--------|--------|--------------|---------|
| `dev` | `com.sreerajp.mantrajapacounter.dev` | SreerajP MantraJapa Counter Dev | Debug keystore (automatic) |
| `prod` | `com.sreerajp.mantrajapacounter` | SreerajP MantraJapa Counter | Release keystore (`android/key.properties`) |

> Flutter sets `FLUTTER_APP_FLAVOR` automatically via `--flavor`. Access in Dart via `String.fromEnvironment('FLUTTER_APP_FLAVOR')`.

---

## Signing / keystore

- Release keystore lives at `android/keystore.jks` (per `docs/guidelines/guideline.md` §2.1 — the keystore must sit directly in `android/`).
- Configure `android/key.properties` (gitignored — never commit). Its `storeFile` is `../keystore.jks`, resolved by Gradle from `android/app/`.
- Back up the keystore and its passwords as `docs/guidelines/guideline.md` §2.3 says: at least two separate secure backups, at least one of them offline.
- `.gitignore` must ignore `android/key.properties`, `android/*.jks`, `android/*.keystore`, `build/symbols/`, and `.env` / `.env.*`.

---

## Security rules

- Never log counter names, session counts, user notes, or private fields — even in debug builds. Log only through `AppLogger` (never `print` / `debugPrint`); it writes error types, never error messages.
- Follow the Security Baseline (`docs/guidelines/flutter_project_engineering_standard.md` §15.1; status in `docs/security.md` §1.1).
  Never weaken a security control to make something work; ask first.
- HTTPS only; never disable certificate checks. (The app has no network; cleartext is off in the manifest.)
- No secrets in code, assets, or `--dart-define` — anything shipped in the app is public.
- Validate all outside input (backup files — size first, then structure; QR frames; platform channels) — see `docs/security.md` §3.1.
- Request minimal permissions only; no `INTERNET` permission in AndroidManifest.
- Backup and device-transfer rules stay as recorded in `docs/security.md` §10 (`android:allowBackup="false"`).

---

## Localization rules

- All user-visible text comes from `lib/l10n/*.arb` via `AppLocalizations` — never a raw string literal in a widget. The app ships all three mandatory languages: English (`en`), Malayalam (`ml`), and Sanskrit (`sa`).
- Key parity is mandatory across `app_en.arb`, `app_ml.arb`, and `app_sa.arb` (verified by `test/l10n/translation_parity_test.dart`).
- `l10n.yaml` (project root) and `lib/l10n/app_<base>.arb` must exist. Run `flutter gen-l10n` after editing any `.arb` file.
- Every ARB key needs an `@key` description entry.
- Literals are allowed only for logs, non-UI exception messages, asset paths, route names,
  map/JSON keys, `Semantics` test tags and developer-only screens.
- The one other source of user-visible text is the About-screen values in
  `assets/config/app_config.json` (locale maps, `docs/guidelines/guideline.md` §1). The app name
  comes from `appName` there and matches every platform's own files (§1.8) — never add an app-name
  key to ARB or write the name in Dart.
- The About screen ends with the signature badge "Made with {heart} from India" (`madeWithLove` /
  `madeWithLoveA11y`, as recorded in `docs/PROJECT_PROFILE.md` §5). Use `{heart}`, never an emoji.

---

## Code style / naming

- Files `snake_case.dart`; classes `PascalCase`; methods/variables `camelCase`; providers `camelCase` + `Provider` suffix.
- Use `package:` imports over relative imports for external references.
- Import `package:material_ui/material_ui.dart` / `package:cupertino_ui/cupertino_ui.dart`, never `package:flutter/material.dart` / `package:flutter/cupertino.dart` (enforced by the `migrate_design_widgets` lint).
- For `localizationsDelegates`, always use `LocaleConfig.localizationsDelegates`, never the generated `AppLocalizations.localizationsDelegates`.
- Run `dart format .` before every commit; `flutter analyze` adds no new warnings (zero is the goal).

---

## Testing rules

- Mirror `lib/` structure in `test/` (e.g., `test/models/`, `test/services/`, `test/core/utils/`).
- No fixed coverage percentage (engineering standard §18.3); the critical areas are listed below.
- Required test coverage areas: Mala calculations (default 1 mala = 108 counts, set per counter; 0 = no mala), session recovery, database migrations (v1 → v2 → v3 → v4 → v5), JSON export/import compatibility.

---

## Dependency constraints

- **Prohibited dependencies**: HTTP clients (`http`, `dio`), cloud/BaaS (`firebase`), analytics (`amplitude`, `mixpanel`), crash reporting (`sentry`, `crashlytics`), ad networks, or network-info libraries.

---

## Where things live

```
CLAUDE.md            # this file — Claude Code native rules
AGENTS.md            # AI agent instructions
.github/             # CI checks only (no Dependabot)
docs/                # design docs & architectural baseline
plans/               # change implementation plans
change_log/          # implementation log records
assets/              # configuration assets and custom fonts
lib/                 # app source code
test/                # unit and widget test suite
```

---

## Workflow rules (mandatory — from global rules)

Every change follows plan-before-changing and log-after-changing:

1. **Plan before changing.** Write a full plan to `plans/` named `yyyymmdd_hhMMss_<short-slug>.md` with a `**Status:**` line, the files to change, the issue, and the fix. Then **STOP and get explicit approval** before editing/creating/deleting any project file (other than the plan). A question or ambiguous reply is not approval. A plan that touches network, storage, sign-in, permissions, deep links, WebViews, platform folders or dependencies has a short **"Security impact"** line (engineering standard §22.2).
2. **Log after changing.** After implementing, write a change log to `change_log/` named `yyyymmdd_hhMMss_<short-slug>.md` describing what changed and referencing its plan.
3. **Relative paths & privacy only.** All `plans/` and `change_log/` files MUST use relative repository paths only (never absolute system paths like `C:\...`, `l:\...`, or `file:///...`). They MUST NOT contain any sensitive or private information that cannot be shared publicly on the internet (secrets, API keys, tokens, passwords, keystore passphrases, local absolute paths, internal IPs, credentials, or PII).
4. **Guidelines submodule is read-only.** Never edit, check out or commit `docs/guidelines/` or its version. If a guideline needs a change, write a note for the user instead (`docs/guidelines/DOCS_FOLDER_GUIDELINE.md` §1.1). If the folder is empty or missing, stop and ask the user.
5. **CI is checks only.** GitHub CI runs only `flutter pub get`, the format check, the l10n staleness check, `flutter analyze`, and `flutter test`. CI never builds release artifacts, signs, holds signing secrets, uploads, or publishes. Release builds are done locally. Dependencies are updated by hand — no Dependabot or other update bot (`docs/guidelines/flutter_project_engineering_standard.md` §19).

---

## Communication rules

- **Always use simple English.** Write all responses, plans, change logs, and explanations in plain, simple English. Short sentences, common words. Explain any jargon you must use.

---

## What Claude must always / never do

**Always:**
- Read `CLAUDE.md` and relevant `docs/` files before making edits.
- Maintain pure Dart models without Flutter or sqflite dependencies.
- Run `flutter analyze` and `flutter test` after modifications.

**Never:**
- Add networking or cloud SDK dependencies.
- Put SQL queries, SharedPreferences keys, or UI text inside widget code.
- Hard-code About screen information instead of reading from `ConfigService`.
