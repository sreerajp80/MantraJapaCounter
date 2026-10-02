# Plan: Upgrade to AGP 9.1.0, Gradle 9.3.1 and Kotlin 2.4.0

**Status:** completed

## The issue

Flutter was upgraded from 3.44.8 to 3.47.6. Flutter 3.47.6 recommends this Android build toolchain:

- Java 17 (minimum). The project already uses 17.
- Kotlin Gradle Plugin (KGP) 2.4.0. The project uses 2.2.20.
- Android Gradle Plugin (AGP) 9.1.0. The project uses 8.11.1.
- Gradle 9.3.1. The project uses 8.14.

The user chose to do the full upgrade ("Option B").

Things that block a simple version bump:

1. **`project.exec` was removed in Gradle 9.** The `generateBuildMetadata` task in
   `android/app/build.gradle.kts` uses `project.exec { ... }` twice, to run
   `tool/generate_app_version.dart` and `tool/generate_build_date.dart`. On Gradle 9 this does
   not compile, so every Android build would fail.
2. **Kotlin setup is different in AGP 9.** AGP 9 has Kotlin built in. Flutter 3.47.6's own
   app template still turns this off with `android.builtInKotlin=false` and
   `android.newDsl=false` in `gradle.properties`. It also no longer lists `kotlin-android` in
   the app's `plugins { }` block, because the Flutter Gradle plugin applies Kotlin itself when
   built-in Kotlin is off. Our `gradle.properties` already has both flags (the Flutter migrator
   added them). The app still lists `id("kotlin-android")`.
3. **The shared guideline says "stay on AGP 8.x".** `docs/guidelines/flutter_project_engineering_standard.md`
   and `docs/guidelines/flutter_build_flavors_guide.md` say AGP 9 is not supported (written for
   Flutter 3.41). That is now out of date for Flutter 3.47.6. `docs/guidelines` is a git
   submodule (the shared `Flutter_Guidelines` repo), so it must not be edited inside this project.

## Files to change

| File | Change |
|------|--------|
| `android/settings.gradle.kts` | AGP `8.11.1` → `9.1.0`; Kotlin `2.2.20` → `2.4.0` |
| `android/gradle/wrapper/gradle-wrapper.properties` | `gradle-8.14-all.zip` → `gradle-9.3.1-all.zip` |
| `android/app/build.gradle.kts` | Replace `project.exec` with Gradle's `ExecOperations`; remove `id("kotlin-android")` to match the Flutter 3.47.6 template |
| `android/gradle.properties` | No change planned. Keep `android.builtInKotlin=false`, `android.newDsl=false` and `kotlin.incremental=false`. Only the comments may be updated so they explain why the flags stay. |
| `CLAUDE.md` | Add a short "Android toolchain" row/note: Java 17, AGP 9.1.0, Gradle 9.3.1, Kotlin 2.4.0 |

Not changed:

- `docs/guidelines/**` (submodule). Updating the "stay on AGP 8.x" rule belongs in the shared
  `Flutter_Guidelines` repo. This will be listed as a follow-up in the change log.
- `android/app/src/main/kotlin/.../MainActivity.kt` already has uncommitted changes from
  earlier work. This plan does not touch it.
- Dart code, `pubspec.yaml`, the JSON export format and the database. None of these change.

## The fix, step by step

1. **Version bumps**
   - `android/settings.gradle.kts`:
     - `id("com.android.application") version "9.1.0" apply false`
     - `id("org.jetbrains.kotlin.android") version "2.4.0" apply false`
   - `android/gradle/wrapper/gradle-wrapper.properties`:
     - `distributionUrl=https\://services.gradle.org/distributions/gradle-9.3.1-all.zip`

2. **Replace `project.exec` in `generateBuildMetadata`**

   Use the Gradle pattern for build scripts: get `ExecOperations` through an injected object.

   ```kotlin
   import javax.inject.Inject
   import org.gradle.process.ExecOperations

   interface InjectedExecOps {
       @get:Inject val execOps: ExecOperations
   }

   val generateBuildMetadata = tasks.register("generateBuildMetadata") {
       // ... same group, description, inputs and outputs as today ...
       val injected = project.objects.newInstance<InjectedExecOps>()
       doLast {
           // same dartExecutable existence check as today
           injected.execOps.exec {
               workingDir = projectRootDir
               commandLine(dartExecutable.absolutePath, "run", "tool/generate_app_version.dart")
           }
           injected.execOps.exec {
               workingDir = projectRootDir
               commandLine(dartExecutable.absolutePath, "run", "tool/generate_build_date.dart")
           }
       }
   }
   ```

   The task still does exactly the same work: same inputs, outputs, error message and order.

3. **Kotlin plugin line**
   - Remove `id("kotlin-android")` from the `plugins { }` block of `android/app/build.gradle.kts`,
     to match the Flutter 3.47.6 template. The Flutter Gradle plugin applies Kotlin
     automatically while `android.builtInKotlin=false`.
   - Keep the `kotlin { compilerOptions { jvmTarget.set(JvmTarget.JVM_17) } }` block. The
     template keeps it too.
   - Fallback: if the build cannot find Kotlin, put `id("kotlin-android")` back. The only goal
     of this step is to match the template; it is not needed for the upgrade to work.

4. **Check the rest of `android/app/build.gradle.kts` for AGP 9 / Gradle 9 problems**
   - `afterEvaluate { tasks.findByName(...) ... }` (signing check), `bundle { language { } }`,
     `signingConfigs`, `productFlavors`, `buildTypes`, `proguardFiles` and the
     `coreLibraryDesugaring` dependency. These are expected to keep working while
     `android.newDsl=false`. Fix only what the build actually reports.

5. **Clean and verify** (all must pass)
   - `flutter clean` then `flutter pub get`
   - `flutter analyze` → 0 issues
   - `flutter test` → all pass
   - `flutter build apk --flavor dev --debug`
   - `flutter build apk --flavor prod --release --obfuscate --split-debug-info=build/symbols/android-prod-v6.10.0/ --split-per-abi`
     (checks R8/ProGuard and release signing on the new AGP)
   - `flutter build appbundle --flavor prod --release --obfuscate --split-debug-info=build/symbols/android-prod-v6.10.0/`
   - Confirm that `lib/core/utils/app_version.g.dart` and `lib/core/utils/build_date.g.dart` are
     still generated by the build (the `project.exec` replacement works).
   - Confirm that the merged manifest still has no `INTERNET` permission and that
     `android:allowBackup="false"` is still set.
   - Read the build output for new deprecation warnings and list them in the change log.

   If a build fails because a Flutter plugin package does not support AGP 9 yet, stop and
   report it to the user before trying workarounds.

6. **Docs**
   - `CLAUDE.md`: add the Android toolchain versions (Java 17, AGP 9.1.0, Gradle 9.3.1, Kotlin 2.4.0).
   - Change log in `change_log/`. It will note the follow-up to update the shared
     `Flutter_Guidelines` repo (the "stay on AGP 8.x" rule).

## Update 1 — `file_picker` build failure (found during step 5)

**What happened.** Steps 1–3 were done. The first `flutter build apk --flavor dev --debug`
failed with `cannot find symbol ... FilePickerPlugin` in `GeneratedPluginRegistrant.java`.
The `ExecOperations` change worked (both `.g.dart` files were generated).

**Why.** `file_picker` 11.0.2 is written in Kotlin. Its `android/build.gradle` skips the Kotlin
plugin when AGP is 9 or newer, because it expects AGP's built-in Kotlin to compile it. But this
project sets `android.builtInKotlin=false` (the same as Flutter's template), because five other
plugins (`audioplayers_android`, `file_picker`, `package_info_plus`, `share_plus`,
`shared_preferences_android`) still apply the old Kotlin plugin. So nothing compiles
`file_picker`'s Kotlin code.

**Extra files to change**

| File | Change |
|------|--------|
| `pubspec.lock` | `file_picker` 11.0.2 → 11.0.3 (fits the current `^11.0.2` range; `pubspec.yaml` is not changed) |
| `android/build.gradle.kts` | Only if 11.0.3 does not fix it: a small, temporary block that applies the Kotlin plugin to the `file_picker` module |

**Fix, step by step**

A. Run `flutter pub upgrade file_picker` (only this package). Rebuild the dev debug APK.
   If it builds, skip step B.

B. If it still fails, add this to `android/build.gradle.kts`. It is limited to the
   `file_picker` module and only runs while built-in Kotlin is off:

   ```kotlin
   // TEMPORARY (AGP 9): file_picker 11.x skips the Kotlin plugin on AGP 9 and expects
   // built-in Kotlin, but android.builtInKotlin=false is still needed for other plugins.
   // Apply Kotlin to file_picker only. Remove once all plugins support built-in Kotlin.
   subprojects {
       if (name == "file_picker" &&
           providers.gradleProperty("android.builtInKotlin").orNull == "false"
       ) {
           pluginManager.withPlugin("com.android.library") {
               if (!pluginManager.hasPlugin("org.jetbrains.kotlin.android")) {
                   pluginManager.apply("org.jetbrains.kotlin.android")
               }
           }
           // Match file_picker's Java 17 target so Kotlin and Java agree.
           tasks.withType<org.jetbrains.kotlin.gradle.tasks.KotlinCompile>().configureEach {
               compilerOptions.jvmTarget.set(org.jetbrains.kotlin.gradle.dsl.JvmTarget.JVM_17)
           }
       }
   }
   ```

   The exact code may need small changes to compile (for example, how the Kotlin classes are
   referenced from the root script). The behaviour stays the same: Kotlin is applied to
   `file_picker` only, with a Java 17 target.

C. Continue with step 5 (all verify builds and tests) and step 6 (docs). The change log will
   list this workaround and when to remove it: once every plugin in Flutter's warning list
   supports built-in Kotlin, set `android.builtInKotlin=true`, remove the block, and retest.

If neither A nor B gives a working build, stop and ask the user again (the other options were
upgrading `file_picker` to 13.x, or rolling back to AGP 8.x).

## Risks

- The first Gradle 9.3.1 build downloads the new Gradle distribution and AGP. This is a
  build-time download only. The app stays fully offline.
- A third-party Flutter plugin may not build on AGP 9 yet. The verify step will show this.
- Gradle daemons from the old version may still be running. Do not kill Java processes
  globally. If needed, run `android\gradlew --stop` from the project only.

## Rollback

Revert the files listed above with git (`git checkout -- <file>`), then run `flutter clean`.
