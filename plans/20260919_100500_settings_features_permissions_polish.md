# Implementation Plan: Settings Redesign, Status Borders, Custom Achievement Tones, Help Tutorial, Features & Permissions

**Status:** Complete

## 1. Overview
This plan implements the complete polish required before publishing SreerajP MantraJapa Counter to Google Play Store and GitHub:
1. **Card-Based Settings Page:** Transform Settings into a list of rounded cards matching the reference design. Each card opens its dedicated settings sub-page.
2. **Counter Card Status Borders:** Add a thin border to counter cards based on their status: vermillion for active cards, dark green for successfully completed cards, and black for failed completed cards.
3. **Custom Achievement Tones:** Enable setting custom tones for both Daily Goal achievement and Lifetime achievement, in addition to the 3 sacred mala completion tones.
4. **Help Section & Tutorial:** Expand the Help section to accurately cover all features and include a comprehensive step-by-step tutorial on using the app.
5. **Accurate Features Showcase:** Update the Features section so all app capabilities (counter lifecycle, locking, optical sync, encryption, sacred audio, privacy) are thoroughly covered.
6. **Permissions Page in Settings:** Add a dedicated Permissions card and page explaining implicit vs. explicit permissions and the zero-trust privacy guarantee.

---

## 2. Files to Change & Create

### New Files
- `lib/screens/settings/sound_settings_screen.dart`: Dedicated screen for mala tones, daily goal tone, lifetime goal tone, and haptics.
- `lib/screens/settings/display_settings_screen.dart`: Dedicated screen for stillness mode and brightness controls.
- `lib/screens/settings/language_settings_screen.dart`: Dedicated screen for language selection (English, Malayalam, Sanskrit, System default).
- `lib/screens/settings/backup_settings_screen.dart`: Dedicated screen for Optical Sync transmit/receive, JSON/encrypted export & import, and data reset.
- `lib/screens/settings/permissions_screen.dart`: Dedicated screen detailing explicit, implicit, and prohibited permissions with clear explanations.
- `lib/screens/help/tutorial_help_screen.dart`: Step-by-step guide on how to use the app.
- `test/screens/permissions_screen_test.dart`: Unit and widget test for the permissions screen.
- `test/screens/sound_settings_screen_test.dart`: Unit and widget test for sound and custom goal tones.

### Modified Files
- `lib/core/constants/app_constants.dart`: Add SharedPreferences keys and channel IDs for lifetime goal tones.
- `lib/core/routing/router.dart`: Add routes for `/settings/sound`, `/settings/display`, `/settings/language`, `/settings/backup`, `/settings/permissions`, `/help/tutorial`.
- `lib/models/app_settings.dart` & `lib/providers/settings_provider.dart`: Add `lifetimeSoundUri` and `lifetimeSoundName` properties and setters.
- `lib/repositories/settings_repository.dart`: Persist lifetime achievement sound URI and name in SharedPreferences.
- `lib/services/notification_service.dart`: Add lifetime goal notification channel and `notifyLifetimeGoalReached()` method.
- `lib/services/sound_service.dart`: Ensure support for playing sacred asset paths, device ringtones, alarm stream, and custom audio files.
- `lib/providers/counting_provider.dart`: Track `_lifetimeGoal` and fire lifetime achievement notification, vibration, and custom sound upon goal completion.
- `lib/widgets/counter_card.dart`: Set thin border color: vermillion for active, dark green for `disabledSuccess`, and black for `disabledFailure`.
- `lib/screens/settings/settings_screen.dart`: Redesign into rounded cards linking to individual settings screens.
- `lib/screens/settings/notification_sound_picker.dart`: Generalize sound picker to support picking sacred tones, system ringtones, and storage audio files for daily or lifetime goals.
- `lib/screens/features_screen.dart`: Update feature categories to comprehensively and accurately cover all features.
- `lib/screens/help/help_home_screen.dart`: Add prominent tutorial card and link to the tutorial.
- `lib/l10n/app_en.arb`, `lib/l10n/app_ml.arb`, `lib/l10n/app_sa.arb`: Add new localized strings with `@description` entries in all three languages.
- `test/screens/settings_screen_test.dart`: Update tests for the new card navigation and sub-screens.
- `test/widgets/counter_card_test.dart`: Add tests asserting the thin border colors for active, successfully completed, and failed completed states.

---

## 3. Detailed Fix and Implementation Steps

### Step 1: Status Borders for Counter Cards (Requirement 2)
- In `lib/widgets/counter_card.dart`:
  - Determine border color from `counter.status`:
    - `CounterStatus.active` -> `TempleColors.vermillion` (`#D34E2A`)
    - `CounterStatus.disabledSuccess` -> `const Color(0xFF1B5E20)` (dark green)
    - `CounterStatus.disabledFailure` -> `Colors.black` (black)
  - Border width is thin: `1.0`.

### Step 2: Custom Tones for Daily Goal & Lifetime Achievement (Requirement 3)
- Extend `SettingsRepository`, `AppSettings`, and `SettingsNotifier` with `lifetimeSoundUri` and `lifetimeSoundName`.
- Update `CountingNotifier._checkNotifications()`:
  - Check when `liveLifetimeTotal` crosses `_lifetimeGoal` from below.
  - Trigger `NotificationService.notifyLifetimeGoalReached()`.
  - Trigger haptic vibration.
  - Play configured lifetime custom sound via `SoundService.playTone(settings.lifetimeSoundUri)`.
- Update `NotificationSoundPicker` bottom sheet to support both daily goal and lifetime achievement, presenting:
  - System default tone
  - Sacred tones (Temple Bronze Bell, Tibetan Singing Bowl, Synthesized Tone, Sacred Shankha)
  - Device ringtones from system `RingtoneManager`
  - Audio file picker from device storage

### Step 3: Card-Based Settings Hub (Requirement 1)
- Redesign `SettingsScreen` to present a unified list of rounded cards:
  - **Sound & Haptics** (`/settings/sound`): Mala sounds, daily goal sound, lifetime achievement sound, notifications, vibration.
  - **Display & Stillness** (`/settings/display`): Brightness control, still mode description.
  - **Language** (`/settings/language`): App language selection.
  - **Backup & Restore** (`/settings/backup`): Optical QR sync (transmit/receive), file export & import (plain JSON and AES-256-GCM encrypted), data wipe.
  - **Appearance** (`/settings/appearance`): Themes, typography, accent colors.
  - **Features** (`/settings/features`): Complete feature list.
  - **Permissions** (`/settings/permissions`): Implicit & explicit permissions guide.
  - **Help & Tutorial** (`/help`): User guide & walkthrough.
  - **About** (`/about`): App details, author, offline guarantee.
- Each card has a rounded container, themed leading icon in rounded box, title, subtitle, and right chevron.

### Step 4: Permissions Page in Settings (Requirement 6)
- Create `lib/screens/settings/permissions_screen.dart` with three distinct sections:
  1. **Explicit Permissions** (Runtime user prompt):
     - `CAMERA`: Used exclusively for the air-gapped Optical QR sync receiver.
     - `POST_NOTIFICATIONS`: Used to notify when a daily mantra goal is achieved.
  2. **Implicit Permissions** (System granted at install):
     - `VIBRATE`: Provides tactile feedback on chant taps, malas, and goals.
     - `MODIFY_AUDIO_SETTINGS`: Routes completion tones through the alarm stream so they remain audible during meditation.
  3. **Zero-Trust Privacy Guarantee** (Permissions intentionally omitted):
     - Zero `INTERNET` permission: App cannot access the internet, send telemetry, or connect to servers.
     - No broad storage permissions: Uses standard system file pickers for safe export/import.

### Step 5: Help Section & Tutorial (Requirement 4)
- Create `lib/screens/help/tutorial_help_screen.dart` with interactive walkthrough steps:
  1. Creating a counter and setting goals
  2. Fullscreen counting, stillness dimming, and gestures
  3. Mala beads, chimes, and excess chant accounting
  4. Daily and lifetime goal celebrations
  5. Counter locking and status archiving
  6. Air-gapped Optical QR sync between devices
  7. Encrypted backup and passphrase restoration
- Add a top featured card in `HelpHomeScreen` pointing to the tutorial.
- Review and refine existing help screens for full feature accuracy.

### Step 6: Features Showcase Enhancement (Requirement 5)
- Update `lib/screens/features_screen.dart` to comprehensively document:
  - Sacred counting mechanics and mala mathematics
  - Dual goal progression (daily target + lifetime milestones)
  - Custom chimes and alarm audio stream management
  - Air-gapped fountain code optical synchronization
  - Client-side AES-256-GCM encryption with Argon2/PBKDF2 keys
  - Local SQLite persistence and crash recovery safety
  - Trilingual design and temple aesthetic themes

### Step 7: Localization & Verification
- Add all required localized strings across `app_en.arb`, `app_ml.arb`, and `app_sa.arb` with `@description` metadata.
- Run `flutter gen-l10n`.
- Run `flutter test` and `flutter analyze` to guarantee 0 errors and complete test pass.
