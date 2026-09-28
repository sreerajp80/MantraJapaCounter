# Change log: audit fixes — offline QR scanner and data bugs

Implements plan: `plans/20260928_163722_audit-fixes-offline-scanner.md`

## Summary

- Removed hidden Google telemetry: the QR scanner no longer uses ML Kit, and
  the release APK no longer has the `INTERNET` permission.
- Fixed a start-up crash after deleting a counter with a paused session.
- Fixed doubled counts after pressing minus down to 0 and tapping again.
- Fixed cleared history coming back on the next start.
- DND mode and alarm volume are now restored even if Android kills the app.
- The app now asks for the Android 13+ notification permission.
- Removed the unused `logger` package and fixed the docs.

## Issue 1 — Offline QR scanner (ZXing)

- `pubspec.yaml`: removed `mobile_scanner` and `logger`; added `camera: ^0.12.1`.
- `android/app/build.gradle.kts`: added `com.google.zxing:core:3.5.3`.
- New `android/app/src/main/kotlin/com/sreerajp/mantrajapacounter/QrFrameDecoder.kt`:
  decodes the Y plane of one camera frame with ZXing (normal, then inverted).
- `MainActivity.kt`: new channel `com.sreerajp.mantrajapacounter/qr_decoder`
  with `decodeFrame`, run on one background thread.
- New `lib/services/qr_decoder_service.dart` (`QrDecoderService`,
  `QrScannerUnavailableException`) and `qrDecoderServiceProvider` in
  `lib/providers/app_providers.dart`.
- New `lib/widgets/qr_camera_view.dart`: back camera, YUV frames, one frame
  decoded at a time; releases the camera in the background and restarts on
  resume; shows messages for "permission denied", "camera failed" and
  "not available".
- `lib/screens/optical_sync_screen.dart`: uses `QrCameraView` instead of
  `MobileScanner`.
- ARB files (`en`, `ml`, `sa`): new keys `opticalCameraDenied`,
  `opticalCameraError`, `opticalCameraUnavailable` with descriptions.
- `AndroidManifest.xml`: added `xmlns:tools`, and removes `INTERNET` and
  `ACCESS_NETWORK_STATE` with `tools:node="remove"`.
- **Extra (not in the plan, same goal):** the `camera` plugin adds
  `RECORD_AUDIO`, `WRITE_EXTERNAL_STORAGE` and (implied)
  `READ_EXTERNAL_STORAGE` for video recording. The app never records, and it
  did not have these before, so they are also removed with
  `tools:node="remove"`.

## Issues 2, 4, 6c — Saved sessions after delete / clear

- `lib/repositories/settings_repository.dart`: new `clearAllActiveSessions()`.
- `lib/providers/counters_provider.dart`: `deleteCounter()` also clears that
  counter's saved session; new `clearAllData()`.
- `lib/providers/history_provider.dart`: new `HistoryActions.clearHistory()`
  and `historyActionsProvider`; clears saved sessions too.
- `lib/screens/history/history_screen.dart` and
  `lib/screens/settings/backup_settings_screen.dart`: call these provider
  methods instead of the repository.
- `lib/services/session_recovery_service.dart`: skips (and clears) saved
  sessions whose counter no longer exists; each entry is wrapped in
  `try/catch` so recovery can never stop the app from starting.

## Issue 3 — Doubled counts after going to zero

- `lib/providers/counting_provider.dart`: new `_startFreshSession()` helper
  used by `init`, `decrement` (when it reaches 0), `resetSession` and
  `resetCounter`. The prefs session and the DB row now always share one id.
  `_insertSessionRow` falls back to the session's own id, never a random one.

## Issue 5 — DND / alarm volume restore

- `MainActivity.kt`: the original alarm volume and DND filter are also saved
  in private native SharedPreferences (`native_restore_state`) and cleared
  after restore. On the next start, leftover values are restored only if the
  current value is still the one the app set (alarm = max, DND = priority).

## Issue 6a — Notification permission

- `lib/services/notification_service.dart`: new `requestPermissionIfNeeded()`.
- `lib/providers/settings_provider.dart`: turning on the daily-goal or
  lifetime-goal notification switch asks for the permission.
- `lib/providers/counting_provider.dart`: asks once (not awaited) the first
  time a counter with a goal is opened while goal notifications are on.
  A flag (`notification_permission_asked`, in `app_constants.dart` and
  `settings_repository.dart`) stops repeat prompts.
- Differs from the plan's file list: the request lives in the providers, so
  `counting_screen.dart` and the sound settings screen did not need changes.
  `proguard-rules.pro` also needed no change (the release build and R8
  worked without a ZXing keep rule).

## Issue 6b / docs

- `docs/security.md`, `docs/architecture.md`, `docs/features.md`,
  `docs/release_process.md`: logger lines corrected; explained why ML Kit is
  not used; release checklist now also checks for no `mlkit`,
  `datatransport` or `firebase` entries.

## Tests

- New `test/providers/counting_provider_test.dart`: down to 0 and up again is
  counted once after restart and resume; prefs id matches the DB row.
  Checked against the old code: it failed there (6 instead of 3).
- New `test/services/qr_decoder_service_test.dart` (mocked channel).
- `test/services/session_recovery_service_test.dart`: deleted counter with
  foreign keys on — no crash, entry dropped, other counters still recovered.
- `test/repositories/settings_repository_test.dart`:
  `clearAllActiveSessions` and `notificationPermissionAsked`.

## Verification

- `flutter analyze`: no issues.
- `flutter test`: 170 tests, all pass (was 160).
- `flutter build apk --flavor prod --release --split-per-abi`: success.
  `aapt2 dump permissions` on the arm64 APK lists only `VIBRATE`, `CAMERA`,
  `ACCESS_NOTIFICATION_POLICY`, `POST_NOTIFICATIONS` and the app's own
  receiver permission. No `INTERNET`, no ML Kit files, no `datatransport`.
- `flutter build apk --flavor dev --debug`: success; the debug manifest still
  has `INTERNET` (needed by `flutter run` / hot reload).

## Not yet done (needs a real device)

- Optical Sync receive with a real sender phone.
- Camera-denied message.
- Delete a counter with a paused session, restart — app opens.
- Minus to 0, tap, kill the app, reopen — count not doubled.
