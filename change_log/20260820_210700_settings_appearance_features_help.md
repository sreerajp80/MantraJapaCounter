# Change Log — Settings Appearance, Features, and Help Cards

**Plan Reference:** [plans/20260820_210000_settings_appearance_features_help.md](../plans/20260820_210000_settings_appearance_features_help.md)
**Date:** 2026-08-20

## Summary

Created new **Appearance**, **Features**, and **Help** cards under Settings in `SreerajP MantraJapa Counter`, inspired by the organization and user interface design in `SreerajPContactSphere` while faithfully maintaining the devotional Temple Theme.

## Changes Made

1. **Settings Hub**:
   - Added top-level navigation cards for `Appearance`, `Features`, `Help & User Guides`, and `About` in `lib/screens/settings_screen.dart`.
   - Maintained all existing daily goal, mala, optical sync, brightness, and data management sections.

2. **Appearance Screen (`lib/screens/appearance_screen.dart`)**:
   - Screen brightness and stillness slider with system default reset.
   - Sacred temple color palette explanation (Vermillion, Tulsi Green, Sandalwood, Rose, Temple Sanctum Cream).
   - Typography samples and script previews (EB Garamond serif, Inter sans, Noto Sans Malayalam).

3. **Features Showcase Screen (`lib/screens/features_screen.dart`)**:
   - Devotional gradient header card.
   - Categorized feature cards with badges and highlights for:
     - Sacred Japa & Mala Counting
     - Optical Air-Gap Sync & Data Safety
     - Practice Insights & History
     - Temple Aesthetics, Audio & Haptics
     - Privacy & Offline-First Core

4. **Help Hub & Topic Screens (`lib/screens/help/`)**:
   - `HelpHomeScreen`: Central help hub organized into practice, sync, audio, and privacy categories.
   - `CountingHelpScreen`: Gesture guides, large tap circle, two-finger swipe undo, session timer.
   - `MalaMathHelpScreen`: 108 mala cycle calculations, excess bead counts, daily/lifetime targets.
   - `OpticalSyncHelpScreen`: Step-by-step camera QR streaming guide and loss-tolerant fountain code explanation.
   - `SoundHapticsHelpScreen`: Bell chimes, custom audio picker, and haptic feedback settings.
   - `BackupHelpScreen`: JSON file export, sharing, and safe database restore.
   - `PrivacyOfflineHelpScreen`: Offline architecture, zero INTERNET permission, local SQLite v3 persistence.
   - `FaqHelpScreen`: Frequently asked questions and troubleshooting answers.

5. **Routing & Localization**:
   - Added routes in `lib/config/router.dart`.
   - Added all UI strings with full descriptions in `lib/l10n/app_en.arb` and Malayalam translations in `lib/l10n/app_ml.arb`.

6. **Tests & Quality**:
   - Added widget tests in `test/screens/appearance_screen_test.dart`, `test/screens/features_screen_test.dart`, and `test/screens/help_screen_test.dart`.
   - Verified `flutter analyze` passes with 0 issues and all 55 tests pass cleanly.
