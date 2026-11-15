# Plan: App's own sound volume, vibration strength, and "ignore phone vibration settings"

**Status:** completed

## The issue

The user wants Sound & Haptics to work from the app's own settings, not the phone's settings,
with controls for sound volume and vibration strength.

How it works today:
- **Mala chime and goal tones** play on the alarm stream. Before each sound the app sets the
  phone's alarm volume to **maximum** and puts it back about 6 seconds later. So they already
  play in silent / Do Not Disturb (DND) mode, but always at full volume.
- **Mala and goal vibrations** are sent as alarm vibrations at **full strength (255)**. They
  already ignore silent mode, but the strength can't be changed.
- **Per-tap pulse** (`HapticFeedback.lightImpact`) and **undo vibration**
  (`HapticFeedback.mediumImpact`) use the phone's touch feedback. Android skips them when touch
  vibration is off in the phone's settings.

## Agreed design

1. **Switch "Ignore phone vibration settings"** (off by default).
   - It changes only the two things that follow the phone today: the per-tap pulse and the
     undo vibration.
   - **Off:** same as today (phone touch feedback).
   - **On:** both are sent by the app as alarm vibrations (like mala/goal), so they work even
     in silent mode or with touch vibration turned off.
2. **Sound volume slider** (10–100 %, default 100 %), always shown. Sets how loud the mala
   chime and goal tones play. The app sets the alarm stream to this share of its maximum,
   instead of always the maximum. Sound still ignores silent / DND at any level.
3. **Vibration strength slider** (10–100 %, default 100 %), always shown. Sets the strength of
   mala, goal and undo vibrations, and of the tap pulse when the switch is on.
   - Short note under it: when the switch is off, the tap and undo pulses use the phone's own
     strength.
   - Hidden on phones that cannot change vibration strength (no amplitude control).
4. Letting go of a slider plays a short sample (the current mala sound, or one mala
   vibration), so the user can hear / feel the level.

Defaults keep today's behaviour exactly, so current users see no change.

## Design details

- New SharedPreferences keys (in `AppConstants`): `ignore_phone_vibration` (bool, default
  false), `feedback_volume_percent` (int, default 100), `vibration_strength_percent` (int,
  default 100). A missing or out-of-range saved value → clamped to 10–100 / default.
- These are app settings, not counter data, so the backup format does not change.
- Native (`MainActivity.kt`, `com.sreerajp.mantrajapacounter/haptic` channel):
  - `boostAlarmVolume`, `playMalaTone`, `playRingtoneUri`, `previewDefaultNotificationTone`
    take an optional `volume` (0.1–1.0). Target = `max(1, round(maxAlarmVolume * volume))`.
    Missing argument → 1.0 (today's behaviour).
  - The crash-recovery restore today only puts the old volume back if the alarm volume is
    still at max. It will also save the level the app set, and restore only if the volume
    still equals that level (so a change the user made is never undone).
  - `vibrateMala` and `vibrateDailyGoal` take an optional `strength` (0.1–1.0) →
    amplitude `max(1, round(255 * strength))`. Missing → 255 (today).
  - New `vibrateTap` (about 20 ms) and `vibrateUndo` (about 40 ms) one-shots with
    USAGE_ALARM and the given strength.
  - New `hasAmplitudeControl` → bool, used to hide the strength slider.
- Dart services stay free of settings: the provider passes the levels in.
  - `HapticFeedbackService`: `vibrateMala({double strength})`,
    `vibrateDailyGoal({double strength})`, `tapPulse({bool ignorePhone, double strength})`,
    new `undoPulse({bool ignorePhone, double strength})`, `hasAmplitudeControl()`.
    When `ignorePhone` is false, tap/undo use `HapticFeedback` as today.
  - `SoundService`: `playMalaSound`, `playTone`, `playSacredAsset` take `{double volume}` and
    pass it to the native boost / tone calls.
- `counting_provider.dart` passes the levels from `AppSettings` at the mala, goal and tap call
  sites. `counting_screen.dart` undo swipe calls `undoPulse(...)` through the service
  instead of calling `HapticFeedback.mediumImpact()` directly (also fixes a layer leak).
- Settings screen (Sound & Haptics → Vibration section): add the switch, then a new
  "Levels" area with the two sliders, reusing the look of `SettingsBrightnessRow`.

## Files to change

- `android/app/src/main/kotlin/com/sreerajp/mantrajapacounter/MainActivity.kt`
- `lib/core/constants/app_constants.dart`
- `lib/repositories/settings_repository.dart`
- `lib/providers/settings_provider.dart`
- `lib/providers/counting_provider.dart`
- `lib/services/haptic_feedback_service.dart`
- `lib/services/sound_service.dart`
- `lib/screens/counting_screen.dart`
- `lib/screens/settings/sound_settings_screen.dart`
- new `lib/screens/settings/settings_level_slider.dart` (shared percent slider row)
- `lib/l10n/app_en.arb`, `app_ml.arb`, `app_sa.arb` (new keys with `@` descriptions; switch
  title/sub, volume, strength, the "phone's own strength" note) + `flutter gen-l10n`
- Help text in the ARB files: `helpAudioVibrationBullet1/2`, `helpCountingTapBullet3` updated
  to mention the new switch and sliders
- `docs/architecture.md` (Sound & Haptics section), `docs/security.md` (preferences table,
  `VIBRATE` row)
- Tests: `test/repositories/settings_repository_test.dart`,
  `test/providers/settings_provider_test.dart`, `test/providers/counting_provider_test.dart`,
  `test/screens/sound_settings_screen_test.dart`, new
  `test/services/haptic_feedback_service_test.dart` (channel arguments, ignorePhone on/off)

## Security impact

Touches a platform folder (native Android code). No new permission: `VIBRATE` is already
declared, and changing the alarm stream volume needs none. No network, storage format or
backup change. The existing rule stays: the app restores the user's alarm volume after each
sound, on pause, and after a crash.

## Risks

- Very low volume may be hard to hear on some phones; the minimum is 10 %, not 0.
- Phones without amplitude control ignore strength (slider hidden there).
- Tap vibration with the switch on uses the alarm channel on every tap, so the battery warning
  still applies.

## Verify

- `dart format .`, `flutter analyze`, `flutter test`.
- On a phone (you): silent mode + touch vibration off → tap/undo pulse only with the switch
  on; sliders change chime loudness and vibration strength; alarm volume comes back after.
