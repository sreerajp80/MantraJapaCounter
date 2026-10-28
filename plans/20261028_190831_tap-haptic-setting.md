# Plan: Setting to turn haptic feedback on each tap on or off

**Status:** completed

## What the issue is

The user wants a setting that turns a short vibration (haptic feedback) on or off for each
counting tap. If this uses battery, the setting must show a warning.

What the app does today:

- A normal counting tap gives **no** vibration at all. Only the two-finger swipe (undo one
  count) gives a short `HapticFeedback.mediumImpact()` (`lib/screens/counting_screen.dart`).
- Mala completion and goal completion vibrate through `HapticFeedbackService`, controlled by
  the one existing switch `vibrationEnabled` (Settings → Sound & Haptics → Vibration).
- The text under that switch (`permVibrationDesc`) says it gives feedback "on each chant tap".
  That is not true today, so the text is misleading.

Battery: each tap pulse is very short (about 10–20 ms), so one tap costs almost nothing. But a
long session has thousands of taps, so the vibration motor runs many times. This does use some
extra battery. So the warning is needed, and the new setting will be **off by default**.

## The plan for the fix

1. **New saved setting `tapVibrationEnabled`** (default `false`).
   - New key `prefsTapVibrationKey = 'tap_vibration'` in `AppConstants`.
   - Getter and setter in `SettingsRepository`.
   - New field in `AppSettings` (constructor, `copyWith`, initial load) and a
     `setTapVibrationEnabled` method in `SettingsNotifier`.
   - It is separate from the existing Vibration switch. The existing switch keeps controlling
     mala / goal / undo vibration only.

2. **Vibrate on each counted tap.**
   - Add `tapPulse()` to `HapticFeedbackService`. It calls Flutter's
     `HapticFeedback.lightImpact()` (the phone's own light "key click" feel). Errors are
     swallowed, like the other methods — feedback must never break a count.
   - In `CountingNotifier.tap()` (`lib/providers/counting_provider.dart`), call it only when the
     tap was really counted (not during the Meru pause, not with no session) and the setting is on.
   - Note: Android may skip this pulse if the user turned off "Touch feedback / vibration" in the
     phone's own settings. That is the normal Android rule for this kind of feedback.

3. **New switch in Settings → Sound & Haptics → Vibration section**
   (`lib/screens/settings/sound_settings_screen.dart`).
   - Title: "Vibrate on each tap".
   - Sub text: short description plus the battery warning, for example:
     "A short vibration each time you tap to count. Uses a little extra battery in long sessions."
   - Shown with a warning-style line (small battery icon + warning text) under the switch, so the
     warning is clear and not hidden.

4. **Text (ARB) changes in all three languages (en, ml, sa)**, each with an `@key` description:
   - New keys: `tapVibration`, `tapVibrationSub`, `tapVibrationBatteryWarning`.
   - Fix `permVibrationDesc` so it no longer says "each chant tap" (it says mala completion,
     goal achievement and undo).
   - Update `helpAudioVibrationBullet1` to mention the optional per-tap vibration.
   - Run `flutter gen-l10n`.

5. **Tests**
   - `test/repositories/settings_repository_test.dart`: default is `false`; set/get works.
   - `test/providers/settings_provider_test.dart`: notifier updates state.
   - `test/services/haptic_feedback_service_test.dart`: `tapPulse()` calls the platform haptic
     and never throws.
   - `test/providers/counting_provider_test.dart`: pulse fires on a counted tap when on; not
     when off; not during Meru pause.
   - `test/screens/sound_settings_screen_test.dart`: new switch and warning text are shown.

6. **Docs**: short note in `docs/architecture.md` (settings list / feedback) and update the
   `VIBRATE` row in `docs/security.md` to include the optional per-tap feedback.

7. Run `dart format .`, `flutter analyze`, `flutter test`. No Gradle build needed.

## Files to be changed

- `lib/core/constants/app_constants.dart`
- `lib/repositories/settings_repository.dart`
- `lib/providers/settings_provider.dart`
- `lib/services/haptic_feedback_service.dart`
- `lib/providers/counting_provider.dart`
- `lib/screens/settings/sound_settings_screen.dart`
- `lib/l10n/app_en.arb`, `lib/l10n/app_ml.arb`, `lib/l10n/app_sa.arb` (+ generated
  `lib/l10n/app_localizations*.dart`)
- `test/repositories/settings_repository_test.dart`
- `test/providers/settings_provider_test.dart`
- `test/services/haptic_feedback_service_test.dart`
- `test/providers/counting_provider_test.dart`
- `test/screens/sound_settings_screen_test.dart`
- `docs/architecture.md`, `docs/security.md`

## Not changed

- Backup / export format — settings are not part of the backup, so import compatibility is not
  touched.
- `AndroidManifest.xml` — the `VIBRATE` permission already exists.

**Security impact:** None. Uses the existing `VIBRATE` permission; one new non-sensitive
SharedPreferences boolean; no network, no new dependency, nothing logged.
