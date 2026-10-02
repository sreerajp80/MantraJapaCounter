# Update docs/guidelines submodule

**Status:** completed

## Files to be changed

- `docs/guidelines` (submodule pointer only)

## Issue

The `docs/guidelines` submodule (Flutter_Guidelines) is at commit `3f1aa0b`.
The remote `master` branch has 2 newer commits (`d3e5041`, `519e7f3`).
These change 30 files: toolchain update to Flutter 3.47, "latest stable, not pinned"
versions, more generic multi-platform guidelines, new files such as
`AI_AGENT_START_HERE.md`, `PROJECT_PROFILE_TEMPLATE.md`, `platform_store_readiness.md`,
and `language_packs/sanskrit_malayalam.md`.

## Plan for the fix

1. Move the submodule to the latest remote commit:
   `git submodule update --remote docs/guidelines`.
2. Check `git submodule status` shows `519e7f3`.
3. Write a change log in `change_log/`.

## Out of scope

- No changes to app code or to this project's own docs (`CLAUDE.md`, `docs/*.md`) to match
  the new guideline text. If the new guidelines need project changes (for example the
  Flutter 3.47 toolchain), that will be a separate plan.
- No commit unless asked.
