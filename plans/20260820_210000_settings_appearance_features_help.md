# Implementation Plan — Settings Appearance, Features, and Help Cards

**Status:** Completed

## Overview

Based on the structure in `SreerajPContactSphere`, we will enhance the Settings section in `SreerajP MantraJapa Counter` by adding three dedicated cards:
1. **Appearance Card**: Navigates to an Appearance settings screen detailing stillness brightness control, temple color palette, and typography.
2. **Features Card**: Navigates to a comprehensive Features showcase screen grouped by categories with visual highlights and badges.
3. **Help Card**: Navigates to a rich Help & User Guides screen with structured topic cards explaining counting, mala calculations, optical air-gap sync, audio/vibration, backup/restore, privacy, and FAQs.

---

## User Review Required

- **New Screens & Navigation:**
  - `/settings/appearance` -> `AppearanceScreen`
  - `/settings/features` -> `FeaturesScreen`
  - `/help` -> `HelpHomeScreen` (with sub-topic detail views for in-depth guidance)
- **Design System:**
  - All new screens will adhere to the devotional **Temple Theme** (`TempleColors.bg`, `TempleColors.card`, `TempleColors.vermillion`, `AppTheme.serif`, `AppTheme.sans`).
- **Localization:**
  - Full support for English (`app_en.arb`) and Malayalam (`app_ml.arb`) with complete `@key` metadata entries.

---

## Files to Create & Modify

### Localization
- `lib/l10n/app_en.arb` [MODIFY]
- `lib/l10n/app_ml.arb` [MODIFY]

### Presentation & Screens
- `lib/screens/settings_screen.dart` [MODIFY]
- `lib/screens/appearance_screen.dart` [NEW]
- `lib/screens/features_screen.dart` [NEW]
- `lib/screens/help_screen.dart` [MODIFY / REPLACE with Help Hub & Topic Screens]
- `lib/screens/help/counting_help_screen.dart` [NEW]
- `lib/screens/help/optical_sync_help_screen.dart` [NEW]
- `lib/screens/help/backup_help_screen.dart` [NEW]
- `lib/screens/help/sound_haptics_help_screen.dart` [NEW]
- `lib/screens/help/privacy_offline_help_screen.dart` [NEW]
- `lib/screens/help/faq_help_screen.dart` [NEW]
- `lib/config/router.dart` [MODIFY]

### Documentation & Tests
- `plans/20260820_093000_settings_appearance_features_help.md` [NEW]
- `test/screens/appearance_screen_test.dart` [NEW]
- `test/screens/features_screen_test.dart` [NEW]
- `test/screens/help_screen_test.dart` [NEW]

---

## Verification Plan

### Automated Tests
- Run `flutter gen-l10n` to compile localizations.
- Run `flutter analyze` to ensure 0 errors/warnings.
- Run `flutter test` to verify all unit and widget tests pass.

### Manual Verification
- Verify navigation from Settings to Appearance, Features, and Help screens.
- Check that all cards, icons, colors, and typography render in Temple theme.
