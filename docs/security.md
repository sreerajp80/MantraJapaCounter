# Security — Mantra Japa Counter

This app stores spiritual practice counting data only. There is no authentication data, financial
data, health records, or personally identifiable information. The security profile is **low**.

The sections below document the controls in place and the deliberate decisions not to apply
controls that would be disproportionate for this risk level.

---

## 1. Security Scope

- App: `Mantra Japa Counter`
- Data sensitivity level: `low`
- Engineering standard profiles in force:
  - `Core Baseline`
- Platforms in scope:
  - `Android`

---

## 2. Security Objectives

- Prevent accidental disclosure of usage data through debug builds, logs, or misconfigured backup settings.
- Ensure the release binary resists trivial reverse engineering through code obfuscation.
- Verify the app operates fully offline with no unintended network access in any release build.
- Keep permissions minimal: request only permissions actively used by the app.
- Ensure imported data is validated and cannot corrupt the database through malformed JSON.

---

## 3. Threat Model Summary

### In Scope Threats

- Accidental plaintext export disclosure — user shares the backup file without realizing it is human-readable.
- Log leakage of user-created counter names in debug builds left on a shared device.
- Reverse engineering of application logic from a release binary without obfuscation.
- Permissions creep: app requesting more permissions than are actively needed.

### Out Of Scope Threats

- Physical device attacks or rooted device exploits.
- Nation-state or advanced persistent threat adversaries.
- Network interception (app has no network traffic).
- Authentication bypass (app has no authentication).
- Data exfiltration attacks — counting data has no significant value to third parties; no PII, no credentials, no financial information.

---

## 4. Sensitive Data Inventory

| Data Type | Example | Where It Exists | Protection Required |
|-----------|---------|-----------------|---------------------|
| Counter names | "Om Namah Shivaya" | sqflite DB, JSON export | None — not sensitive |
| Session counts and timestamps | 432 taps, 2024-01-15 08:30 | sqflite DB, JSON export | None — not sensitive |
| Notification preferences | vibration enabled, custom tone path | SharedPreferences | None — not sensitive |
| Screen brightness setting | 70% | SharedPreferences | None — not sensitive |
| Active session crash-recovery state | In-progress tap count and session ID | SharedPreferences | None — ephemeral; cleared on session complete or recovery |

No secrets, tokens, health records, financial data, or personally identifiable information are
stored or transmitted by this app.

---

## 5. Storage Model

### At Rest

- Primary local storage: `sqflite` — counters and sessions database; unencrypted (data is not sensitive)
- Secure key storage: not applicable — no secrets or encryption keys
- Backup behavior: Android Auto Backup enabled (`android:allowBackup=true`) with explicit `backup_rules.xml`; session and counter data backed up to help users recover after device loss or replacement

### In Memory

- No sensitive values are held in memory; all in-memory state is counting data and UI state
- Memory clearing strategy: not applicable

### In Transit

- Network use: none — fully offline
- Transport protections: not applicable

---

## 6. Cryptography Design

Not applicable. The app stores no sensitive data that requires encryption.

Export files are plaintext JSON. The export UX informs users that the exported file is
unencrypted before they save or share it.

---

## 7. Authentication And Access Control

- App-lock strategy: none — data is not sensitive enough to warrant a lock screen
- Fallback behavior: n/a
- Session-expiry rule: n/a
- Background lock rule: n/a
- Protected-route strategy: none — all routes are accessible without authentication
- Lock screen implementation: none

Future hardening option: add an optional biometric or PIN app-lock as a user preference, for
users who share a device and want privacy for their practice history.

---

## 8. Binary Protections

### 8.1 Obfuscation

All production release builds MUST be compiled with:

```bash
--obfuscate --split-debug-info=build/symbols/android-prod-<version>/
```

Obfuscation is applied even for a low-sensitivity app because it is a build-time no-cost control
that raises the bar for casual reverse engineering of app logic.

The debug symbol files produced by `--split-debug-info` MUST be:
- Archived securely alongside the release artifact at `releases/v<version>/symbols/`.
- Never committed to source control (add `build/symbols/` to `.gitignore`).
- Retained for the lifetime of the released version for crash symbolication.

### 8.2 R8 / ProGuard

Android release builds run R8 code shrinking. Verify `android/app/proguard-rules.pro` keeps:
- Flutter engine classes: `-keep class io.flutter.** { *; }`
- sqflite native module: `-keep class com.tekartik.sqflite.** { *; }`
- JSON serialization: keep `toJson`/`fromJson` methods if generated via `json_serializable`

Run a full release build test after adding any new dependency; R8 can silently strip
classes accessed only via reflection. See `docs/flutter_build_flavors_guide.md` for required rules.

### 8.3 Debuggable Flag

Verify `android:debuggable=false` in the merged release manifest before every production release.

```bash
aapt2 dump badging build/app/outputs/apk/prod/release/app-arm64-v8a-prod-release.apk | grep -i debuggable
```

Expected: no output (attribute absent = false by default). If it appears, investigate
`isDebuggable` in `android/app/build.gradle.kts` under the release build type.

---

## 9. Logging And Telemetry Policy

### Never Log

- Counter names (user-created; treated as private even if not technically sensitive)
- Full session data rows or field values
- Any value the user has typed, selected, or configured

### Allowed Diagnostic Context

- Operation name (e.g., `"openDatabase"`, `"insertSession"`, `"importFromJson"`)
- Screen or flow name (e.g., `"CountingScreen"`, `"ExportService"`)
- Error category (e.g., `"StorageException"`, `"ImportParseException"`) — not raw exception messages if they may contain user data

### Logging Controls

- Logger implementation: `logger` package
- Verbose logging gate: `AppFlavorConfig.enableVerboseLogging` — `true` for dev flavor, `false` for prod
- Log level in production: `info` and above only; debug and verbose calls stripped in prod flavor
- Redaction strategy: user-provided field values (counter names, file paths) replaced with `[VALUE]` in any log output

---

## 10. Platform Security Controls

### Android

- `android:allowBackup`: `true` — data is not sensitive; backup helps users recover after device loss
- `android:fullBackupContent`: `backup_rules.xml` — explicitly includes counter and session data; explicitly excludes the `active_session` SharedPreferences key (ephemeral crash-recovery state that is meaningless after process termination)
- Screenshot protection: not applied — counting screen contains no sensitive information; `FLAG_SECURE` would unnecessarily block users from screenshotting their practice progress
- `android:debuggable`: MUST be `false` in all release builds (verified per section 8.3)
- Root detection: not implemented — out of scope for this threat model

### iOS

Not in scope for this release.

### Windows

Not in scope for this release.

---

## 11. Permissions

| Permission | Why It Is Needed | Requested When | Denial Handling |
|------------|------------------|----------------|-----------------|
| `VIBRATE` | Vibration feedback on mala completion and daily goal achievement | Declared in manifest; no runtime request | Notifications sent without vibration |
| `POST_NOTIFICATIONS` | Show local notifications on Android 13+ (API 33+) | First time user enables notifications in Settings screen | Notifications silently disabled; user informed in Settings |
| `READ_MEDIA_AUDIO` | User picks a custom notification tone from device storage (Android 13+) | When user taps "Choose custom tone" in Settings | Default system tone used instead; feature gracefully unavailable |
| `READ_EXTERNAL_STORAGE` | User picks a custom notification tone from device storage (Android ≤12) | When user taps "Choose custom tone" in Settings on Android ≤12 | Default system tone used instead; feature gracefully unavailable |

Permission review rules:

- `INTERNET` permission MUST be absent from the merged release manifest. Verify before every release.
- No dangerous permissions are requested at app startup; all requested at point of use with a clear rationale.
- The app functions fully without `POST_NOTIFICATIONS`, `READ_MEDIA_AUDIO`, and `READ_EXTERNAL_STORAGE`; these control optional features only.

---

## 12. OWASP Mobile Top 10 Compliance

Review and sign off each item before every production release.

| ID | Risk | Control | Status |
|----|------|---------|--------|
| M1 | Improper Credential Usage | No credentials, tokens, or secrets in this app | n/a |
| M2 | Inadequate Supply Chain Security | `pubspec.lock` committed; dependency audit performed before each release; licenses verified | verified |
| M3 | Insecure Authentication | No authentication in app; no lock screen bypasses possible | n/a |
| M4 | Insufficient Input/Output Validation | Import JSON validated; malformed input rejected without DB corruption; sqflite uses parameterized queries | verified |
| M5 | Insecure Communication | No network traffic; INTERNET permission absent from release manifest | verified |
| M6 | Inadequate Privacy Controls | No PII stored; counter names not logged; backup config explicit in backup_rules.xml | verified |
| M7 | Insufficient Binary Protections | `--obfuscate` applied to all prod releases; `android:debuggable=false` verified; R8/ProGuard applied | verified |
| M8 | Security Misconfiguration | Permissions minimal; backup config explicit; debug features disabled in prod flavor | verified |
| M9 | Insecure Data Storage | No sensitive data in SharedPreferences or unencrypted files; sqflite unencrypted intentionally (low-sensitivity data, documented decision) | verified |
| M10 | Insufficient Cryptography | No encryption applied; justified by low data sensitivity; no keys or algorithms to misconfigure | n/a |

---

## 13. Data Retention And Purge Policy

### Retention Schedule

| Data Type | Retention Period | Deletion Trigger |
|-----------|-----------------|-----------------|
| Counter records | Indefinite | User explicitly deletes counter from app |
| Session records | Indefinite | User deletes individual sessions or all history from HistoryScreen |
| Active session crash-recovery state | Duration of active session only | Cleared on session complete or on next app start after crash recovery |
| Notification preferences | Indefinite | User resets settings or uninstalls app |
| Export files | User-managed | Written to user-chosen location; app does not track or delete them |

### Purge Implementation

Settings screen provides a **"Delete all data"** action that removes:

- All counter and session records from the sqflite database
- All SharedPreferences keys used by the app
- Any temporary files created in `getTemporaryDirectory()` during export operations

Integration test requirement: after purge, reopening the app must show the empty counter list
as if freshly installed — no residual counters, sessions, or preferences.

Temporary export files (created during the share flow) are created in `getTemporaryDirectory()`
and deleted after the share action completes, or cleaned up on the next `resumed` lifecycle event.

### Data Purge On Uninstall

- Android: app data is deleted on uninstall by default. `android:allowBackup=true` means cloud
  backup may persist; this is intentional and acceptable for non-sensitive data.
- No Keychain, Credential Manager, or secure storage is used; no additional cleanup required.

---

## 14. Backup, Import, Export, And Recovery

- Backup supported: yes — Android Auto Backup (platform-managed, covers sqflite DB and SharedPreferences per backup_rules.xml)
- Backup format: platform-managed; unencrypted; acceptable for low-sensitivity data
- Import supported: yes — JSON file created by this app's export, or by the Android app's export (for migration from Android to Flutter version)
- Recovery flow: user taps Import in Settings → selects a JSON file → app validates structure → inserts missing counters and sessions
- Plaintext export policy: allowed — JSON export is human-readable; export UX includes a note that the file is unencrypted before the user saves or shares it

### Validation Requirements

- Import parsing MUST reject malformed JSON and JSON with unexpected structure without corrupting existing data.
- Import MUST handle duplicate record IDs gracefully (skip or upsert based on ID; do not create duplicate records).
- Import compatibility with Android app's Gson-exported format MUST be tested with real export files as fixtures in `test/fixtures/`.
- Export UX MUST inform the user that the file is unencrypted before they confirm save or share.

---

## 15. Security Testing Strategy

| Area | Test Type | Notes |
|------|-----------|-------|
| Import parsing | Unit + integration | Malformed JSON rejected; partial data does not corrupt DB |
| Import compatibility | Integration | Round-trip: Android-exported JSON → Flutter import → all counters and sessions intact |
| Data purge | Integration | After purge: DB empty, SharedPreferences cleared, no residual data |
| Permission audit | Release build verification | Merged manifest contains only declared, needed permissions; INTERNET absent |
| Obfuscation | Release build verification | `--obfuscate` flag confirmed in all prod release build commands |
| Debuggable flag | Release build verification | `android:debuggable=false` confirmed in merged manifest |
| ProGuard rules | Release build verification | Release build launches, counting flow and import/export work end-to-end |

### Required Test Areas

- Import round-trip: Android Gson export file → Flutter import → all counters and sessions intact
- Migration round-trip: v1 schema → v2 → v3 with data present at each stage
- Malformed import: JSON with missing required fields, wrong field types, and truncated content — all rejected gracefully

---

## 16. Incident Response Notes

- Triage owner: sreerajp (sole developer and maintainer)
- Severity model: low — no user credentials, financial data, or PII at risk; incidents are most likely app crashes or data corruption bugs
- Immediate containment actions:
  - Halt new installs via Google Play Console (halt rollout) if a data corruption bug is confirmed
  - Publish a hotfix release following the full release checklist in `docs/release_process.md`
- User communication trigger: if a confirmed bug causes silent data loss; communicate via Play Store release notes and app update
- Patch release process reference: `docs/release_process.md`

---

## 17. Open Risks And Future Hardening

- Risk: No optional app-lock for users who share a device and want privacy for their practice history.
  Hardening option: add opt-in biometric or PIN lock in Settings (low priority; data sensitivity does not require it).

- Risk: Export file is plaintext JSON; user may share it inadvertently without realizing it reveals their practice history.
  Hardening option: add optional password-protected ZIP export as a future enhancement.

- Risk: `android:allowBackup=true` means practice data is included in Android cloud backup. Users who do not want this have no in-app opt-out.
  Hardening option: add a backup opt-out toggle in Settings that modifies the backup scope (complex; low priority for a low-sensitivity app).

---

## 18. Security Review Checklist

Complete before every production release.

- [ ] Threat model reviewed and current.
- [ ] Sensitive data inventory reviewed — no new data types added without assessment.
- [ ] Logging reviewed — no counter names or user data appear in any log statement.
- [ ] Permission usage reviewed — no unnecessary permissions in merged manifest.
- [ ] INTERNET permission confirmed absent from merged release manifest.
- [ ] `--obfuscate` and `--split-debug-info` confirmed in all prod release build commands.
- [ ] Debug symbols archived at `releases/v<version>/symbols/` for this version.
- [ ] `android:debuggable=false` verified in merged release manifest.
- [ ] ProGuard rules verified — release build launches and counting flow works end-to-end.
- [ ] OWASP Mobile Top 10 checklist (section 12) reviewed and signed off.
- [ ] Import parsing tested with malformed JSON and real Android-exported JSON files.
- [ ] Data purge path tested — purge leaves no residual counters, sessions, or preferences.
- [ ] Export UX includes plaintext disclosure to user before save or share.
