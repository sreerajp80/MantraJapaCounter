# Low Power, Dimmed Chanting & DND Plan

**Status:** Approved by user — in progress

## Overview
Optimize the app to use minimal battery and CPU power on Android devices, introduce a battery-saving Dimmed Chanting Mode where the mala circle remains visible, and integrate Android Do Not Disturb (DND) to prevent incoming alerts from interrupting chanting sessions.

---

## 1. Engine & CPU Battery Optimizations
- **Isolate Duration Timer**: Move the 1-second display timer in `lib/screens/counting_screen.dart` into an isolated `_SessionDurationPill` widget. The main counting screen, 108 mala beads, medallion, and layout math will only rebuild when the user taps or when session status changes (eliminating 60 full-screen redraws per minute).
- **Lifecycle-Aware Timers**:
  - Cancel display timer in `_SessionDurationPill` on `AppLifecycleState.paused` / `inactive`.
  - In `CountingNotifier.onPause()`, cancel `_prefsTimer` and `_dbTimer` after the final flush so the Dart VM does not spin in the background.
  - In `CountingNotifier.onResume()`, restart timers only when the session is active.
- **Guard Idle Disk Writes**:
  - In `CountingNotifier._flushPrefsIfNeeded()`, return immediately if `_tapsSinceLastPrefsFlush == 0`.
  - In `CountingNotifier._flushDbIfNeeded()`, return immediately if `_tapsSinceLastDbFlush == 0`.

---

## 2. Dimmed Chanting Mode (Screen Battery Saver)
- Add a toggle button in the top bar of `CountingScreen`.
- When active:
  - The outer screen areas (background, top bar, footer) darken to a deep night color (`#0E0B07`), turning off the vast majority of AMOLED pixels.
  - The mala circle, beads, and count remain clearly visible with warm temple illumination so the user clearly sees where to tap.
  - Taps remain strictly inside the circle, honoring the existing design and preventing accidental taps.

---

## 3. Automatic Do Not Disturb (DND) During Chanting
- Add `android.permission.ACCESS_NOTIFICATION_POLICY` to `android/app/src/main/AndroidManifest.xml`.
- Implement native DND controls in `MainActivity.kt`:
  - `isDndAccessGranted`: checks system permission.
  - `openDndSettings`: opens Android's Do Not Disturb Access settings screen.
  - `enableDnd`: saves current filter and sets `INTERRUPTION_FILTER_PRIORITY`.
  - `restoreDnd`: restores previous filter when leaving chanting or backgrounding.
- Add `DndService` in `lib/services/dnd_service.dart`.
- Add DND toggle setting in `SettingsRepository`, `SettingsNotifier`, and settings UI.
- In `CountingScreen`, automatically enable DND on enter/resume and restore on exit/pause.

---

## Files to Change
1. `android/app/src/main/AndroidManifest.xml` — Add `ACCESS_NOTIFICATION_POLICY` permission.
2. `android/app/src/main/kotlin/com/sreerajp/mantrajapacounter/MainActivity.kt` — Add native DND method channel handlers.
3. `lib/core/constants/app_constants.dart` — Add preference keys for DND and dimmed mode.
4. `lib/services/dnd_service.dart` [NEW] — Service for DND permission check, settings launch, and activation.
5. `lib/repositories/settings_repository.dart` — Add getters/setters for DND and dimmed mode preferences.
6. `lib/providers/settings_provider.dart` — Expose DND and dimmed mode in `AppSettings` and `SettingsNotifier`.
7. `lib/providers/app_providers.dart` — Provide `dndServiceProvider`.
8. `lib/providers/counting_provider.dart` — Stop timers on pause, resume on resume, guard idle writes.
9. `lib/screens/counting_screen.dart` — Isolate timer pill, implement dimmed chanting mode, integrate DND lifecycle.
10. `lib/screens/settings/display_settings_screen.dart` — Add DND setting toggle with permission prompt.
11. `lib/l10n/app_en.arb`, `lib/l10n/app_ml.arb`, `lib/l10n/app_sa.arb` — Add localization keys for DND and dimmed mode.

---

## Verification Plan
1. Run `flutter gen-l10n` to rebuild localizations.
2. Run `flutter test` to verify all unit/widget tests pass.
3. Run `flutter analyze` to ensure 0 warnings and 0 errors.
4. Verify timer isolation, dimmed chanting visuals, and DND behavior.
