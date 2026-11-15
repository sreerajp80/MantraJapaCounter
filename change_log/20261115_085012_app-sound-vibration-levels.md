# Change log: App's own sound volume, vibration strength, and "ignore phone vibration settings"

Implements plan: [plans/20261115_083919_app-sound-vibration-levels.md](../plans/20261115_083919_app-sound-vibration-levels.md)

## What changed

### New settings (Settings → Sound & Haptics)
- **Ignore phone vibration settings** switch, in the Vibration section (off by default).
  It changes only the tap pulse and the undo pulse. When it is on, the app sends both as alarm
  vibrations, so they work even when the phone's touch vibration is off or the phone is on
  silent. When it is off, they work as before.
- New **Levels** section with two sliders (10–100 %, steps of 10, default 100 %):
  - **Sound volume** for the mala chime and goal tones.
  - **Vibration strength** for mala, goal and undo vibrations, and the tap pulse when the switch
    is on. A note under it says the tap and undo pulses use the phone's own strength while the
    switch is off. The slider is hidden on phones that cannot change vibration strength.
  - Letting go of a slider saves it once and plays one sample (mala sound / mala vibration).
- Defaults keep the old behaviour exactly.

### Native Android (`MainActivity.kt`)
- `playMalaTone`, `boostAlarmVolume`, `playRingtoneUri`, `previewDefaultNotificationTone` take
  an optional `volume` (0.1–1.0). The alarm stream is set to `volume × max` (at least 1)
  instead of always max. Missing argument → 1.0.
- `vibrateMala`, `vibrateDailyGoal` take an optional `strength` (0.1–1.0) → amplitude
  `strength × 255`. New `vibrateTap` (20 ms), `vibrateUndo` (40 ms) and `hasAmplitudeControl`.
- Crash-recovery restore now also saves the level the app set (`boosted_alarm_level`) and
  restores the user's alarm volume only if it still equals that level. Older saved state
  without this value falls back to max, as before.

### Dart
- `AppConstants`: three new prefs keys and the 10 / 100 / 100 level limits.
- `SettingsRepository`, `AppSettings`, `SettingsNotifier`: new fields and setters. Out-of-range
  values are clamped on save; bad saved values fall back to 100.
- `HapticFeedbackService`: `volume` / `strength` arguments, `tapPulse({ignorePhone, strength})`,
  new `undoPulse(...)` and `hasAmplitudeControl()`.
- `SoundService`: `playMalaSound`, `playTone`, `playSacredAsset` take `volume`.
- `vibratorHasAmplitudeControlProvider` (new `FutureProvider` in `app_providers.dart`).
- `counting_provider.dart` passes the levels at the mala, goal and tap call sites.
- `counting_screen.dart`: the undo swipe now calls `HapticFeedbackService.undoPulse(...)`
  instead of `HapticFeedback.mediumImpact()` directly (removes a layer leak and an unused
  import).
- Sound picker previews (`mala_sound_picker.dart`, `notification_sound_picker.dart`) and the
  "Preview tone" rows play at the chosen volume.
- New widget `lib/screens/settings/settings_level_slider.dart`.

### Translations and help
- 9 new ARB keys in `app_en.arb` (with `@` descriptions), `app_ml.arb` and `app_sa.arb`;
  `flutter gen-l10n` run.
- Help text updated in all three languages: `helpAudioIntro`, `helpAudioVibrationBullet1`,
  `helpAudioVibrationBullet2`, `helpCountingTapBullet3` (the last one wrongly said taps never
  vibrate).

### Docs
- `docs/architecture.md`, `docs/security.md` (preferences table, `VIBRATE` row), and
  `docs/features.md` (not in the plan's list; it described the old "max volume / max amplitude"
  behaviour, so it was brought up to date).

### Tests
- `settings_repository_test.dart`, `settings_provider_test.dart`: defaults, save/read, clamping,
  bad saved values.
- `counting_provider_test.dart`: the tap pulse gets the switch and strength.
- `haptic_feedback_service_test.dart`: levels sent to the native side, tap/undo routing with
  `ignorePhone`, `hasAmplitudeControl`.
- `sound_service_test.dart`: volume is passed for every playback path.
- `sound_settings_screen_test.dart`: switch, sliders, note, hidden strength slider, saving a
  slider value.

## Results
- `dart format`: no changes needed. `flutter analyze`: no issues. `flutter test`: all 445 pass.
- Not yet checked: a Gradle build of the Kotlin changes, and a test on a real phone.

## Backup format
No change. These are app settings in SharedPreferences, not part of the export file.
