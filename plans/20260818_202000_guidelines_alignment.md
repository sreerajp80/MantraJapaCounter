# Implementation Plan: Guidelines Alignment for Structure, Docs, and Code

**Status:** Implemented

## 1. Issue & Objective

The project guidelines in `docs/guidelines/` (`guideline.md`, `DOCS_FOLDER_GUIDELINE.md`, `AGENTS_MD_GUIDELINE.md`, `CLAUDE_MD_GUIDELINE.md`, and `GUIDELINES_MANIFEST.md`) require consistent structure, documentation conventions, and root instructions.

An audit revealed minor gaps against the guideline specifications:
1. **Document H1 titles (`DOCS_FOLDER_GUIDELINE.md` §4)**: App-specific living documents `docs/architecture.md`, `docs/security.md`, and `docs/release_process.md` use generic titles (`# Architecture`, `# Security`, `# Release Process`) instead of the required format with app name suffix (`# Architecture — Mantra Japa Counter`, `# Security — Mantra Japa Counter`, `# Release Process — Mantra Japa Counter`).
2. **Shared pointer file (`DOCS_FOLDER_GUIDELINE.md` §1)**: `docs/GUIDELINES_MANIFEST.md` should be kept identical to `docs/guidelines/GUIDELINES_MANIFEST.md`.
3. **Mandatory instruction sections (`AGENTS_MD_GUIDELINE.md` §3 & `CLAUDE_MD_GUIDELINE.md` §3)**: The mandatory `## Localization rules` section is missing from both `AGENTS.md` and `CLAUDE.md`.
4. **Symbol path versions (`AGENTS.md` & `CLAUDE.md`)**: The build command examples reference older version `v6.9.1` while the app is at `v6.10.0`.

## 2. Proposed Changes

### Documentation Updates
- [docs/architecture.md](docs/architecture.md): Update H1 to `# Architecture — Mantra Japa Counter`.
- [docs/security.md](docs/security.md): Update H1 to `# Security — Mantra Japa Counter`.
- [docs/release_process.md](docs/release_process.md): Update H1 to `# Release Process — Mantra Japa Counter`.
- [docs/GUIDELINES_MANIFEST.md](docs/GUIDELINES_MANIFEST.md): Sync exactly with `docs/guidelines/GUIDELINES_MANIFEST.md`.

### Root AI Instruction Files
- [AGENTS.md](AGENTS.md):
  - Add mandatory `## Localization rules` section.
  - Update symbol directory version string in release build commands to `v6.10.0`.
- [CLAUDE.md](CLAUDE.md):
  - Add mandatory `## Localization rules` section.
  - Update symbol directory version string in release build commands to `v6.10.0`.

## 3. Verification Plan

1. Run `flutter analyze` to ensure 0 warnings.
2. Run `flutter test` to ensure all unit and widget tests pass.
3. Validate all relative links and verify that all rules across `docs/`, `AGENTS.md`, and `CLAUDE.md` are aligned.
