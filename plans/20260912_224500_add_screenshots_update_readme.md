# Plan: Run App on Emulator, Capture Screenshots, and Update README.md

**Status:** Completed

## Issue
The repository `README.md` does not have visual screenshots of the mobile application. In addition, `README.md` needs to be updated to match the current state of the application:
1. Version references in build instructions still point to older versions (e.g., `v6.10.4` instead of `v6.11.0`).
2. Localization section only mentions English (`en`) and Malayalam (`ml`), but Sanskrit (`sa`) has now been added.
3. Recent features such as Counter Lock, Optical Air-Gap QR Sync, and Language Picker are not highlighted in `README.md`.

## Proposed Fix
1. Launch the application on `emulator-5554` with `flutter run --flavor dev -d emulator-5554`.
2. Seed sample data or interact with the app to showcase real usage (active counters, mala count, history sitting).
3. Capture high-resolution screenshots via `adb -s emulator-5554 exec-out screencap -p`:
   - `docs/screenshots/01_home_screen.png`: Home screen with counters, daily progress strip, and today's summary pill.
   - `docs/screenshots/02_counting_screen.png`: Active counting session with 108-bead sacred mala ring and timer.
   - `docs/screenshots/03_history_screen.png`: Practice history logs and session analytics.
   - `docs/screenshots/04_settings_screen.png`: Settings screen showing audio, haptic, stillness brightness, and language options.
   - `docs/screenshots/05_optical_sync.png`: Optical Air-Gap sync screen (animated QR code stream).
4. Save screenshots in `docs/screenshots/`.
5. Update `README.md`:
   - Add a visual Screenshots section with side-by-side or captioned previews.
   - Update version numbers to `v6.11.0`.
   - Update localization documentation to include Sanskrit (`sa`).
   - Update feature summary to reflect current capabilities (gesture controls, counter lock, air-gap optical sync, multilingual support).
6. Verify formatting with `dart format .` and check analysis with `flutter analyze`.

## Files to Change
- `docs/screenshots/*.png` [NEW]
- `README.md` [MODIFY]
