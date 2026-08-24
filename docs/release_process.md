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
- Version history context: Android app reached v4.34 (build code 12); Flutter rewrite begins at v5.0.0+1 to signal the platform change
- Build-number increment rule: increment by 1 for every build submitted to Google Play; never reuse or skip a build number
- Git tag format: `vX.Y.Z` (e.g., `v5.0.0`)

---

## 4. Branch And Merge Policy

- Release branch strategy: trunk-based — releases are cut directly from `main`
- Hotfix strategy: fix on `main`; cherry-pick to a temporary `hotfix/vX.Y.Z` branch only if a patch must be applied against a specific shipped version while `main` has moved ahead
- Required checks before merge:
  - `dart format --output=none --set-exit-if-changed .` passes
  - `flutter analyze` passes with zero warnings
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

All production release builds MUST include the following flags. Omitting any of them is a
release-blocking issue.

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

Reference: `android/app/proguard-rules.pro` and `docs/flutter_build_flavors_guide.md`.

### 6.3 App Size Analysis

Run before every release to catch dependency bloat early:

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
aapt2 dump badging build/app/outputs/apk/prod/release/app-arm64-v8a-prod-release.apk \
  | grep -i debuggable
```

Expected output: no lines (attribute absent = false by default). If it appears, investigate
`isDebuggable` in `android/app/build.gradle.kts` under the release build type.

---

## 7. Signing And Secret Handling

- Signing strategy: Strategy A — local file-based signing (single developer; see `docs/flutter_build_flavors_guide.md`)
- Config location: `android/key.properties` — gitignored; never committed
- Keystore files: kept in `android/` and git-ignored; backed up in two separate locations outside the repository
- Keystore ownership: sreerajp
- Release keystore: `android/keystore.jks`; alias `sreerajp_mantrajapacounter`. Keep at least one offline backup in a separate location.
- Secret rotation process: generate a new keystore only if the existing key is compromised; note that changing the Play Store upload key requires contacting Google Play support and cannot be done unilaterally
- Rules:
  - Signing material MUST NOT be committed to source control.
  - `android/key.properties` MUST be listed in `.gitignore`.
  - Keystore files (`android/*.jks`, `android/*.keystore`) MUST be listed in `.gitignore`.
  - The build MUST fail clearly for `prod --release` if `android/key.properties` is absent (enforced via Gradle guard — see `docs/flutter_build_flavors_guide.md`).

---

## 8. Release Checklist

Complete these items before every release.

### Code And Quality

- [ ] All changes committed; `git status` is clean.
- [ ] `dart format --output=none --set-exit-if-changed .` passes.
- [ ] `flutter analyze` passes with zero warnings.
- [ ] `flutter test` passes — all unit, widget, and integration tests.
- [ ] Code generation is current: `dart run build_runner build --delete-conflicting-outputs`.
- [ ] No critical or release-blocking bugs remain open.

### Performance

- [ ] Counting screen profiled for jank on a physical mid-range Android device (release build, Profile mode).
- [ ] Cold startup time confirmed under 2 seconds on a mid-range device (release build).
- [ ] Counting timer confirmed as 2-second display updates and 5-second state updates (not 1-second polling).
- [ ] App size analyzed and within budget (see section 6.3); output recorded in release evidence.

### Security

- [ ] `--obfuscate` and `--split-debug-info` flags present in all prod release build commands.
- [ ] Debug symbols archived at `releases/v<version>/symbols/android-prod-<version>/`.
- [ ] ProGuard rules verified — release build launches; counting flow and import/export work end-to-end.
- [ ] `android:debuggable=false` confirmed in merged release manifest.
- [ ] INTERNET permission confirmed absent from merged release manifest.
- [ ] Permissions in manifest reviewed — only VIBRATE, POST_NOTIFICATIONS (Android 13+), READ_MEDIA_AUDIO (Android 13+), READ_EXTERNAL_STORAGE (maxSdkVersion=32).
- [ ] Security checklist in `docs/security.md` section 18 completed.

### Product And Documentation

- [ ] Version in `pubspec.yaml` updated (`version: X.Y.Z+N`).
- [ ] `CHANGELOG.md` updated with user-visible changes.
- [ ] Play Store listing metadata reviewed (description, screenshots, feature graphic if changed).

### Artifact Validation

- [ ] Release APK builds successfully with all hardening flags.
- [ ] APK installs on a clean Android 10 (API 29) device or emulator.
- [ ] APK installs on a recent Android (API 34+) device.
- [ ] App displays the prod app name "Mantra Japa Counter" (not "Mantra Japa Counter Dev").
- [ ] Version name and build number are correct in the About screen.
- [ ] End-to-end counting flow: create counter → count → session recorded → history shows session.
- [ ] Import/export round-trip works on the release build.
- [ ] Notifications work on release build (mala completion and daily goal achievement).

---

## 9. Android Release Steps

1. Pull the release commit and verify `git status` is clean.
2. Verify version in `pubspec.yaml`.
3. `flutter pub get`.
4. `dart run build_runner build --delete-conflicting-outputs`.
5. `dart format --output=none --set-exit-if-changed .`
6. `flutter analyze`
7. `flutter test`
8. Build release artifacts (commands below).
9. Run size analysis; record output in `releases/v<version>/size-analysis.txt`.
10. Verify `android:debuggable=false` in merged manifest.
11. Install APK on a clean Android 10 device; run the end-to-end counting flow.
12. Archive debug symbols from `build/symbols/` to `releases/v<version>/symbols/`.
13. Upload AAB to Google Play (internal testing track first; promote to production after validation).
14. Tag the release: `git tag v<version> && git push origin v<version>`.

### Android Build Commands

```bash
flutter pub get
dart run build_runner build --delete-conflicting-outputs
dart format --output=none --set-exit-if-changed .
flutter analyze
flutter test

# Split APKs for direct sideload distribution (arm64-v8a covers most modern devices)
flutter build apk \
  --flavor prod \
  --release \
  --obfuscate \
  --split-debug-info=build/symbols/android-prod-$(grep '^version:' pubspec.yaml | cut -d' ' -f2 | cut -d'+' -f1)/ \
  --split-per-abi

# App Bundle for Google Play
flutter build appbundle \
  --flavor prod \
  --release \
  --obfuscate \
  --split-debug-info=build/symbols/android-prod-$(grep '^version:' pubspec.yaml | cut -d' ' -f2 | cut -d'+' -f1)/

# Size analysis
flutter build apk --flavor prod --release \
  --analyze-size
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
| Direct APK | arm64-v8a split APK | Beta testers / sideload users | Distributed manually; arm64-v8a covers most modern Android devices |

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

- CI run: n/a (no CI pipeline in initial release; all checks run locally)
- Test report: `flutter test` output; save as `releases/v<version>/test-report.txt`
- Size analysis output: `releases/v<version>/size-analysis.txt`
- Debug symbols archive: `releases/v<version>/symbols/android-prod-<version>/`
- Built artifact: `build/app/outputs/bundle/prodRelease/app-prod-release.aab`
- Release notes: `CHANGELOG.md` entry for `v<version>`
- Store submission: Google Play Console → release track → build record
- Security checklist sign-off: completed locally by sreerajp before each submission

---

## 15. Post-Release Checks

- [ ] APK / AAB confirmed as live in Google Play Console.
- [ ] Install from Play Store on a clean device; verify correct version name in About screen.
- [ ] End-to-end counting flow verified on the Play Store build.
- [ ] Crash and ANR reports reviewed in Google Play Console (Android Vitals) within 48 hours of release.
- [ ] User-reported issues in Play Store reviews triaged.
- [ ] Release tag confirmed: `git tag -l v<version>`.
- [ ] Debug symbols confirmed at `releases/v<version>/symbols/`.
- [ ] Follow-up tasks recorded (bugs found during validation, deferred features).
