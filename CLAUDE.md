# CLAUDE.md — Mantra Japa Counter

This file is the authoritative guide for working on this repository. Read it in full before
making any changes.

---

## Project Status

**Current state:** Flutter app (Riverpod + sqflite), v5.0.0+1. Migrated from the
Android/Kotlin v4.34 app (Jetpack Compose + Room); the original Android source has been
removed from this repository.

---

## Repository Layout

The Flutter project lives in a subfolder at the repository root:

```
l:\Android\MantraJapaCounter\
├── mantra_japa_counter\      ← Flutter project (all development happens here)
│   ├── android\
│   ├── lib\
│   ├── test\
│   └── pubspec.yaml
├── keystore\                 ← Release keystores (never commit)
├── docs\                     ← Architecture, security, release process
└── CLAUDE.md
```

All Flutter development, builds, and commands are run from within `mantra_japa_counter/`.

---

## Architecture And Design Reference

Before writing any Flutter code, read these documents in full. They are the specification for
the Flutter app.

| Document | Purpose |
|----------|---------|
| [docs/architecture.md](docs/architecture.md) | Full Flutter architecture: structure, state management, navigation, data flow, lifecycle, testing strategy |
| [docs/security.md](docs/security.md) | Security profile, permissions, binary protections, OWASP checklist |
| [docs/release_process.md](docs/release_process.md) | Release checklist, build commands, signing, distribution |
| [docs/flutter_build_flavors_guide.md](docs/flutter_build_flavors_guide.md) | Flavor setup for `dev`/`prod`, signing configuration, ProGuard rules |
| [docs/flutter_project_engineering_standard.md](docs/flutter_project_engineering_standard.md) | Engineering standards, conformance rules, structure guidelines |

---

## Flutter App Specification

### Identity

| Field | Value |
|-------|-------|
| App name (prod) | `Mantra Japa Counter` |
| App name (dev) | `Mantra Japa Counter Dev` |
| Package ID (prod) | `com.sreerajp.mantrajapacounter` |
| Package ID (dev) | `com.sreerajp.mantrajapacounter.dev` |
| Flutter package name | `mantra_japa_counter` |
| Starting version | `5.0.0+1` |
| Min Android SDK | 29 (Android 10) |
| Target Android SDK | 35 |
| Orientation | Portrait only |

### Technology Stack

| Concern | Package |
|---------|---------|
| State management | `flutter_riverpod` + `riverpod_annotation` |
| Navigation | `go_router` |
| Database | `sqflite` |
| Key-value storage | `shared_preferences` |
| Notifications | `flutter_local_notifications` |
| File picker (audio tone) | `file_picker` |
| Export / share | `path_provider` + `share_plus` |
| Logging | `logger` |
| Code generation | `build_runner` + `riverpod_generator` (if used) |

### Library Structure (`lib/`)

Follow the Tier 1 layer-first layout from `docs/architecture.md §4`:

```
lib/
├── config/        # Theme, router, app constants, flavor config
├── models/        # Immutable domain models (no Flutter or sqflite imports)
├── providers/     # Riverpod providers
├── repositories/  # sqflite + SharedPreferences access
├── screens/       # One file per screen
├── services/      # Business logic
├── widgets/       # Shared reusable widgets
└── main.dart
```

### Screens (6 total)

| Screen | Route | Purpose |
|--------|-------|---------|
| CounterListScreen | `/` | List all active counters |
| CountingScreen | `/counting/:counterId` | Active counting session |
| HistoryScreen | `/history` | Session history grouped by date |
| AboutCounterScreen | `/counter/:counterId` | Statistics for one counter |
| SettingsScreen | `/settings` | Notifications, brightness, data management |
| AboutScreen | `/about` | App info and credits |

### Database Schema

Schema version: **3** — must be identical to the Android Room schema for import compatibility.
See `docs/architecture.md §11` for the full migration history (v1 → v2 → v3).

### Critical Behavioral Requirements

These must match the Android app exactly:

1. **Zero data loss**: SharedPreferences crash-recovery write every 5 taps or 5 seconds;
   sqflite batch write every 30 seconds or 20 taps. Recover abandoned sessions on next app start.

2. **Power optimization**: Display timer updates every 2 seconds. State updates every 5 seconds.
   Database writes batched. No continuous 1-second polling.

3. **Mala calculation**: 1 mala = 108 counts. Calculate `malas = count ÷ 108` (integer division).

4. **Import compatibility**: JSON export format must be byte-compatible with the Android app's
   Gson export. Test with real export files from the Android app before release.

5. **Portrait lock**: Set in `main()` via `SystemChrome.setPreferredOrientations` before `runApp`.

---

## Build Flavors

Two flavors: `dev` and `prod`. See `docs/flutter_build_flavors_guide.md` for full setup.

The Gradle `productFlavors` block for `android/app/build.gradle.kts`:

```kotlin
flavorDimensions += "environment"
productFlavors {
    create("dev") {
        dimension = "environment"
        applicationIdSuffix = ".dev"
        versionNameSuffix = "-dev"
        resValue("string", "app_name", "Mantra Japa Counter Dev")
    }
    create("prod") {
        dimension = "environment"
        resValue("string", "app_name", "Mantra Japa Counter")
    }
}
```

Runtime flavor is auto-populated from `--flavor` — Flutter (≥ 3.19) sets the
`FLUTTER_APP_FLAVOR` dart-define for you and now rejects passing it explicitly.
Read it at runtime with `String.fromEnvironment('FLUTTER_APP_FLAVOR')`.

---

## Signing

The release keystore lives at `keystore/keystore.jks` in the repository root. The
alias inside is `sreerajp_mantrajapacounter`. Keep at least one offline backup of this
file — losing it means losing the ability to publish updates to Google Play.

Create `mantra_japa_counter/android/key.properties` (gitignored — never commit):

```properties
storeFile=<absolute-path-to>/keystore/keystore.jks
storePassword=<store-password>
keyAlias=<key-alias>
keyPassword=<key-password>
```

The `mantra_japa_counter/android/` `.gitignore` must include:
```
key.properties
```

---

## Gitignore Rules

The `mantra_japa_counter/.gitignore` must include:
```
# Signing
android/key.properties
*.jks
*.keystore

# Debug symbols
build/symbols/
```

---

## Release Builds

All production release builds require these flags. See `docs/release_process.md §9` for the
full command set:

```bash
flutter build appbundle \
  --flavor prod \
  --release \
  --obfuscate \
  --split-debug-info=build/symbols/android-prod-<version>/
```

---

## Coding Rules

- Follow `docs/flutter_project_engineering_standard.md` for all architectural decisions.
- Widgets must not know SQL, SharedPreferences keys, file paths, or notification channel IDs.
- Services must not know navigation routes, widget lifecycle, or UI copy strings.
- Repositories abstract all storage implementation details.
- No business logic in `main.dart` — only initialization and `runApp`.
- No `setState` for cross-widget state; use Riverpod providers.
- Never log counter names, session values, or user-configured fields in any flavor.
- Keep `lib/models/` free of Flutter and sqflite imports — pure Dart only.

---

## Testing

- Mirror `lib/` structure in `test/`.
- Include `test/fixtures/` with real Android-exported JSON files for import compatibility tests.
- Critical test areas (must be covered before first release):
  - Mala calculation
  - Session crash recovery (both SharedPreferences and DB write paths)
  - Database migration v1 → v2 → v3
  - Import parsing with malformed JSON (must not corrupt DB)
  - Import compatibility with Android Gson export format

---

## Pre-Release Checks

Before every release, complete the full checklist in `docs/release_process.md §8` and the
security checklist in `docs/security.md §18`.
