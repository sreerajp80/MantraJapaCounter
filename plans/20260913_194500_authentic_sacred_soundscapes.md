# Plan: Authentic Sacred Acoustic Soundscapes

**Status:** Proposed
**Date:** 2026-09-13
**Author:** AI Agent

---

## 1. Overview

Replace the synthetic electronic beep used for mala completion with authentic, offline sacred acoustic soundscapes. Practitioners can choose between:
1. **Temple Bronze Bell (*Ghanta*)**: Deep, tranquil bronze resonance with long acoustic decay.
2. **Tibetan Singing Bowl**: Soothing harmonic overtone for quiet mindfulness.
3. **Synthesized Tone**: The classic 100ms electronic beep (DTMF).

Additionally, bundle offline audio assets for:
- **Conch Shell (*Shankha*)**: Auspicious ceremonial blow for major goal completions.
- **Organic Wood Bead Click**: Warm, subtle wooden click of sacred beads.

All audio files will be stored locally in `assets/audio/` with zero internet access required.

---

## 2. Issues & Current State

1. Mala completion currently only plays a synthesized 100ms DTMF tone via Android `ToneGenerator`.
2. Electronic beeps feel like kitchen or office alarms and can disturb deep meditative stillness.
3. No soundscape options or offline sacred instrument recordings are bundled in the app.
4. Settings does not offer a choice for mala completion sound.

---

## 3. Proposed Fix & Architecture

1. **Audio Assets (`assets/audio/`)**:
   - Generate and bundle high-fidelity 16-bit 44.1kHz PCM WAV audio files:
     - `assets/audio/temple_bell.wav` (3.6s bronze bell resonance with natural acoustic decay).
     - `assets/audio/singing_bowl.wav` (4.2s singing bowl overtones with gentle rotary pulsation).
     - `assets/audio/shankha.wav` (3.2s ceremonial conch shell blow).
     - `assets/audio/bead_click.wav` (0.045s subtle wooden bead click).
   - Register `assets/audio/` in `pubspec.yaml`.

2. **Domain Model (`lib/models/mala_sound.dart`)**:
   - Create a pure Dart enum `MalaSound` with values:
     - `templeBell` (`'temple_bell'`)
     - `singingBowl` (`'singing_bowl'`)
     - `synthesizedTone` (`'synthesized_tone'`)
   - Include helper properties (`id`, `assetPath`) and `fromId()` deserializer. Default is `templeBell`.

3. **Storage & Preferences**:
   - In `lib/core/constants/app_constants.dart`, add `prefsMalaSoundKey = 'mala_sound'`.
   - In `lib/repositories/settings_repository.dart`, add getter and setter for `malaSound`.
   - In `lib/providers/settings_provider.dart`, add `malaSound` to `AppSettings` and `setMalaSound` in `SettingsNotifier`.

4. **Audio Service (`lib/services/sound_service.dart`)**:
   - Add `playMalaSound(MalaSound sound)`:
     - If `synthesizedTone`, invokes native channel `'playMalaTone'`.
     - If `templeBell` or `singingBowl`, triggers temporary alarm volume boost and plays via `audioplayers` `AssetSource`.
   - Add `playSacredAsset(String assetPath)` for preview and sacred audio triggers.

5. **Counting Provider (`lib/providers/counting_provider.dart`)**:
   - In `_checkNotifications`, when a full mala (108 counts) is reached and `settings.malaNotificationsEnabled` is true:
     - Play the selected sound using `sound.playMalaSound(settings.malaSound)`.

6. **Settings UI (`lib/screens/settings/`)**:
   - In `lib/screens/settings/settings_screen.dart`, add a Mala Sound row under the Mala section showing the active choice.
   - Create `lib/screens/settings/mala_sound_picker.dart` (a bottom sheet matching existing design):
     - Displays the three options with titles and descriptions.
     - Provides an inline play button to preview each sound.
     - Radio selection to pick the preferred sound.

7. **Localization (`lib/l10n/`)**:
   - Add localized keys in `app_en.arb`, `app_ml.arb`, and `app_sa.arb` for:
     - `malaSoundTitle`
     - `malaSoundSub`
     - `soundTempleBell`
     - `soundTempleBellSub`
     - `soundSingingBowl`
     - `soundSingingBowlSub`
     - `soundSynthesizedTone`
     - `soundSynthesizedToneSub`
   - Run `flutter gen-l10n` to rebuild localization classes.

---

## 4. Files to Change

### New Files:
- `assets/audio/temple_bell.wav`
- `assets/audio/singing_bowl.wav`
- `assets/audio/shankha.wav`
- `assets/audio/bead_click.wav`
- `lib/models/mala_sound.dart`
- `lib/screens/settings/mala_sound_picker.dart`
- `test/models/mala_sound_test.dart`

### Modified Files:
- `pubspec.yaml`
- `lib/core/constants/app_constants.dart`
- `lib/repositories/settings_repository.dart`
- `lib/providers/settings_provider.dart`
- `lib/services/sound_service.dart`
- `lib/providers/counting_provider.dart`
- `lib/screens/settings/settings_screen.dart`
- `lib/l10n/app_en.arb`
- `lib/l10n/app_ml.arb`
- `lib/l10n/app_sa.arb`
- `test/repositories/settings_repository_test.dart`
- `test/screens/settings_screen_test.dart`

---

## 5. Verification Plan

1. **Automated Tests**:
   - Run `flutter test` to ensure all existing and new unit/widget tests pass.
   - Run `test/l10n/translation_parity_test.dart` to verify key parity across English, Malayalam, and Sanskrit.
2. **Static Analysis**:
   - Run `flutter analyze` to ensure 0 warnings and 0 errors.
   - Run `dart format .` to maintain formatting standards.
3. **Manual / Runtime Checks**:
   - Verify audio asset file properties and bundle paths.
   - Check settings navigation and sound preview behavior.
