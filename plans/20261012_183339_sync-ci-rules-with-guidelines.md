# Sync the project CI rules with the new guidelines

**Status:** completed

## What the issue is

The guidelines submodule commit `1f728b9` changed the CI rules (engineering standard §19):
GitHub CI may only run pass/fail checks and Dependabot. It must never build, sign, upload or
release. It also added a workflow rule 5 ("CI is checks + Dependabot only") that the
`CLAUDE.md` and `AGENTS.md` templates must show inline.

I compared the project with the new rules.

### Already matches (no change)

- `.github/workflows/ci.yml` runs only checks: pub get, format check, l10n staleness check,
  analyze, test. No build, no signing, no secrets, `permissions: contents: read`, one
  `ubuntu-latest` runner, pinned Flutter version.
- `.github/dependabot.yml` has `pub` and `github-actions` (both MUST) and `gradle` (MAY).
- `docs/release_process.md` §17 already says CI is checks only, with no secrets.
- Release builds and signing are already done locally.

### Small differences (kept on purpose, to be written down)

1. **Golden tests are skipped in CI** (`--exclude-tags golden`). §19.1 says `flutter test`
   includes golden tests. The project's golden images only match on Windows, and CI runs on
   Linux, so they would always fail. Keep the skip and record it as a known deviation.
2. **Dependabot also watches the `docs/guidelines` submodule** (`gitsubmodule`). §19.2 does not
   list this, but does not forbid it either; it is still Dependabot. Keep it and record it.
   The user (not an AI agent) reviews and merges these pull requests, because workflow
   rule 4 says AI agents never change the submodule version.
3. **Format check covers `lib test tool`**, not `.`. Same effect for this project. No change.

### Out of date or missing (to fix)

- `CLAUDE.md` and `AGENTS.md` lack workflow rule 4 (guidelines submodule is read-only, added in
  `0607386`) and the new workflow rule 5 (CI is checks + Dependabot only).
- `AGENTS.md` "Where things live" lacks the `.github/` line that `CLAUDE.md` already has.
- `docs/architecture.md` still says "no CI pipeline in initial release" (team constraints and
  the risks list). This is no longer true.
- `docs/release_process.md` release record still says "CI run: n/a (no CI pipeline ...)", and
  the release checklist lacks the new "release artifacts built locally, not in CI" item.

## Files to be changed

- `CLAUDE.md` — add workflow rules 4 and 5.
- `AGENTS.md` — add workflow rules 4 and 5; add `.github/` to "Where things live".
- `docs/architecture.md` — replace the "no CI pipeline" lines with the current CI setup; add a
  short "CI deviations" note for golden tests and the `gitsubmodule` Dependabot entry.
- `docs/release_process.md` — fix the "CI run: n/a" line; add the "built locally, not in CI"
  checklist item; in §17, mention that submodule update PRs are merged by the user only.
- `change_log/<timestamp>_sync-ci-rules-with-guidelines.md` (new).

No change to `.github/` files and no change inside `docs/guidelines/`.

## Plan for the fix

1. Add to the "Workflow rules" list in `CLAUDE.md` and `AGENTS.md`:
   - **4. Guidelines submodule is read-only.** Never edit, check out or commit
     `docs/guidelines/` or its version. If a guideline needs a change, write a note for the
     user instead. If the folder is empty or missing, stop and ask the user.
   - **5. CI is checks + Dependabot only.** GitHub CI runs only `flutter pub get`, the format
     check, the l10n staleness check, `flutter analyze` and `flutter test`, plus Dependabot.
     CI never builds release artifacts, signs, holds signing secrets, uploads or publishes.
     Release builds are done locally (engineering standard §19).
2. Add the `.github/` line to `AGENTS.md` "Where things live".
3. Update `docs/architecture.md` and `docs/release_process.md` as listed above.
4. Run `flutter analyze` and `flutter test` (docs-only change, as a sanity check).
5. Write the change log.
