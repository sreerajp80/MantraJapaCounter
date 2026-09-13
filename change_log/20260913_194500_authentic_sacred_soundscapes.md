# Change Log: Authentic Sacred Acoustic Soundscapes

**Date:** 2026-09-13
**Author:** AI Agent
**Reference Plan:** plans/20260913_194500_authentic_sacred_soundscapes.md

---

## 1. Summary of Changes

- **Bundled Sacred Audio Assets (`assets/audio/`)**:
  - Generated and bundled 16-bit 44.1kHz studio-quality offline PCM WAV audio files:
    - `assets/audio/temple_bell.wav`: Deep, tranquil resonance of a cast bronze temple bell (*Ghanta*) with rich inharmonic partials and natural acoustic decay (3.6s).
    - `assets/audio/singing_bowl.wav`: Himalayan Tibetan singing bowl harmonic overtones with gentle rotary pulsation (4.2s).
    - `assets/audio/shankha.wav`: Auspicious ceremonial blow of a sacred conch shell (*Shankha*) (3.2s).
    - `assets/audio/bead_click.wav`: Faint, warm wooden bead tactile click (0.045s).
  - Registered `assets/audio/` under `flutter: assets:` in `pubspec.yaml`.

- **Domain Model (`lib/models/mala_sound.dart`)**:
  - Created pure Dart enum `MalaSound` with values:
    - `templeBell` (`'temple_bell'`) — default
    - `singingBowl` (`'singing_bowl'`)
    - `synthesizedTone` (`'synthesized_tone'`)
  - Added helper properties `id`, `assetPath`, and deserializer `fromId()`.

- **Constants & Persistence**:
  - Added `prefsMalaSoundKey = 'mala_sound'` to `lib/core/constants/app_constants.dart`.
  - Added `malaSound` getter and `setMalaSound` setter to `lib/repositories/settings_repository.dart`.
  - Added `malaSound` to `AppSettings`, `copyWith`, and `SettingsNotifier` in `lib/providers/settings_provider.dart`.

- **Audio Service (`lib/services/sound_service.dart`)**:
  - Added `playMalaSound(MalaSound sound)`:
    - For `MalaSound.synthesizedTone`, invokes the native `ToneGenerator` DTMF beep via `MethodChannel`.
    - For `MalaSound.templeBell` and `MalaSound.singingBowl`, boosts alarm volume and plays via `audioplayers` `AssetSource`.
  - Added `playSacredAsset(String assetPath)` for preview and sacred instrument triggers.
  - Added `stop()` to stop audio playback and preview tones.
  - Added optional `AudioPlayer? player` parameter to constructor for unit testing.

- **Counting Provider Integration (`lib/providers/counting_provider.dart`)**:
  - Updated mala completion handler (108 beads) to call `sound.playMalaSound(settings.malaSound)`.

- **Settings UI & Sound Picker**:
  - Added Mala Sound row under the Mala completion section in `lib/screens/settings/settings_screen.dart`.
  - Created `lib/screens/settings/mala_sound_picker.dart` modal bottom sheet allowing practitioners to preview and select between Temple Bronze Bell (*Ghanta*), Tibetan Singing Bowl, and Synthesized Tone (*DTMF*).

- **Multilingual Localization (`lib/l10n/`)**:
  - Added localized strings and `@` metadata across English (`app_en.arb`), Malayalam (`app_ml.arb`), and Sanskrit (`app_sa.arb`) for all mala soundscape options.
  - Regenerated localization files via `flutter gen-l10n`.

- **Test Suite**:
  - Added `test/models/mala_sound_test.dart` for enum serialization and defaults.
  - Added `test/services/sound_service_test.dart` testing sound service methods and dispatch.
  - Added `malaSound` repository and notifier tests in `test/repositories/settings_repository_test.dart`.
  - Added widget test for mala sound row and picker in `test/screens/settings_screen_test.dart`.
  - Verified ARB parity and translation compliance with `test/l10n/translation_parity_test.dart`.

---

## 2. Files Changed

### Created:
- `assets/audio/temple_bell.wav`
- `assets/audio/singing_bowl.wav`
- `assets/audio/shankha.wav`
- `assets/audio/bead_click.wav`
- `lib/models/mala_sound.dart`
- `lib/screens/settings/mala_sound_picker.dart`
- `plans/20260913_194500_authentic_sacred_soundscapes.md`
- `change_log/20260913_194500_authentic_sacred_soundscapes.md`
- `test/models/mala_sound_test.dart`
- `test/services/sound_service_test.dart`

### Modified:
- `pubspec.yaml`
- `lib/core/constants/app_constants.dart`
- `lib/repositories/settings_repository.dart`
- `lib/providers/settings_provider.dart`
- `lib/providers/counting_provider.dart`
- `lib/services/sound_service.dart`
- `lib/screens/settings/settings_screen.dart`
- `lib/l10n/app_en.arb`
- `lib/l10n/app_ml.arb`
- `lib/l10n/app_sa.arb`
- `test/repositories/settings_repository_test.dart`
- `test/screens/settings_screen_test.dart`

---

## 3. Verification Results

- `flutter test`: All 139 unit and widget tests passed.
- `flutter test test/l10n/translation_parity_test.dart`: All localization checks passed with 100% parity across `en`, `ml`, and `sa`.
- `flutter analyze`: Passed with 0 errors and 0 warnings.
- `dart format .`: All files formatted cleanly.
