# Change log — Move `lib/config/` and `lib/utils/` under `lib/core/`

**Plan:** `plans/20260910_185144_move_config_utils_under_core.md`

**Follows up:** `change_log/20260910_102935_guidelines_conformance_audit.md` §8.

---

## 1. Summary

The `lib/` folder now matches the standard layout in `docs/guidelines/guideline.md` §3.
The top-level `lib/config/` and `lib/utils/` folders are gone. This is a pure move: no class,
function or behaviour changed. Only file locations and import lines changed.

## 2. Files moved (with `git mv`, so history is kept)

| Old path | New path |
|----------|----------|
| `lib/config/app_constants.dart` | `lib/core/constants/app_constants.dart` |
| `lib/config/theme.dart` | `lib/theme/theme.dart` |
| `lib/config/router.dart` | `lib/core/routing/router.dart` |
| `lib/config/flavor_config.dart` | `lib/core/flavor/flavor_config.dart` |
| `lib/config/locale_config.dart` | `lib/core/locale/locale_config.dart` |
| `lib/utils/mala.dart` | `lib/core/utils/mala.dart` |
| `lib/utils/app_version.g.dart` | `lib/core/utils/app_version.g.dart` |
| `lib/utils/build_date.g.dart` | `lib/core/utils/build_date.g.dart` |
| `test/utils/mala_test.dart` | `test/core/utils/mala_test.dart` |

`lib/core/config/` (`AppConfig` + `ConfigService`) was not moved. It now holds only the About
pattern, as the guideline asks.

`theme.dart` went to top-level `lib/theme/`, not `lib/core/`, because that is where the
guideline puts it.

## 3. Imports updated

34 Dart files under `lib/` and `test/` had their `package:mantra_japa_counter/config/...` and
`package:mantra_japa_counter/utils/...` imports changed to the new paths. All imports already
used the `package:` form, so there were no relative imports to fix.

## 4. Build-metadata generator

- `tool/generate_app_version.dart` and `tool/generate_build_date.dart` now write to
  `lib/core/utils/`.
- `android/app/build.gradle.kts` — the `generateBuildMetadata` task's two `outputs.file(...)`
  lines now point to `lib/core/utils/`.

Both scripts were run after the change. They wrote to the new folder and did not recreate
`lib/utils/`.

## 5. Docs updated

- `CLAUDE.md`, `AGENTS.md` — the "Layout" rule now lists the new folders and says
  `core/config/` holds only `AppConfig` + `ConfigService`. The test-mirror example now says
  `test/core/utils/`.
- `docs/architecture.md` — folder tree, ownership table, router path and theme path. Also fixed
  a stale line that pointed to `lib/config/colors.dart` and `lib/config/typography.dart`. Those
  files never existed; colors and text styles live in `lib/theme/theme.dart`.
- `docs/project_structure.md` — folder tree.
- `README.md` — five stale paths (single-test example, generator comments, flavor config path,
  `dbVersion` location). **Not listed in the plan.** The plan's search missed it, and the final
  check caught it. Same kind of doc-only fix, so it was included.

Not changed: `docs/guidelines/` (shared guidelines repo) and older `plans/` / `change_log/`
files (they are history).

## 6. Verification

| Check | Result |
|-------|--------|
| `dart format lib test tool` | 80 files, 0 changed |
| `flutter analyze` | No issues found |
| `flutter test` | 80 passing (same as before) |
| `flutter test test/core/utils/mala_test.dart` | 11 passing (README example works) |
| Search for old paths in `lib/`, `test/`, `tool/`, `android/`, docs, README | none left |
| Generators run | write to `lib/core/utils/`; `lib/utils/` not recreated |
