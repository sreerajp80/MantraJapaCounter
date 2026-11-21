# Change log: split APKs use the same versionCode as the App Bundle

Implements plan: `plans/20261121_125617_split-apk-version-code.md`

## What changed

- `android/gradle.properties` — added `force-version-code-ignoring-abi=true` with a short
  comment. Flutter's Gradle plugin then gives every `--split-per-abi` APK the plain
  `pubspec.yaml` build number as versionCode, the same as the App Bundle. Before, it added
  1000 (armeabi-v7a), 2000 (arm64-v8a) or 4000 (x86_64).
- `docs/release_process.md`:
  - Section 9 build commands: a note under the split APK command that all split APKs share
    the bundle's versionCode, and how to check it with `aapt2 dump badging <apk>`.
  - Section 12 Distribution Channels: a paragraph on why direct APKs and Play must share
    one versionCode, and why the Play app signing key must match the release keystore.
  - Release checklist (Security): new item "Split APK versionCode equals the
    `pubspec.yaml` build number — no 1000/2000/4000 added".
- `README.md` — one line under "Split APKs" saying the APKs keep the plain build number.

## Why

With the offset, a phone with a sideloaded split APK (for example 2050) sees every Play
build below that code as older. Play never updates it, and the only way out is to
uninstall, which deletes the app's private data.

## Not done here

- No build was run. The user builds and the results are checked afterwards.
- `docs/guidelines/` (read-only submodule) was not changed. Suggestion for the shared
  build guide is in the plan.

## Security impact

Build configuration only. No permission, network, storage or signing change.
