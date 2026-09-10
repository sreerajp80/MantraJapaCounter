# Plan — Move `lib/config/` and `lib/utils/` under `lib/core/`

**Status:** Done — see `change_log/20260910_185144_move_config_utils_under_core.md`

**Follows up:** `change_log/20260910_102935_guidelines_conformance_audit.md` §8 ("Deliberately not done").

---

## 1. The issue

`docs/guidelines/guideline.md` §3 gives the standard `lib/` layout for every app:

```
lib/
  core/
    config/      # AppConfig + ConfigService (About). REQUIRED, fixed path.
    constants/   # app_constants.dart
    utils/       # small helpers
  theme/         # colors, text styles, ThemeData
  ...
```

This app does not match it yet:

- `lib/config/` is a top-level folder that mixes five different things: constants, theme,
  router, flavor setup and locale policy.
- `lib/utils/` is top-level instead of `lib/core/utils/`.
- Having both `lib/config/` and `lib/core/config/` is confusing. They sound like the same
  thing but hold different code.

The earlier audit left this out because it touches many imports. It is a pure move — no
behaviour changes.

## 2. Where each file goes

File names stay the same. Only folders change. `git mv` is used so file history is kept.

| Now | New place | Why |
|-----|-----------|-----|
| `lib/config/app_constants.dart` | `lib/core/constants/app_constants.dart` | guideline §3 names this exact path |
| `lib/config/theme.dart` | `lib/theme/theme.dart` | guideline §3 puts `theme/` at top level, not in `core/` |
| `lib/config/router.dart` | `lib/core/routing/router.dart` | no guideline path; `routing/` matches the Tier 2 naming in the engineering standard |
| `lib/config/flavor_config.dart` | `lib/core/flavor/flavor_config.dart` | no guideline path; kept out of `core/config/`, which is reserved for the About pattern |
| `lib/config/locale_config.dart` | `lib/core/locale/locale_config.dart` | no guideline path; kept out of `lib/l10n/`, which holds generated files |
| `lib/utils/mala.dart` | `lib/core/utils/mala.dart` | guideline §3 |
| `lib/utils/app_version.g.dart` | `lib/core/utils/app_version.g.dart` | guideline §3 (generated file) |
| `lib/utils/build_date.g.dart` | `lib/core/utils/build_date.g.dart` | guideline §3 (generated file) |

`lib/core/config/` (`AppConfig` + `ConfigService`) does not move.

After the move, `lib/config/` and `lib/utils/` are empty and removed.

**Note on `theme.dart`:** the audit wording said "under `lib/core/`", but the guideline itself
puts `theme/` at the top of `lib/`. This plan follows the guideline. If you would rather have
`lib/core/theme/`, say so when approving.

## 3. Files to change

### 3a. Dart imports (only the import line changes)

`lib/`:
- `lib/main.dart` (5 imports)
- `lib/providers/counter_stats_provider.dart`, `lib/providers/counting_provider.dart`
- `lib/repositories/settings_repository.dart`
- `lib/services/counting_service.dart`, `lib/services/export_service.dart`,
  `lib/services/notification_service.dart`
- `lib/core/utils/mala.dart` (after move — imports `app_constants.dart`)
- `lib/screens/about_counter_screen.dart`, `about_screen.dart`, `appearance_screen.dart`,
  `counter_list_screen.dart`, `counting_screen.dart`, `features_screen.dart`,
  `history_screen.dart`, `optical_sync_screen.dart`, `settings_screen.dart`
- `lib/screens/help/*.dart` (9 files — `theme.dart` import)
- `lib/widgets/counter_card.dart`, `optical_sync_import_preview_sheet.dart`,
  `temple_decorations.dart`, `temple_mala_circle.dart`

`test/`:
- `test/repositories/japa_counter_repository_migration_test.dart`
- `test/services/session_recovery_service_test.dart`
- `test/screens/about_screen_test.dart`
- `test/utils/mala_test.dart` → moved to `test/core/utils/mala_test.dart` (so `test/` still
  mirrors `lib/`)

### 3b. Build-metadata generator (important — otherwise the next build recreates the old folder)

- `tool/generate_app_version.dart` — output path and header comment → `lib/core/utils/app_version.g.dart`
- `tool/generate_build_date.dart` — output path and header comment → `lib/core/utils/build_date.g.dart`
- `android/app/build.gradle.kts` — the two `outputs.file(...)` lines in `generateBuildMetadata`

### 3c. Docs

- `CLAUDE.md` and `AGENTS.md` — the "Layout" line and the `test/utils/` example
- `docs/architecture.md` — folder tree, folder table, router path, theme path. Also fix the
  stale line that points to `lib/config/colors.dart` / `typography.dart` (these files do not
  exist; tokens live in `theme.dart`)
- `docs/project_structure.md` — folder tree

Not changed: `docs/guidelines/` (shared guidelines, a separate repo), and old files in
`plans/` / `change_log/` (they are history).

## 4. Steps

1. `git mv` each file in the table in §2, and `test/utils/mala_test.dart`.
2. Update every import in §3a (find-and-replace on the `package:mantra_japa_counter/config/...`
   and `.../utils/...` paths).
3. Update the generator paths in §3b.
4. Update the docs in §3c.
5. Check nothing still points at the old paths: search for `/config/` (excluding
   `core/config/` and `assets/config/`) and `lib/utils` across `lib/`, `test/`, `tool/`,
   `android/`, and docs.
6. Run `dart run tool/generate_app_version.dart` and `dart run tool/generate_build_date.dart`
   to confirm they write to the new folder and do not recreate `lib/utils/`.
7. Run `dart format .`, `flutter analyze` (must be clean) and `flutter test` (must stay at 80
   passing).
8. Write the change log in `change_log/`.

## 5. Risks

- **Low risk overall.** Every import uses `package:` form (no relative imports), so a missed
  import shows up at once as an analyzer error — it cannot fail silently.
- **Generated files.** If step 3b were missed, the next Gradle build would write the `.g.dart`
  files back into `lib/utils/`. Step 6 checks this.
- **Uncommitted work.** The working tree already has many uncommitted changes from the
  conformance audit, including edits to some of the files being moved. `git mv` carries those
  edits along safely, but it is cleaner to commit the audit work first so this move is its own
  commit. Recommended, not required.

## 6. Out of scope

- Renaming files or classes (for example `router.dart` → `app_router.dart`).
- Any code or behaviour change.
- Splitting large screen files (separate plan, per the audit change log).
