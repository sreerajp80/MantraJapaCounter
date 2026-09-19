# Plan: Update README.md and Capture Clean Screenshots from Emulator

**Status:** Completed

## Issue
The repository `README.md` acts as the homepage of the GitHub repository. Currently:
1. The screenshots in `docs/screenshots/` (`01_home_screen.png` through `06_stillness_and_backup.png`) contain red `DEBUG` banners in the top-right corner from an older debug build, which looks unpolished on the public repository homepage.
2. `README.md` references older version `v6.11.0` in production build command examples, while `pubspec.yaml` is at `6.12.1+29`.
3. Recent features such as Sacred Soundscapes (Temple Bronze Bell and Sacred Shankha tones) and updated settings hierarchy need proper visual representation and accurate descriptions in `README.md`.

## Proposed Fix
1. Install and launch the production release build (`build/app/outputs/flutter-apk/app-x86_64-prod-release.apk`) on `emulator-5554` so that all screens render cleanly with zero `DEBUG` banners.
2. Ensure realistic, beautiful spiritual practice data is present (e.g., Mahamrityunjaya Mantra, Gayatri Mantra, Om Namah Shivaya with daily progress and completed malas).
3. Capture 6 high-resolution screenshots directly from `emulator-5554` using `adb -s emulator-5554 exec-out screencap -p`:
   - `docs/screenshots/01_home_screen.png`: Home screen with temple header, today's summary pill, and counter cards with 27-segment prayer-bead daily progress strips.
   - `docs/screenshots/02_counting_screen.png`: Active counting session featuring the 108-bead sacred mala circle, bead countdown, and active duration timer.
   - `docs/screenshots/03_history_screen.png`: Practice history & logs showing vow progress, diya lamp track, and date-grouped session offerings.
   - `docs/screenshots/04_settings_screen.png`: Practice settings screen showing Appearance, Features, Sound & Haptics, and Help & User Guides.
   - `docs/screenshots/05_language_selection.png`: Multilingual bottom sheet displaying English, Malayalam (മലയാളം), and Sanskrit (संस्कृतम्).
   - `docs/screenshots/06_sound_haptics.png` (or `06_stillness_and_backup.png`): Sacred soundscapes screen (Temple Bronze Bell, Sacred Shankha) or Stillness Mode & Optical Air-Gap Sync.
4. Update `README.md`:
   - Update screenshot gallery with the new clean images and descriptive labels.
   - Update version references from `v6.11.0` to `v6.12.1` in the build commands section.
   - Ensure feature list and documentation links are accurate and up-to-date.
5. Verify formatting with `dart format .` and ensure static analysis remains clean with `flutter analyze`.

## Files to Change
- `docs/screenshots/01_home_screen.png` [MODIFY]
- `docs/screenshots/02_counting_screen.png` [MODIFY]
- `docs/screenshots/03_history_screen.png` [MODIFY]
- `docs/screenshots/04_settings_screen.png` [MODIFY]
- `docs/screenshots/05_language_selection.png` [MODIFY]
- `docs/screenshots/06_sound_haptics.png` or `docs/screenshots/06_stillness_and_backup.png` [MODIFY]
- `README.md` [MODIFY]
