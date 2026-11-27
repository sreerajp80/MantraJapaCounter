# Change log: Back up settings and the running count

Implements plan: `plans/20261121_155352_backup_settings_and_running_count.md`

## What changed

Every export (full backup file, selected-counter export, QR transfer) now also
holds:

- the **user settings** (new optional `settings` object), and
- the **running count** of each exported counter — the part-done mala on the
  counting screen (new optional `activeSessions` list). It is saved paused, so
  the time between export and import is not counted as chanting time.

The format stays `exportVersion` 1. Both fields are optional, so older backups
still import and older app versions skip the new fields.

Import:

- **Full import** replaces the database (as before), clears every running count
  on the phone, writes the ones from the file, and writes the settings when the
  file has them. Clearing also fixes an old bug: running counts used to stay
  behind after a full import and could point at deleted sessions.
- **Selected import** writes only the chosen counters' running counts. It
  **never changes settings**. (Changed on the user's request during
  implementation; the first plan version applied settings here too.)
- After a full import (file or QR), the app reloads settings: brightness is
  applied, the language changes, and the daily reminder is scheduled again or
  cancelled.

Not exported (device-only): custom notification / lifetime-goal sound links, and
the "notification permission already asked" flag.

Validation: a running count must belong to a counter in the file, appear once per
counter, have a non-empty id, step of at least 1, and no negative values. The
language must be `en`, `ml`, `sa`, or empty (follow the phone). A wrong type in
`settings` refuses the whole file before anything is written.

## Files

| File | Change |
|------|--------|
| `lib/models/backup_settings.dart` | New pure-Dart model for the `settings` object. |
| `lib/models/export_data.dart` | Optional `settings` and `activeSessions`; `copyWith`. |
| `lib/repositories/settings_repository.dart` | `exportSettings()`, `importSettings()`, `replaceActiveSessions()`. |
| `lib/services/export_service.dart` | Takes `SettingsRepository`; new `buildExportData()`; applies extras on import; new validation. |
| `lib/providers/app_providers.dart` | Passes `SettingsRepository` to `ExportService`. |
| `lib/providers/optical_sync_provider.dart` | QR send uses `buildExportData()`; full QR import reloads settings. |
| `lib/providers/settings_provider.dart` | Shared `_readSettings()`; new `reloadFromRepository()`. |
| `lib/screens/settings/backup_settings_screen.dart`, `lib/screens/counter_list/import_export_dialog.dart` | Reload settings after import. |
| `test/models/backup_settings_test.dart` (new), `test/models/export_data_test.dart`, `test/repositories/settings_repository_test.dart`, `test/services/export_service_test.dart`, `test/providers/settings_provider_test.dart`, `test/repositories/backup_format_test.dart`, `test/screens/backup_settings_screen_test.dart`, `test/screens/optical_sync_screen_test.dart` | New and updated tests. |
| `test/fixtures/backup_format_v1_settings.json` (new), `test/fixtures/README.md` | New made-up fixture; the old v1 fixture is unchanged. |
| `docs/architecture.md`, `docs/security.md`, `docs/features.md` | Describe the new backup contents. |

## Checks

- `dart format`: clean.
- `flutter analyze`: no issues.
- `flutter test`: all 481 tests pass.
- Not yet tested by hand on a phone.

## Not done (follow-up)

- The in-app help text `helpBackupExportBullet1` (en / ml / sa ARB files) still
  says only counters, goals and session history go into the backup. It should
  also mention settings and the running count. This needs its own small plan.

## Security impact

Backup files now also hold settings and running counts. These are not secret
(counter names were already in the file). Optional encryption is unchanged.
Device-only sound links are not exported. Validation covers the new fields. No
new permissions, no network.
