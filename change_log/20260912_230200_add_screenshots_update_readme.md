# Change Log: Captured Screenshots and Updated README.md

**Plan reference:** `plans/20260912_224500_add_screenshots_update_readme.md`

## Summary of Changes
1. Installed and ran the application on `emulator-5554`.
2. Seeded authentic practice data (counters with daily offerings, lifetime vows, and multi-day session records).
3. Captured high-quality screenshots and saved them to `docs/screenshots/`:
   - `docs/screenshots/01_home_screen.png`: Home screen with counters, 27-segment progress strips, and summary pill.
   - `docs/screenshots/02_counting_screen.png`: Active counting sitting with 108-bead mala circle and session countdown.
   - `docs/screenshots/03_history_screen.png`: Practice history log with date grouping, session details, and Diya progress bar.
   - `docs/screenshots/04_settings_screen.png`: Settings screen with sound, haptic, and feature options.
   - `docs/screenshots/05_language_selection.png`: Multilingual picker showing English, Malayalam, and Sanskrit.
   - `docs/screenshots/06_stillness_and_backup.png`: Stillness mode display brightness slider and air-gap backup options.
4. Updated `README.md`:
   - Added an App Screenshots visual gallery showcasing the 6 screens.
   - Added a Key Features section summarizing gestures, lock, audio/haptics, air-gap sync, and offline operation.
   - Updated version references from `v6.10.4` to `v6.11.0`.
   - Updated localization section to document Sanskrit (`sa`) alongside English and Malayalam.
   - Updated the project layout tree under `lib/` to reflect `core/` and `theme/` directories.

## Verification
- Captured images verified with image viewer.
- Ran `flutter analyze` with 0 issues reported.
