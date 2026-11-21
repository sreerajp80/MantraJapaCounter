# Plan: split APKs use the same versionCode as the App Bundle

**Status:** completed

## The issue

`flutter build apk --split-per-abi` adds an offset to the build number from `pubspec.yaml`:
1000 for armeabi-v7a, 2000 for arm64-v8a, 4000 for x86_64. The App Bundle for Google Play
gets no offset.

Example from the last local build (6.13.19+50): the split APKs had versionCode 1050, 2050
and 4050, while the AAB had 50.

A phone with a direct split APK (for example 2050) sees every Play build below 2050 as
older, so Play never updates it. The only way out is to uninstall, and that deletes the
app's private data (counters, sessions). This breaks the "zero data loss" rule for those
users.

## What was checked

- **Flutter SDK:** local Flutter is 3.50.1 (CI pins 3.47.6). The switch exists in the local
  SDK: `FlutterPluginUtils.kt` reads the Gradle property `force-version-code-ignoring-abi`
  with `project.findProperty(...)`, so a line in `android/gradle.properties` works. When it
  is `true`, no ABI offset is added and each split APK gets the normal versionCode.
  (CI does not build APKs, so the CI version does not matter for this change.)
- **build.gradle.kts:** `versionCode = flutter.versionCode`, `versionName =
  flutter.versionName` (as expected). No custom per-ABI code.
- **Split APKs shipped?** The docs list a "Direct APK" channel (arm64-v8a split APK, beta
  testers / sideload). Old split APKs exist in `build/` with codes 1050 / 2050 / 4050.
  Old APKs in git history are from the old Kotlin app (v4.34 has versionCode 12), which is
  lower than Play, so they are no problem.
- **Connected phones:** two phones (armeabi-v7a). Both have `com.sreerajp.mantrajapacounter`
  versionCode 50, versionName 6.13.19, installer `com.android.vending` (Google Play). No
  sideloaded build on them.
- **Unknown (only you know):** whether any Flutter split APK (code 1xxx / 2xxx / 4xxx) was
  ever given to other people. See "Risk" below.

## Files to change

1. `android/gradle.properties` — add:
   ```properties
   # Give every --split-per-abi APK the same versionCode as the App Bundle (no
   # 1000/2000/4000 ABI offset). With the offset, a sideloaded APK looks newer than
   # every Play build, so Play never updates it and the user must uninstall (data loss).
   force-version-code-ignoring-abi=true
   ```
2. `docs/release_process.md` (local project copy, not in the guidelines submodule):
   - Section 9 build commands: under the split APK command, note that all split APKs share
     the bundle's versionCode (set by `force-version-code-ignoring-abi=true`) and how to
     check it: `aapt2 dump badging <apk>` (first line shows versionCode and versionName).
   - Section 12 Distribution Channels: a short paragraph on why direct APKs and Play must
     use the same versionCode (Play updates a sideloaded install only when its code is
     higher; same signing key needed too).
   - Release checklist: add "Split APK versionCode equals the `pubspec.yaml` build number —
     no 1000/2000/4000 added (`aapt2 dump badging`)."
3. `README.md` — one short line under "Split APKs" saying the APKs keep the plain build
   number. (Small, optional; drop it if you prefer README unchanged.)
4. `change_log/<timestamp>_split-apk-version-code.md` — after the change.

No Dart code, no tests change.

## Risk: users who already have a split APK with a high code

If anyone got a Flutter split APK (for example 2050 for 6.13.19+50), Android will refuse
any later build with a lower code. After this fix, the next APK/AAB would be 51, so those
users stay stuck. The way out is a **one-time jump** of the build number in `pubspec.yaml`
above the highest code ever handed out (for example `+4051` if an x86_64 4050 was shared,
or `+2051` if only arm64 was shared). versionCode can never go down afterwards, so the jump
is permanent — pick it only if real users need it.

Also, Play can update a sideloaded install only if both are signed with the same key. If
Play App Signing uses a Google-held app signing key that is different from the local
release keystore, sideloaded users can never get Play updates without uninstalling. Check
in Play Console → App integrity → App signing that the app signing key certificate matches
the release keystore (`keytool -list -v -keystore android/keystore.jks`).

## Guidelines submodule

`docs/guidelines/` is read-only. Note for you: the shared Flutter build guide
(`docs/guidelines/flutter_build_flavors_guide.md`) could recommend
`force-version-code-ignoring-abi=true` for any project that ships both split APKs and an
AAB. I will not edit it.

## Security impact

Build configuration only. No permission, network, storage or signing change.

## Verification (after you build)

- Each split APK: `aapt2 dump badging <apk>` → versionCode equals the pubspec build number.
- AAB: unzip `base/manifest/AndroidManifest.xml` (protobuf) and decode versionCode with a
  small Python script (standard library only), or bundletool if installed.
- All files show the same versionCode and versionName; file names match the version inside.
- After the build: `android\gradlew --stop`, and check no GradleDaemon /
  KotlinCompileDaemon java process is left.
