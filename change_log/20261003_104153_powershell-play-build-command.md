# Change log: Document the PowerShell Google Play build command

**Plan:** [plans/20261003_103527_powershell-play-build-command.md](../plans/20261003_103527_powershell-play-build-command.md)

## What changed

- **`CLAUDE.md`, `AGENTS.md`** (Build & run commands):
  - Symbol folder fixed from `android-prod-v<version>/` to `android-prod-<version>/` (no `v`),
    matching the build command and the other docs.
  - The Play Store bundle command is now the Windows PowerShell command, marked as the one to use
    for Google Play uploads. It reads the version from `pubspec.yaml`:

    ```powershell
    $version = ((Select-String -Path pubspec.yaml -Pattern '^version:\s*(.+)$').Matches[0].Groups[1].Value -split '\+')[0]
    flutter build appbundle --flavor prod --release --obfuscate "--split-debug-info=build/symbols/android-prod-$version/"
    ```

  - The split APK command stays in bash with a `<version>` placeholder.
- **`README.md`** §6: same `v` fix; the App Bundle section now shows the PowerShell command.
- **`docs/release_process.md`** §9: added the PowerShell App Bundle command after the bash
  commands, marked as the command used for Play uploads.

## Checks
- `dart format --output=none --set-exit-if-changed .`: 0 files changed.
- `flutter analyze`: no issues.
- `flutter test`: all 228 tests passed.
- The version part of the command was tested on `pubspec.yaml` and gives the folder
  `build/symbols/android-prod-6.13.6/`.
