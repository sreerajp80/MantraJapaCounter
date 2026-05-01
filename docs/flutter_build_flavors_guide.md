# Flutter Build Flavors Guide

Use this as a reusable reference for Flutter projects that define build flavors such as `dev`
and `prod` across Android, iOS, and Windows desktop.

This guide documents one well-tested approach for each platform. It is not the only valid
approach. Teams with different CI pipelines, signing strategies, or flavor matrices should treat
the examples here as a starting point and document their deviations in `docs/architecture.md`.

---

## Flavor Basics

A flavor usually represents an environment or release lane.

| Flavor | Typical Purpose | Typical Mode |
|--------|-----------------|--------------|
| `dev` | Local development, QA, internal testing | `debug` |
| `prod` | Production builds, store submissions, public release | `release` |

Common combinations:

| Flavor | Mode | Signing | Notes |
|--------|------|---------|-------|
| `dev` | `debug` | Automatic debug keystore | Daily development — no setup required |
| `dev` | `release` | Configurable — see signing strategy notes | QA release-like build |
| `prod` | `debug` | Automatic debug keystore | Rare; production config with debug tooling |
| `prod` | `release` | Release keystore required | Store submission or public distribution |

---

## Android Flavor Setup

### Product Flavors In Gradle

Define product flavors in `android/app/build.gradle.kts`:

```kotlin
android {
    flavorDimensions += "environment"
    productFlavors {
        create("dev") {
            dimension = "environment"
            applicationIdSuffix = ".dev"
            versionNameSuffix = "-dev"
            resValue("string", "app_name", "MyApp Dev")
        }
        create("prod") {
            dimension = "environment"
            resValue("string", "app_name", "MyApp")
        }
    }
}
```

---

### Android Signing Configuration

#### Signing Strategy Options

Android signing is context-dependent. There is no single correct strategy for all teams.
Choose the approach that fits your CI environment and team policy, then document it in
`docs/architecture.md §15`.

**Strategy A — Local file-based signing (single developer or small team)**

A `key.properties` file supplies keystore credentials on the developer's machine. CI writes
the same file from environment variables. This is the simplest approach for small projects.

- `* --debug` — Android provides the SDK debug keystore automatically. No setup required.
- `dev --release` — Configured by the team. Options: use the release keystore (same as prod),
  use a separate dev keystore, or allow the debug keystore as a fallback for internal QA builds.
  Document which policy your team uses; do not leave it implicit.
- `prod --release` — Release keystore required. The build MUST fail clearly if credentials are
  absent rather than silently signing with the wrong key.

**Strategy B — CI-managed signing (recommended for multi-developer teams)**

Signing credentials are never stored on developer machines. CI injects the keystore and
credentials as secrets at build time. Local builds of `prod --release` are intentionally
blocked or produce an unsigned artifact. This is the lower-risk approach for team projects.

**Strategy C — Separate keystores per flavor**

`dev` and `prod` flavors use completely separate keystores with different aliases. This
guarantees a dev-signed APK can never be mistaken for or substitute a prod APK.

Whichever strategy is chosen: **document it explicitly** and commit that documentation. The
most common signing incidents happen when the strategy is assumed rather than written down.

---

#### Step 1 — Create The Keystore

If you do not yet have a release keystore, generate one with `keytool`. Run this once and
store the output `.jks` file securely outside the project directory.

```bash
keytool -genkey -v \
  -keystore ~/keys/myapp-prod.jks \
  -alias myapp \
  -keyalg RSA \
  -keysize 2048 \
  -validity 10000
```

Keystore rules:
- Never store the `.jks` file inside the project directory or commit it to source control.
- Back it up in at least two separate secure locations (cloud storage + physical).
  Losing it permanently prevents you from publishing updates to Google Play for this app.
- Store the passwords in a password manager. They cannot be recovered from the keystore file.

#### Step 2 — Create `android/key.properties` (Strategy A)

Create the file at `android/key.properties`. This file is gitignored (see Step 3).

```properties
storeFile=/absolute/path/to/myapp-prod.jks
storePassword=your-store-password
keyAlias=myapp
keyPassword=your-key-password
```

Use an absolute path for `storeFile`. Relative paths resolve from the `android/app/` directory,
which is easy to get wrong. An absolute path is unambiguous across machines and CI environments.

For CI environments, set these values as environment variables and write the file from a
pre-build step rather than committing it.

#### Step 3 — Gitignore Signing Artefacts

Add to `.gitignore` at the project root:

```gitignore
# Android signing — never commit
android/key.properties
*.jks
*.keystore
```

Verify the file is not tracked:

```bash
git status android/key.properties
# Expected: nothing (the file should not appear)
```

If the file was previously committed, remove it from history before it reaches a remote
repository. A committed keystore or key.properties is a security incident.

#### Step 4 — Configure `android/app/build.gradle.kts`

The example below implements Strategy A (local file-based signing) with a Gradle guard that
blocks `prod --release` builds if credentials are absent. Read the caveats below the example
before adopting this pattern.

```kotlin
// ─── Signing ─────────────────────────────────────────────────────────────────
val keystorePropertiesFile = rootProject.file("android/key.properties")

android {
    // ... namespace, compileSdk, defaultConfig, etc. ...

    signingConfigs {
        create("release") {
            if (keystorePropertiesFile.exists()) {
                val props = java.util.Properties()
                props.load(keystorePropertiesFile.inputStream())
                keyAlias      = props.getProperty("keyAlias")
                keyPassword   = props.getProperty("keyPassword")
                storeFile     = file(props.getProperty("storeFile"))
                storePassword = props.getProperty("storePassword")
            }
        }
    }

    buildTypes {
        release {
            isMinifyEnabled = true
            proguardFiles(
                getDefaultProguardFile("proguard-android-optimize.txt"),
                "proguard-rules.pro"
            )
            if (keystorePropertiesFile.exists()) {
                signingConfig = signingConfigs.getByName("release")
            }
        }
        debug {
            // Android applies the SDK debug keystore automatically.
        }
    }

    flavorDimensions += "environment"
    productFlavors {
        create("dev") {
            dimension = "environment"
            applicationIdSuffix = ".dev"
            versionNameSuffix = "-dev"
            resValue("string", "app_name", "MyApp Dev")
        }
        create("prod") {
            dimension = "environment"
            resValue("string", "app_name", "MyApp")
        }
    }
}

// ─── Signing enforcement ──────────────────────────────────────────────────────
// Block prod --release tasks at execution time when key.properties is absent.
// See caveats below before adopting this pattern.
afterEvaluate {
    listOf("assembleProdRelease", "bundleProdRelease").forEach { taskName ->
        tasks.findByName(taskName)?.doFirst {
            if (!keystorePropertiesFile.exists()) {
                throw GradleException(
                    "\n" +
                    "══════════════════════════════════════════════════════════\n" +
                    "  SIGNING REQUIRED — prod --release build blocked         \n" +
                    "══════════════════════════════════════════════════════════\n" +
                    "  android/key.properties not found.                       \n" +
                    "  Create the file with your release keystore credentials. \n" +
                    "  See docs/flutter_build_flavors_guide.md                 \n" +
                    "  Section: Android Signing Configuration                  \n" +
                    "══════════════════════════════════════════════════════════\n"
                )
            }
        }
    }
}
```

**Caveats for this Gradle enforcement pattern:**

- The task names `assembleProdRelease` and `bundleProdRelease` are derived from the
  `prod` flavor name and the `release` build type. If your project uses different flavor
  names, a custom build type name, or more than one flavor dimension, the task names will
  differ and this guard will silently do nothing. Verify the actual task names with
  `./gradlew tasks --all | grep -i release` before relying on this check.
- This pattern assumes signing credentials come from a local file. Teams using CI-managed
  signing (Strategy B) should replace this guard with a CI pipeline check rather than a
  Gradle-level file existence test.
- `afterEvaluate` with `tasks.findByName` is sensitive to the Gradle configuration phase.
  In some project configurations, tasks are registered lazily and `findByName` may return
  null even for tasks that will exist at execution time. Use `tasks.matching { ... }` or
  a configuration-time check if you encounter this issue.

---

### Flavor-Specific Resource Files

Place flavor-specific files in the corresponding source set:

```text
android/app/src/
|-- dev/
|   `-- res/
|       |-- mipmap-hdpi/       # Dev app icon (with badge)
|       `-- values/
|           `-- strings.xml
`-- prod/
    `-- res/
        |-- mipmap-hdpi/       # Production app icon
        `-- values/
            `-- strings.xml
```

---

### Android Run And Build Commands

> **Note:** Flutter ≥ 3.19 auto-populates the `FLUTTER_APP_FLAVOR` dart-define from
> `--flavor` and now rejects passing it explicitly via `--dart-define`. Read it in Dart
> with `String.fromEnvironment('FLUTTER_APP_FLAVOR')`.

Run the development flavor (no signing setup needed):

```bash
flutter run --flavor dev
```

Run the production flavor for debug inspection (no signing setup needed):

```bash
flutter run --flavor prod
```

Build a development debug APK (no signing setup needed):

```bash
flutter build apk --flavor dev --debug
```

Build production split APKs for direct distribution:

```bash
flutter build apk --flavor prod --release \
  --obfuscate \
  --split-debug-info=build/symbols/prod/ \
  --split-per-abi
```

Build a Play Store bundle:

```bash
flutter build appbundle --flavor prod --release \
  --obfuscate \
  --split-debug-info=build/symbols/prod/
```

---

### ProGuard / R8 Rules

R8 shrinks and optimizes the Java/Kotlin bytecode in Android release builds. It can strip
classes that are loaded dynamically or accessed via JVM reflection, causing
`ClassNotFoundException` or `NoSuchMethodException` at runtime — errors that only appear
in release builds.

**Which Flutter packages actually require R8 keep rules:**

Packages that contain Java or Kotlin plugin code accessed via method channels are the primary
risk. The Dart layer of a Flutter app compiles to native AOT machine code and is not subject
to R8. Only the native Android plugin side is affected.

Common cases:
- **Native Android plugins** — any package that registers a `FlutterPlugin` implementation
  in Java or Kotlin. The Flutter engine classes themselves need keeping.
- **sqflite** — uses a Java plugin (`com.tekartik.sqflite`) that can be affected.
- **Packages using JVM reflection internally** — check the package's own README or
  ProGuard documentation for any required keep rules it publishes.

`freezed` and `json_serializable` generate Dart source files at build time. Their output
is compiled Dart, not JVM bytecode, and does not require R8 keep rules.

Create or edit `android/app/proguard-rules.pro`:

```proguard
# Flutter engine — always required
-keep class io.flutter.** { *; }
-keep class io.flutter.plugins.** { *; }

# sqflite native plugin
-keep class com.tekartik.sqflite.** { *; }

# Add keep rules for any other native Android plugin packages
# that document reflection-based class loading in their README.
# Check each package's documentation rather than adding blanket rules.
```

Reference the file in the `buildTypes.release` block in `android/app/build.gradle.kts`:

```kotlin
buildTypes {
    release {
        isMinifyEnabled = true
        proguardFiles(
            getDefaultProguardFile("proguard-android-optimize.txt"),
            "proguard-rules.pro"
        )
    }
}
```

Always test the production release build after adding a new dependency. R8 issues only surface
in release mode and can be hard to trace if not caught immediately after the dependency is added.

---

### Which Android Artifact To Use

Use split APKs when you distribute the app yourself.

Output files from `--split-per-abi`:

- `app-armeabi-v7a-prod-release.apk`
- `app-arm64-v8a-prod-release.apk`
- `app-x86_64-prod-release.apk`

Use an App Bundle (`.aab`) when publishing to Google Play. Google Play serves optimized
device-specific downloads from the `.aab`.

### Important Flag Distinction

`--target-platform` controls compilation targets but does NOT automatically guarantee ABI-specific
APKs. Use `--split-per-abi` for separate per-ABI APKs.

---

## iOS Flavor Setup

### Xcode Scheme And xcconfig Setup

Each flavor requires a separate Xcode scheme and a pair of xcconfig files (Debug and Release).

**Directory structure:**

```text
ios/
|-- Flutter/
|   |-- dev/
|   |   |-- Debug.xcconfig
|   |   `-- Release.xcconfig
|   `-- prod/
|       |-- Debug.xcconfig
|       `-- Release.xcconfig
|-- Runner/
|   |-- Info.plist
|   `-- ... (Xcode project files)
```

> **Note:** `FLUTTER_APP_FLAVOR` is auto-populated from the active scheme/`--flavor` on
> Flutter ≥ 3.19 — do **not** put it in `DART_DEFINES`, the framework rejects it.

**`ios/Flutter/dev/Debug.xcconfig`:**

```
#include "Generated.xcconfig"
#include "../../Flutter/Flutter.xcconfig"
FLUTTER_TARGET=lib/main.dart
BUNDLE_ID_SUFFIX=.dev
DISPLAY_NAME=MyApp Dev
```

**`ios/Flutter/dev/Release.xcconfig`:**

```
#include "Generated.xcconfig"
#include "../../Flutter/Flutter.xcconfig"
FLUTTER_TARGET=lib/main.dart
BUNDLE_ID_SUFFIX=.dev
DISPLAY_NAME=MyApp Dev
```

**`ios/Flutter/prod/Release.xcconfig`:**

```
#include "Generated.xcconfig"
#include "../../Flutter/Flutter.xcconfig"
FLUTTER_TARGET=lib/main.dart
BUNDLE_ID_SUFFIX=
DISPLAY_NAME=MyApp
```

**In `ios/Runner/Info.plist`**, use the variable references:

```xml
<key>CFBundleIdentifier</key>
<string>com.yourcompany.myapp$(BUNDLE_ID_SUFFIX)</string>
<key>CFBundleDisplayName</key>
<string>$(DISPLAY_NAME)</string>
```

### Creating Xcode Schemes

In Xcode:

1. Product → Scheme → New Scheme → name it `dev`.
2. Product → Scheme → New Scheme → name it `prod`.
3. For the `dev` scheme:
   - Edit Scheme → Build: set configuration to `Debug`.
   - Edit Scheme → Run: set configuration to `Debug`.
   - Edit Scheme → Archive: set configuration to `Release`.
4. In each scheme's Build Configuration, select the matching xcconfig via
   Project → Info → Configurations → Expand each configuration → set xcconfig for Runner.

### iOS Run And Build Commands

Run the dev flavor (automatic development signing):

```bash
flutter run --flavor dev
```

Run the prod flavor (automatic development signing for device testing):

```bash
flutter run --flavor prod
```

Build a release IPA (**requires App Store distribution provisioning profile**):

```bash
flutter build ipa --flavor prod --release \
  --obfuscate \
  --split-debug-info=build/symbols/ios-prod/
```

### iOS Provisioning

- Each flavor MUST use a separate provisioning profile matching its bundle ID.
  - Dev: `com.yourcompany.myapp.dev` — development or ad-hoc profile.
  - Prod: `com.yourcompany.myapp` — App Store distribution profile.
- Never share a production distribution certificate with dev builds.
- Configure signing in Xcode under Signing & Capabilities, per scheme.
- `flutter run` uses automatic signing by default; `flutter build ipa` requires an explicit
  distribution profile configured in Xcode for the prod scheme.

### iOS Flavor-Specific Assets

Place flavor-specific app icons in `ios/Runner/Assets.xcassets` using an `AppIcon-dev` asset
catalog set for the dev flavor and `AppIcon` for prod. Reference the correct set in each scheme's
`Info.plist` via `CFBundleIcons`.

---

## Windows Desktop Flavor Setup

Windows does not have a native flavor system equivalent to Android product flavors or Xcode
schemes. For most behavioral differences — feature flags, environment URLs, logging verbosity —
`--dart-define` combined with `AppFlavorConfig` is sufficient at the Dart layer.

However, `--dart-define` does not handle all flavor-differentiation needs:

- **MSIX package identity** — if dev and prod builds need to be installed side by side on the
  same machine, they require distinct `identity_name` values in `msix_config`. This requires
  either separate `pubspec.yaml` sections per flavor, or a build script that substitutes the
  correct value before calling `msix:create`.
- **Distribution certificates** — sideloaded MSIX packages require a code-signing certificate
  trusted by the target machine. Store-distributed packages go through Microsoft Partner Center
  signing. These are fundamentally different processes; a single `msix_config` block cannot
  serve both without adjustment.
- **App display name and icon** — these are set in `msix_config` statically. If dev and prod
  builds need distinct display names or icons in the installed app list, the config must differ
  per flavor.

Document which of these cases apply to your project before settling on a Windows build strategy.

### Windows Run And Build Commands

> **Caveat:** `--flavor` is not supported for desktop targets, so the auto-population of
> `FLUTTER_APP_FLAVOR` does not apply on Windows. And because Flutter ≥ 3.19 reserves
> `FLUTTER_APP_FLAVOR`, you also can't pass it via `--dart-define`. For desktop, use a
> different name (e.g. `APP_FLAVOR`) and read it with
> `String.fromEnvironment('APP_FLAVOR')` in a desktop-only init path. The Android-only
> setup in this project is unaffected; this section is reference only.

Run the dev flavor:

```bash
flutter run -d windows --dart-define=APP_FLAVOR=dev
```

Run the prod flavor:

```bash
flutter run -d windows --dart-define=APP_FLAVOR=prod
```

Build a production Windows release:

```bash
flutter build windows --release \
  --dart-define=APP_FLAVOR=prod \
  --obfuscate \
  --split-debug-info=build/symbols/windows-prod/
```

### MSIX Packaging

For distributing Windows builds outside direct EXE copy, package as MSIX.

Add to `pubspec.yaml`:

```yaml
dev_dependencies:
  msix: ^3.16.0

msix_config:
  display_name: MyApp
  publisher_display_name: Your Name Or Company
  identity_name: com.yourcompany.myapp
  publisher: CN=YourPublisherCN
  msix_version: 1.0.0.0
  logo_path: assets/icons/icon.png
  capabilities: runFullTrust
  languages: en-us
```

Build the MSIX:

```bash
flutter pub run msix:create
```

If dev and prod must be installed side by side, use a distinct `identity_name` for the dev
flavor (e.g. `com.yourcompany.myapp.dev`). The simplest approach is a separate
`pubspec_dev.yaml` that overrides only the `msix_config` block, invoked explicitly in your
dev build script. Document the chosen approach in `docs/architecture.md §15`.

### Windows-Specific sqflite Initialization

This is required before any database operation on Windows or Linux desktop. Add it to `main()`
before `runApp`:

```dart
import 'dart:io';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (Platform.isWindows || Platform.isLinux) {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  }

  runApp(const MyApp());
}
```

### Window Size Constraints

Prevent the window from being resized to dimensions that break the UI:

```yaml
# pubspec.yaml
dependencies:
  window_manager: ^0.4.0
```

```dart
import 'package:window_manager/window_manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await windowManager.ensureInitialized();

  const windowOptions = WindowOptions(
    size: Size(1024, 768),
    minimumSize: Size(800, 600),
    title: 'MyApp',
    center: true,
  );
  await windowManager.waitUntilReadyToShow(windowOptions, () async {
    await windowManager.show();
    await windowManager.focus();
  });

  runApp(const MyApp());
}
```

---

## Recommended Release Matrix

For most Flutter projects targeting Android, iOS, and Windows:

| Platform | Flavor | Mode | Signing Required | Command |
|----------|--------|------|-----------------|---------|
| Android | `dev` | `debug` | No — automatic debug keystore | `flutter run --flavor dev` |
| Android | `dev` | `release` | Team policy — document your choice | `flutter build apk --flavor dev --release` |
| Android | `prod` | `debug` | No — automatic debug keystore | `flutter run --flavor prod` |
| Android | `prod` | `release` split APK | Yes — release keystore required | `flutter build apk --flavor prod --release --obfuscate --split-debug-info=... --split-per-abi` |
| Android | `prod` | `release` Play Store | Yes — release keystore required | `flutter build appbundle --flavor prod --release --obfuscate --split-debug-info=...` |
| iOS | `dev` | `debug` | No — automatic development signing | `flutter run --flavor dev` |
| iOS | `prod` | `release` | Yes — distribution profile required | `flutter build ipa --flavor prod --release --obfuscate --split-debug-info=...` |
| Windows | n/a | `debug` | No | `flutter run -d windows --dart-define=APP_FLAVOR=dev` (see Windows caveat above) |
| Windows | n/a | `release` MSIX | Depends on distribution channel — see Windows section | `flutter build windows --release --dart-define=APP_FLAVOR=prod --obfuscate --split-debug-info=...` then `flutter pub run msix:create` |

---

## Debug Symbol Management

Every production release build MUST be built with:

```bash
--obfuscate
--split-debug-info=build/symbols/<platform>-<version>/
```

**What `--obfuscate` does:** Dart compiles to native AOT machine code; it is not bytecode and
does not require decompilation in the way Java or C# do. The `--obfuscate` flag additionally
renames Dart class and method identifiers in the compiled binary's symbol table, making
class and method names meaningless strings rather than readable source names. This is a useful
hardening step that raises the cost of static analysis and makes crash symbolication without the
accompanying symbols file impossible.

It is not a strong security boundary on its own. A determined analyst with the binary and
sufficient time can still reconstruct logic from the machine code. Do not treat `--obfuscate`
as a substitute for sound data security, proper secret management, or server-side enforcement
of sensitive operations.

**Symbol archive policy:**

The symbols directory produced by `--split-debug-info` MUST be:

- Stored securely for the lifetime of the released version.
- Never committed to source control.
- Archived alongside the release artifact (e.g. in a release artifacts storage bucket or
  secure folder).

Without the symbols file, crash reports from that release version cannot be decoded. Losing
it permanently means those crashes are undiagnosable.

---

## Notes For New Projects

To support this workflow, the native projects typically need:

**Android:**
- Product flavors in `android/app/build.gradle.kts`.
- Distinct `applicationIdSuffix` for side-by-side installation.
- Flavor-specific icons and resource values.
- ProGuard rules for the Flutter engine and any native plugins that require them.
- A documented and implemented signing strategy for each flavor × mode combination.
- `android/key.properties` and `*.jks` / `*.keystore` added to `.gitignore`.

**iOS:**
- Xcode schemes aligned with flavor names.
- xcconfig files per flavor per build configuration.
- Provisioning profiles per flavor bundle ID.
- Flavor-specific app icons in asset catalogs.
- Distribution profile required for `prod --release`; automatic signing for debug and dev.

**Windows:**
- `sqflite_common_ffi` initialization in `main()` for any desktop + sqflite usage.
- `window_manager` for size constraints.
- `msix` package for distribution packaging.
- A documented strategy for MSIX identity and display name differentiation between flavors
  if side-by-side installation is required.

---

## Mantra Japa Counter — Project Configuration

This section documents the exact flavor configuration for this project. Use it as the reference
when setting up the `android/app/build.gradle.kts` file for the Flutter rewrite.

### Application Identifiers

| Flavor | Application ID | App Name |
|--------|---------------|----------|
| `dev` | `com.sreerajp.mantrajapacounter.dev` | `Mantra Japa Counter Dev` |
| `prod` | `com.sreerajp.mantrajapacounter` | `Mantra Japa Counter` |

### Signing Strategy

This project uses **Strategy A — local file-based signing** (see the signing strategy section
above). Single developer; no CI pipeline in initial release.

- Signing config file: `android/key.properties` (gitignored)
- Release keystore: `keystore/keystore.jks` at the repository root (alias: `sreerajp_mantrajapacounter`); keep at least one offline backup in a separate location

### Android `build.gradle.kts` Product Flavors Block

```kotlin
flavorDimensions += "environment"
productFlavors {
    create("dev") {
        dimension = "environment"
        applicationIdSuffix = ".dev"
        versionNameSuffix = "-dev"
        resValue("string", "app_name", "Mantra Japa Counter Dev")
    }
    create("prod") {
        dimension = "environment"
        // No suffix — uses base applicationId: com.sreerajp.mantrajapacounter
        resValue("string", "app_name", "Mantra Japa Counter")
    }
}
```

### `android/key.properties` Template

```properties
storeFile=/absolute/path/to/keystore.jks
storePassword=<store-password>
keyAlias=<key-alias>
keyPassword=<key-password>
```

Use an absolute path for `storeFile`. Store passwords in a password manager; they cannot be
recovered from the keystore file.

### Gitignore Entries

Verify these entries exist in `.gitignore` at the project root:

```gitignore
# Android signing — never commit
android/key.properties
*.jks
*.keystore

# Debug symbols — archive separately, never commit
build/symbols/
```

### Release Build Commands

```bash
# Split APKs for direct distribution
flutter build apk \
  --flavor prod \
  --release \
  --obfuscate \
  --split-debug-info=build/symbols/android-prod-<version>/ \
  --split-per-abi

# App Bundle for Google Play
flutter build appbundle \
  --flavor prod \
  --release \
  --obfuscate \
  --split-debug-info=build/symbols/android-prod-<version>/
```

### Platforms In Scope

This project targets Android only. iOS and Windows flavor setup (documented in the sections
above) does not apply to this release.