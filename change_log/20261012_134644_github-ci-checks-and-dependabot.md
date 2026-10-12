# Add GitHub CI checks and Dependabot

Implements plan: `plans/20261012_134329_github-ci-checks-and-dependabot.md`

## What changed

### New: `.github/workflows/ci.yml`

A GitHub Actions workflow that runs **checks only** (no build, no signing, no secrets).

- Runs on every push to `main`, every pull request, and by hand (`workflow_dispatch`).
- One Linux job, Flutter 3.47.6 (stable) with caching, 20-minute limit, read-only access.
- An older run on the same branch is cancelled when a newer push comes in.
- Steps: `flutter pub get` → format check → `flutter gen-l10n` + `git diff --exit-code lib/l10n`
  → `flutter analyze` → `flutter test --exclude-tags golden`.
- The `docs/guidelines` submodule is not checked out (not needed).
- Golden tests are left out because their images only match on Windows.

### New: `.github/dependabot.yml`

Weekly (Monday) update pull requests for:

- Dart packages (`pub`, `/`) — max 5 open,
- Gradle / Android (`/android`) — max 5 open,
- GitHub Actions (`/`),
- the `docs/guidelines` submodule (`gitsubmodule`, `/`).

### Changed: `docs/release_process.md`

New section **17. GitHub CI**: what CI runs, why golden tests stay local, to update
`flutter-version` in `ci.yml` when upgrading Flutter, and how Dependabot pull requests are
handled (own plan and change log before merging).

### Changed: `CLAUDE.md`

Added `.github/` to the "Where things live" list.

## Checks done

- Both YAML files load without errors.
- The CI steps were run locally:
  - format: 150 files, 0 changed,
  - `flutter gen-l10n`: no changes in `lib/l10n`,
  - `flutter analyze`: no issues,
  - `flutter test --exclude-tags golden`: 306 tests passed.
- No Gradle build was run.

## Not done

- Nothing committed or pushed. The first real CI run happens after the user pushes.
- The optional GitHub settings (Dependabot alerts, secret scanning, push protection) are
  switched on by the user in the repo settings, if wanted.
