# Change Log: Settings Redesign, Status Borders, Custom Achievement Tones, Help Tutorial, Features & Permissions

**Date:** 2026-09-19  
**Plan:** plans/20260919_100500_settings_features_permissions_polish.md

## Summary

This change polishes the app to prepare for release on Google Play Store and GitHub. It addresses all 6 requested improvements:
1. Redesigned Settings as a list of distinct cards where tapping each card navigates to a dedicated settings sub-screen.
2. Added thin (1.0px) status borders to counter cards: vermillion for active, dark green for completed with success, and black for completed with failure.
3. Added custom achievement tones for daily goals and lifetime goals with choices for sacred temple sounds, system ringtones, and local audio files.
4. Added an illustrated 7-step app tutorial in the Help section covering practice essentials, mala cycles, optical sync, and encryption.
5. Expanded the Features section to comprehensively and accurately document all app capabilities.
6. Added a Permissions card and dedicated page in Settings detailing explicit permissions, implicit capabilities, and zero-trust excluded permissions.

## Changes Made

### 1. Counter Card Status Borders
- `lib/widgets/counter_card.dart`:
  - Added thin borders to counter cards matching card status:
    - Active: vermillion (`TempleColors.vermillion`, `#C8401E`).
    - Successfully completed (`disabledSuccess`): dark green (`#1B5E20`).
    - Failed completed (`disabledFailure`): black (`#000000`).
- `test/widgets/counter_card_test.dart`:
  - Added widget tests validating border colors for each status.

### 2. Custom Achievement Tones for Daily & Lifetime Goals
- `lib/core/constants/app_constants.dart`:
  - Added notification channel ID and preference keys for lifetime goal tone settings.
- `lib/repositories/settings_repository.dart` & `lib/providers/settings_provider.dart`:
  - Added `lifetimeGoalNotificationsEnabled`, `lifetimeSoundUri`, and `lifetimeSoundName` with getters, setters, and persistent storage.
- `lib/services/sound_service.dart`:
  - Added support for playing sacred tone identifiers (`sacred:shankha`, `sacred:temple_bell`, `sacred:singing_bowl`, `sacred:synthesized_tone`), asset paths, and local audio files.
- `lib/services/notification_service.dart`:
  - Added dedicated Android notification channel for lifetime goal achievement.
- `lib/providers/counting_provider.dart`:
  - Added `_lifetimeGoal` milestone tracking and trigger logic. Plays the configured sound, vibrates, and shows notification upon reaching lifetime goal.
- `lib/screens/settings/notification_sound_picker.dart`:
  - Generalized sound picker into `showCustomSoundPicker` offering system default, sacred chimes, device ringtones, and file browser. Added `showLifetimeSoundPicker`.

### 3. Dedicated Settings Screens & Card-Based Settings Hub
- `lib/screens/settings/settings_screen.dart`:
  - Redesigned main Settings screen into clean rounded cards with leading icons, titles, descriptions, and chevron arrows.
- `lib/screens/settings/sound_settings_screen.dart`:
  - Created dedicated sub-screen for mala completion soundscapes, daily goal tone, lifetime achievement tone, and vibration settings.
- `lib/screens/settings/display_settings_screen.dart`:
  - Created dedicated sub-screen for screen stillness mode and auto-dimming.
- `lib/screens/settings/language_settings_screen.dart`:
  - Created dedicated sub-screen for English, Malayalam, Sanskrit, and system default language selection.
- `lib/screens/settings/backup_settings_screen.dart`:
  - Created dedicated sub-screen for air-gapped optical QR sync transmit/receive, JSON export/import, encrypted export/import, and data reset.
- `lib/screens/settings/permissions_screen.dart`:
  - Created dedicated sub-screen grouping permissions into:
    - Explicit device permissions (Camera for QR optical sync, Notifications for goal alerts).
    - Implicit hardware capabilities (Vibration feedback, Audio volume control).
    - Zero-trust excluded permissions (No Internet, No wide storage read/write).
- `lib/core/routing/router.dart`:
  - Added named sub-routes for all settings pages and the help tutorial.

### 4. Help Section & Step-by-Step Tutorial
- `lib/screens/help/tutorial_help_screen.dart`:
  - Created illustrated 7-step tutorial covering:
    1. Creating your first counter.
    2. Sacred fullscreen counting experience.
    3. 108 beads mala milestone system.
    4. Daily and lifetime milestone goals.
    5. Counter locking and archiving.
    6. Air-gapped optical QR sync.
    7. Encrypted offline backup and recovery.
- `lib/screens/help/help_home_screen.dart`:
  - Added featured tutorial entry card at the top of the help center.

### 5. Accurate Features Coverage
- `lib/screens/features_screen.dart`:
  - Expanded feature list with detailed descriptions for lifetime goals, sacred audio soundscapes, air-gapped optical sync, and AES-GCM encrypted backups.

### 6. Localization & Testing
- `lib/l10n/app_en.arb`, `lib/l10n/app_ml.arb`, `lib/l10n/app_sa.arb`:
  - Added 32 new strings across all three languages with full key parity and `@description` entries.
  - Generated localizations with `flutter gen-l10n`.
- `test/l10n/translation_parity_test.dart`:
  - Verified 100% key parity across English, Malayalam, and Sanskrit.
- `test/screens/settings_screen_test.dart`, `test/screens/sound_settings_screen_test.dart`, `test/screens/tutorial_help_screen_test.dart`:
  - Added and updated tests for card navigation, custom sound picker, and tutorial rendering.
- Code formatted with `dart format .`. Static analysis clean with `flutter analyze` (0 issues). All 157 tests pass with `flutter test`.

## Verification
- `flutter analyze`: 0 warnings, 0 errors.
- `flutter test`: 157 tests passed (0 failures).
