# Change log — pub package upgrade (minor / patch)

Implements plan: [plans/20261127_041453_pub_package_upgrade.md](../plans/20261127_041453_pub_package_upgrade.md)

## What changed

### `pubspec.yaml`

- `flutter_local_notifications: ^23.0.0-dev.3` → `^23.0.4`. The app now uses the stable
  release and cannot fall back to a pre-release.

### `pubspec.lock`

42 locked versions changed. No package was added or removed. No major-version jump.

Direct dependencies:

| Package | Old | New |
|---------|-----|-----|
| `camera` | 0.12.1 | 0.12.2 |
| `file_picker` | 13.1.0 | 13.4.1 |
| `flutter_local_notifications` | 23.0.0-dev.4 | 23.0.4 |
| `flutter_riverpod` | 3.4.3 | 3.5.0 |
| `go_router` | 18.1.0 | 18.1.4 |
| `sqflite` | 2.4.4+1 | 2.4.6 |
| `timezone` | 0.11.1 | 0.11.2 |
| `sqflite_common_ffi` (dev only) | 2.4.4 | 2.4.7 |

The rest are transitive packages that moved with them (for example
`shared_preferences_android` 2.5.5, `jni` 1.2.1, `sqflite_android` 2.4.6,
`camera_android_camerax` 0.7.6+2, and the `flutter_local_notifications_*` platform packages,
now all stable).

### `docs/dependencies.md`

- Notifications row: `^23.0.0-dev.3` → `^23.0.4`.

## Not changed (as planned)

- `material_ui` stays 1.7.0 and `cupertino_ui` stays 1.1.2 (release_process.md §16: own change).

## Note on how it was done

`flutter pub upgrade --unlock-transitive <packages>` also upgraded `material_ui` and
`cupertino_ui`, even though they were not in the list. They were put back at once with
`flutter pub downgrade material_ui cupertino_ui` (their `^` limits make the lowest allowed
version the old one). Only those two packages changed in that step. For a future UI-package
freeze, check the lock file after any `--unlock-transitive` upgrade.

## Checks

- `dart format --set-exit-if-changed .` — 0 files changed.
- `flutter analyze` — no issues.
- `flutter test` — all 481 tests passed.

## Not verified yet

- An Android build and a run on a phone. Several upgraded packages have native Android code
  (`camera`, `file_picker`, `shared_preferences_android`, `sqflite_android`, `jni`). Worth
  checking by hand: Optical Sync receive (camera), picking a backup file and a tone file, the
  daily reminder notification, and that the merged manifest has no new permissions.
