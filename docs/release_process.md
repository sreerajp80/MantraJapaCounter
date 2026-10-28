# Release Process — Mantra Japa Counter

This document defines the release runbook, signing configuration, build commands, and quality verification checklist for Mantra Japa Counter.

Read [AGENTS.md](../AGENTS.md) and [CLAUDE.md](../CLAUDE.md) before building or publishing a release. See [GUIDELINES_MANIFEST.md](GUIDELINES_MANIFEST.md) for full guideline references.

---

## 1. Release Scope

- App: `Mantra Japa Counter`
- Release profile: `public`
- Supported release platforms:
  - `Android`
- Engineering standard profiles in force:
  - `Core Baseline`
  - `Production App Extension`

---

## 2. Roles And Responsibilities

| Role | Responsibility | Owner |
|------|----------------|-------|
| Release owner | Coordinates release readiness and final sign-off | sreerajp |
| Engineering | Code freeze, build, fixes, and artifact validation | sreerajp |
| QA | Test execution and regression sign-off | sreerajp |
| Store or distribution owner | Uploads artifacts to Google Play and manages release metadata | sreerajp |

---

## 3. Versioning Policy

- Version format: `MAJOR.MINOR.PATCH+BUILD`
- Source of truth: `pubspec.yaml`
- Build-number increment rule: increment by 1 for every build submitted to Google Play; never reuse or skip a build number
- Git tag format: `vX.Y.Z` — the `pubspec.yaml` version without `+build` (e.g., `v6.13.13`). One tag per release, even when both the AAB and the APKs ship.

---

## 4. Branch And Merge Policy

- Release branch strategy: trunk-based — releases are cut directly from `main`
- Hotfix strategy: fix on `main`; cherry-pick to a temporary `hotfix/vX.Y.Z` branch only if a patch must be applied against a specific shipped version while `main` has moved ahead
- Required checks before merge:
  - `dart format --output=none --set-exit-if-changed .` passes
  - `flutter analyze` adds no new warnings (zero is the goal; engineering standard §16.1)
  - `flutter test` passes

---

## 5. Environment And Flavor Matrix

| Flavor | Mode | Purpose | Example Command |
|--------|------|---------|-----------------|
| `dev` | `debug` | Local development and daily QA | `flutter run --flavor dev` |
| `dev` | `release` | Release-like testing on physical device | `flutter build apk --flavor dev --release` |
| `prod` | `release` | Final Google Play and direct-distribution artifact | See section 9 for full commands with all required flags |

---

## 6. Release Build Hardening

All production release builds for a native platform (here: Android) MUST include the following
flags. Omitting any of them is a release-blocking issue.

### 6.1 Obfuscation And Debug Symbols

```bash
--obfuscate
--split-debug-info=build/symbols/android-prod-<version>/
```

`--obfuscate` renames Dart class and method names in the compiled binary to meaningless
identifiers, raising the cost of reverse engineering application logic.

`--split-debug-info` extracts the debug symbol mapping required to decode crash stack traces.
Without it, stack traces from that release are permanently unreadable.

**Symbol archive policy:**

- Archive `build/symbols/android-prod-<version>/` to `releases/v<version>/symbols/` after every
  prod release build.
- Never commit symbols to source control (add `build/symbols/` to `.gitignore`).
- Retain for the lifetime of the released version.

### 6.2 ProGuard / R8 (Android)

`android/app/proguard-rules.pro` must cover:

- Flutter engine classes: `-keep class io.flutter.** { *; }`
- sqflite native module: `-keep class com.tekartik.sqflite.** { *; }`
- JSON serialization annotations if using `json_serializable`

Always perform a full release build test after adding a new dependency; R8 can silently strip
classes accessed only via reflection. Symptoms: `ClassNotFoundException` in release builds only.

Reference: `android/app/proguard-rules.pro` and `docs/guidelines/flutter_build_flavors_guide.md`.

### 6.3 App Size Analysis

Optional, but recommended before every release to catch dependency bloat early. Run it
**before** the hardened build: it writes into the same output folders, and its output must never be
shipped or archived as the release artifact.

```bash
flutter build apk --flavor prod --release \
  --analyze-size
```

Size budgets:

| Platform | Target | Hard Limit |
|----------|--------|------------|
| Android APK arm64 | < 30 MB | 50 MB |
| Android AAB download size | < 20 MB | 40 MB |

Record the output in the release evidence section. A size increase of more than 10% without
a documented justification is a review item.

### 6.4 Debuggable Verification (Android)

Verify `android:debuggable` is `false` in the merged release manifest before every production
release. A debuggable production build is a security vulnerability and a Google Play policy
violation.

```bash
aapt2 dump badging build/app/outputs/flutter-apk/app-arm64-v8a-prod-release.apk \
  | grep -i debuggable
```

Expected output: no lines (attribute absent = false by default). If it appears, investigate
`isDebuggable` in `android/app/build.gradle.kts` under the release build type.

Flutter copies the finished APKs to `build/app/outputs/flutter-apk/`; the build log prints the
exact file names.

### 6.5 Cleartext Traffic (Android)

The manifest sets `android:usesCleartextTraffic="false"`. Cleartext is off by default for apps that
target API 28 or higher; it is set explicitly anyway. There is no network security config. The app
has no network at all (`docs/security.md` §1.1).

### 6.6 Bundled Asset Audit

Before releasing, list the assets in the APK and confirm there are no secrets, keys or test data:

```bash
unzip -l build/app/outputs/flutter-apk/app-arm64-v8a-prod-release.apk "assets/*"
```

```powershell
tar -tf build\app\outputs\flutter-apk\app-arm64-v8a-prod-release.apk | Select-String "assets/"
```

### 6.7 Exported Components (Android)

Only `MainActivity` (the launcher) is exported. Check the merged release manifest: every other
activity, service and receiver must have `android:exported="false"` (`docs/security.md` §10).

---

## 7. Signing And Secret Handling

- Signing strategy: Strategy A — local file-based signing (single developer; see `docs/guidelines/flutter_build_flavors_guide.md`)
- Config location: `android/key.properties` on the release machine — gitignored; never committed; never in CI (`docs/guidelines/guideline.md` §2)
- Keystore files and their passwords: kept in `android/` and git-ignored; backed up as `docs/guidelines/guideline.md` §2.3 says — at least two separate secure backups, at least one of them offline (not cloud storage). Passwords live in a password manager.
- Keystore ownership: sreerajp
- Release keystore: `android/keystore.jks`; alias `sreerajp_mantrajapacounter`.
- Secret rotation process: generate a new keystore only if the existing key is compromised; note that changing the Play Store upload key requires contacting Google Play support and cannot be done unilaterally
- Rules:
  - Signing material MUST NOT be committed to source control.
  - `android/key.properties` MUST be listed in `.gitignore`.
  - Keystore files (`android/*.jks`, `android/*.keystore`) MUST be listed in `.gitignore`.
  - The build MUST fail clearly for `prod --release` if `android/key.properties` is absent (enforced via Gradle guard — see `docs/guidelines/flutter_build_flavors_guide.md`).

---

## 8. Release Checklist

Complete these items before every release.

### Code And Quality

- [ ] All changes committed; `git status` is clean.
- [ ] `dart format --output=none --set-exit-if-changed .` passes.
- [ ] `flutter analyze` adds no new warnings (zero is the goal, engineering standard §16.1).
- [ ] `flutter test` passes — all unit, widget, and integration tests.
- [ ] Golden tests pass (`flutter test --tags golden`). Run them on Windows — see section 16.
- [ ] Code generation: not used by this project (no `build_runner`). If it is ever added, run `dart run build_runner build --delete-conflicting-outputs` and check generated files are current.
- [ ] No critical or release-blocking bugs remain open.
- [ ] GitHub CI is green for the release commit.
- [ ] Release artifacts built locally, not in CI (engineering standard §19.3).

### Performance

- [ ] Counting screen profiled for jank on a physical mid-range Android device (release build, Profile mode).
- [ ] Cold startup time confirmed under 2 seconds on a mid-range device (release build).
- [ ] Counting timer confirmed as 2-second display updates and 5-second state updates (not 1-second polling).
- [ ] App size analyzed and within budget (optional size build, run before the hardened build — section 6.3); output recorded in release evidence.

### Security

- [ ] Security Baseline re-verified — every line of `docs/security.md` §1.1 is `verified` or `n/a`
      with a reason (engineering standard §15.1).
- [ ] No secrets in the shipped app — code, assets, `--dart-define` values, or native config files.
- [ ] No code path disables certificate checks (no trust-all `badCertificateCallback` or
      `HttpOverrides`); cleartext is off (section 6.5).
- [ ] No debug menus, test accounts, or backdoors in the production build.
- [ ] Only `MainActivity` is exported in the merged release manifest (section 6.7).
- [ ] `--obfuscate` and `--split-debug-info` flags present in all prod release build commands.
- [ ] No `--analyze-size` build was shipped or archived as the release artifact (section 6.3).
- [ ] Debug symbols archived at `releases/v<version>/symbols/android-prod-<version>/`.
- [ ] ProGuard rules verified — release build launches; counting flow and import/export work end-to-end.
- [ ] `android:debuggable=false` confirmed in merged release manifest.
- [ ] INTERNET permission confirmed absent from merged release manifest.
- [ ] No `mlkit`, `datatransport` or `firebase` entries in the merged release manifest
      (`build/app/intermediates/merged_manifest/prodRelease/processProdReleaseMainManifest/AndroidManifest.xml`).
- [ ] Permissions in manifest reviewed — only VIBRATE, CAMERA, POST_NOTIFICATIONS (Android 13+) and
      ACCESS_NOTIFICATION_POLICY. No storage permissions (READ_EXTERNAL_STORAGE,
      WRITE_EXTERNAL_STORAGE, READ_MEDIA_AUDIO) and no RECORD_AUDIO.
- [ ] OWASP Mobile Top 10 checklist signed off in `docs/security.md` section 12 (MUST under the
      Production App Extension; items that do not apply are `n/a`).
- [ ] Security checklist in `docs/security.md` section 18 completed.

### Product And Documentation

- [ ] Version in `pubspec.yaml` updated (`version: X.Y.Z+N`).
- [ ] `CHANGELOG.md` updated with user-visible changes.
- [ ] Play Store listing metadata reviewed (description, screenshots, feature graphic if changed).
- [ ] Privacy policy URL in Play Console opens without login, and
      [PRIVACY_POLICY.md](../PRIVACY_POLICY.md) matches the current permissions and features.
- [ ] Tablets and Chromebooks are excluded in Play Console → Device catalog (the app is portrait-only, phone-only).
- [ ] Before raising `targetSdk` to 37: handle landscape on large screens. The Android 16 portrait-lock opt-out (`PROPERTY_COMPAT_ALLOW_RESTRICTED_RESIZABILITY`) is ignored from API 37.

### Artifact Validation

- [ ] Release APK builds successfully with all hardening flags.
- [ ] APK installs on a clean Android 10 (API 29) device or emulator.
- [ ] APK installs on a recent Android (API 34+) device.
- [ ] Launcher and About screen show the prod app name from `app_config.json` in each language (English: "SreerajP MantraJapa Counter", not "... Dev").
- [ ] Version name and build number are correct in the About screen.
- [ ] End-to-end counting flow: create counter → count → session recorded → history shows session.
- [ ] Import/export round-trip works on the release build.
- [ ] Notifications work on release build (mala completion and daily goal achievement).

---

## 9. Android Release Steps

1. Pull the release commit and verify `git status` is clean.
2. Verify version in `pubspec.yaml`.
3. `flutter pub get`.
4. Code generation: not used by this project (skip; run `dart run build_runner build --delete-conflicting-outputs` only if it is ever added).
5. `dart format --output=none --set-exit-if-changed .`
6. `flutter analyze`
7. `flutter test`
8. Optional: run the size-analysis build (section 6.3) **now, before** the hardened build; record output in `releases/v<version>/size-analysis.txt`.
9. Build release artifacts with all hardening flags (commands below).
10. Verify `android:debuggable=false`, cleartext off and exported components in the merged manifest (sections 6.4–6.7).
11. Install APK on a clean Android 10 device; run the end-to-end counting flow.
12. Archive debug symbols from `build/symbols/` to `releases/v<version>/symbols/`.
13. Complete the Google Play gate (`docs/guidelines/platform_store_readiness.md` §2), then upload the AAB to Google Play (internal testing track first; promote to production after validation).
14. Direct APK: before each direct-APK release, check Google's Android developer verification status and complete any developer or package / signing-key registration it asks for (`docs/guidelines/platform_store_readiness.md` §2.5A). Then publish the split APKs.
15. Tag the release once: `git tag v<X.Y.Z> && git push origin v<X.Y.Z>` — `<X.Y.Z>` is the `pubspec.yaml` version without `+build` (section 3).

### Android Build Commands

```bash
flutter pub get
dart format --output=none --set-exit-if-changed .
flutter analyze
flutter test

# Optional size analysis — run it BEFORE the hardened builds below (section 6.3)
flutter build apk --flavor prod --release \
  --analyze-size

VERSION=$(grep '^version:' pubspec.yaml | cut -d' ' -f2 | cut -d'+' -f1 | tr -d '\r')

# Split APKs for direct sideload distribution (arm64-v8a covers most modern devices)
# Output: build/app/outputs/flutter-apk/app-<abi>-prod-release.apk
flutter build apk \
  --flavor prod \
  --release \
  --obfuscate \
  --split-debug-info=build/symbols/android-prod-$VERSION/ \
  --split-per-abi

# App Bundle for Google Play
flutter build appbundle \
  --flavor prod \
  --release \
  --obfuscate \
  --split-debug-info=build/symbols/android-prod-$VERSION/
```

**App Bundle for Google Play on Windows (PowerShell) — this is the command used for Play
uploads.** It gives the same result as the bash App Bundle command above:

```powershell
$version = ((Select-String -Path pubspec.yaml -Pattern '^version:\s*(.+)$').Matches[0].Groups[1].Value -split '\+')[0]
flutter build appbundle --flavor prod --release --obfuscate "--split-debug-info=build/symbols/android-prod-$version/"
```

---

## 10. iOS Release Steps

Not applicable — iOS is not a supported platform for this release.

---

## 11. Windows Release Steps

Not applicable — Windows is not a supported platform for this release.

---

## 12. Distribution Channels

| Channel | Artifact | Audience | Notes |
|---------|----------|----------|-------|
| Google Play Store (production) | AAB | All public users | Promoted from internal testing track after validation |
| Google Play Internal Testing | AAB | sreerajp (developer self-testing) | First submission target before promoting to production |
| Direct APK | arm64-v8a split APK | Beta testers / sideload users | Signed with the release keystore; Android developer verification checked before each release (store gate §2.5A); arm64-v8a covers most modern Android devices |

---

## 13. Rollback And Hotfix Process

- Rollback trigger: confirmed data corruption bug, crash-on-launch affecting more than 1% of sessions, or a security issue identified post-release
- Rollback method: halt rollout in Google Play Console (Releases → Production → Halt rollout); the previously active version remains live for users who have already updated
- Hotfix branch naming: `hotfix/v<major>.<minor>.<patch+1>` (e.g., `hotfix/v5.0.1`)
- Verification after rollback or hotfix:
  - The full release checklist MUST be completed even for a one-line hotfix.
  - Debug symbols for the hotfix build MUST be archived.

---

## 14. Release Evidence

Record links or references to release evidence after each release.

- CI run: link to the green GitHub CI run for the release commit (checks only — section 17)
- Test report: `flutter test` output; save as `releases/v<version>/test-report.txt`
- Size analysis output: `releases/v<version>/size-analysis.txt`
- Debug symbols archive: `releases/v<version>/symbols/android-prod-<version>/`
- Built artifact: `build/app/outputs/bundle/prodRelease/app-prod-release.aab`
- Release notes: `CHANGELOG.md` entry for `v<version>`
- Store submission: Google Play Console → release track → build record
- Security checklist sign-off: completed locally by sreerajp before each submission
- OWASP checklist sign-off (required under the Production App Extension): `docs/security.md` §12, signed by sreerajp / `<date>`

---

## 15. Post-Release Checks

- [ ] APK / AAB confirmed as live in Google Play Console.
- [ ] Install from Play Store on a clean device; verify correct version name in About screen.
- [ ] End-to-end counting flow verified on the Play Store build.
- [ ] Crash and ANR reports reviewed in Google Play Console (Android Vitals) within 48 hours of release.
- [ ] User-reported issues in Play Store reviews triaged.
- [ ] Release tag created and pushed: `git tag -l v<X.Y.Z>` (version without `+build`, section 3).
- [ ] Debug symbols confirmed at `releases/v<version>/symbols/`.
- [ ] Follow-up tasks recorded (bugs found during validation, deferred features).

---

## 16. UI Package Upgrades (`material_ui` / `cupertino_ui`)

Since Flutter 3.47, Material and Cupertino widgets come from the `material_ui` and
`cupertino_ui` packages, not from the Flutter SDK. They can get new releases every week.
Both use a caret (`^`) constraint in `pubspec.yaml`, as engineering standard §6.1 requires;
`pubspec.lock` holds the exact versions. To keep visual changes under control, upgrade them
(`flutter pub upgrade material_ui cupertino_ui`) only with this checklist.

- [ ] Upgrade the UI packages in **their own change**. Never in the same change as a
      Flutter SDK upgrade or other package upgrades, so any breakage has one clear cause.
- [ ] Read the package changelogs on pub.dev. Note any visual or breaking changes in the plan.
- [ ] Upgrade the packages (raise the `^` constraint in `pubspec.yaml` if needed), then run `flutter pub get`.
- [ ] `flutter analyze` adds no new warnings.
- [ ] `flutter test` passes.
- [ ] If golden tests fail, look at the difference images in `test/**/failures/`.
      - If the change is expected, run `flutter test --update-goldens --tags golden`
        and commit the new images in `test/**/goldens/`.
      - If it is not expected, stay on the old version.
- [ ] Check by hand on a device: counting screen, counter list, bottom sheets, dialogs,
      and settings — in all three languages (English, Malayalam, Sanskrit).

### Golden tests and platforms

Golden tests compare a widget's picture to a saved reference image in a `goldens/`
folder next to the test. Text is drawn slightly differently on Windows, macOS and Linux,
so the reference images are made on **Windows** and must only be updated on Windows.
`flutter test --tags golden` runs only the golden tests; `flutter test` runs everything.

## 17. GitHub CI

GitHub Actions runs **checks only**. It does not build, sign or release the app, and it
uses no secrets (no keystore, no passwords).

### What runs

`.github/workflows/ci.yml` runs on every push to `main`, on every pull request, and by hand
from the **Actions** tab. On Linux, with the
same Flutter version as the project, it runs:

1. `dart format --output=none --set-exit-if-changed lib test tool`
2. `flutter gen-l10n`, then `git diff --exit-code lib/l10n` — fails if an `.arb` file
   was changed but the generated localization files were not re-generated and committed.
3. `flutter analyze` — must report 0 issues.
4. `flutter test --exclude-tags golden`

Golden tests are left out because the reference images only match on Windows
(section 16). Run `flutter test --tags golden` locally before a release.

When you upgrade Flutter, also change `flutter-version` in `ci.yml`.

### Dependency updates

Dependencies are updated by hand (engineering standard §19.2). There is no Dependabot or other
update bot, and `.github/dependabot.yml` must not be added. Each update needs its own plan and
change log, and UI package updates follow the section 16 checklist. Only the user updates the
`docs/guidelines` submodule version — AI agents never change it.

Golden tests being skipped in CI is a known deviation from §19.1, recorded in
`docs/architecture.md` section 19.
