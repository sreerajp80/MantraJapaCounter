# Change Log — Guidelines Alignment & Mandatory Files Setup

**Date:** 2026-08-12  
**Status:** Completed  
**Plan:** Implemented approved plan for project structure, documentation, AI instructions, and About config alignment.

---

## 1. Summary of Changes

### Root AI Instructions
- Created mandatory root [AGENTS.md](AGENTS.md) following `AGENTS_MD_GUIDELINE.md` (Thin pointer profile).
- Updated root [CLAUDE.md](CLAUDE.md) following `CLAUDE_MD_GUIDELINE.md` (Thin pointer profile), fixing stale subfolder repository layout references and adding mandatory inline Workflow and Communication rules.

### Documentation Suite Baseline (`docs/`)
Created the 5 missing mandatory baseline documents per `DOCS_FOLDER_GUIDELINE.md §6`:
- [docs/workflow_rules.md](docs/workflow_rules.md): Living document for plan-before-changing, explicit approval gate, and logging standards.
- [docs/dependencies.md](docs/dependencies.md): Living document for approved and prohibited offline-first package lists.
- [docs/project_structure.md](docs/project_structure.md): Living document for repository file tree and layer responsibility breakdown.
- [docs/implementation_plan.md](docs/implementation_plan.md): Point-in-time document for phased build roadmap.
- [docs/implementation_progress.md](docs/implementation_progress.md): Point-in-time document for live feature status tracking.

### About Screen Configuration & Core Layer (`guideline.md §1`)
- Created [assets/config/app_config.json](assets/config/app_config.json) as the single source of truth for About screen metadata.
- Registered `assets/config/` in [pubspec.yaml](pubspec.yaml).
- Implemented `AppConfig` typed model in [lib/core/config/app_config.dart](lib/core/config/app_config.dart) with safe JSON parsing and fallback defaults.
- Implemented `ConfigService` asset loader in [lib/core/config/config_service.dart](lib/core/config/config_service.dart) with runtime version check.
- Refactored [lib/screens/about_screen.dart](lib/screens/about_screen.dart) to load configuration asynchronously via `ConfigService` and dynamically render detail entries from `config.details`.

### Unit Tests & Routing
- Added unit tests in [test/core/config/config_service_test.dart](test/core/config/config_service_test.dart) covering `AppConfig.fromJson`, fallback defaults, and `ConfigService` error degradation.
- Updated route builder in [lib/config/router.dart](lib/config/router.dart) for `AboutScreen`.

---

## 2. Files Created & Modified

### Created Files
- `AGENTS.md`
- `assets/config/app_config.json`
- `docs/workflow_rules.md`
- `docs/dependencies.md`
- `docs/project_structure.md`
- `docs/implementation_plan.md`
- `docs/implementation_progress.md`
- `lib/core/config/app_config.dart`
- `lib/core/config/config_service.dart`
- `test/core/config/config_service_test.dart`
- `change_log/20260812_204600_guidelines_alignment.md`

### Modified Files
- `CLAUDE.md`
- `pubspec.yaml`
- `lib/config/router.dart`
- `lib/screens/about_screen.dart`

---

## 3. Verification Results

- `flutter analyze`: Passed with 0 issues.
- `flutter test`: Passed all 38 tests (including 5 new tests for `AppConfig` & `ConfigService`).
