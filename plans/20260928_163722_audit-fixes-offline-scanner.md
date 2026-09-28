# Audit fixes: remove hidden Google telemetry, fix data bugs

**Status:** completed

## Background

An audit of the app (analyze clean, 160 tests passing) found one hidden
behaviour and several bugs. This plan fixes all of them.

---

## Issue 1 — Hidden Google telemetry and INTERNET permission (high)

**Problem.** The QR scanner package `mobile_scanner` uses Google ML Kit.
ML Kit pulls in `com.google.android.datatransport` (`transport-backend-cct`),
which adds `INTERNET` and `ACCESS_NETWORK_STATE` to the final release manifest,
plus a background job service and alarm receiver used to send ML Kit usage
logs to Google. This breaks the hard rule "strictly offline, zero telemetry".
`docs/security.md` wrongly marks "INTERNET absent" as verified.

**Fix.** Use the same approach already proven in the `sreerajp_todo` project
(its release manifest has no ML Kit and no datatransport):

1. Remove `mobile_scanner` from `pubspec.yaml`.
2. Add the official `camera` plugin (CameraX, no ML Kit) to get live frames.
3. Add ZXing core (`com.google.zxing:core:3.5.3`, Apache 2.0, pure Java maths,
   no network code, no Play Services) in `android/app/build.gradle.kts`.
4. Add `QrFrameDecoder.kt`: decodes the brightness (Y) plane of one YUV frame
   with `QRCodeReader` + `HybridBinarizer`, tries normal then inverted image.
5. Add a `decodeFrame` method on a new channel
   `com.sreerajp.mantrajapacounter/qr_decoder` in `MainActivity.kt`, running
   the decode on a single background thread (not the UI thread).
6. Add a Dart `QrDecoderService` (in `lib/services/`) that calls the channel,
   plus a provider in `app_providers.dart`.
7. Rewrite the receive view in `optical_sync_screen.dart`:
   `CameraController` (back camera, `yuv420`, no audio) → `startImageStream`
   → one frame at a time to the decoder (skip frames while one is being
   decoded) → existing `processScannedFrame()`. Release the camera when the
   app goes to the background and when the screen closes; restart on resume.
   Show clear messages when the camera permission is denied or the camera
   fails (new ARB keys, see below).
8. **Safety net:** in `AndroidManifest.xml`, add `xmlns:tools` and remove
   `INTERNET` and `ACCESS_NETWORK_STATE` with `tools:node="remove"`, so no
   plugin can ever add them again. The OS will then block all network use.
9. After a prod release build, check the merged manifest has no
   `INTERNET`, `ACCESS_NETWORK_STATE`, `mlkit` or `datatransport` entries.

**Why this choice.** ZXing core is small, well known, fully offline, and the
exact code is already working in `sreerajp_todo`. Other options (such as
`flutter_zxing`, a C++ FFI wrapper) add more native code for no gain here.

---

## Issue 2 — App can crash on every start after deleting a counter (high)

**Problem.** Leaving a counter mid-mala saves a "paused" session in
SharedPreferences. Deleting that counter (or "Clear all data") does not remove
it. On the next start, `SessionRecoveryService` inserts a session row for a
counter that no longer exists. The foreign key rejects it, the error is thrown
inside `main()` before `runApp`, and the app fails to open.

**Fix.**
- `CountersNotifier.deleteCounter()` also clears the saved session for that
  counter.
- "Clear all data" clears all saved sessions (new
  `SettingsRepository.clearAllActiveSessions()`).
- `SessionRecoveryService`: if the counter no longer exists, drop the saved
  session instead of inserting. Wrap each session's recovery in `try/catch`
  so one bad entry can never stop the app from starting.

## Issue 3 — Counts can be doubled after going down to zero (high)

**Problem.** Pressing minus to 0 cancels the session and clears the DB row id.
The next tap saves a row with a **new** id, but the saved session in prefs
keeps the **old** id. On restart (or re-entering the counter), recovery finds
no row with the old id and inserts a second row — the count is added twice.

**Fix.** In `CountingNotifier.decrement()`, when the count reaches 0, start a
fresh session object (new id, fresh start time) and set `_sessionDbId` to that
same id — the same way `resetSession()` does. Move the shared "build a fresh
session" code into one private helper used by `decrement`, `resetSession`
and `resetCounter`.

## Issue 4 — Cleared history can come back (medium)

**Problem.** "Clear history" (all, or one counter) deletes session rows but
leaves paused sessions in prefs, so recovery re-creates them on next start.

**Fix.** The clear-history actions also clear the matching saved sessions.

## Issue 5 — DND / alarm volume can stay changed if Android kills the app (medium)

**Problem.** `MainActivity.kt` keeps the user's old DND mode and alarm volume
only in memory. If Android kills the process without calling
`onPause`/`onDestroy`, the phone can be left in DND or at max alarm volume.

**Fix.** Save the old values in the Activity's own private Android
SharedPreferences when changing them, and clear them after restore. On the
next app start (`configureFlutterEngine`), if saved values exist, restore
them — but only if the current value is still the one the app set (DND =
priority, alarm volume = max), so a later change by the user is never undone.

## Issue 6a — Goal notifications may never show on Android 13+ (low)

**Problem.** The app never asks for `POST_NOTIFICATIONS`.

**Fix.** Add `NotificationService.requestPermissionIfNeeded()` using
`AndroidFlutterLocalNotificationsPlugin.requestNotificationsPermission()`.
Call it when the user turns ON the daily-goal or lifetime-goal notification
switch in Settings, and once when a counting session opens for a counter
with a goal while those notifications are on (a "asked once" flag is stored
so the user is not asked again and again).

## Issue 6b — Unused `logger` package (low)

**Fix.** Remove `logger` from `pubspec.yaml`; fix the line in
`docs/security.md` that says it is used.

## Issue 6c — Screens call the repository directly (low)

**Problem.** `history_screen.dart` and `backup_settings_screen.dart` call
repository delete methods from widget code (breaks the layer rules).

**Fix.** Add provider methods (`clearHistory(counterId?)`,
`clearAllData()`) that do the deletes **and** clear saved sessions (issues 2
and 4). Screens call only these methods.

---

## Files to change

| File | Change |
|------|--------|
| `pubspec.yaml` | remove `mobile_scanner`, `logger`; add `camera` |
| `android/app/build.gradle.kts` | add `com.google.zxing:core:3.5.3` |
| `android/app/src/main/AndroidManifest.xml` | `xmlns:tools`; remove INTERNET + ACCESS_NETWORK_STATE |
| `android/app/src/main/kotlin/.../QrFrameDecoder.kt` | **new** — ZXing frame decoder |
| `android/app/src/main/kotlin/.../MainActivity.kt` | QR channel; persist + restore DND/volume |
| `android/app/proguard-rules.pro` | keep rule for ZXing if R8 needs it |
| `lib/services/qr_decoder_service.dart` | **new** — channel wrapper |
| `lib/providers/app_providers.dart` | QR decoder provider |
| `lib/screens/optical_sync_screen.dart` | camera + ZXing scanner view |
| `lib/providers/counting_provider.dart` | fix zero-count session id (issue 3) |
| `lib/providers/counters_provider.dart` | clear saved session on delete; `clearAllData()` |
| `lib/providers/history_provider.dart` | `clearHistory(counterId?)` |
| `lib/repositories/settings_repository.dart` | `clearAllActiveSessions()`; "notif permission asked" flag |
| `lib/services/session_recovery_service.dart` | skip missing counters; never throw |
| `lib/services/notification_service.dart` | `requestPermissionIfNeeded()` |
| `lib/screens/history/history_screen.dart` | use provider method |
| `lib/screens/settings/backup_settings_screen.dart` | use provider method |
| `lib/screens/settings/*` (notification settings) | request permission on switch-on |
| `lib/screens/counting_screen.dart` | one-time permission request |
| `lib/l10n/app_en.arb`, `app_ml.arb`, `app_sa.arb` | camera-denied / camera-failed messages (+ `@` descriptions) |
| `docs/security.md` | correct INTERNET/telemetry and logger lines |
| `docs/architecture.md` | scanner now `camera` + ZXing |
| `test/services/session_recovery_service_test.dart` | tests for missing counter + bad entry |
| `test/providers/counting_provider_test.dart` | test: down to 0, tap, restart → no double count |
| `test/services/qr_decoder_service_test.dart` | **new** — channel wrapper test (mocked channel) |

(`...` = `com/sreerajp/mantrajapacounter`)

## Checks after the change

1. `flutter pub get`, `flutter gen-l10n`, `dart format .`
2. `flutter analyze` — must be clean.
3. `flutter test` — all pass, including new tests.
4. `flutter build apk --flavor prod --release` and check the merged manifest:
   no `INTERNET`, `ACCESS_NETWORK_STATE`, `mlkit`, `datatransport`.
5. Manual on a device: Optical Sync receive works; camera deny message shows;
   delete a counter with a paused session then restart — app opens;
   minus to 0, tap, kill app, reopen — count not doubled.
6. Write the change log in `change_log/`.
