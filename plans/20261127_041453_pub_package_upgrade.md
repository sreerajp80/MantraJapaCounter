# Upgrade pub packages (minor / patch, within current constraints)

**Status:** completed

## What the issue is

`flutter pub outdated` shows 44 packages locked to older versions. All of them can move to
newer versions **without** changing a major version (no breaking `^` jump). The one
notable item: `flutter_local_notifications` is on a pre-release (`23.0.0-dev.4`) while the
stable `23.0.4` is out.

Direct dependencies that will move:

| Package | Now | New |
|---------|-----|-----|
| `camera` | 0.12.1 | 0.12.2 |
| `file_picker` | 13.1.0 | 13.4.1 |
| `flutter_local_notifications` | 23.0.0-dev.4 | 23.0.4 (stable) |
| `flutter_riverpod` | 3.4.3 | 3.5.0 |
| `go_router` | 18.1.0 | 18.1.4 |
| `sqflite` | 2.4.4+1 | 2.4.6 |
| `timezone` | 0.11.1 | 0.11.2 |
| `sqflite_common_ffi` (dev only) | 2.4.4 | 2.4.7 |

About 35 transitive packages move with them (for example `shared_preferences_android`
2.4.28 → 2.5.5, `jni` 1.1.0 → 1.2.1, `sqflite_android`, `camera_android_camerax`).

**Not upgraded in this change:**

- `material_ui` (1.7.0 → 1.11.1) and `cupertino_ui` (1.1.2 → 1.1.7). `docs/release_process.md`
  §16 says to upgrade them in their own change, never together with a Flutter SDK upgrade or
  other package upgrades, and with a visual check. They need a separate plan.
- Major-version jumps (none for direct dependencies; `qr` 4.x and `cross_file` 0.4 are blocked
  by other packages and stay).

## Files to change

| File | Change |
|------|--------|
| `pubspec.lock` | New locked versions (written by pub, no manual edit) |
| `pubspec.yaml` | `flutter_local_notifications: ^23.0.0-dev.3` → `^23.0.4`, so the app can never fall back to a pre-release |
| `docs/dependencies.md` | Notifications row: `^23.0.0-dev.3` → `^23.0.4` |

Other `^` lower bounds in `pubspec.yaml` stay as they are. The lock file holds the exact
versions; raising every lower bound adds churn with no benefit for an app.

## Plan for the fix

1. Edit the `flutter_local_notifications` constraint in `pubspec.yaml` and `docs/dependencies.md`.
2. Upgrade every direct dependency except the two UI packages, with their transitive
   dependencies:
   `flutter pub upgrade --unlock-transitive camera file_picker flutter_local_notifications flutter_riverpod go_router sqflite timezone sqflite_common_ffi shared_preferences path_provider share_plus package_info_plus audioplayers qr_flutter cryptography uuid path`
3. Check `pubspec.lock` diff: `material_ui` must still be 1.7.0 and `cupertino_ui` 1.1.2.
4. Run `dart format --set-exit-if-changed .`, `flutter analyze`, `flutter test`.
5. If analyze shows new deprecations from the upgrades: fix small ones; report bigger ones.
6. Write the change log.

## Risks

- **The Android build is not covered by analyze or tests.** `camera`, `file_picker`,
  `shared_preferences_android`, `sqflite_android` and `jni` all have native Android code. Only a
  real build (and a quick run on a phone: camera / Optical Sync, file picker, a notification)
  proves them. The Flutter 3.50.1 dev build from the previous plan is also not run yet. If the
  build now fails, the cause could be either change. Running that build is still the user's step.
- `flutter_local_notifications` dev → stable: the API may have changed slightly between the
  pre-release and 23.0.4. `flutter analyze` will show it if so.

**Security impact:** Dependency versions only. No new packages, no new permissions, no network.
Newer patch versions usually include fixes. I will check that no upgraded package adds a new
Android permission (merged manifest is checked at build time — part of the user's build step).
