# Sync the project CI rules with the new guidelines

Implements plan: `plans/20261012_183339_sync-ci-rules-with-guidelines.md`

## What changed

- `CLAUDE.md`, `AGENTS.md` — added workflow rule 4 (the `docs/guidelines/` submodule is
  read-only) and rule 5 (GitHub CI is checks + Dependabot only; release builds are local).
- `AGENTS.md` — added the `.github/` line to "Where things live".
- `docs/architecture.md` §19 — replaced "no CI pipeline" with the current CI setup and added
  a "CI deviations" note: golden tests skipped in CI (Windows-only images), and Dependabot
  also watches the guidelines submodule (user merges those PRs only).
- `docs/architecture.md` §21 — rewrote the old "no CI pipeline" risk to match the current setup.
- `docs/release_process.md` §8 — added checklist items "GitHub CI is green for the release
  commit" and "Release artifacts built locally, not in CI".
- `docs/release_process.md` §14 — the "CI run" evidence line now asks for the CI run link.
- `docs/release_process.md` §17 — noted that submodule update PRs are merged by the user only,
  and pointed to the recorded deviations.

No change to `.github/` files or inside `docs/guidelines/`.

## Checks

- `flutter analyze` — no issues.
- `flutter test` — all 318 tests passed.
