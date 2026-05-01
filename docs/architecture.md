# Architecture

## 1. Scope

- Product: `Mantra Japa Counter`
- Repository type: `application`
- Engineering standard profiles in force:
  - `Core Baseline`
  - `Production App Extension`
- Platforms: `Android`

---

## 2. Goals And Non-Goals

### Goals

- Allow users to create and manage multiple named mantra counters independently.
- Count mantra repetitions (japa) with a simple tap interface, including configurable increment steps and automatic mala (108-bead round) tracking.
- Persist all session history with duration and count data, grouped by date for easy review.
- Support daily and lifetime goal setting with visual progress indicators per counter.
- Provide JSON-based import/export for data backup and restore, with full compatibility with the Android app's export format.
- Deliver a fully offline, battery-efficient experience with zero data loss even after unexpected app termination.

### Non-Goals

- No cloud sync or online backup.
- No social sharing or community features.
- No multi-device or multi-account support.
- No web or desktop platform support in this release.
- No audio playback of mantras; notifications use vibration and device sounds only.

---

## 3. Architecture Summary

> The app uses a Tier 1 layer-first Flutter structure with Riverpod for state management.
> Screens delegate all business logic to use-case services; local persistence is isolated behind
> repository abstractions over a sqflite database. Session crash-recovery state is additionally
> written to SharedPreferences on every tap batch, replicating the zero-data-loss guarantee from
> the original Android version. App-wide configuration is injected at startup through a Riverpod
> ProviderScope at the root widget tree. The app is fully offline; no network access is used
> or permitted.

---

## 4. Repository Structure

### Current Structure Tier

- `Tier 1` (Layer-First)
- Why this tier is appropriate:
  - Single product domain: tracking mantra repetitions across multiple named counters.
  - Maintained by a single developer; no parallel team feature branches.
  - Six screens sharing a common data model; feature-first partitioning adds overhead without benefit.

### Top-Level Source Layout

```text
lib/
|-- config/           # Flavor config, app constants, theme tokens, router definitions
|-- models/           # Immutable domain models: Counter, JapaSession, CounterStatus, DailySummary, ActiveSession
|-- providers/        # Riverpod providers: counters list, active session, history, settings
|-- repositories/     # Data access: JapaCounterRepository (sqflite), SettingsRepository (shared_preferences)
|-- screens/          # One file per screen: counter_list, counting, history, settings, about_counter, about
|-- services/         # Business logic: CountingService, ExportService, NotificationService, SessionRecoveryService
|-- widgets/          # Shared reusable widgets: CounterCard, ProgressBar, MalaDisplay, GoalProgressBar, etc.
`-- main.dart
```

### Ownership Rules

| Path | Responsibility |
|------|----------------|
| `lib/config/` | App-wide constants, flavor config, theme tokens, go_router route definitions |
| `lib/models/` | Immutable domain entities; no Flutter imports, no sqflite imports |
| `lib/providers/` | Riverpod providers bridging services/repositories to UI; no direct sqflite access |
| `lib/repositories/` | sqflite + SharedPreferences access; maps DB rows to domain models; no business logic |
| `lib/screens/` | Build UI from widgets; read providers; initiate navigation; no direct DB or service calls |
| `lib/services/` | Business logic; calls repositories; no navigation, no widget imports, no UI copy strings |
| `lib/widgets/` | Reusable Flutter widgets; accept display data only; no business logic |

---

## 5. App Initialization Sequence

| Step | Code / Call | Notes |
|------|-------------|-------|
| 1 | `WidgetsFlutterBinding.ensureInitialized()` | Always first |
| 2 | `SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])` | Lock portrait before any frames render |
| 3 | `openDatabase(path, version: 3, onCreate: ..., onUpgrade: ...)` | Apply schema version 3; runs migrations 1→2→3 if upgrading |
| 4 | `SharedPreferences.getInstance()` | Used for crash-recovery active session and user settings |
| 5 | `AppFlavorConfig.init(flavor)` | Read flavor via `String.fromEnvironment('FLUTTER_APP_FLAVOR')` — auto-populated by `--flavor` |
| 6 | `FlutterLocalNotificationsPlugin.initialize(...)` | Create Android notification channels for goal and mala alerts |
| 7 | `SessionRecoveryService.recoverIfNeeded(db, prefs)` | Write any abandoned in-progress session from SharedPreferences to DB |
| 8 | `runApp(ProviderScope(child: MantraJapaCounterApp()))` | Riverpod scope wraps the full app |

Session recovery (step 7) restores any active session that was abandoned due to process kill or
crash, writing it to the database before the UI mounts. This preserves the zero-data-loss
guarantee of the original Android version.

---

## 6. App Lifecycle Behavior

| Lifecycle State | App Behavior |
|----------------|--------------|
| `resumed` | Resume the counting timer if a session is active; re-register notification listeners if needed |
| `inactive` | Flush pending SharedPreferences batch for active session immediately (handles incoming calls, notification shade) |
| `paused` | Write current active session state to SharedPreferences; flush pending batched DB write |
| `detached` | Perform final session DB write; close any open export file handles |
| Memory pressure | Clear cached gradient objects; do not clear session state or provider state |

---

## 7. Offline Behavior

- **Connectivity requirement**: fully offline
- **Network permission**: `INTERNET permission absent` from the merged release manifest
- **Offline data source**: sqflite (counters and sessions), SharedPreferences (active session crash recovery, user settings)

The merged Android release manifest MUST NOT contain `<uses-permission android:name="android.permission.INTERNET" />`.
Verify before every release:

```bash
aapt2 dump badging build/app/outputs/apk/prod/release/app-arm64-v8a-prod-release.apk | grep -i internet
```

Expected output: no lines. All dependencies must be audited for transitive network activity before
each release.

---

## 8. State Management

- Primary pattern: Riverpod (StateNotifier + AsyncNotifier + StreamProvider)
- Why Riverpod:
  - Compile-safe provider references without requiring BuildContext in service or logic layers.
  - `StreamProvider` wraps sqflite reactive queries, mirroring the Kotlin Flow behavior of the original Android version.
  - Clean test overrides via `ProviderContainer(overrides: [...])` without widget tree overhead.
- State boundaries:
  - Widgets own: animation controllers, focus nodes, scroll position, local form state
  - Providers own: counter list, active session tap count and timer state, history list, settings values
  - Services own: counting business logic, mala calculation, session batching thresholds, notification triggers

---

## 9. Data Flow

```text
Widget (tap) → CountingNotifier (provider) → CountingService → JapaCounterRepository → sqflite
                                                      ↓
                                       SharedPreferences (crash-recovery batch: every 5 taps or 5s)
```

Additional flows:

- `HistoryScreen` → `historyProvider` (StreamProvider) → `JapaCounterRepository.watchSessions()` → sqflite
- `SettingsScreen` → `settingsProvider` → `SettingsRepository` → SharedPreferences

Intentional layer omissions:

- `AboutScreen` reads static content; no provider or repository involved.
- `SettingsRepository` writes directly to SharedPreferences without a service layer; no business logic is needed for simple key-value preferences.

### Rules

- Widgets must not know: SQL, SharedPreferences keys, file paths, notification channel IDs.
- Services must not know: navigation routes, widget lifecycle, or UI copy strings.
- Repositories abstract: sqflite table names, column names, SharedPreferences keys, file system paths.

---

## 10. Error Handling Architecture

- **Global error handler**: `FlutterError.onError` and `PlatformDispatcher.instance.onError` configured in `main()`.
- **Domain exception hierarchy**: `AppException` sealed class in `lib/core/errors/app_exception.dart`.

| Exception Class | Thrown By | Meaning |
|----------------|-----------|---------|
| `StorageException` | JapaCounterRepository | sqflite read or write failure |
| `ValidationException` | ExportService | Import JSON failed schema validation |
| `ImportParseException` | ExportService | JSON malformed or unexpected top-level structure |

- **Error escalation policy**: transient DB write errors during counting are retried once silently; persistent failures show a SnackBar; session data is never silently discarded (SharedPreferences copy always available for recovery).
- **Fatal error screen**: if the database cannot be opened on startup, show a simple error screen with a "clear app data and restart" option.

---

## 11. Domain Model

### Current Schema Version

SQLite schema version: `3` (matches the Android Room database version 3 schema for import compatibility)

Migration history:

| Version | Change Summary |
|---------|---------------|
| 1 | Initial schema: `counters` table (id TEXT PK, name, initialCount, incrementStep, goal, dailyGoal, startDate, createdAt, status TEXT) |
| 2 | Added `japa_sessions` table (id TEXT PK, counterId TEXT FK CASCADE, counterName, count INTEGER, timestamp INTEGER, duration INTEGER); added indices on counterId and timestamp |
| 3 | Added `malas` INTEGER, `chants` INTEGER columns to `japa_sessions`; added `disabledAt` INTEGER, `disabledReason` TEXT columns to `counters` |

### Core Models Or Entities

| Type | Purpose | Mutable? | Notes |
|------|---------|----------|-------|
| `Counter` | Named mantra practice configuration with count, goals, and lifecycle status | No | Immutable; state changes produce new instances via `copyWith` |
| `JapaSession` | Single completed counting session (count, malas, chants, timestamp, duration) | No | Append-only; never edited after creation |
| `CounterStatus` | Enum: ACTIVE, DISABLED_SUCCESS, DISABLED_FAILURE | No | Controls counter visibility in the active list |
| `DailySummary` | Sessions grouped by date with aggregated totals | No | Computed at read time; not stored in DB |
| `ActiveSession` | In-progress session state during counting | Yes | Held in `CountingNotifier`; serialized to SharedPreferences for crash recovery |
| `ExportData` | Top-level wrapper for JSON import/export (list of counters + sessions) | No | Must be compatible with Android Gson export format |

### Serialization Strategy

- JSON models: yes — `ExportData`, `Counter`, and `JapaSession` implement `toJson`/`fromJson`
- Database models: yes — each entity implements `toMap`/`fromMap` for sqflite row mapping
- Separate domain entities from transport models: no — models serve as both DB entities and JSON transport (Tier 1; shapes are identical)

### Database Indexes

| Table | Indexed Columns | Reason |
|-------|----------------|--------|
| `japa_sessions` | `counterId` | Fast lookup of all sessions for a given counter (history screen, statistics) |
| `japa_sessions` | `timestamp` | Date-range queries for daily summaries and history grouped-by-date view |

---

## 12. Dependency Management And Injection

- DI approach: Riverpod provider tree — providers defined globally in `lib/providers/`
- App-root dependencies (initialized in `main()`, injected via provider overrides):
  - `Database` (sqflite) — opened once at startup; injected into `JapaCounterRepository`
  - `SharedPreferences` — injected into `SettingsRepository` and `SessionRecoveryService`
  - `FlutterLocalNotificationsPlugin` — initialized once; injected into `NotificationService`
- Test replacement strategy:
  - Override providers in tests via `ProviderContainer(overrides: [...])` with in-memory sqflite instances
  - Use a fake `NotificationService` implementation that records calls without invoking platform channels

---

## 13. Navigation

- Navigation approach: `go_router`
- Route definition location: `lib/config/router.dart`
- Protected-route strategy: none — app contains no sensitive data requiring an access lock
- Deep-link support: no

### Route Table

| Route | Screen | Notes |
|-------|--------|-------|
| `/` | CounterListScreen | Home screen; lists all active counters |
| `/counting/:counterId` | CountingScreen | Active counting session for a specific counter |
| `/history` | HistoryScreen | Full session history grouped by date |
| `/history/:counterId` | HistoryScreen (filtered) | Sessions filtered to a specific counter |
| `/counter/:counterId` | AboutCounterScreen | Statistics and details for a specific counter |
| `/settings` | SettingsScreen | Notification preferences, screen brightness, data management |
| `/about` | AboutScreen | App information and credits |

---

## 14. Persistence And External Systems

### Local Storage

- Database: `sqflite` — main data store for all counters and sessions; schema version 3
- WAL mode: enabled (`PRAGMA journal_mode=WAL`) for concurrent read performance during active counting
- Key-value storage: `shared_preferences` — active session crash recovery, notification preferences, screen brightness setting
- Secure storage: not applicable — app data contains only spiritual practice counts; no sensitive data requiring encryption

### Network

- Network client: none
- Offline behavior: fully offline

### Platform Channels Or Native Integrations

- `flutter_local_notifications`: vibration and sound notifications for daily goal achievement and mala (108-bead round) completion; custom notification channels on Android
- `file_picker`: user-selected audio file for custom notification tone (Android 13+: READ_MEDIA_AUDIO; Android ≤12: READ_EXTERNAL_STORAGE)
- `path_provider` + `share_plus`: export JSON backup to device file system or share sheet

---

## 15. Environment And Build Model

- Flavors used: `dev`, `prod`
- Runtime config mechanism: `--flavor <flavor>` (Flutter ≥ 3.19 auto-populates the `FLUTTER_APP_FLAVOR` dart-define; reading it explicitly via `--dart-define` is now rejected)
- Build outputs supported:
  - Debug APK (dev flavor) — daily development and QA
  - Release APK split-per-ABI (prod flavor) — direct sideload distribution
  - App Bundle / AAB (prod flavor) — Google Play submission
- Obfuscation: enabled for all prod release builds — symbols stored at `build/symbols/android-prod-<version>/`

---

## 16. UI System

- Theme source of truth: `lib/config/theme.dart`
- Design tokens location: `lib/config/colors.dart`, `lib/config/typography.dart`
- Shared widget strategy: `lib/widgets/` — CounterCard, CircularProgressWidget, MalaCountDisplay, GoalProgressBar, SessionListTile
- Accessibility expectations:
  - Minimum touch target: 48 × 48 dp; the counting tap area covers the full screen, far exceeding this
  - Color contrast: WCAG AA minimum (4.5:1 normal text, 3:1 large text)
  - Screen reader: TalkBack (Android) tested before each release
  - Text scale: layouts verified at 1.0×, 1.5×, 2.0× text scale

### Theme

- Material Design 3 (Material You)
- Dark and light mode support
- Dynamic color on Android 12+ (API 31+)
- Portrait orientation locked at app startup via `SystemChrome.setPreferredOrientations`

---

## 17. Logging

- Logger implementation: `logger` package
- Log file location: console only; no persistent log files in production
- Log rotation policy: n/a (console-only logging)
- Verbose logging gate: `AppFlavorConfig.enableVerboseLogging` — `true` for dev, `false` for prod
- Sensitive data policy: user data (counter names, counts, timestamps) MUST NOT appear in log messages in any flavor; log operation names and error categories only

---

## 18. Testing Strategy

| Test Type | Scope | Notes |
|-----------|-------|-------|
| Unit | `CountingService` (mala calc, increment logic, batching thresholds), `ExportService` (JSON serialization) | Pure Dart; no platform dependencies |
| Widget | `CounterListScreen`, `CountingScreen` — tap interaction, progress bar updates, session timer display | ProviderScope with overridden in-memory providers |
| Integration | Full counting flow: create counter → tap 108 times → complete session → verify DB | sqflite in-memory |
| Integration | Import/export round-trip: export JSON → purge all data → import → verify data intact | — |
| Integration | Crash recovery: simulate kill mid-session → reopen app → verify session written to DB | — |
| Integration | DB migration: apply schema v1 through v3 → verify data integrity at each step | — |

### Test Layout

```text
test/
|-- models/          # Unit tests: mala calculation, goal progress, DailySummary grouping
|-- services/        # Unit tests: CountingService, ExportService, SessionRecoveryService
|-- repositories/    # Integration tests with in-memory sqflite; migration tests
|-- screens/         # Widget tests for all 6 screens
|-- helpers/         # Fake repositories, mock notification plugin, test database factory
`-- fixtures/        # Sample JSON export files from Android app for import compatibility testing
```

### Critical Test Areas

- Mala calculation: `count ÷ 108` integer division produces correct completed rounds
- Session crash recovery: SharedPreferences written every 5 taps or 5 seconds; DB written every 30 seconds or 20 taps; both write paths must be exercised
- Daily goal progress: sessions within the same calendar date aggregated correctly across midnight boundaries
- Database migration from v1 → v2 → v3
- Import parsing: malformed JSON rejected without corrupting existing database state
- Import compatibility: Android Gson-exported JSON parses correctly in Flutter
- Error boundary: sqflite open failure handled gracefully at startup

---

## 19. Operational Constraints

- Minimum supported OS: Android 10 (API 29)
- Performance constraints:
  - Cold startup target: under 2 seconds to first meaningful frame (release build, mid-range device)
  - Frame budget: 16 ms at 60 Hz; counting tap area is performance-critical; sustained jank above 5% is release-blocking
  - APK size budget: target < 30 MB for arm64 APK; hard limit 50 MB
  - Power budget: counting screen MUST NOT prevent deep sleep; display timer updates every 2 seconds; state writes every 5 seconds; DB writes every 30 seconds or 20 taps (not continuous 1-second polling)
- Regulatory or store constraints: Google Play Developer Policy (category: lifestyle / spirituality)
- Team constraints: single developer; no CI pipeline in initial release; all checks run locally before every release
- Offline constraints: no INTERNET permission in release manifest; all transitive dependencies audited for network activity

---

## 20. Decisions And Tradeoffs

| Decision | Chosen Option | Why | Tradeoff |
|----------|---------------|-----|----------|
| State management | Riverpod | Compile-safe; mirrors Kotlin Flow; easy test overrides | Learning curve; more boilerplate than setState for simple cases |
| Database | sqflite | Full SQL control; WAL mode; Android Room schema compatible for import | Manual row mapping required; needs sqflite_ffi for desktop tests |
| Navigation | go_router | Type-safe routes; standard Flutter recommendation; supports future deep links | Over-engineered for 6 screens today; Navigator.push would suffice |
| Structure | Tier 1 layer-first | Single domain, single developer, 6 screens share all models | Would need migration to Tier 2 if major independent feature areas are added |
| Crash recovery | SharedPreferences + DB batching | Zero data loss guarantee preserved from Android version | Dual-write path adds complexity; justified given spiritual practice context |
| Screen orientation | Portrait locked | Full-screen tap counting is designed for portrait; landscape offers no benefit | Cannot rotate; acceptable for the use case |
| Platform | Android only | Existing Android user base; preserves schema compatibility | No iOS or desktop coverage until a future release |

---

## 21. Known Risks And Follow-Ups

- Risk: sqflite type mapping may differ from Android Room (BOOLEAN stored as INTEGER 0/1; timestamp format differences between Room's Long and sqflite's INTEGER).
  Mitigation: write schema integration tests against real exported data from the Android app before first release.

- Risk: `flutter_local_notifications` custom notification tone behavior differs between Android API levels (API ≥26 requires a new notification channel ID per tone change).
  Mitigation: match the Android app's existing behavior; document the limitation in the SettingsScreen UI.

- Risk: Power optimization strategies (2s display timer, 5s state updates, batched DB writes) must be re-validated in Flutter; different rendering pipeline may have different battery impact.
  Mitigation: profile on a physical mid-range device before release; compare battery drain to Android version.

- Risk: JSON import from Android app's Gson-serialized export format must parse correctly in Flutter's `dart:convert`.
  Mitigation: include real Android export files as test fixtures in `test/fixtures/`; run import round-trip test before release.

- Risk: No CI pipeline in initial release means pre-release checks depend entirely on the local checklist in `docs/release_process.md`.
  Mitigation: document every check in the release checklist; add CI as a follow-up task after the first stable release.

---

## 22. Related Documents

- `README.md`
- `docs/flutter_project_engineering_standard.md`
- `docs/flutter_build_flavors_guide.md`
- `docs/release_process.md`
- `docs/security.md`
