# Plan — Remove the leftovers of the old Kotlin app

**Status:** completed

**Date:** 2026-10-22 04:10
**Change log (after work is done):** `change_log/20261022_<hhMMss>_remove-old-kotlin-app-references.md`, timed after this plan.

---

## 1. Issue

The old Kotlin/Compose/Room version of the app no longer exists (your decision,
2026-10-22). Only this Flutter app is left. But many files still talk about it:

- A **hard rule** in `CLAUDE.md` and `AGENTS.md` says the JSON export must stay
  "byte-compatible with the original Android Room/Gson export format".
- **Docs** describe Room/Gson compatibility, "the original Android version", old-app
  fixtures, and v4.34 version history.
- **User-visible text:** the Features screen shows a "Room/Gson compatibility"
  heading (English and Malayalam; Sanskrit already says "easy restore").
- **Code comments** say "mirrors / matches the Kotlin app".
- **Tests:** a test group is named "Android Gson compatibility"; `test/fixtures/README.md`
  asks for an old-app export.

What still matters is that **this app can always read its own older backups** (users
keep backup files, and the optical sync uses the same format). The plan replaces the
old-app rule with that rule, and adds a test that locks the format.

---

## 2. What changes

### 2.1 The hard rule (`CLAUDE.md`, `AGENTS.md`)
Replace rule 3 with:

> **Import compatibility**: Every app version must import backups made by any earlier
> version of this app (export format `exportVersion` 1). Never rename or remove a JSON
> field; new fields must be optional, with a default when missing.

Also in `CLAUDE.md` "Testing rules": "JSON export/import compatibility" stays, pointing to
the new format test.

### 2.2 Docs
| File | Change |
|------|--------|
| `docs/architecture.md` | Remove "original Android version", "mirrors Kotlin Flow", "Android Room schema compatible", the Room-vs-sqflite risk, and the old-app fixture lines. Reword the import goal, the `ExportData` row, the schema line (`5`, no Room note), the fixtures line and the import test line to "this app's own earlier backups". |
| `docs/security.md` | Import section: only "JSON files made by this app's export". Replace the four "Android-exported JSON / Gson" test lines with the new format test. |
| `docs/features.md` | Replace "Gson & Android Schema Compatibility" with "Backward-compatible backups: files from any earlier version of this app always import." |
| `docs/implementation_progress.md` | "byte-compatible Android import" → "import of the app's own backups". |
| `docs/implementation_plan.md` | Remove "Flutter migration" and "legacy Android (Compose + Room)" wording. |
| `docs/release_process.md` | Remove the "Android app reached v4.34…" version history line (versions simply continue from the current `pubspec.yaml`). |
| `README.md` | Line ~235 (migration step 6): "byte-compatible with the original Android Room/Gson format" → "readable by every later version of this app". |

### 2.3 User-visible text (ARB)
- `featJsonExportH3`: English "Room/Gson compatibility" → **"Works with older backups"**;
  Malayalam "Room/Gson അനുയോജ്യത" → **"പഴയ ബാക്കപ്പുകളും പുനഃസ്ഥാപിക്കാം"**.
  Sanskrit already says "सुगमपुनःस्थापनम्" (easy restore) — unchanged. Update the
  `@featJsonExportH3` description. Then `flutter gen-l10n`.

### 2.4 Code comments only (no behaviour change)
Reword comments that say "Kotlin app", "Android Gson", "Room" or "original Android" to
describe the behaviour itself, in:
`lib/models/active_session.dart`, `lib/models/counter.dart`, `lib/models/counter_status.dart`,
`lib/models/export_data.dart`, `lib/models/japa_session.dart`,
`lib/providers/counter_stats_provider.dart`, `lib/providers/counting_provider.dart`,
`lib/providers/history_provider.dart`, `lib/screens/history/history_screen.dart`,
`lib/services/export_service.dart`, `lib/services/haptic_feedback_service.dart`,
`lib/services/notification_service.dart`, `lib/services/session_recovery_service.dart`.

**Kept on purpose (not old-app leftovers):**
- The import parser's tolerance for missing fields (defaults for `incrementStep`,
  `status`, etc.). It also protects this app's own older backups, so removing it would
  only add risk.
- The `status` values `ACTIVE` / `DISABLED_SUCCESS` / `DISABLED_FAILURE` and the JSON
  field names — they are this app's own backup format now.
- The "legacy" single-slot active-session key in `settings_repository.dart` and
  `help_screen.dart` — both are from earlier *Flutter* versions.
- Kotlin build settings and `MainActivity.kt` — that is this app's own Android host code.
- `plans/` and `change_log/` — they are history records and stay as written.
- `docs/guidelines/` — shared submodule, read-only.

### 2.5 Tests
- `test/models/counter_test.dart`: rename group "JSON round-trip (Android Gson
  compatibility)" → "JSON round-trip".
- **New** `test/fixtures/backup_format_v1.json`: a small, made-up backup in today's
  format (dummy counter names, a few sessions; one counter with defaults, one locked,
  one with `malaSize` 0, one disabled; one Malayalam-script dummy name to cover UTF-8).
  No real data.
- **New** `test/repositories/backup_format_test.dart`:
  - the fixture imports with every field correct;
  - exporting again gives the same counters and sessions, with the same field names
    and values (so a future change can't silently break old backups);
  - a minimal old-style counter (no `isLocked`, no `malaSize`) still imports with
    defaults.
- `test/fixtures/README.md`: rewritten to describe the new fixture and the rule
  "never edit a fixture to make a test pass — add a new one".

### 2.6 Repository hygiene
- `.gitignore`: add `mantra_japa_counter_backup*.json` and `*.json.enc` at the root
  level only (`/mantra_japa_counter_backup*.json`, `/*.json.enc`), so personal backup
  files dropped into the project folder are never committed by mistake.
- Your file `mantra_japa_counter_backup (1).json` at the project root is **not deleted
  or moved by me** — it is your data. After this change it will be ignored by git. You
  may want to move it out of the project folder.

### 2.7 Memory (outside the repository)
Delete my note pointing to the old Kotlin source folder and update the project note,
so future sessions don't look for it. (Done right away — it is not a project file.)

---

## 3. Files to change

**Changed:** `CLAUDE.md`, `AGENTS.md`, `README.md`, `.gitignore`,
`docs/architecture.md`, `docs/security.md`, `docs/features.md`,
`docs/implementation_progress.md`, `docs/implementation_plan.md`,
`docs/release_process.md`, `lib/l10n/app_en.arb`, `lib/l10n/app_ml.arb`
(+ generated `lib/l10n/app_localizations*.dart`), the 13 `lib/` files in §2.4,
`test/models/counter_test.dart`, `test/fixtures/README.md`.

**New:** `test/fixtures/backup_format_v1.json`, `test/repositories/backup_format_test.dart`.

**Not touched:** app behaviour, database schema, JSON format, `docs/guidelines/`,
`plans/`, `change_log/`.

---

## 4. Order of work

1. Rule text in `CLAUDE.md` / `AGENTS.md`.
2. Docs and README.
3. ARB text + `flutter gen-l10n`.
4. Code comments.
5. Fixture + new test; rename test group; fixtures README.
6. `.gitignore`.
7. `dart format .`, `flutter analyze`, `flutter test` (golden tests for the Features
   screen, if any, are checked — the heading text changes).
8. Final search: no "Room", "Gson", "Kotlin app" or "original Android" left outside
   `plans/`, `change_log/`, `docs/guidelines/` and build settings.
9. Change log; set this plan to `completed`.

---

## 5. Risks

- Very low. No behaviour change. The new test makes the backup format stricter to
  change by accident, which is the point.
