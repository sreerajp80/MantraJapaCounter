# Plan: Remove "Ignore phone vibration settings", add a Yes/No vibration test

**Status:** completed

Follows: [plans/20261115_083919_app-sound-vibration-levels.md](20261115_083919_app-sound-vibration-levels.md)

## The issue

Testing on a phone showed:
- With "Ignore phone vibration settings", "Vibration" and "Vibrate on each tap" all on, no tap
  vibration was felt, and the mala vibration was only a faint click.
- The cause was the phone's own **Alarm vibration** level, which was low. Android scales every
  app's alarm vibrations by that level, and when the phone's main vibration switch is off, all
  vibrations stop. No app can get past this.
- So the switch name promised more than Android allows. Its only real job was to get past the
  phone's **touch** vibration setting for the tap and undo pulses. That is too little for a
  switch of its own.
- The tap pulse (20 ms on/off) is also too short for many vibration motors.

Agreed with the user:
1. Remove the switch. Tap and undo pulses always use the app's own vibration, like the mala and
   goal vibrations.
2. When the user turns on Vibration or Vibrate on each tap, the app plays one test vibration and
   asks "Did you feel a vibration?" (Yes / No). On No it explains the phone setting and offers to
   open the phone's settings. The app setting stays on either way.
3. The app does **not** block its own switch based on the phone setting, because Android gives
   no reliable way to read that setting.

## Design details

- **Tap and undo pulses (native):**
  - Android 11+ (API 30) and the phone supports the "click" primitive: play
    `VibrationEffect.startComposition().addPrimitive(PRIMITIVE_CLICK, strength)` (undo: two
    clicks with a short gap). This is a short click tuned for the phone's motor, and `strength`
    (0.1–1.0) scales it.
  - Otherwise: a one-shot pulse, made longer so it can be felt: tap 35 ms, undo 60 ms, at the
    in-app strength.
  - Same `USAGE_ALARM` attributes as now.
- **`HapticFeedbackService`:** `tapPulse({double strength})` and `undoPulse({double strength})`
  always call the native side (no more `HapticFeedback` system haptics). New
  `openPhoneVibrationSettings()`.
- **Native `openPhoneVibrationSettings`:** opens `Settings.ACTION_SOUND_SETTINGS` (the phone's
  Sound & vibration page, the closest page Android lets an app open). If that fails, it opens
  the main Settings page. It never throws.
- **Yes/No test dialog** (new widget `lib/screens/settings/vibration_test_dialog.dart`):
  - Shown only when a switch goes from off to on, for Vibration or Vibrate on each tap.
  - It plays one mala vibration at the current strength, then asks "Did you feel a vibration?"
    with **Yes** / **No**. A "Test again" button replays it.
  - **Yes** → close. **No** → the dialog explains: "The phone's vibration is off or set very
    low. Every app's vibration is limited by the phone's own settings. Turn vibration on and
    raise Alarm vibration there." Buttons: **Open phone settings**, **Close**.
- **Strength slider note** now says the phone's own vibration settings set the maximum
  strength. It is always shown, with no link to a switch.
- **Removed:** the `ignorePhoneVibration` setting (constant, repository, `AppSettings`, notifier,
  UI row) and its ARB keys `ignorePhoneVibration`, `ignorePhoneVibrationSub`,
  `vibrationStrengthPhoneNote`. The switch was never in a released build. A saved
  `ignore_phone_vibration` value on a test phone is simply ignored.
- **New ARB keys** (en / ml / sa, with `@` descriptions in en): `vibrationTestTitle`,
  `vibrationTestBody`, `vibrationTestYes`, `vibrationTestNo`, `vibrationTestAgain`,
  `vibrationOffTitle`, `vibrationOffBody`, `openPhoneSettings`, `vibrationTestClose`,
  `vibrationStrengthPhoneLimit`.
- **Help text** (en / ml / sa): `helpAudioVibrationBullet1` / `Bullet2` drop the mention of the
  removed switch and say that the phone's own vibration settings set the limit.

## Files to change

- `android/app/src/main/kotlin/com/sreerajp/mantrajapacounter/MainActivity.kt`
- `lib/core/constants/app_constants.dart`
- `lib/repositories/settings_repository.dart`
- `lib/providers/settings_provider.dart`
- `lib/providers/counting_provider.dart`
- `lib/services/haptic_feedback_service.dart`
- `lib/screens/counting_screen.dart`
- `lib/screens/settings/sound_settings_screen.dart`
- new `lib/screens/settings/vibration_test_dialog.dart`
- `lib/l10n/app_en.arb`, `app_ml.arb`, `app_sa.arb` + `flutter gen-l10n`
- `docs/architecture.md`, `docs/features.md`, `docs/security.md`
- Tests: `test/repositories/settings_repository_test.dart`,
  `test/providers/settings_provider_test.dart`, `test/providers/counting_provider_test.dart`,
  `test/services/haptic_feedback_service_test.dart`,
  `test/screens/sound_settings_screen_test.dart` (dialog shown on off→on only, Yes closes, No
  shows the help and the button calls the service)

## Security impact

Touches a platform folder (native Android code). It opens a system Settings page with a
standard intent, which needs no permission. No new permission, no network, no change to stored
data or the backup format. The app still cannot change any phone setting itself; it only opens
the page for the user.

## Risks

- `ACTION_SOUND_SETTINGS` lands on a slightly different page on each phone maker. The user may
  need one more tap to reach the vibration settings. The dialog text says where to look.
- The "click" primitive feels lighter than a buzz. If it is too light on the user's phone, the
  fallback durations can be tuned after testing.

## Verify

- `dart format .`, `flutter analyze`, `flutter test`.
- On the phone (user): turn the phone's Alarm vibration level down, then turn on Vibration in the
  app → test vibration → No → Open phone settings opens the phone's Sound & vibration page.
  Raise the level → tap and undo pulses feel like crisp clicks, and the strength slider changes
  them.
