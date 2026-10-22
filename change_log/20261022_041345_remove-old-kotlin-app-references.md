# Change log — Remove the leftovers of the old Kotlin app

**Date:** 2026-10-22 04:13
**Plan:** `plans/20261022_041011_remove-old-kotlin-app-references.md` (status: `completed`)

---

## Summary

The old Kotlin/Compose/Room app no longer exists, so every reference to it outside the
history folders was removed or reworded. The "byte-compatible with the Android
Room/Gson export" rule was replaced by a rule about this app's own backups, and a new
test now locks the backup format. No app behaviour changed.

`flutter analyze`: no issues. `flutter test`: 376 tests pass (372 before; 4 new).
Final search found no "Gson", "Room", "Kotlin app", "original Android", "Android
version" or "v4.34" outside `plans/`, `change_log/`, `docs/guidelines/` and build
settings.

---

## Changes

### Rule (`CLAUDE.md`, `AGENTS.md`)
Hard rule 3 now says: every app version must import backups made by any earlier version
of this app (`exportVersion` 1); never rename or remove a JSON field; new fields must
be optional with a default. It points to `test/repositories/backup_format_test.dart`.

### Docs
- `docs/architecture.md`: removed "original Android version", "mirrors Kotlin Flow",
  "Android Room schema compatible", the Room type-mapping risk, the old-app fixture
  lines and "compare to Android version". Import goal, `ExportData` row, `Counter` row,
  schema line, fixtures line, test line and the import risk now describe this app's own
  backups and the new format test.
- `docs/security.md`: import is "files from this app's export (any earlier version)";
  test lines now use the made-up fixture.
- `docs/features.md`: "Gson & Android Schema Compatibility" → "Backward-Compatible Backups".
- `docs/implementation_progress.md`, `docs/implementation_plan.md`: removed
  "byte-compatible Android import", "Flutter migration" and "legacy Android (Compose +
  Room)" wording.
- `docs/release_process.md`: removed the "Android app reached v4.34" version-history line.
- `README.md`: migration step 6 now says the export must stay "readable by every later
  version of this app".

### On-screen text (`lib/l10n/*.arb`, regenerated with `flutter gen-l10n`)
- Features screen `featJsonExportH3`: "Room/Gson compatibility" → "Works with older
  backups" (en); "പഴയ ബാക്കപ്പുകളും പുനഃസ്ഥാപിക്കാം" (ml). Sanskrit already said
  "easy restore" — unchanged.
- Help screen `helpBackupImportBullet5` (found by the final search; not listed in the
  plan): "Backup files from the older Android version of this app can also be
  imported." → "Backup files from earlier versions of this app can always be
  imported." in en, ml and sa.

### Code comments only
Reworded comments that said "Kotlin app", "Android Gson", "Room" or "original Android"
in: `lib/models/active_session.dart`, `counter.dart`, `counter_status.dart`,
`export_data.dart`, `japa_session.dart`; `lib/providers/counter_stats_provider.dart`,
`counting_provider.dart`, `history_provider.dart`;
`lib/screens/history/history_screen.dart`; `lib/services/export_service.dart`,
`haptic_feedback_service.dart`, `notification_service.dart`,
`session_recovery_service.dart`. The `status` strings and JSON field names are now
documented as part of this app's backup format.

### Tests
- New `test/fixtures/backup_format_v1.json`: made-up backup (5 counters covering
  default, locked + Malayalam name, no mala, finished, custom step / initial count /
  mala size; 6 sessions). No real data.
- New `test/repositories/backup_format_test.dart` (4 tests): fixture is format 1; every
  field imports correctly; export after import gives back exactly the same counter and
  session fields and values; a counter without `isLocked` / `malaSize` imports with
  defaults.
- `test/models/counter_test.dart`: group renamed to "JSON round-trip".
- `test/fixtures/README.md`: rewritten (no real data; never edit a fixture to make a
  test pass).

### Repository hygiene
- `.gitignore`: added `/mantra_japa_counter_backup*.json` and `/*.json.enc`, so backup
  files placed in the project root are never committed. Your file
  `mantra_japa_counter_backup (1).json` is now ignored; it was not moved or deleted.

### Kept on purpose
Import defaults for missing fields, the `status` strings, the earlier-Flutter "legacy"
active-session key, `help_screen.dart`, Kotlin build settings and `MainActivity.kt`,
and all `plans/` and `change_log/` history.

### Outside the repository
Removed my memory note that pointed to the old Kotlin source folder; the project note
now says this is a Flutter-only app.
