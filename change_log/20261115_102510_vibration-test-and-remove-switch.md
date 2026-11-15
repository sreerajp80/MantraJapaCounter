# Change log: Remove "Ignore phone vibration settings", add a Yes/No vibration test

Implements plan: [plans/20261115_101944_vibration-test-and-remove-switch.md](../plans/20261115_101944_vibration-test-and-remove-switch.md)

Follows: [change_log/20261115_085012_app-sound-vibration-levels.md](20261115_085012_app-sound-vibration-levels.md)

## Why

Phone testing showed that the phone's own Alarm vibration level and main vibration switch limit
every app's vibrations, and no app can get past them. The "Ignore phone vibration settings"
switch promised more than Android allows, and the 20 ms tap pulse was too short to feel.

## What changed

### Removed
- The "Ignore phone vibration settings" switch: prefs key constant, repository getter/setter,
  `AppSettings` field, notifier setter, settings row, and ARB keys `ignorePhoneVibration`,
  `ignorePhoneVibrationSub`, `vibrationStrengthPhoneNote` (en / ml / sa). It was never in a
  released build.

### Tap and undo pulses
- Always sent by the app (`USAGE_ALARM`), never by the system haptics
  (`HapticFeedback.lightImpact` / `mediumImpact` are no longer used).
- Native `vibrateClicks`: on Android 11+ phones that support `PRIMITIVE_CLICK`, a tuned click
  scaled by the strength (undo = two clicks, 70 ms apart). Otherwise a plain pulse, now 35 ms
  (tap) / 60 ms (undo) instead of 20 / 40 ms.
- `HapticFeedbackService.tapPulse({strength})` / `undoPulse({strength})`.

### Vibration test
- New `lib/screens/settings/vibration_test_dialog.dart`. Turning on Vibration or Vibrate on each
  tap (off → on only) plays one mala vibration at the current strength and asks "Did you feel a
  vibration?" with Test again / No / Yes.
- No → explains that the phone's vibration is off or low, with Close and Open phone settings.
- New native method `openPhoneVibrationSettings` (`ACTION_SOUND_SETTINGS`, falling back to
  `ACTION_SETTINGS`) and `HapticFeedbackService.openPhoneVibrationSettings()`.
- The app setting stays on whatever the answer.

### Text
- New ARB keys (en with `@` descriptions, ml, sa): `vibrationStrengthPhoneLimit`,
  `vibrationTestTitle`, `vibrationTestBody`, `vibrationTestYes`, `vibrationTestNo`,
  `vibrationTestAgain`, `vibrationOffTitle`, `vibrationOffBody`, `openPhoneSettings`,
  `vibrationTestClose`. `flutter gen-l10n` run.
- The strength slider note now always says the phone's own vibration settings set the maximum.
- Help text `helpAudioVibrationBullet1` / `Bullet2` rewritten in all three languages: no mention
  of the removed switch; it now says the phone's vibration settings set the strength limit.

### Docs
- `docs/architecture.md`, `docs/features.md`, `docs/security.md` updated.

### Tests
- Removed the switch tests; the tap pulse fake and settings tests no longer use the switch.
- `haptic_feedback_service_test.dart`: tap/undo always go to the native side with the
  strength; `openPhoneVibrationSettings` calls the native side and never throws.
- `sound_settings_screen_test.dart`: the dialog appears on off → on only, Yes closes it,
  Test again replays, No shows the help and Open phone settings calls the service, and the
  setting stays on.

## Results
- `dart format`: clean. `flutter analyze`: no issues. `flutter test`: all 446 pass.
- Not yet checked: a Gradle build of the Kotlin changes, and a test on a real phone.
