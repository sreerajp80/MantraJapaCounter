# Upgrade AGP and Gradle

Implements plan: `plans/20261006_193915_upgrade-agp-gradle.md`

## What changed

| Tool | Before | After |
|------|--------|-------|
| Flutter | 3.47.6 | 3.47.6 (no change — already the newest stable) |
| Dart | 3.13.5 | 3.13.5 (no change — ships with Flutter) |
| Android Gradle Plugin (AGP) | 9.1.0 | 9.4.1 |
| Gradle wrapper | 9.3.1 | 9.8.0 |
| Kotlin Gradle Plugin | 2.4.0 | 2.4.0 (no change — out of scope) |

## Files changed

- `android/settings.gradle.kts` — `com.android.application` plugin version `9.1.0` → `9.4.1`.
- `android/gradle/wrapper/gradle-wrapper.properties` — `gradle-9.3.1-all.zip` → `gradle-9.8.0-all.zip`.
- `CLAUDE.md` — Android toolchain row now says AGP 9.4.1, Gradle 9.8.0.

Not changed on purpose:

- `android/gradle.properties` — `android.builtInKotlin=false`, `android.newDsl=false` and
  `kotlin.incremental=false` are kept. AGP 9.4 still accepts them.
- `docs/guidelines/*` — these shared guides record what Flutter 3.47.6 *generates*
  (AGP 9.1.0, Gradle 9.3.1). That is still true, so they were left as they are.

## Checks

- `flutter analyze` — no issues.
- `flutter test` — all 242 tests passed.
- `flutter build apk --flavor dev --debug` — built.
- `flutter build apk --flavor prod --release` — built (R8 shrinking works with AGP 9.4.1).

## Notes

- Flutter 3.47.6 has only been tested up to AGP 9.2 and Gradle 9.3.1. Newer versions are
  accepted by the Flutter tool, and both builds above work. If a future plugin update
  breaks the Android build, the rollback is to revert the two version lines above.
- The first attempt at the prod build failed with a Dart "Out of memory" error, and the test
  run hung. Both happened because the build and the tests were run at the same time. Run
  one by one, both pass. This is not caused by the upgrade.
