# Full Guidelines Conformance Audit and Fix

**Status:** completed

**Date:** 2026-09-10

**Scope:** Whole repository — project structure, code, docs, build config, and repo hygiene,
checked against `CLAUDE.md`, `AGENTS.md`, and every document listed in
`docs/GUIDELINES_MANIFEST.md`.

---

## 1. What was checked

I read the guideline set and then checked the repository against it:

- `docs/guidelines/guideline.md` — folder layout, About-config pattern, keystore rules.
- `docs/guidelines/flutter_project_engineering_standard.md` — sections 3, 8, 13, 15, 16, 18, 20, 21, 23.
- `docs/guidelines/DOCS_FOLDER_GUIDELINE.md` — `docs/` folder rules.
- `docs/guidelines/CLAUDE_MD_GUIDELINE.md` / `AGENTS_MD_GUIDELINE.md` — root AI files.
- Project `CLAUDE.md` and `AGENTS.md` hard rules.

### Things that already pass (no work needed)

- `flutter analyze` — clean, 0 issues.
- `flutter test` — 62 tests, all pass.
- About-screen config pattern: `assets/config/app_config.json`, `lib/core/config/app_config.dart`,
  `lib/core/config/config_service.dart` all present with the required class names.
- `assets/config/` is registered in `pubspec.yaml`.
- ARB files: 330 keys, every key has an `@key` description, and `app_ml.arb` matches `app_en.arb`
  key for key with no missing and no extra keys.
- `l10n.yaml` exists at project root with the required fields.
- No `INTERNET` permission in the release manifest; no prohibited network, analytics, or crash
  dependencies in `pubspec.yaml`.
- No `print()` calls in `lib/`.
- Keystore rules: keystore path and `key.properties` handling in `android/app/build.gradle.kts`
  match `guideline.md` §2, and `.gitignore` covers `android/key.properties`, `*.jks`, `*.keystore`.
- Signing enforcement block correctly stops an unsigned `prod --release` build.

---

## 2. Problems found

Grouped by area, with the rule each one breaks.

### Group A — Android build correctness (highest priority)

| # | Problem | Rule broken |
|---|---------|-------------|
| A1 | `android/app/src/main/AndroidManifest.xml` sets `android:label="mantra_japa_counter"`. The Gradle flavors define `resValue("string", "app_name", ...)` for both `dev` and `prod`, but nothing reads it. So the launcher name is the raw package name for **both** flavors, not "SreerajP MantraJapa Counter" / "... Dev". | `CLAUDE.md` project identity table; `flutter_build_flavors_guide.md` |
| A2 | `android:allowBackup="false"` is missing from the manifest. It is not set anywhere in `android/`. | `CLAUDE.md` security rules; `docs/security.md` |

### Group B — Repository hygiene and privacy

| # | Problem | Rule broken |
|---|---------|-------------|
| B1 | `local.properties` is **tracked in git** and contains a local machine SDK path. | Engineering standard §20.2 ("never commit local machine configuration files containing machine-specific paths") |
| B2 | `change_log/20260812_210900_fix_keystore_path.md` line 3 links to an absolute `file:///` path with a drive letter. | Engineering standard §21.1.1 (**MUST**); `CLAUDE.md` workflow rule 3 |
| B3 | `.gitignore` is missing entries the standard requires: `*.apk`, `*.aab`, `*.ipa`, `*.msix`, `*.symbols/`, `.flutter-plugins`, and `local.properties`. | Engineering standard §20.4 |
| B4 | The `docs/guidelines` submodule pointer in the parent repo is stale (`git submodule status` shows `+`). The submodule working tree itself is clean and unedited. | Repo hygiene |

### Group C — `plans/` folder hygiene

| # | Problem | Rule broken |
|---|---------|-------------|
| C1 | 4 plan files have **no** `**Status:**` line at all: `20260623_103000_counting-back-button-larger.md`, `20260623_104500_counting-back-button-elongated.md`, `20260624_080058_about-made-in-india.md`, `20260624_080537_multilingual-en-ml.md`. | `CLAUDE.md` workflow rule 1 |
| C2 | 6 plan files use status values that are not in the allowed list (`Proposed`, `Pending Approval`, `Implemented`, `Completed`, `COMPLETED`). Allowed values are only: `draft`, `approval_pending`, `in_progress`, `completed`, `dropped`, `partial_completion`. | `CLAUDE.md` workflow rule 1 |

### Group D — Documentation

| # | Problem | Rule broken |
|---|---------|-------------|
| D1 | `README.md` is still the 17-line stock Flutter template. It has none of the required content: prerequisites, clean-clone setup, how to run tests, how to run code generation, per-platform build commands, how to add a database migration, or `--dart-define` values. | Engineering standard §21.3 |
| D2 | `docs/flutter_project_engineering_standard.md` (1864 lines) and `docs/flutter_build_flavors_guide.md` (820 lines) are **stale local copies** of shared reference documents. The submodule versions are 2320 and 946 lines. Because "the local copy wins", the project is currently following an outdated standard. The docs guideline says reference documents must be linked, not copied. | `DOCS_FOLDER_GUIDELINE.md` §2 |
| D3 | The doc tables in `CLAUDE.md`, `AGENTS.md`, and `docs/` point readers at those stale local copies. | Follows from D2 |

### Group E — Code standards

| # | Problem | Rule broken |
|---|---------|-------------|
| E1 | **Hard-coded user-visible English text.** `lib/screens/features_screen.dart` holds a whole feature catalogue as Dart string literals (13 features across 5 categories: titles, descriptions, and 3 highlight bullets each — roughly 100 strings). `lib/screens/settings_screen.dart` (section and tile titles, 2 error SnackBars), `lib/screens/optical_sync_screen.dart` (empty-state text), and `lib/widgets/optical_sync_import_preview_sheet.dart` (stat labels) also hard-code text. | `CLAUDE.md` localization rules (**MUST**); engineering standard §8.2 |
| E2 | All 140 imports inside `lib/` are relative (`../config/theme.dart`). Zero use `package:mantra_japa_counter/...`. | `CLAUDE.md` code style; engineering standard §16.1 (`always_use_package_imports`) |
| E3 | `analysis_options.yaml` is the stock Flutter template. None of the 26 recommended baseline lint rules from §16.1 are enabled. | Engineering standard §16.1 |
| E4 | Folder layout drifts from the baseline: the project has `lib/config/` (constants, theme, router, locale) and `lib/utils/`, where the guideline baseline is `lib/core/constants/`, `lib/core/utils/`, and `lib/theme/`. §3.2 also says a broad catch-all `utils/` should be avoided. | `guideline.md` §3; engineering standard §3.2 |
| E5 | 8 files are over the 500-line "split or justify" threshold: `settings_screen.dart` (1028), `counter_list_screen.dart` (854), `history_screen.dart` (837), `counting_screen.dart` (732), `counting_provider.dart` (621), `features_screen.dart` (547), `appearance_screen.dart` (523), `counter_card.dart` (517). | Engineering standard §16.2 (guidance, not a hard failure) |

### Group F — Tests

| # | Problem | Rule broken |
|---|---------|-------------|
| F1 | `test/models/counting_service_test.dart` tests `lib/services/counting_service.dart`, so it sits in the wrong mirror folder. | `CLAUDE.md` testing rules; engineering standard §3.2 |
| F2 | Two required coverage areas have **no tests at all**: database migrations (v1 → v2 → v3) and session recovery. Nothing in `test/` references `onUpgrade`, migration, or `SessionRecoveryService`. | `CLAUDE.md` testing rules |

---

## 3. The plan

I propose doing this in five phases, smallest risk first. Each phase ends with
`flutter analyze` and `flutter test` clean.

### Phase 1 — Build correctness and repo hygiene (A, B, C)

Low risk, high value. No Dart code changes.

1. `AndroidManifest.xml`: change `android:label` to `@string/app_name`, and add
   `android:allowBackup="false"`.
2. `git rm --cached local.properties` so it stops being tracked, and add it to `.gitignore`.
   The file stays on disk, so builds keep working.
3. Add the missing `.gitignore` entries from §20.4.
4. Fix the absolute `file:///` link in the one change-log file to a relative path.
5. Add the missing `**Status:**` lines to 4 plans and normalise the 6 non-standard values to the
   allowed vocabulary.
6. Stage the updated `docs/guidelines` submodule pointer.

**Files:** `android/app/src/main/AndroidManifest.xml`, `.gitignore`,
`change_log/20260812_210900_fix_keystore_path.md`, 10 files in `plans/`.

### Phase 2 — Documentation (D)

1. Delete the two stale local reference copies: `docs/flutter_project_engineering_standard.md`
   and `docs/flutter_build_flavors_guide.md`.
2. Repoint every link to them — in `CLAUDE.md`, `AGENTS.md`, and any `docs/*.md` file — to the
   submodule paths `docs/guidelines/...`.
3. Rewrite `README.md` to cover the §21.3 required list: prerequisites, clean-clone setup, run,
   test, code generation (`flutter gen-l10n`, the `tool/` metadata generators), all build
   commands per flavor, how to add a database migration, and flavor/`--dart-define` values.
4. Check `docs/architecture.md`, `docs/project_structure.md`, and `docs/security.md` still
   describe the real code, and correct any drift found.

**Files:** `README.md`, `CLAUDE.md`, `AGENTS.md`, `docs/architecture.md`,
`docs/project_structure.md`, `docs/security.md`, plus deleting 2 files in `docs/`.

### Phase 3 — Lints and imports (E2, E3)

1. Add the §16.1 recommended lint rules to `analysis_options.yaml`.
2. Fix everything the new rules flag. `always_use_package_imports` will rewrite all 140 relative
   imports in `lib/` to `package:mantra_japa_counter/...`; the rest are mostly `const`,
   single-quote, and `final` fixes. Most can be done with `dart fix --apply`.
3. Run `dart format .`.

**Files:** `analysis_options.yaml` and most files under `lib/` (import lines and small lint fixes
only — no behaviour change).

### Phase 4 — Localization (E1)

This is the largest piece and the only remaining **MUST** violation.

1. Add ARB keys for every hard-coded string, each with its `@key` description, to `lib/l10n/app_en.arb`.
2. Add matching Malayalam translations to `lib/l10n/app_ml.arb`.
3. Restructure `features_screen.dart` so the `_categories` list is built from `AppLocalizations`
   at build time instead of being a `static const` list of English literals.
4. Replace the literals in `settings_screen.dart`, `optical_sync_screen.dart`, and
   `optical_sync_import_preview_sheet.dart`.
5. Run `flutter gen-l10n` and update `test/screens/features_screen_test.dart`, which currently
   asserts on the English literals.

**Files:** `lib/l10n/app_en.arb`, `lib/l10n/app_ml.arb`, `lib/screens/features_screen.dart`,
`lib/screens/settings_screen.dart`, `lib/screens/optical_sync_screen.dart`,
`lib/widgets/optical_sync_import_preview_sheet.dart`, `test/screens/features_screen_test.dart`.

### Phase 5 — Tests (F)

1. Move `test/models/counting_service_test.dart` to `test/services/counting_service_test.dart`.
2. Add `test/repositories/japa_counter_repository_migration_test.dart` covering the v1 → v2 → v3
   sqflite migrations, using an in-memory database.
3. Add `test/services/session_recovery_service_test.dart` covering save, restore, and the
   discard-stale path.

**Files:** 1 moved file, 2 new test files.

---

## 4. Deliberately NOT in this plan

- **E4 (folder move `lib/config/` → `lib/core/`, `lib/utils/` → `lib/core/utils/`).** The
  guideline says existing apps "SHOULD be migrated over time (migration is a separate task, not
  part of adopting this document)". It touches every import in the project and is best done on
  its own, after Phase 3 has already rewritten the imports. I recommend a separate plan.
- **E5 (splitting the 8 large files).** §16.2 calls these "prompts to review, not automatic
  failures". Splitting four 800–1000 line screens is a refactor with real regression risk and no
  rule forcing it. I recommend a separate plan per screen.

Say the word if you want either of these folded in instead.

---

## 5. Full list of files to be changed

**Phase 1**
- `android/app/src/main/AndroidManifest.xml`
- `.gitignore`
- `change_log/20260812_210900_fix_keystore_path.md`
- `plans/20260623_103000_counting-back-button-larger.md`
- `plans/20260623_104500_counting-back-button-elongated.md`
- `plans/20260624_080058_about-made-in-india.md`
- `plans/20260624_080537_multilingual-en-ml.md`
- `plans/20260812_205500_optical_air_gap_sync.md`
- `plans/20260812_210810_fix_keystore_path.md`
- `plans/20260818_202000_guidelines_alignment.md`
- `plans/20260818_203000_update_app_name.md`
- `plans/20260818_205600_add_arb_metadata.md`
- `plans/20260820_210000_settings_appearance_features_help.md`
- `plans/20260824_213000_align_project_structure_codes_docs_guidelines.md`
- `plans/20260829_050500_automate_build_metadata_and_display_build_date.md`
- `plans/20260829_052800_counter_lock_feature.md`
- `local.properties` (untracked from git only; file stays on disk)

**Phase 2**
- `README.md` (rewritten)
- `CLAUDE.md`, `AGENTS.md` (doc links)
- `docs/architecture.md`, `docs/project_structure.md`, `docs/security.md` (drift fixes)
- `docs/flutter_project_engineering_standard.md` (deleted)
- `docs/flutter_build_flavors_guide.md` (deleted)

**Phase 3**
- `analysis_options.yaml`
- All 64 `.dart` files under `lib/` (import lines and small lint fixes)

**Phase 4**
- `lib/l10n/app_en.arb`, `lib/l10n/app_ml.arb`
- `lib/screens/features_screen.dart`, `lib/screens/settings_screen.dart`,
  `lib/screens/optical_sync_screen.dart`
- `lib/widgets/optical_sync_import_preview_sheet.dart`
- `test/screens/features_screen_test.dart`
- Regenerated: `lib/l10n/app_localizations*.dart`

**Phase 5**
- `test/models/counting_service_test.dart` → `test/services/counting_service_test.dart`
- `test/repositories/japa_counter_repository_migration_test.dart` (new)
- `test/services/session_recovery_service_test.dart` (new)

---

## 6. Verification for every phase

- `flutter analyze` → 0 issues.
- `flutter test` → all tests pass.
- `dart format .` → no changes left.
- Phase 1 extra: confirm `git ls-files` no longer lists `local.properties`, and grep `plans/`
  and `change_log/` for absolute paths returns nothing.
- Phase 4 extra: launch both `en` and `ml` and confirm the Features and Settings screens show
  translated text.
