# Upgrade AGP and Gradle

**Status:** completed

## What the issue is

The user asked to upgrade Flutter, the Android Gradle Plugin (AGP) and Gradle.

Current versions, and the newest versions available on 2026-10-06:

| Tool | Current | Newest stable | Notes |
|------|---------|---------------|-------|
| Flutter | 3.47.6 | 3.47.6 | Already the newest. `flutter upgrade --verify-only` says "already up to date". **No change.** |
| Dart | 3.13.5 | 3.13.5 | Comes with Flutter. **No change.** |
| AGP | 9.1.0 | 9.4.1 | AGP 9.4 needs Gradle 9.6.0 or newer, and JDK 17 (we already use 17). |
| Gradle | 9.3.1 | 9.8.0 | |
| Kotlin plugin | 2.4.0 | 2.4.20 | Not asked for. Left unchanged (see "Out of scope"). |

### Risk to know about

Flutter 3.47.6 has only been tested with AGP up to 9.2 and Gradle up to 9.3.1. These
limits are in the Flutter tool source (`packages/flutter_tools/lib/src/android/gradle_utils.dart`).
For newer versions, the Flutter tool does not block the build. It treats them as
"valid, but unknown" and may print a warning. So AGP 9.4.1 + Gradle 9.8.0 should work,
but it goes beyond what the Flutter team has tested. If a plugin or the Flutter Gradle
plugin breaks, we roll back by reverting the two version lines.

## Files to change

1. `android/settings.gradle.kts` — AGP plugin version `9.1.0` → `9.4.1`.
2. `android/gradle/wrapper/gradle-wrapper.properties` — `gradle-9.3.1-all.zip` → `gradle-9.8.0-all.zip`.
3. `CLAUDE.md` — Android toolchain row: AGP 9.4.1, Gradle 9.8.0.
4. Docs that list the AGP/Gradle versions (for example `docs/guidelines/flutter_build_flavors_guide.md`,
   `docs/architecture.md`, `docs/release_process.md`, `AGENTS.md`) — update the version numbers
   only where they appear. I will search for `9.1.0` and `9.3.1` and change only the
   AGP/Gradle mentions.

## Plan for the fix

1. Change the two version lines above.
2. Keep `android.builtInKotlin=false` and `android.newDsl=false` in `android/gradle.properties`.
   Flutter plugins still need them. AGP 9.4 still accepts them (they are only removed in AGP 10).
3. Keep `kotlin.incremental=false` (needed for the H: / L: drive split).
4. Run `flutter clean`, `flutter pub get`.
5. Run `flutter analyze` and `flutter test`.
6. Run a real Android build to prove AGP/Gradle work: `flutter build apk --flavor dev --debug`.
   (Gradle 9.8.0 will download the first time, about 200 MB.) Read the output for new
   warnings and deprecations.
7. If the build fails and the fix is not small, stop and report. Fallback option:
   AGP 9.2.1 (the newest version Flutter knows about) with the lowest Gradle it accepts.
8. Update the docs listed above.
9. Write the change log in `change_log/`.

Note: I will never stop Java processes globally to recover a stuck Gradle daemon.
If needed, I will use `./gradlew --stop` from `android/`.

## Out of scope

- Kotlin Gradle plugin 2.4.0 → 2.4.20. Small and low-risk, but not asked for. Can be
  added to this plan if wanted.
- Switching to built-in Kotlin or the new DSL.
- The uncommitted "session across days" work already in the tree. This plan does not touch it.
