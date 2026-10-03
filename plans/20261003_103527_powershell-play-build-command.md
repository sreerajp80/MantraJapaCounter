# Document the PowerShell Google Play build command

**Status:** completed

## Issue

1. The developer builds on Windows with PowerShell. The chosen command for the Google Play
   bundle reads the version from `pubspec.yaml` by itself:

   ```powershell
   $version = ((Select-String -Path pubspec.yaml -Pattern '^version:\s*(.+)$').Matches[0].Groups[1].Value -split '\+')[0]
   flutter build appbundle --flavor prod --release --obfuscate "--split-debug-info=build/symbols/android-prod-$version/"
   ```

   The docs only show bash commands or a manual `<version>` placeholder.
2. The previous change (plan `20261003_095948_play-closed-testing-readiness-docs.md`) set the
   symbol folder in `CLAUDE.md`, `AGENTS.md` and `README.md` to `android-prod-v<version>/` (with a
   `v`). The command above, `docs/release_process.md`, `docs/security.md` and the build flavors
   guide all use `android-prod-<version>/` (no `v`). The `v` is wrong and must be removed.

## Files to change

| File | Change |
|------|--------|
| `CLAUDE.md` | Build commands: drop the `v`; add the PowerShell Play bundle command as the main release command |
| `AGENTS.md` | Same as `CLAUDE.md` |
| `README.md` | §6 Build commands: drop the `v`; add the PowerShell Play bundle command |
| `docs/release_process.md` | §9 Android Build Commands: add the PowerShell Play bundle command next to the bash one, marked as the one used for Play uploads |

Not changed: `docs/guidelines/` (shared guidelines, already correct), old plans and change logs.

## Plan for the fix

- In each file, change `android-prod-v<version>/` to `android-prod-<version>/`.
- Add a "Google Play bundle (Windows PowerShell — used for Play uploads)" block with the exact
  two-line command above, in a `powershell` code block, with one line of explanation: it reads the
  version from `pubspec.yaml`, so each release gets its own symbols folder
  (e.g. `build/symbols/android-prod-6.13.6/`).
- Keep the existing bash commands for the split APK and for non-Windows use.
- Run `dart format` check, `flutter analyze`, `flutter test`; write the change log.
