# Security — Mantra Japa Counter

This document defines the security boundaries, threat model, permission constraints, and offline data handling policies for Mantra Japa Counter.

Read [AGENTS.md](../AGENTS.md) and [CLAUDE.md](../CLAUDE.md) before modifying security-sensitive code. See [GUIDELINES_MANIFEST.md](GUIDELINES_MANIFEST.md) for full guideline references.

> The `Sensitive Data Extension` does **not** apply to this app (see
> [PROJECT_PROFILE.md](PROJECT_PROFILE.md) §2). The Security Baseline (§1.1) applies, as it does to
> every app, and the OWASP sign-off (§12) applies because the app ships under the
> `Production App Extension`.

---

## 1. Security Scope

- App: `Mantra Japa Counter`
- Data sensitivity level: `low`
- Engineering standard profiles in force:
  - `Core Baseline`
  - `Production App Extension`
- Platforms in scope:
  - `Android`

### 1.1 Security Baseline (Every App)

Rules: engineering standard §15.1. Re-check this list before every production release.

| Area | Rule | Status |
|------|------|--------|
| Secrets | No real secrets in code, assets, `--dart-define` or native config; shipped keys restricted by the provider | `verified` — the app ships no keys, tokens or passwords; `.env` files are git-ignored |
| Network | HTTPS only; certificate checks never disabled; cleartext off; ATS on; timeouts set | `verified` — no network at all: `INTERNET` and `ACCESS_NETWORK_STATE` are removed from the merged manifest, and `android:usesCleartextTraffic="false"` is set. ATS: `n/a` (no iOS) |
| Tokens | Sign-in tokens and credentials only in platform secure storage; removed on sign-out | `n/a` — no accounts, no tokens |
| Sign-in | OAuth/OIDC with PKCE via the system browser, platform sign-in or passkeys; server enforces access | `n/a` — no sign-in, no server |
| Outside input | Deep links, intents, imports, payloads, clipboard, platform channels validated (§3.1); parameterized SQL; no path traversal | `verified` — see §3.1. All SQL uses sqflite parameter binding. The app never builds a file path from input |
| Deep links | No sensitive action without user confirmation; verified App Links / Universal Links for callbacks | `n/a` — the app declares no deep links |
| WebView | Not used, or allowlisted HTTPS origins, JavaScript only if needed, no bridge to untrusted content | `n/a` — no WebView |
| Platform hardening | Android components not exported unless needed; `PendingIntent` immutable; narrow `FileProvider`; private app folders | `verified` — see §10 |
| Randomness / crypto | `Random.secure()` for security values; standard, maintained crypto libraries only | `verified` — salt and IV use `Random.secure()`; AES-256-GCM and PBKDF2 come from the `cryptography` package. The seeded `Random` in Optical Sync only picks which data chunks go in a QR frame; it is not a security value |
| Release build | No debug menus, test accounts or backdoors; `debuggable=false`; `--obfuscate` | `verified` — dev-only items (the About "DEV" badge, debug banner) show only in the `dev` flavor |
| Third-party SDKs | Each SDK listed in §4 with what it collects; no secrets or PII in crash reports or analytics | `n/a` — no analytics, ads, crash-reporting or other data-sending SDK |
| Data minimization | Only data that a feature needs is collected and kept | `verified` — only counters, sessions and settings, on the device |
| Web (if declared) | No secrets in the web bundle; Content Security Policy set where hosting allows | `n/a` — Web is not declared |

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
- A wrong, damaged or very large file picked for import.

### Out Of Scope Threats

- Physical device attacks or rooted device exploits.
- Nation-state or advanced persistent threat adversaries.
- Network interception (app has no network traffic).
- Authentication bypass (app has no authentication).
- Data exfiltration attacks — counting data has no significant value to third parties; no PII, no credentials, no financial information.

### 3.1 Entry Points And Attack Surface

Every way data or commands reach the app from outside (engineering standard §15.1, "Input from
outside the app").

| Entry Point | Example | Validation | Sensitive Action Possible? |
|-------------|---------|------------|----------------------------|
| Launcher intent | `MainActivity` (`MAIN` / `LAUNCHER`) | Takes no data from the intent | no |
| Boot / package-replaced broadcast | `ScheduledNotificationBootReceiver` (not exported; system broadcasts only) | Plugin only re-schedules the daily reminder | no |
| Notification tap | Daily reminder, goal and mala notifications | Opens the app; no payload is read | no |
| File import | Backup `.json` / `.json.enc` picked with the system file picker | Size checked first (`AppConstants.maxBackupImportBytes`, 10 MB) before reading; extension filter; JSON structure validated; encrypted files need the passphrase and GCM tag check; import runs in one DB transaction, so a bad file changes nothing | no — the user starts the import and the data is only added |
| QR code (camera) | Optical Sync receive frames | Frame header `AIRQR\|LT1` and every field type checked (`OpticalSyncFrame.parse`, bad frames ignored); the rebuilt JSON goes through the same import validation; user confirms in a preview sheet | no — import only after the user confirms |
| Platform channels | `…/haptic`, `…/qr_decoder`, `…/screen` (own native code) | Argument types checked on the native side; Dart catches `PlatformException` / `MissingPluginException` | no |
| Sound file pick | Custom notification tone via the system picker | Only the content URI is stored; the file is played by the system | no |

---

## 4. Sensitive Data Inventory

| Data Type | Example | Where It Exists | Protection Required |
|-----------|---------|-----------------|---------------------|
| Counter names | "Om Namah Shivaya" | sqflite DB, JSON export | Never logged (§9) |
| Session counts and timestamps | 432 taps, 2024-01-15 08:30 | sqflite DB, JSON export | Never logged (§9) |
| Notification preferences | vibration enabled, custom tone path | SharedPreferences | None — not sensitive |
| Screen brightness setting | 70% | SharedPreferences | None — not sensitive |
| Active session crash-recovery state | In-progress tap count and session ID | SharedPreferences | None — ephemeral; cleared on session complete or recovery |

No secrets, tokens, health records, financial data, or personally identifiable information are
stored or transmitted by this app.

### Third-Party SDKs

No analytics, ads, crash-reporting or other SDK that can send data off the device. The app has no
`INTERNET` permission, so no library can send data.

| SDK | What It Collects | Where It Sends It | Why It Is Needed |
|-----|------------------|-------------------|------------------|
| none | — | — | — |

---

## 5. Storage Model

### At Rest

- Primary local storage: `sqflite` — counters and sessions database in the app's private folder; unencrypted (data is not sensitive)
- Secure key storage: not applicable — no secrets or encryption keys are kept
- Backup behavior: Android backup is **off** (`android:allowBackup="false"`, `android:fullBackupContent="false"`), and `data_extraction_rules.xml` excludes every domain from cloud backup and device-to-device transfer. Users move data with the app's own export / import or Optical Sync.

### In Memory

- No sensitive values are held in memory; all in-memory state is counting data and UI state
- An export passphrase is held only while the export or import runs
- Memory clearing strategy: not applicable

### In Transit

- Network use: none — fully offline
- Transport protections: not applicable (no network)
- Rules (engineering standard §15.1) if network is ever added: HTTPS only; certificate checks never
  disabled (no `badCertificateCallback` returning `true`, no trust-all `HttpOverrides`); connect and
  receive timeouts set. Adding network is a product change and needs the user's approval first.
- Certificate pinning: not used (no network).

---

## 6. Cryptography Design

### 6.1 Optional Export Encryption
Export backups support optional user-configured AES-256-GCM encryption with password-based key derivation. Plaintext JSON remains the default for transparent data portability.

- **Algorithm**: AES-256-GCM (Galois/Counter Mode with 128-bit authentication tag).
- **Key Derivation**: PBKDF2 with HMAC-SHA256, 100,000 iterations, 16-byte random salt, generating a 256-bit key.
- **IV / Nonce**: 12 bytes generated per export using `Random.secure()`.
- **Envelope Structure**: JSON wrapper containing `encrypted: true`, `version: 1`, `salt` (Base64), `iv` (Base64), and `ciphertext` (Base64). The ciphertext includes the 16-byte GCM tag appended.
- **Offline Compliance**: Pure-Dart cryptographic engine via the `cryptography` package (`^2.7.0`) — zero platform dependencies, zero native code, and zero network access.
- **Import Behavior**: Import routines auto-detect the envelope format; if encrypted, the user is prompted for their passphrase to decrypt before merging or restoring.

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

### 7.1 Usability Balance

Security must not make the app hard to use or slow (engineering standard §15.6).

- Lock grace period after backgrounding: none — there is no app lock
- Fallback when biometrics are not available: n/a
- Response to rooted, jailbroken or emulator devices: none — out of the threat model (§3)
- Heavy crypto off the main isolate: export encryption and import decryption run only when the
  user asks for them (one export or import at a time); there is no crypto at startup
- Key-derivation cost tuned for: PBKDF2 100,000 iterations, run once per export or import

| Control That Adds A Step For The User | Why It Is Needed |
|---------------------------------------|------------------|
| Passphrase prompt when importing an encrypted backup | The file cannot be read without it |
| Preview sheet before an Optical Sync import | The user sees what will be added before it is saved |
| Camera permission asked only when Optical Sync receive starts | Permission at the moment of need (§11) |

---

## 8. Binary Protections

### 8.1 Obfuscation

All production release builds MUST be compiled with:

```bash
--obfuscate --split-debug-info=build/symbols/android-prod-<version>/
```

Obfuscation is applied even for a low-sensitivity app because it is a build-time no-cost control
that raises the bar for casual reverse engineering of app logic.

Obfuscation does **not** hide string literals: they stay readable in every build. Never put a
secret in a string.

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
classes accessed only via reflection. See `docs/guidelines/flutter_build_flavors_guide.md` for required rules.

### 8.3 Debuggable Flag

Verify `android:debuggable=false` in the merged release manifest before every production release.

```bash
aapt2 dump badging build/app/outputs/flutter-apk/app-arm64-v8a-prod-release.apk | grep -i debuggable
```

Expected: no output (attribute absent = false by default). If it appears, investigate
`isDebuggable` in `android/app/build.gradle.kts` under the release build type.

---

## 9. Logging And Telemetry Policy

### Never Log

- Counter names (user-created; treated as private even if not technically sensitive)
- Full session data rows or field values
- Any value the user has typed, selected, or configured
- Raw exception messages (they can hold user data) — log the error type only

### Allowed Diagnostic Context

- Operation name (e.g., `"openDatabase"`, `"insertSession"`, `"importFromJson"`)
- Screen or flow name (e.g., `"CountingScreen"`, `"ExportService"`)
- Error category (e.g., `"StorageException"`, `"ImportParseException"`) — not raw exception messages if they may contain user data

### Logging Controls

- Logger implementation: `AppLogger` in `lib/core/logging/app_logger.dart` (no logging package).
  It writes to the developer log only; there is no log file. `print` and `debugPrint` are not used.
- `AppLogger` writes only the **type** of an error object, never its message.
- Verbose logging gate: `AppFlavorConfig.enableVerboseLogging` — `true` for dev flavor, `false` for prod
- Log level in production: `info` and above only; `trace` and `debug` write nothing in the prod flavor

---

## 10. Platform Security Controls

### Android

- `android:allowBackup`: `false`, with `android:fullBackupContent="false"` — no Android backup
- `android:dataExtractionRules`: `@xml/data_extraction_rules` — excludes every domain from cloud backup and device-to-device transfer (Android 12+)
- Screenshot protection: not applied — counting screen contains no sensitive information; `FLAG_SECURE` would unnecessarily block users from screenshotting their practice progress
- `android:debuggable`: MUST be `false` in all release builds (verified per section 8.3)
- Cleartext traffic: `android:usesCleartextTraffic="false"` on `<application>`; no network security config (`release_process.md` §6.5)
- Exported components: only `MainActivity` is exported (`android:exported="true"`), because it is the launcher activity; it reads no data from its intent. Both notification receivers are `android:exported="false"`.
- `PendingIntent`: created only by `flutter_local_notifications`, which uses `FLAG_IMMUTABLE` on Android 12+; the app creates none itself
- `FileProvider` paths: none declared by the app; `share_plus` shares the export file from the app's own folder through its own provider
- Root / integrity detection: not implemented — out of scope for this threat model (response recorded in §7.1)

### iOS

Not in scope for this release.

### Windows

Not in scope for this release.

---

## 11. Permissions

| Permission | Why It Is Needed | Requested When | Denial Handling |
|------------|------------------|----------------|-----------------|
| `VIBRATE` | Vibration feedback on mala completion and daily goal achievement, and an optional light pulse on each counting tap (off by default) | Declared in manifest; no runtime request | Notifications sent without vibration |
| `POST_NOTIFICATIONS` | Show local notifications on Android 13+ (API 33+) | First time user enables notifications in Settings screen | Notifications silently disabled; user informed in Settings |
| `CAMERA` | Optical Sync receive: read QR codes from live camera frames. Frames are decoded on the device by ZXing and thrown away; nothing is saved or sent | When the user starts a camera receive in Optical Sync | Camera receive shows a "permission denied" message; the rest of the app works normally |
| `RECEIVE_BOOT_COMPLETED` | Lets the notification plugin set the optional daily practice reminder again after the phone restarts or the app updates. Nothing else runs at boot, and nothing is sent | Declared in manifest; normal install-time permission, no runtime prompt | Not applicable (no prompt). If the reminder is off, the boot receiver has nothing to schedule |
| `ACCESS_NOTIFICATION_POLICY` | Optional Do Not Disturb while chanting | When the user turns on "Silence notifications (Do Not Disturb)" in Settings; Android opens its own settings page | Chanting works as normal, without silencing alerts |

The custom tone picker uses the system file picker, which needs no storage permission.
`READ_EXTERNAL_STORAGE`, `WRITE_EXTERNAL_STORAGE` and `RECORD_AUDIO` are removed from the merged
manifest with `tools:node="remove"`.

Permission review rules:

- `INTERNET` permission MUST be absent from the merged release manifest. Verify before every release.
- `AndroidManifest.xml` removes `INTERNET` and `ACCESS_NETWORK_STATE` with `tools:node="remove"`, so a
  plugin or library cannot add them back. Libraries can still add them silently if this is removed:
  for example Google ML Kit (used by `mobile_scanner`) pulls in `com.google.android.datatransport`,
  which adds `INTERNET` and a background job that uploads ML Kit usage logs to Google. For this reason
  QR scanning uses the `camera` plugin plus ZXing core (`com.google.zxing:core`) instead of ML Kit.
- The merged release manifest must also contain no `mlkit`, `datatransport` or `firebase` entries.
- No dangerous permissions are requested at app startup; all requested at point of use with a clear rationale.
- The app functions fully without `POST_NOTIFICATIONS`, `CAMERA`, and `ACCESS_NOTIFICATION_POLICY`; these control optional features only.
- Any change to the permission list must also update [PRIVACY_POLICY.md](../PRIVACY_POLICY.md) and the Play Console Data safety form.

---

## 12. OWASP Mobile Top 10 Compliance

Review and sign off each item before every production release. This is a MUST under the
`Production App Extension` (engineering standard §15.3). Items that do not apply are `n/a`.

| ID | Risk | Control | Status |
|----|------|---------|--------|
| M1 | Improper Credential Usage | No secrets shipped in the app; no keys, tokens or credentials exist | n/a |
| M2 | Inadequate Supply Chain Security | `pubspec.lock` committed; dependency audit performed before each release; licenses verified | verified |
| M3 | Insecure Authentication/Authorization | No sign-in, no server, no app lock | n/a |
| M4 | Insufficient Input/Output Validation | All outside input validated (§3.1); import size-checked and structure-validated; malformed input rejected without DB corruption; parameterized queries; no paths built from input | verified |
| M5 | Insecure Communication | No network traffic; INTERNET removed via `tools:node="remove"`; cleartext off; no ML Kit / datatransport in release manifest (was present via `mobile_scanner` until 2026-09-28) | verified |
| M6 | Inadequate Privacy Controls | No PII stored; counter names not logged; backup and device transfer off (§10) | verified |
| M7 | Insufficient Binary Protections | `--obfuscate` applied to all prod releases; `android:debuggable=false` verified; R8 / ProGuard rules verified (Android) | verified |
| M8 | Security Misconfiguration | Permissions minimal; backup config explicit; only the launcher activity exported; debug features and backdoors absent in prod | verified |
| M9 | Insecure Data Storage | No sensitive data in SharedPreferences or unencrypted files; sqflite unencrypted intentionally (low-sensitivity data, documented decision) | verified |
| M10 | Insufficient Cryptography | Optional export encryption: versioned envelope (`version: 1`), AES-256-GCM, PBKDF2-HMAC-SHA256 (100,000 iterations), `Random.secure()` salt and IV; no hard-coded keys | verified |

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

- Android: app data is deleted on uninstall. Backup is off (§10), so no copy stays in the cloud.
- No Keychain, Credential Manager, or secure storage is used; no additional cleanup required.

---

## 14. Backup, Import, Export, And Recovery

- Backup supported: only through the app's own export (JSON file, optionally encrypted) and Optical Sync. Android backup is off (§10).
- Backup format: JSON (`exportVersion` 1), plain or AES-256-GCM envelope (§6.1)
- Import supported: yes — JSON file created by this app's export (any earlier version)
- Recovery flow: user taps Import in Settings → selects a JSON file → app checks its size → validates structure → inserts missing counters and sessions
- Plaintext export policy: allowed — JSON export is human-readable; export UX includes a note that the file is unencrypted before the user saves or shares it

### Validation Requirements

- Import MUST check the file size before reading it (`AppConstants.maxBackupImportBytes`).
- Import parsing MUST reject malformed JSON and JSON with unexpected structure without corrupting existing data.
- Import MUST handle duplicate record IDs gracefully (skip or upsert based on ID; do not create duplicate records).
- Import of backups from earlier app versions MUST be tested with the made-up fixture `test/fixtures/backup_format_v1.json` (no real user data in fixtures).
- Export UX MUST inform the user that the file is unencrypted before they confirm save or share.

---

## 15. Security Testing Strategy

| Area | Test Type | Notes |
|------|-----------|-------|
| Import parsing | Unit + integration | Malformed JSON rejected; partial data does not corrupt DB |
| Import size limit | Unit | A file over the limit is rejected before it is read (`test/services/export_service_test.dart`) |
| Import compatibility | Integration | Round-trip: fixture backup → import → export → same counters and sessions, same field names and values |
| Entry-point validation | Unit | Bad Optical Sync frames are ignored (`OpticalSyncFrame.parse`); bad import files are rejected |
| Data purge | Integration | After purge: DB empty, SharedPreferences cleared, no residual data |
| Permission audit | Release build verification | Merged manifest contains only declared, needed permissions; INTERNET absent |
| Transport security | Code review + release verification | No network code; cleartext off; no trust-all overrides |
| Logging | Unit | `AppLogger` writes only error types; debug is silent in prod (`test/core/logging/app_logger_test.dart`) |
| Obfuscation | Release build verification | `--obfuscate` flag confirmed in all prod release build commands |
| Debuggable flag | Release build verification | `android:debuggable=false` confirmed in merged manifest |
| ProGuard rules | Release build verification | Release build launches, counting flow and import/export work end-to-end |

### Required Test Areas

- Import round-trip: fixture backup file → import → export → all counters and sessions intact
- Migration round-trip: v1 schema → v2 → v3 → v4 → v5 with data present at each stage
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
  Status: Mitigated. Users can optionally encrypt their export backup files with a custom passphrase using AES-256-GCM. Unencrypted export remains available for users preferring simple JSON text portability.

- Risk: Android backup is off, so a lost phone loses its data unless the user made an export.
  Mitigation: the Backup screen offers export and Optical Sync; this is a deliberate privacy choice.

---

## 18. Security Review Checklist

Complete before every production release.

- [ ] Security Baseline (§1.1) re-verified — every line `verified` or `n/a` with a reason.
- [ ] Entry points (§3.1) current and each one validated.
- [ ] Usability balance (§7.1) reviewed — no new friction without a recorded reason.
- [ ] Threat model reviewed and current.
- [ ] Sensitive data inventory reviewed — no new data types added without assessment.
- [ ] Logging reviewed — no counter names or user data appear in any log statement.
- [ ] Permission usage reviewed — no unnecessary permissions in merged manifest.
- [ ] INTERNET permission confirmed absent from merged release manifest.
- [ ] No `mlkit`, `datatransport` or `firebase` entries in the merged release manifest.
- [ ] Only `MainActivity` is exported in the merged release manifest; cleartext is off.
- [ ] `--obfuscate` and `--split-debug-info` confirmed in all prod release build commands.
- [ ] Debug symbols archived at `releases/v<version>/symbols/` for this version.
- [ ] `android:debuggable=false` verified in merged release manifest.
- [ ] ProGuard rules verified — release build launches and counting flow works end-to-end.
- [ ] OWASP Mobile Top 10 checklist (section 12) reviewed and signed off.
- [ ] Import parsing tested with malformed JSON and the backup format fixture.
- [ ] Data purge path tested — purge leaves no residual counters, sessions, or preferences.
- [ ] Export UX includes plaintext disclosure to user before save or share.
