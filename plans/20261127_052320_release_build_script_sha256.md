# Release build script with SHA-256 checksums

**Status:** completed

## What the issue is

- Release builds are run by hand with long `flutter build` commands. The output files keep
  Flutter's generic names (`app-arm64-v8a-prod-release.apk`, `app-prod-release.aab`), so they do
  not show the app or the version.
- `flutter build apk` writes a `.sha1` file next to each APK. SHA-1 is weak and Flutter has no
  SHA-256 option. `flutter build appbundle` writes no checksum at all.
- The docs tell APK and AAB builds of the same version to use the SAME symbols folder
  (`build/symbols/android-prod-<version>/`). They are separate compiles, so the second build
  overwrites the first build's symbols, and crash stack traces from the first one can no longer
  be decoded.

## Facts checked in this project

- Flavors (`android/app/build.gradle.kts`): `dev` and `prod`. Production flavor: `prod`.
- Version in `pubspec.yaml`: `6.13.21+52` (has a `+build` part).
- Flutter SDK 3.50.1. Output names checked in the SDK:
  - APK (`gradle/src/main/kotlin/tasks/CopyFlutterApksTask.kt`, `apkFileName`, and
    `listApkPaths` in `lib/src/android/gradle.dart`):
    `build/app/outputs/flutter-apk/app[-<abi>][-<flavor>]-<mode>.apk`, flavor lower case.
    Split ABIs: `armeabi-v7a`, `arm64-v8a`, `x86_64`. (The other helper `_apkFilesFor`, with
    flavor before ABI, is only used for add-to-app module projects, not this app.)
  - `.sha1` is written by the Flutter tool after Gradle ends (`gradle.dart`, "Generate sha1 for
    every generated APKs"). So it must be removed by a script after `flutter build`.
  - AAB (`findBundleFile`): `build/app/outputs/bundle/<flavor><Mode>/app-<flavor>-<mode>.aab`,
    e.g. `bundle/prodRelease/app-prod-release.aab`.
- `docs/guidelines/` is a git submodule — it will not be touched.
- `/build/` is git-ignored, so all script output stays out of git.

## Files to change

| File | Change |
|------|--------|
| `tool/build_release.ps1` | **New.** The build script. |
| `docs/release_process.md` | New "Release build script" part (usage, options table, rules, examples, file names, how to check a hash); APK symbols folder `-apk`; archive both symbols folders; checklist item "every APK/AAB has a `.sha256` and no `.sha1`". Raw `flutter build` commands kept as "what the script runs with defaults". |
| `CLAUDE.md`, `AGENTS.md`, `README.md` | Point to the script; fix the APK symbols folder to `android-prod-<version>-apk/`. |
| `docs/security.md`, `docs/architecture.md` | Same symbols-folder fix (one line each). |

(The last two rows keep all docs saying the same thing. If you want only `release_process.md`
changed, say so and I will drop them.)

## The fix — `tool/build_release.ps1`

Options:

| Option | Values | Default |
|---|---|---|
| `-Name` | `^[A-Za-z0-9._-]+$` | required, no default |
| `-Target` | `apk`, `aab` | required |
| `-Flavor` | `dev`, `prod` | `prod` |
| `-Mode` | `release`, `profile`, `debug` | `release` |
| `-NoSplit` | switch: one universal APK | off |
| `-NoObfuscate` | switch: no `--obfuscate` / `--split-debug-info` | off |
| `-SymbolsDir` | path | aab: `build/symbols/android-<flavor>-<version>/`, apk: `build/symbols/android-<flavor>-<version>-apk/` |

Steps:
1. Find the repo root (parent of `tool/`) and work from there. Read `version: x.y.z+n` from
   `pubspec.yaml`; stop with a clear message if `+n` is missing.
2. Check options before running Flutter:
   - refuse `-NoObfuscate` for `prod` + `release` (exit 1);
   - refuse `-SymbolsDir` when the build is not obfuscated (exit 1);
   - `debug` mode: drop obfuscation automatically, with a message;
   - `-NoSplit` with `aab`: message "ignored".
   - `-SymbolsDir` must resolve to a folder inside `build/` (the script writes only inside `build/`).
3. Delete old Flutter-named output (and APK `.sha1`) for this flavor/mode first.
4. Run `flutter build apk|appbundle` with the flags. Non-zero exit → stop, rename and hash nothing.
5. Rename each output to `<Name>-[<abi>-]v<version>_<build>-<flavor>-<mode>.<apk|aab>` in the same
   output folder (short ABIs `armeabi`, `arm64`, `x86_64`). Replace an existing file with a message.
   Example: `Japam-arm64-v6.13.21_52-prod-release.apk`.
6. Delete Flutter's `.sha1` for each APK.
7. Write `<file>.sha256` = `<lower-case hash>  <file name>\n`, UTF-8 without BOM
   (`[IO.File]::WriteAllText` + `UTF8Encoding($false)`).
8. Print each file with size and SHA-256, and the symbols folder to archive.
9. `finally`: run `android\gradlew.bat --stop`.

Works in Windows PowerShell 5.1 and PowerShell 7. Never reads `key.properties` or the keystore.

## Testing (no real build)

In a scratchpad folder (not this repo): copy the script to `repo/tool/`, add `repo/pubspec.yaml`
with `version: 2.8.0+38`, a stand-in `flutter.cmd` first on PATH that logs its arguments and
creates files with Flutter's exact names (plus `.sha1` for APKs), and a stand-in
`android/gradlew.bat`. Cases: default apk, default aab, `dev` debug apk, `-NoSplit`,
`-NoObfuscate` on `dev` release, custom `-SymbolsDir`, the two refused cases (exit 1, flutter not
called), missing `-Name`, rebuild of the same version. Check hashes against `Get-FileHash`, no BOM,
no `.sha1` left. Parse-check in both PowerShell 5.1 and 7.

## Security impact

Build tooling only. No app code, permissions, network or dependency change. The script does not
touch signing files; Gradle still signs from `android/key.properties`. Checksums let users verify
downloaded APKs.
