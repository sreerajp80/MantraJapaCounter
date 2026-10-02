# Plan: Migrate to file_picker 13 and remove the AGP 9 file_picker workaround

**Status:** completed

## The issue

The user upgraded these packages to new major versions in `pubspec.yaml`:

| Package | Old | New | Effect on this app |
|---------|-----|-----|--------------------|
| `go_router` | ^17.2.2 | ^18.0.2 | Needs Flutter 3.44+. No API break found. Analyze is clean. |
| `flutter_local_notifications` | ^21.0.0 | ^22.3.1 | No Android API break found. Analyze is clean. |
| `file_picker` | ^11.0.2 | ^13.1.0 | **Breaks the build** (see below). |
| `share_plus` | ^12.0.2 | ^13.3.1 | Break is Windows-only (win32). Analyze is clean. |
| `package_info_plus` | ^9.0.1 | ^10.2.2 | Break is Windows-only (win32). Analyze is clean. |
| `cupertino_icons` | ^1.0.8 | ^2.0.0 | Needs Flutter 3.44+. Analyze is clean. |

`flutter analyze` now reports 4 errors and 3 warnings, all from `file_picker`. Three test
files fail to load for the same reason (`counter_list_screen_test.dart`,
`settings_screen_test.dart`, `sound_settings_screen_test.dart`).

**Why.** `file_picker` 12.0.0 removed `FilePickerResult`. `FilePicker.pickFiles()` now returns
`Future<List<PlatformFile>>` (an empty list when cancelled, no `.files`), and multi-select is on
by default. For one file, the new API is `FilePicker.pickFile()`, which returns
`Future<PlatformFile?>` (`null` when cancelled). `PlatformFile.path` and `PlatformFile.name`
still exist.

**Good news.** `file_picker` 12+ moved its Android code into a separate package,
`android_file_picker` (2.0.0). Its build file now reads `android.builtInKotlin` and applies the
Kotlin plugin itself when built-in Kotlin is off. So the temporary `file_picker` workaround
added to `android/build.gradle.kts` in
`plans/20261002_195120_upgrade-agp9-gradle9-kotlin24.md` is no longer needed. It is also now
dead code, because no Gradle module is named `file_picker` any more.

## Files to change

| File | Change |
|------|--------|
| `lib/screens/counter_list/import_export_dialog.dart` | `pickFiles(...)` → `pickFile(...)`; use the returned `PlatformFile?` directly |
| `lib/screens/settings/backup_settings_screen.dart` | Same |
| `lib/screens/settings/notification_sound_picker.dart` | Same |
| `android/build.gradle.kts` | Remove the temporary `file_picker` Kotlin block |
| `CLAUDE.md` | Toolchain row: drop the "see `file_picker` note" text |

`pubspec.yaml` and `pubspec.lock` were changed by the user and are kept as they are.

## The fix

1. **`import_export_dialog.dart`** (around line 96):
   ```dart
   final picked = await FilePicker.pickFile(
     type: FileType.custom,
     allowedExtensions: ['json', 'enc'],
   );
   final pickedPath = picked?.path;
   if (pickedPath == null) return;
   ...
   final content = await File(pickedPath).readAsString();
   ```
2. **`backup_settings_screen.dart`** (around line 193): the same change. `pickedPath` becomes
   `picked?.path`.
3. **`notification_sound_picker.dart`** (around line 220):
   ```dart
   final picked = await FilePicker.pickFile(type: FileType.audio);
   final pickedPath = picked?.path;
   if (pickedPath != null) {
     await onSelect(pickedPath, picked!.name);
   }
   ```
   The behaviour stays the same: one file, the same filters, and cancel does nothing.
4. **Tests.** Check whether any test mocks `FilePicker` / `FilePickerResult`. If so, update the
   mocks to the new API. (A search found no direct use in `test/`. The 3 failing tests fail only
   because the screens they import do not compile.)
5. **Remove the workaround** in `android/build.gradle.kts` (the `subprojects { if (name ==
   "file_picker" ...) }` block and its comment).
6. **Verify**
   - `flutter pub get`, `flutter analyze` (0 issues), `flutter test` (all pass)
   - `flutter build apk --flavor dev --debug`
   - `flutter build apk --flavor prod --release --obfuscate --split-debug-info=build/symbols/android-prod-v6.10.0/ --split-per-abi`
   - `flutter build appbundle --flavor prod --release --obfuscate --split-debug-info=build/symbols/android-prod-v6.10.0/`
   - Check that the merged prod manifest still has no `INTERNET` permission, has
     `allowBackup="false"`, and that no new permissions were added by the upgraded plugins.
   - Note which plugins Flutter still lists in its "apply KGP" warning.
7. **Change log** in `change_log/`.

## Needs a test on a real phone (cannot be checked by build or unit tests)

- Import a `.json` and a `.enc` backup from both import screens. `file_picker` 12+ was a
  rewrite. A picked file must still come back with a real file `path`, not only a
  `content://` link. If `path` is `null`, the import would silently do nothing.
- Pick a custom notification sound, then check that it still plays later.
- Share an export (`share_plus` 13) and check that notifications still appear
  (`flutter_local_notifications` 22).

## Rollback

Revert the changed files with git, or set the package versions back in `pubspec.yaml` and run
`flutter pub get`.
