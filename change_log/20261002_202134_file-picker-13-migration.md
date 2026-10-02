# Change log: Migrate to file_picker 13 and remove the AGP 9 file_picker workaround

Implements plan: `plans/20261002_201303_file-picker-13-migration.md`.

## Why

The user upgraded `go_router` (18), `flutter_local_notifications` (22), `file_picker` (13),
`share_plus` (13), `package_info_plus` (10) and `cupertino_icons` (2). Only `file_picker` broke
the app. Version 12.0.0 removed `FilePickerResult`, so `pickFiles()` now returns a plain list,
and single-file picking uses the new `pickFile()`.

## What changed

| File | Change |
|------|--------|
| `lib/screens/counter_list/import_export_dialog.dart` | `FilePicker.pickFiles(...)` → `FilePicker.pickFile(...)`; reads `picked?.path` |
| `lib/screens/settings/backup_settings_screen.dart` | Same |
| `lib/screens/settings/notification_sound_picker.dart` | Same (still passes the file name to `onSelect`) |
| `android/build.gradle.kts` | Removed the temporary `file_picker` Kotlin block from `change_log/20261002_200807_upgrade-agp9-gradle9-kotlin24.md`. The Android code now lives in `android_file_picker` 2.0.0, which reads `android.builtInKotlin` and applies Kotlin itself. |
| `CLAUDE.md` | Toolchain row no longer points to the removed workaround. |

`pubspec.yaml` and `pubspec.lock` contain the user's package upgrades and were not changed here.

Behaviour is the same as before: one file, the same file filters, and cancel does nothing.

## Verification

- `flutter analyze` — No issues found.
- `flutter test` — all 212 tests passed.
- `flutter build apk --flavor dev --debug` — built.
- `flutter build apk --flavor prod --release --obfuscate --split-debug-info=... --split-per-abi` — built (3 ABIs); `apksigner verify` OK.
- `flutter build appbundle --flavor prod --release --obfuscate --split-debug-info=...` — built.
- Merged prod manifest: same permissions as before (VIBRATE, CAMERA,
  ACCESS_NOTIFICATION_POLICY, POST_NOTIFICATIONS, and the app's own dynamic-receiver
  permission). No `INTERNET`. `android:allowBackup="false"`.
- Flutter's "plugins that apply Kotlin Gradle Plugin" warning **no longer appears**.

## Still to test on a real phone

- Import a `.json` and a `.enc` backup from both import screens (counter list dialog and
  Backup settings). If the picker returns no file path, import would silently do nothing.
- Pick a custom notification sound and check that it plays later.
- Share an export (`share_plus` 13) and check that notifications still appear
  (`flutter_local_notifications` 22).

## Follow-ups

- Because the KGP warning is gone, try switching to built-in Kotlin in a separate change:
  set `android.builtInKotlin=true` (and review `android.newDsl=false`) in
  `android/gradle.properties`, then rebuild and retest.
- Update the shared `Flutter_Guidelines` repo's "stay on AGP 8.x" rule (from the previous
  change log).
