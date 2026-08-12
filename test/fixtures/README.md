# Test Fixtures

Place real Android-exported JSON files here for import compatibility tests.

## How to get a fixture file

1. Open the Android app on a device or emulator.
2. Go to the counter list → menu → Import / Export → Export.
3. Save the exported `mantra_japa_counter_backup.json` to this folder.
4. Rename it descriptively, e.g. `android_v4_export.json`.

## Required before first release

At least one real Android export must be present and tested via
`test/repositories/import_compatibility_test.dart` before the first
Flutter release is submitted to Google Play.
