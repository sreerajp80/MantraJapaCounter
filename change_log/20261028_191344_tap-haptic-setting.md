# Change log: Setting to turn haptic feedback on each tap on or off

Implements plan: `plans/20261028_190831_tap-haptic-setting.md`

## What changed

- **New setting "Vibrate on each tap"** (`tapVibrationEnabled`, off by default).
  - `lib/core/constants/app_constants.dart`: new key `prefsTapVibrationKey = 'tap_vibration'`.
  - `lib/repositories/settings_repository.dart`: getter (default `false`) and setter.
  - `lib/providers/settings_provider.dart`: new `AppSettings` field and
    `SettingsNotifier.setTapVibrationEnabled`.
  - It is separate from the existing Vibration switch (mala / goal / undo).
- **Pulse on each counted tap.**
  - `lib/services/haptic_feedback_service.dart`: new `tapPulse()` using
    `HapticFeedback.lightImpact()`. Errors are swallowed.
  - `lib/providers/counting_provider.dart`: `tap()` calls `_pulseOnTap()` right after the count
    goes up. No pulse during the Meru pause or with no session (those taps return early).
- **Settings screen** (`lib/screens/settings/sound_settings_screen.dart`): new switch in the
  Vibration section, with a battery icon and warning text always shown under it.
- **Texts** in `lib/l10n/app_en.arb`, `app_ml.arb`, `app_sa.arb` (+ regenerated
  `app_localizations*.dart`):
  - New keys `tapVibration`, `tapVibrationSub`, `tapVibrationBatteryWarning`.
  - `permVibrationDesc` no longer says the app vibrates on each chant tap (it did not).
  - `helpAudioVibrationBullet1` now mentions the optional per-tap pulse and its battery cost.
- **Tests**:
  - `test/repositories/settings_repository_test.dart`: default off; save and read.
  - `test/providers/settings_provider_test.dart`: notifier saves the value; main Vibration
    switch is untouched.
  - `test/services/haptic_feedback_service_test.dart`: `tapPulse()` sends a light haptic and
    never throws.
  - `test/providers/counting_provider_test.dart`: no pulse when off; one pulse per counted tap
    when on; no pulse for a tap ignored during the Meru pause.
  - `test/screens/sound_settings_screen_test.dart`: switch, warning and icon are shown; tapping
    the switch saves it.
- **Docs**: `docs/architecture.md` (tap vibration note in the mala section) and
  `docs/security.md` (`VIBRATE` row).

## Checks

- `dart format`: no changes needed.
- `flutter analyze`: no issues.
- `flutter test`: all tests pass.
- Not checked on a real phone yet (how strong the pulse feels depends on the device).

## Not changed

- Backup / export format (settings are not in the backup).
- `AndroidManifest.xml` (the `VIBRATE` permission already exists).
