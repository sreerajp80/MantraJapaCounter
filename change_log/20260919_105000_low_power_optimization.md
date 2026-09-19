# Change Log: Low Power, Dimmed Chanting & Do Not Disturb (DND)

**Plan Reference:** `plans/20260919_105000_low_power_optimization.md`

## Summary of Changes

### 1. Engine & CPU Battery Optimization
- **Isolated Duration Timer**: Replaced the 1-second `_displayTimer` in `lib/screens/counting_screen.dart` with an isolated `_SessionDurationPill` widget. The main counting screen, 108 mala beads, medallion, and layout math now only rebuild when the user taps or when session status changes, eliminating 60 heavy full-screen redraws every minute.
- **Lifecycle & Pause-Aware Timers**:
  - `_SessionDurationPill` cancels its periodic ticker when the session is paused or when the app enters the background (`AppLifecycleState.paused` / `inactive`), and restarts only when resumed.
  - In `lib/providers/counting_provider.dart`, `onPause()` cancels `_prefsTimer` and `_dbTimer` after the final flush so the Dart VM does not spin in the background.
  - Added `onResume()` to restart batching timers only when returning to the foreground with an active session.
- **Idle Disk Write Guards**:
  - `_flushPrefsIfNeeded()` returns immediately if `_tapsSinceLastPrefsFlush == 0`.
  - `_flushDbIfNeeded()` returns immediately if `_tapsSinceLastDbFlush == 0`.

### 2. Dimmed Chanting Mode (Screen Battery Saver)
- Added Dimmed Chanting Mode in `lib/screens/counting_screen.dart`.
- When toggled via the moon icon in the top bar:
  - The outer screen areas (background, top bar, footer) darken to deep night (`#0D0A07`), turning off the vast majority of AMOLED pixels.
  - The sacred mala circle, beads, and center count remain softly visible so the user clearly sees where to tap.
  - Taps remain strictly inside the circle, honoring the existing design and preventing accidental counts.

### 3. Automatic Do Not Disturb (DND) During Chanting
- Added `android.permission.ACCESS_NOTIFICATION_POLICY` to `android/app/src/main/AndroidManifest.xml`.
- Added native DND handlers in `android/app/src/main/kotlin/com/sreerajp/mantrajapacounter/MainActivity.kt`:
  - `isDndAccessGranted`: Checks if DND access is granted.
  - `openDndSettings`: Opens Android system settings for DND access.
  - `setDndEnabled`: Silences incoming notifications during chanting.
  - `restoreDndNow`: Restores the previous interruption filter on pause, exit, or destroy.
- Added `lib/services/dnd_service.dart` and exposed it via `lib/providers/app_providers.dart`.
- Added DND toggle setting to `lib/repositories/settings_repository.dart`, `lib/providers/settings_provider.dart`, and `lib/screens/settings/display_settings_screen.dart`.
- In `lib/screens/counting_screen.dart`, automatically enables DND on enter/resume and restores normal ringer mode on exit/pause.

### 4. Localization & Testing
- Added translation keys and descriptions for DND and Dimmed Mode in `lib/l10n/app_en.arb`, `lib/l10n/app_ml.arb`, and `lib/l10n/app_sa.arb`.
- Added unit tests for new repository and notifier settings in `test/repositories/settings_repository_test.dart`.
- Verified key parity with `test/l10n/translation_parity_test.dart`.
- Ran `flutter analyze` (0 warnings, 0 errors) and `flutter test` (all 157+ tests passing).

---

## Files Changed
- `android/app/src/main/AndroidManifest.xml`
- `android/app/src/main/kotlin/com/sreerajp/mantrajapacounter/MainActivity.kt`
- `lib/core/constants/app_constants.dart`
- `lib/services/dnd_service.dart` [NEW]
- `lib/providers/app_providers.dart`
- `lib/repositories/settings_repository.dart`
- `lib/providers/settings_provider.dart`
- `lib/providers/counting_provider.dart`
- `lib/screens/counting_screen.dart`
- `lib/screens/settings/display_settings_screen.dart`
- `lib/screens/settings/sound_settings_screen.dart`
- `lib/screens/settings/permissions_screen.dart`
- `lib/l10n/app_en.arb`
- `lib/l10n/app_ml.arb`
- `lib/l10n/app_sa.arb`
- `test/repositories/settings_repository_test.dart`
- `plans/20260919_105000_low_power_optimization.md`
