# AGENTS.md — Mantra Japa Counter

This file is read by AI agents and LLM coding assistants (Gemini, Antigravity, Cursor, Windsurf, Codex, etc.) at the start of every session in this repository. Read it in full before making any changes. See the docs table below for full detail.

---

## Project identity

| Field | Value |
|-------|-------|
| App name (prod) | `SreerajP MantraJapa Counter` |
| App name (dev) | `SreerajP MantraJapa Counter Dev` |
| Package / org id (prod) | `com.sreerajp.mantrajapacounter` |
| Package / org id (dev) | `com.sreerajp.mantrajapacounter.dev` |
| Platform(s) | Android (minSdk 29, targetSdk 35) |
| Flutter SDK | `^3.12.2` / 3.44.8 or higher |
| Dart SDK | `^3.12.2` or higher |
| State management | `flutter_riverpod` |
| Navigation | `go_router` |
| Database | `sqflite` (schema v3) |
| Key-value storage | `shared_preferences` |
| Orientation | Portrait only |
| Connectivity | Fully offline — no INTERNET permission |

---

## Read these docs before working

| Document | Read when |
|----------|-----------|
| [docs/architecture.md](docs/architecture.md) | Changing structure, screens, state, services, models, repositories |
| [docs/security.md](docs/security.md) | Touching permissions, logging, storage, crypto, manifest |
| [docs/release_process.md](docs/release_process.md) | Building a release, versioning, release checklist |
| [docs/flutter_build_flavors_guide.md](docs/flutter_build_flavors_guide.md) | Build config, signing, flavors, Gradle, ProGuard |
| [docs/flutter_project_engineering_standard.md](docs/flutter_project_engineering_standard.md) | Any code change — layers, naming, testing standards |
| [docs/GUIDELINES_MANIFEST.md](docs/GUIDELINES_MANIFEST.md) | The shared Flutter guidelines index |

---

## Hard rules (must follow — these override convenience)

1. **Offline-first & zero telemetry**: The app is strictly offline. No network requests, no analytics SDKs, no cloud sync, no tracking.
2. **Zero data loss**: SharedPreferences crash-recovery write every 5 taps or 5 seconds; sqflite batch write every 30 seconds or 20 taps.
3. **Import compatibility**: JSON export format must remain byte-compatible with the original Android Room/Gson export format.
4. **Never crash on malformed input**: Parser failures during import must fail gracefully with descriptive error messages without corrupting state.
5. **Portrait orientation lock**: Enforced programmatically in `main.dart` before `runApp`.

---

## Architecture rules

- **Layout**: Tier 1 layer-first under `lib/` (`config/`, `core/config/`, `models/`, `providers/`, `repositories/`, `screens/`, `services/`, `widgets/`, `main.dart`).
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
flutter analyze                        # static analysis (must be clean)
flutter test                           # run all unit tests
dart format .                          # format code

# Production release APK (split per ABI)
flutter build apk --flavor prod --release \
  --obfuscate --split-debug-info=build/symbols/android-prod-v6.10.0/ --split-per-abi

# Production Play Store bundle
flutter build appbundle --flavor prod --release \
  --obfuscate --split-debug-info=build/symbols/android-prod-v6.10.0/
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
- `.gitignore` must ignore `android/key.properties`, `android/*.jks`, `android/*.keystore`, and `build/symbols/`.

---

## Security rules

- Never log counter names, session counts, user notes, or private fields — even in debug builds.
- Request minimal permissions only; no `INTERNET` permission in AndroidManifest.
- Keep `android:allowBackup="false"` in the manifest unless encrypted export is used.

---

## Localization rules

- All user-visible text comes from `lib/l10n/*.arb` via `AppLocalizations` — never a raw string literal in a widget. This applies even though the app ships only `en` and `ml`.
- `l10n.yaml` (project root) and `lib/l10n/app_<base>.arb` must exist. Run `flutter gen-l10n` after editing any `.arb` file.
- Every ARB key needs an `@key` description entry.
- Literals are allowed only for logs, non-UI exception messages, asset paths, route names, and map/JSON keys.

---

## Code style / naming

- Files `snake_case.dart`; classes `PascalCase`; methods/variables `camelCase`; providers `camelCase` + `Provider` suffix.
- Use `package:` imports over relative imports for external references.
- Keep `flutter analyze` clean with 0 warnings before committing.

---

## Testing rules

- Mirror `lib/` structure in `test/` (e.g., `test/models/`, `test/services/`, `test/utils/`).
- Required test coverage areas: Mala calculations (1 mala = 108 counts), session recovery, database migrations (v1 → v2 → v3), JSON export/import compatibility.

---

## Dependency constraints

- **Prohibited dependencies**: HTTP clients (`http`, `dio`), cloud/BaaS (`firebase`), analytics (`amplitude`, `mixpanel`), crash reporting (`sentry`, `crashlytics`), ad networks, or network-info libraries.

---

## Where things live

```
AGENTS.md            # this file — AI agent rules
CLAUDE.md            # Claude Code native project rules
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

1. **Plan before changing.** Write a full plan to `plans/` named `yyyymmdd_hhMMss_<short-slug>.md` with a `**Status:**` line, the files to change, the issue, and the fix. Then **STOP and get explicit approval** before editing/creating/deleting any project file (other than the plan). A question or ambiguous reply is not approval.
2. **Log after changing.** After implementing, write a change log to `change_log/` named `yyyymmdd_hhMMss_<short-slug>.md` describing what changed and referencing its plan.
3. **Relative paths & privacy only.** All `plans/` and `change_log/` files MUST use relative repository paths only (never absolute system paths like `C:\...`, `l:\...`, or `file:///...`). They MUST NOT contain any sensitive or private information that cannot be shared publicly on the internet (secrets, API keys, tokens, passwords, keystore passphrases, local absolute paths, internal IPs, credentials, or PII).

---

## Communication rules

- **Always use simple English.** Write all responses, plans, change logs, and explanations in plain, simple English. Short sentences, common words. Explain any jargon you must use.

---

## What AI agents must always / never do

**Always:**
- Read `AGENTS.md` and relevant `docs/` files before making edits.
- Maintain pure Dart models without Flutter or sqflite dependencies.
- Run `flutter analyze` and `flutter test` after modifications.

**Never:**
- Add networking or cloud SDK dependencies.
- Put SQL queries, SharedPreferences keys, or UI text inside widget code.
- Hard-code About screen information instead of reading from `ConfigService`.
