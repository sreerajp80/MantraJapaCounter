# Approved & Prohibited Dependencies — Mantra Japa Counter

This document catalogues all approved baseline packages and strictly prohibited dependencies for the Mantra Japa Counter application.

Read [AGENTS.md](../AGENTS.md) and [security.md](security.md) before modifying `pubspec.yaml`.

---

## 1. Approved Baseline Dependencies

| Concern | Package | Version | Purpose |
|---------|---------|---------|---------|
| Core Framework | `flutter` | SDK | Cross-platform UI toolkit |
| Localization | `flutter_localizations`, `intl` | SDK / any | English, Malayalam and Sanskrit l10n support |
| State Management | `flutter_riverpod` | `^3.3.1` | Reactive dependency injection & state management |
| Navigation | `go_router` | `^18.1.0` | Declarative route management |
| Database | `sqflite`, `path` | `^2.4.2` / `^1.9.1` | Local SQLite database storage (schema v5) |
| Key-Value Storage | `shared_preferences` | `^2.5.3` | Session crash recovery and user preferences |
| Notifications | `flutter_local_notifications`, `timezone` | `^23.0.0-dev.3` / `^0.11.1` | Local notifications and the daily practice reminder |
| File Selection | `file_picker` | `^13.1.0` | Backup import and custom notification tone selection |
| Audio Playback | `audioplayers` | `^6.1.0` | Mala and tone playback |
| Data Sharing & Optical Sync | `path_provider`, `share_plus`, `qr_flutter`, `camera` | `^2.1.5` / `^13.3.1` / `^4.1.0` / `^0.12.1` | Exporting & sharing JSON backup files and air-gapped QR sync (QR decoding by ZXing core on the Android side; no ML Kit) |
| Encryption | `cryptography` | `^2.7.0` | Optional AES-256-GCM export encryption (pure Dart) |
| Package Metadata | `package_info_plus` | `^10.2.2` | Runtime version verification against `app_config.json` |
| Identifiers | `uuid` | `^4.5.1` | RFC 4122 v4 UUID generation for records |
| Material & Cupertino widgets | `material_ui`, `cupertino_ui` | `^1.7.0` / `^1.1.2` | Material and Cupertino widgets, moved out of the Flutter SDK in 3.47. Caret constraint (engineering standard §6.1); upgrade only via the "UI package upgrades" checklist in [release_process.md](release_process.md). |

Logging uses the app's own `AppLogger` (`lib/core/logging/app_logger.dart`, built on
`dart:developer`); there is no logging package.

Dependencies are updated by hand, each in its own plan and change log. There is no Dependabot or
other update bot (engineering standard §19.2).
---

## 2. Prohibited Dependencies

Because Mantra Japa Counter is a strictly offline-first application, the following categories and specific packages are **strictly prohibited**:

- **HTTP / Networking Clients**: `http`, `dio`, `chopper` (No network requests permitted).
- **Cloud Services / BaaS**: `firebase_core`, `firebase_analytics`, `supabase_flutter`, `aws_signature_v4`.
- **Analytics & Telemetry**: `amplitude_flutter`, `mixpanel_flutter`, `flurry_analytics`, `google_analytics`.
- **Crash Reporting**: `sentry`, `firebase_crashlytics`, `bugsnag_flutter`.
- **Ad Networks**: `google_mobile_ads`, `facebook_audience_network`.
- **Connectivity Inspection**: `connectivity_plus` (Offline-first design requires no network checks).

---

## 3. Dependency Verification Procedure

Before adding any new package to `pubspec.yaml`:
1. Verify the package's `pubspec.yaml` to ensure it introduces no transitive networking or telemetry dependencies.
2. Confirm the license is compatible (MIT, BSD-3-Clause, Apache-2.0).
3. Confirm that no networking permissions (`android.permission.INTERNET`) are required.
