# Change Log: Update README.md and Capture Clean Screenshots from Emulator

**Plan Reference:** [plans/20260919_111300_update_readme_and_screenshots.md](plans/20260919_111300_update_readme_and_screenshots.md)  
**Date:** 2026-09-19  

## What Changed

1. **Updated Screenshots with Zero Debug Banners:**
   - Captured 6 high-resolution, clean screenshots directly from Android emulator `emulator-5554` running the production release build (`app-x86_64-prod-release.apk`):
     - `docs/screenshots/01_home_screen.png`: Home screen with active counter cards, 27-segment prayer-bead progress strips, completed malas, and today's summary pill.
     - `docs/screenshots/02_counting_screen.png`: Sacred 108-bead mala counting screen showing active bead countdown, duration timer, and statistics cards.
     - `docs/screenshots/03_history_screen.png`: Devotional practice history screen displaying the interactive diya lamp track, vow completion percentage, and expandable session log.
     - `docs/screenshots/04_settings_screen.png`: Practice Settings screen showing organized cards for Appearance, Sound & Haptics, Display & Stillness, Language, and Data Backup & Optical Sync.
     - `docs/screenshots/05_language_selection.png`: Multilingual selection screen supporting English, Malayalam (മലയാളം), and Sanskrit (संस्कृतम्).
     - `docs/screenshots/06_stillness_and_backup.png`: Data Backup & Optical Sync screen featuring Optical Air-Gap Sync (Send / Receive) and local JSON backup tools.
   - Removed all older screenshots containing red `DEBUG` banners.

2. **Updated `README.md`:**
   - Updated the Key Features section to highlight the authentic Temple Bronze Bell and Sacred Shankha tones.
   - Updated the production build commands in Section 6 to reference current version `v6.12.1` (matching `pubspec.yaml` `6.12.1+29`).
   - Verified that the screenshot gallery table displays all 6 screenshots cleanly.

3. **Code Formatting & Verification:**
   - Ran `flutter analyze` (0 issues found).
   - Ran `dart format .` across the project.
