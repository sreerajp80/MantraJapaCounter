# Update the docs/guidelines submodule

**Status:** completed

## Files to be changed

- `docs/guidelines` (submodule pointer only)

## What the issue is

The `docs/guidelines` submodule (shared Flutter guidelines) is pinned at commit `eb4b462`.
The upstream `master` branch now has newer commits:

- `5fed66b` Add Contact, Call, Tag and Phone number to the 8.5.4 glossary
- `3f1aa0b` Merge pull request #1 (same change)

Upstream diff: 3 files, +76 lines. It adds four glossary entries to
`flutter_project_engineering_standard.md` and two plan/change-log files in the guidelines repo.
Nothing is removed.

## Plan for the fix

1. In `docs/guidelines`, check out `origin/master` (`3f1aa0b`).
2. In the main repo, confirm `git submodule status` shows the new commit.
3. Do not commit. The pointer change is left in the working tree with the other pending changes.
4. Write a change log in `change_log/`.

No app code changes, so `flutter analyze` and `flutter test` are not affected.
