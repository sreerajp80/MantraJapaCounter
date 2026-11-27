# Plan: Back up settings and the running count

**Status:** completed

## The issue

Export (JSON file and QR transfer) only saves two lists from the database:
`counters` and `sessions`. Two things are missing:

1. **Settings.** All user settings (Meru pause, sounds, vibration, language,
   daily reminder, and so on) live in SharedPreferences
   (`lib/repositories/settings_repository.dart`). Export never reads them.
2. **The running count on the mantra screen.** A part-done mala is an
   `ActiveSession`, kept per counter in SharedPreferences. It is not exported, so
   after import the counting screen starts fresh.

There is also a related bug. A full import deletes every session in the
database, but it leaves the phone's old running counts in SharedPreferences. They
can then point to session rows that no longer exist.

## Decisions (agreed with the user)

- **All exports carry settings**: full backup, selected-counter export, and QR
  transfer.
- **Only a full import applies settings.** A selected import (for example, one
  counter from a friend's phone by QR) never changes this phone's settings.
  (Changed on the user's request during implementation; the first version of
  this plan applied settings on selected imports too.)
- Running counts go along with the counters they belong to (all counters for a
  full export, only the chosen ones for a selected export).

## The fix

### File format (stays `exportVersion` 1)

Add two **optional** top-level fields to the backup JSON. No field is renamed or
removed (hard rule 3):

- `settings` — an object with the user settings.
- `activeSessions` — a list of running counts (same fields as
  `ActiveSession.toMap()`).

Older backups have neither field, so they still import. Older app versions
ignore fields they do not know, so `exportVersion` stays 1.

### What goes into `settings`

Included: screen brightness, daily-goal / lifetime-goal / mala notifications,
mala sound, vibration, tap vibration, feedback volume, vibration strength,
language, Do Not Disturb, dimmed chanting mode, Meru pause (on/off, seconds,
mode, taps), pacing hint, daily reminder (on/off, time).

Left out on purpose (they only make sense on the phone that made them):

- Custom notification sound and lifetime-goal sound (URI + name). These are links
  to sound files on that one phone, so they would break on another phone.
- "Notification permission already asked" flag.

### Export

- Each running count is saved as **paused**, with its active time up to the
  moment of export. So the gap between export and import is not counted as
  chanting time.

### Import

- **Full import** (file or QR, nothing selected):
  1. Replace the database as today (one transaction).
  2. Clear all running counts on the phone (fixes the stale-count bug above,
     also for old backups that have no `activeSessions`).
  3. Write the running counts from the file.
  4. If the file has `settings`, write them. If not (old backup), keep the
     phone's settings.
- **Selected import**: merge counters and sessions as today. For each chosen
  counter that has a running count in the file, replace that counter's running
  count. Other counters are not touched. Settings in the file are **ignored**;
  the phone keeps its own settings.
- After a full import, the settings screen and app reload from storage: brightness is
  applied, language changes, and the daily reminder is scheduled again (new time,
  new language).

### Validation (never crash on bad input — hard rule 4)

- Wrong JSON types in `settings` or `activeSessions` → the whole file is refused
  with a clear `ValidationException`, before anything is written (same as today).
- A running count must belong to a counter in the file, have a non-empty session
  id, and no negative numbers.
- Language must be `en`, `ml`, `sa`, or missing. Number settings out of range fall
  back to the normal default (the repository getters already do this; setters
  clamp where they already clamp).

## Files to change

| File | Change |
|------|--------|
| `lib/models/backup_settings.dart` (new) | Pure-Dart model for the `settings` object, with `toJson` / `fromJson`; every field optional. |
| `lib/models/export_data.dart` | Add optional `settings` and `activeSessions` fields; read/write them. |
| `lib/repositories/settings_repository.dart` | `exportSettings()`, `importSettings()`, `getAllActiveSessions` reuse, `replaceActiveSessions()` for import. |
| `lib/services/export_service.dart` | Take `SettingsRepository`; add settings + paused running counts on export; write them on import; new validation. |
| `lib/providers/app_providers.dart` | Pass `SettingsRepository` into `ExportService`. |
| `lib/providers/optical_sync_provider.dart` | QR send uses the export service path so settings + running counts go along; reload settings after QR import. |
| `lib/providers/settings_provider.dart` | New `reloadFromRepository()`: re-read settings, apply brightness, re-sync daily reminder. |
| `lib/screens/settings/backup_settings_screen.dart` | Call `reloadFromRepository()` after import. |
| `lib/screens/counter_list/import_export_dialog.dart` | Call `reloadFromRepository()` after import. |
| `test/models/export_data_test.dart` | Round-trip with and without the new fields. |
| `test/models/backup_settings_test.dart` (new) | Round-trip, missing fields, bad types. |
| `test/repositories/settings_repository_test.dart` | Export/import settings; replace running counts. |
| `test/services/export_service_test.dart` | Export includes settings + paused running counts; full and selected import restore them; old file clears stale running counts; bad values refused. |
| `test/repositories/backup_format_test.dart` + `test/fixtures/backup_format_v1_settings.json` (new) + `test/fixtures/README.md` | New made-up fixture with the new fields. The old v1 fixture is **not** edited. |
| `test/providers/settings_provider_test.dart` | `reloadFromRepository()` test. |
| `docs/architecture.md`, `docs/security.md`, `docs/features.md` | Describe the new backup contents. |

No ARB (text) changes are expected. No new dependencies.

## Security impact

Backup files now also hold settings and running counts. These are not secret
(counter names are already in the file). Encryption stays optional as today.
Device-only values (sound file links) are not exported. Input validation is
extended to the new fields. No new permissions, no network.

## Checks after the change

- `dart format .`, `flutter analyze`, `flutter test`.
- Manual test on the dev flavor: change settings, count half a mala, export,
  clear data, import → settings and the half mala are back.
