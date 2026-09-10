# Change Log: Full Guidelines Conformance Audit and Fix

**Date:** 2026-09-10

**Plan Reference:** [../plans/20260910_095929_guidelines_conformance_audit.md](../plans/20260910_095929_guidelines_conformance_audit.md)

**Result:** All five planned phases were implemented. `flutter analyze` reports 0 issues,
`dart format .` leaves no changes, and the test suite grew from 62 to 80 passing tests.

---

## 1. Summary

The whole repository was checked against `CLAUDE.md`, `AGENTS.md`, and the shared guideline
set in `docs/guidelines/`. Every problem found was fixed, except two structural refactors that
the plan deliberately deferred (see §8).

One extra bug was found during the work and fixed: a stale database version constant. It is
described in §4.

---

## 2. Phase 1 — Android build correctness and repo hygiene

### Android manifest

- `android/app/src/main/AndroidManifest.xml`: `android:label` changed from the literal
  `mantra_japa_counter` to `@string/app_name`. The Gradle flavors already defined `app_name`
  via `resValue`, but nothing read it, so **both** flavors showed the raw package name as the
  launcher label.
- Added `android:allowBackup="false"` and `android:fullBackupContent="false"`, which the
  project security rules require and which were missing everywhere.
- Added `android:dataExtractionRules="@xml/data_extraction_rules"` and created
  `android/app/src/main/res/xml/data_extraction_rules.xml`, which excludes every data domain
  from cloud backup and device-to-device transfer. This is the Android 12+ (API 31) form of
  the same rule.

Verified by building both flavors and reading the merged manifests:

| Flavor | Merged `android:label` | `app_name` value | `allowBackup` |
|--------|------------------------|------------------|---------------|
| `dev` | `@string/app_name` | SreerajP MantraJapa Counter Dev | `false` |
| `prod` | `@string/app_name` | SreerajP MantraJapa Counter | `false` |

### Repository hygiene

- `local.properties` was tracked in git and held a local machine SDK path. It was untracked
  with `git rm --cached` and added to `.gitignore`. The file stays on disk, so builds still
  work.
- `.gitignore` gained the entries the engineering standard requires: `local.properties`,
  `android/local.properties`, `.flutter-plugins`, `*.apk`, `*.aab`, `*.ipa`, `*.msix`, and
  `*.symbols/`.
- `change_log/20260812_210900_fix_keystore_path.md` linked to an absolute `file:///` path with
  a drive letter. It now uses the relative path `../plans/...`. A repository-wide scan of
  `plans/` and `change_log/` for absolute paths, local hosts, and IP addresses now returns
  nothing.
- Staged the updated `docs/guidelines` submodule pointer, which had drifted from the commit
  the parent repository recorded. The submodule working tree itself was clean and unedited.

### Plan status lines

- Added a missing `**Status:**` line to 4 plans. Each was confirmed implemented by finding its
  matching file in `change_log/` before being marked `completed`.
- Normalised 9 plans that used values outside the allowed vocabulary
  (`Proposed`, `Pending Approval`, `Implemented`, `Completed`, `COMPLETED`) to `completed`.

All 19 plan files now carry a `**Status:**` line using only the allowed values.

---

## 3. Phase 2 — Documentation

- Deleted `docs/flutter_project_engineering_standard.md` and
  `docs/flutter_build_flavors_guide.md`. These were **stale local copies** of shared reference
  documents (1864 and 820 lines against 2320 and 946 in the submodule). Because a local copy
  overrides the submodule, the project had been following an outdated standard. The docs
  guideline says reference documents are linked, not copied.
- Repointed every link to them — in `CLAUDE.md`, `AGENTS.md`, `docs/architecture.md`,
  `docs/release_process.md`, `docs/security.md`, and the Gradle signing error message in
  `android/app/build.gradle.kts` — at the submodule paths under `docs/guidelines/`.
- Removed the two deleted files from the directory tree in `docs/project_structure.md`.
- Rewrote `README.md`. It was still the 17-line stock Flutter template. It now covers every
  item the engineering standard requires: prerequisites, setup from a clean clone (including
  the submodule and `local.properties`), how to run each flavor, how to run tests and
  analysis, code generation (`flutter gen-l10n` and the two `tool/` metadata generators),
  hardened build commands per artifact type, environment values, how to add a database
  migration, the project layout, and the contributing rules.

---

## 4. Extra bug found and fixed — stale database version

Not in the original plan, found while writing the README.

`lib/config/app_constants.dart` declared `dbVersion = 3`, but the repository already had a
`_createV4` migration and `lib/main.dart` opened the database with a hard-coded `version: 4`
and a hard-coded `'japa_counter.db'` filename. So:

- `AppConstants.dbVersion` was dead and wrong — a trap for the next person who trusted it.
- `main.dart` carried database filename and version details that belong to the data layer.

Fixed by setting `AppConstants.dbVersion = 4` and making `main.dart` read
`AppConstants.dbName` and `AppConstants.dbVersion` instead of literals. App behaviour is
unchanged — it was already opening at version 4.

The documentation drift that came with it was corrected too: `CLAUDE.md`, `AGENTS.md`,
`docs/architecture.md`, `docs/dependencies.md`, and `docs/features.md` all said "schema v3"
and now say v4. The two point-in-time documents (`docs/implementation_plan.md` and
`docs/implementation_progress.md`) were left untouched on purpose — the docs guideline says
those record a moment and are not rewritten.

A regression test now guards this exact mistake: see §7.

---

## 5. Phase 3 — Lints and imports

- Rewrote `analysis_options.yaml`. It was the stock template with no rules enabled. It now
  includes the full recommended baseline from the engineering standard §16.1 (26 rules,
  grouped by intent), and excludes generated files (`lib/l10n/app_localizations*.dart`,
  `*.g.dart`, `*.freezed.dart`) from analysis.
- The new rules raised 296 issues. All were fixed with `dart fix --apply`, then
  `dart format .`.
- The largest group was `always_use_package_imports`: every import inside `lib/` was relative.
  The project now has **0 relative imports and 176 `package:mantra_japa_counter/...`
  imports**. The rest were `const`, `final`, redundant-argument, and `DecoratedBox` fixes.

No behaviour changed — these are style and import-path fixes only.

---

## 6. Phase 4 — Localization

This closed the last remaining **MUST** violation.

`lib/screens/features_screen.dart` held the entire feature catalogue as a `static const` list
of English string literals — 5 categories and 15 features, each with a title, a description,
and 3 highlight bullets. Smaller leaks existed in the settings screen, the optical sync
screen, and the optical sync import preview sheet.

What was done:

- Added **114 new keys** to `lib/l10n/app_en.arb` and `lib/l10n/app_ml.arb`, each with an
  `@key` description entry and Malayalam translations. The ARB files went from 330 to 444
  keys, still with zero missing descriptions and zero key drift between the two languages.
- Reused the existing `exportFailed` and `importFailed` keys rather than adding duplicates.
- Converted `_categories` from a `static const` list into
  `static List<_FeatureCategory> _categories(AppLocalizations l)`, built on each frame from
  the localizations. Icons stayed in Dart; all text now comes from the ARB files.
- Replaced the literals in `lib/screens/settings_screen.dart`,
  `lib/screens/optical_sync_screen.dart`, and
  `lib/widgets/optical_sync_import_preview_sheet.dart`, adding
  `AppLocalizations.of(context)` where those files did not already have it.
- Regenerated with `flutter gen-l10n`.

A repository-wide rescan for hard-coded user-visible strings in `lib/screens/` and
`lib/widgets/` now returns nothing.

**Proof it works:** a second test was added to `test/screens/features_screen_test.dart` that
renders the screen under `Locale('ml')` and asserts the Malayalam category and feature titles
appear while the English ones are gone. The original English test still passes unchanged,
because the English ARB values match the old literals exactly.

---

## 7. Phase 5 — Tests

- Moved `test/models/counting_service_test.dart` to `test/services/counting_service_test.dart`,
  matching the service it tests so `test/` mirrors `lib/`.
- Added `sqflite_common_ffi: ^2.3.4` to `dev_dependencies` so sqflite can run on the desktop
  VM in tests. It is test-only and never ships in the app.
- Added `test/repositories/japa_counter_repository_migration_test.dart` — **9 tests** covering
  the v1 → v2 → v3 → v4 chain: fresh-install shape, each upgrade path, row survival across
  upgrades, new columns taking their defaults, an upgraded v1 database matching a fresh
  install exactly, and `onUpgrade` being safe to re-run.

  Two things were learned while writing it and are worth recording:
  - `:memory:` databases are discarded on close, so an upgrade test cannot use them. The tests
    use real temporary files that are deleted in `tearDown`.
  - `onUpgrade` never creates the v1 tables (correctly — a real v1 database already has them),
    so the historical v1/v2/v3 schemas are written out as raw SQL in the test file. That also
    makes them a frozen record, so a later edit to the repository cannot quietly rewrite
    history and still pass.
  - One test asserts `AppConstants.dbVersion` is high enough to cover the newest `_createVN`.
    This is the direct guard against the bug described in §4 happening again.

- Added `test/services/session_recovery_service_test.dart` — **8 tests** covering the crash
  path: nothing stored, a zero-tap placeholder being cleared, a missing session row being
  written with correct mala/chant maths, the prefs entry being left intact for the counting
  screen to resume, multiple counters recovered together, a higher prefs count synced forward,
  a count never walked backwards, and malformed JSON in preferences not throwing.

Test totals: **62 → 80 passing.**

---

## 8. Deliberately not done

Both were listed in the plan as out of scope, and the reasoning has not changed:

- **Moving `lib/config/` and `lib/utils/` under `lib/core/`.** The folder guideline itself says
  existing apps should migrate over time and that migration is a separate task. It touches
  every import in the project.
- **Splitting the 8 files over 500 lines** (`settings_screen.dart` at 1028 lines being the
  largest). The standard calls this "a prompt to review, not an automatic failure", and
  splitting four large screens carries real regression risk with no rule forcing it.

Each deserves its own plan.

---

## 9. Verification

| Check | Result |
|-------|--------|
| `flutter analyze` | 0 issues |
| `flutter test` | 80 passing |
| `dart format .` | no changes |
| `flutter build apk --flavor dev --debug` | success, label and backup flags correct |
| `flutter build apk --flavor prod --debug` | success, label and backup flags correct |
| `git ls-files` contains `local.properties` | no |
| Absolute paths in `plans/` and `change_log/` | none |
| Hard-coded UI strings in `lib/screens` and `lib/widgets` | none |
| Relative imports in `lib/` | 0 (176 `package:` imports) |
| ARB keys missing `@description` or a Malayalam entry | 0 of 444 |
