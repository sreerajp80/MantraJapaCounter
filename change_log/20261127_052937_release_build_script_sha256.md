# Release build script with SHA-256 checksums

Implements plan: `plans/20261127_052320_release_build_script_sha256.md`

## What changed

### New: `tool/build_release.ps1`

A PowerShell script (Windows PowerShell 5.1 and PowerShell 7) for Android release builds:

- Options: `-Name` (required), `-Target apk|aab` (required), `-Flavor dev|prod` (default `prod`),
  `-Mode release|profile|debug` (default `release`), `-NoSplit`, `-NoObfuscate`, `-SymbolsDir`.
- Reads `version: x.y.z+n` from `pubspec.yaml`; stops if `+n` is missing.
- Refuses, before Flutter runs: `-NoObfuscate` for a `prod` release; `-SymbolsDir` when not
  obfuscated; `-SymbolsDir` outside `build/`; a missing or bad `-Name`. Debug mode drops
  obfuscation automatically; `-NoSplit` with `aab` is ignored with a message.
- Deletes old Flutter-named outputs (and `.sha1`) first, runs `flutter build`, stops on failure.
- Renames outputs to `<Name>-[<abi>-]v<version>_<build>-<flavor>-<mode>.<apk|aab>` (short ABIs
  `armeabi`, `arm64`, `x86_64`), deletes Flutter's `.sha1`, writes `<file>.sha256` in
  `sha256sum` format (UTF-8 without BOM), prints sizes, hashes and the symbols folder.
- Default symbols folders: AAB `build/symbols/android-<flavor>-<version>/`, APK
  `build/symbols/android-<flavor>-<version>-apk/` (separate compiles need separate symbols).
- Always runs `android\gradlew.bat --stop` at the end (`finally`).
- Output names were checked against Flutter 3.50.1 (`CopyFlutterApksTask.kt` `apkFileName`,
  `gradle.dart` `listApkPaths` / `findBundleFile`).
- SHA-256 is computed with .NET (`System.Security.Cryptography.SHA256`), not `Get-FileHash`:
  in testing, `Get-FileHash` failed to load in Windows PowerShell 5.1 when started from
  PowerShell 7 (mixed module path).

### Docs

- `docs/release_process.md`: new section 9.1 (usage, options table, rules, examples, file
  names, how to check a hash); section 6.1 explains the two symbols folders and archives both;
  release steps 9 and 12 use the script and archive both folders; new Artifact Validation item
  "every APK / AAB has a `.sha256` and no `.sha1`"; raw `flutter build` commands kept as "what
  the script runs with defaults", with the APK symbols folder now `-apk`; release evidence
  updated.
- `CLAUDE.md`, `AGENTS.md`, `README.md`: point to the script; APK symbols folder now
  `android-prod-<version>-apk/`.
- `docs/security.md` §8.1 and `docs/architecture.md`: same symbols-folder change.
- `docs/guidelines/` (submodule) not touched.

## Testing

Done in a scratchpad folder, not in this repo, with a stand-in `flutter.cmd` (logs its
arguments and creates files with Flutter's exact names, plus `.sha1` for APKs) and a stand-in
`android/gradlew.bat`, using `version: 2.8.0+38`. The script was run under both Windows
PowerShell 5.1 and PowerShell 7: 16 cases, 70 checks, 0 failures.

Cases: default apk, default aab, dev debug apk, `-NoSplit` apk, `-NoSplit` aab (ignored), dev
release `-NoObfuscate`, custom `-SymbolsDir`, refused cases (`-NoObfuscate` on prod release,
`-SymbolsDir` without obfuscation, `-SymbolsDir` in debug, `-SymbolsDir` outside `build/`) exit 1
without calling Flutter, missing `-Name`, bad `-Name`, rebuild of the same version (file
replaced, with a message), failing `flutter build` (stale output deleted, nothing renamed,
`gradlew --stop` still runs), version without `+n`. Each `.sha256` matched `Get-FileHash`, had
no BOM, no `.sha1` was left, and nothing was written outside `build/`. The script parses with 0
errors in both PowerShell versions.

No Dart code changed, so `flutter analyze` / `flutter test` results are unchanged. A real build
has not been run yet.

## Security impact

Build tooling only. No app code, permission, network or dependency change. The script never
reads `android/key.properties` or the keystore; Gradle still signs.
