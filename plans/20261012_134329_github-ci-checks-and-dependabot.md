# Add GitHub CI checks and Dependabot

**Status:** completed

## What the issue is

The project has no GitHub CI. Nothing checks the code on GitHub when it is pushed, so a
push with analyzer warnings, failing tests, unformatted code, or out-of-date translation
files is only caught if it was checked by hand first.

Dependencies (Dart packages, Gradle/Android versions, the `docs/guidelines` submodule)
are also only updated when someone remembers to look.

The user wants:

- automatic **analyze / test checks** on GitHub, and
- **Dependabot** to suggest updates.

The user does **not** want CI to build or release the app. No keystore, passwords or
other secrets are used anywhere in this plan.

## Files to be changed

New files:

- `.github/workflows/ci.yml` — the check workflow.
- `.github/dependabot.yml` — the Dependabot settings.
- `change_log/20261012_<time>_github-ci-checks-and-dependabot.md` — change log.

Changed files:

- `docs/release_process.md` — add a short "GitHub CI" section that says what CI checks,
  what it does not do (no builds, no signing), and that golden tests stay a local step.
- `CLAUDE.md` — add `.github/` to the "Where things live" list.

No app code (`lib/`), test code (`test/`), Android files, or submodule files change.

## Plan for the fix

### 1. Check workflow — `.github/workflows/ci.yml`

**When it runs:**

- every push to `main`,
- every pull request (this includes Dependabot pull requests),
- by hand from the Actions tab (`workflow_dispatch`).

If a new push comes in while an older run on the same branch is still going, the older
run is cancelled (saves minutes).

**Where it runs:** one job on `ubuntu-latest` (Linux), with a 20-minute time limit.
The job gets only read access to the repo (`permissions: contents: read`).

**Steps:**

1. Check out the code. The `docs/guidelines` submodule is **not** checked out — the
   checks do not need it.
2. Install Flutter **3.47.6** (stable), the same version the project uses, with
   `subosito/flutter-action`. Turn on its cache so later runs are faster.
3. `flutter pub get`
4. **Format check:** `dart format --output=none --set-exit-if-changed lib test tool`
   — fails if any file is not formatted. (Checked today: all 150 files are already
   formatted.)
5. **Translation check:** `flutter gen-l10n`, then `git diff --exit-code lib/l10n` —
   fails if someone edited an `.arb` file but did not re-generate and commit the
   localization files.
6. **Analyze:** `flutter analyze` — must report 0 issues.
7. **Tests:** `flutter test --exclude-tags golden` — runs all tests, including the
   translation parity test, migration tests, mala tests and export/import tests.

**Why golden tests are left out:** golden (reference image) tests are made on Windows
and must only be checked on Windows, because Linux draws text slightly differently
(see `docs/release_process.md` section 16). On Linux they would always fail. They stay
a local step on your Windows PC, as today.

*Option (not in this plan unless you ask):* a second job on `windows-latest` could run
`flutter test --tags golden`. Windows runners cost 2× minutes on private repos, and
the images could still differ slightly from your PC. I suggest leaving it out.

### 2. Dependabot — `.github/dependabot.yml`

Dependabot checks **once a week (Monday)** and opens a pull request for each update it
finds. Nothing is merged without you. Four kinds of updates:

| What | Where | Notes |
|------|-------|-------|
| Dart packages (`pub`) | `/` (`pubspec.yaml`) | One pull request per package. This keeps the `material_ui` / `cupertino_ui` upgrades in their own change, as `docs/release_process.md` section 16 asks. Max 5 open at a time. |
| Gradle / Android | `/android` | AGP, Kotlin, Gradle wrapper, Android libraries. Max 5 open at a time. |
| GitHub Actions | `/` | Keeps `actions/checkout` and `subosito/flutter-action` up to date. |
| Submodule | `/` | Tells you when `docs/guidelines` has new commits. |

Each Dependabot pull request runs the checks from step 1, so you see right away if an
update breaks anything.

**Your rules still apply:** a Dependabot pull request only *suggests* an update.
Before merging one, it still needs its own plan and change log (and for UI packages,
the section 16 checklist, including the golden tests on Windows).

### 3. Docs

- `docs/release_process.md`: new short section "GitHub CI" covering the points above.
- `CLAUDE.md`: add `.github/  # CI checks and Dependabot settings` to "Where things live".

### 4. Check the work

- Run the same commands locally (format, gen-l10n + diff, analyze, test without
  goldens) to make sure they pass before pushing.
- Check both YAML files are valid.
- I will **not** commit or push. After you push, check the **Actions** tab on GitHub
  to see the first run go green.

### 5. Things you do on the GitHub website (not files, no plan needed)

These are optional switches in **Settings → Code security**:

- **Dependabot alerts** — warns about packages with known security problems.
- **Secret scanning** and **push protection** — blocks pushes that contain passwords
  or keys.

Dependabot *version updates* (step 2) work from the file alone; no switch is needed.

## Cost

Linux job, about 3–6 minutes per run. Free for public repos; well inside the 2,000 free
minutes a month for private repos, even with Dependabot pull requests.

## Not in this plan

- Building, signing or releasing the app (user decided against it).
- Branch protection rules.
- Scheduled (timer) runs.
- Golden tests in CI (see the option above).
