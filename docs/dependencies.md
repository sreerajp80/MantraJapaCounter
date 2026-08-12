# Approved & Prohibited Dependencies — Mantra Japa Counter

This document catalogues all approved baseline packages and strictly prohibited dependencies for the Mantra Japa Counter application.

Read [AGENTS.md](../AGENTS.md) and [security.md](security.md) before modifying `pubspec.yaml`.

---

## 1. Approved Baseline Dependencies

| Concern | Package | Version | Purpose |
|---------|---------|---------|---------|
| Core Framework | `flutter` | SDK | Cross-platform UI toolkit |
| Localization | `flutter_localizations`, `intl` | SDK / any | English and Malayalam l10n support |
| State Management | `flutter_riverpod` | `^3.3.1` | Reactive dependency injection & state management |
| Navigation | `go_router` | `^17.2.2` | Declarative route management |
| Database | `sqflite`, `path` | `^2.4.2` / `^1.9.1` | Local SQLite database storage (Schema v3) |
| Key-Value Storage | `shared_preferences` | `^2.5.3` | Session crash recovery and user preferences |
| Notifications | `flutter_local_notifications` | `^21.0.0` | Local daily practice reminders |
| File Selection | `file_picker` | `^11.0.2` | Custom notification tone selection |
| Audio Playback | `audioplayers` | `^6.1.0` | Custom tone playback |
| Data Sharing | `path_provider`, `share_plus` | `^2.1.5` / `^12.0.2` | Exporting & sharing JSON backup files |
| Logging | `logger` | `^2.5.0` | Sanitized local file and console logging |
| Package Metadata | `package_info_plus` | `^9.0.1` | Runtime version verification against `app_config.json` |
| Identifiers | `uuid` | `^4.5.1` | RFC 4122 v4 UUID generation for records |
| UI Icons | `cupertino_icons` | `^1.0.8` | Standard iOS style icon set |

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
