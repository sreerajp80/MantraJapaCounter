# Move release keystore to `android/` to match the shared guidelines

**Status:** completed

---

## 1. The issue

The project docs and the shared guidelines submodule disagree about where the release
keystore must live.

- Project docs say: `keystore/keystore.jks` at the repository root.
  - `docs/project_structure.md:45` — tree shows a root `keystore/` folder.
  - `CLAUDE.md:96`, `AGENTS.md:96` — "Release keystore lives at `keystore/keystore.jks`."
  - `docs/release_process.md:136` — same root path.
  - `docs/flutter_build_flavors_guide.md:745` — same root path.
- Shared guidelines say (`docs/guidelines/guideline.md` §2.1–§2.3, the authority):
  - The keystore MUST live directly in `android/`, filename free per app.
  - `android/key.properties` is the fixed name for the signing properties.
  - `.gitignore` must contain `android/key.properties`, `android/*.jks`, `android/*.keystore`.

The user has decided the shared guidelines are the authority. So the real file and every
doc that names its location must move to `android/`.

There is also a second, older contradiction inside
`docs/flutter_build_flavors_guide.md` (Steps 1–3, lines 94–140): it says to keep the
keystore **outside** the project and use an **absolute** `storeFile`. That is the opposite
of the guideline and of line 745 of the same file. This plan fixes that too, so the file
is self-consistent.

Current real state on disk:
- Keystore file: `keystore/keystore.jks` (repo root, gitignored).
- `android/key.properties` exists with `storeFile=../../keystore/keystore.jks`.
- Gradle resolves `storeFile` from `android/app/` (`android/app/build.gradle.kts:39`).

---

## 2. Files to change

### Real files (signing must keep working)

| File | Change |
|------|--------|
| `keystore/keystore.jks` | Move to `android/keystore.jks`; then delete the now-empty root `keystore/` folder. |
| `android/key.properties` | `storeFile=../../keystore/keystore.jks` → `storeFile=../keystore.jks` (resolves from `android/app/` to `android/keystore.jks`). |
| `.gitignore` | Add `android/*.jks` and `android/*.keystore`; keep the existing global `*.jks` / `*.keystore` lines as extra safety. |

### Docs

| File | Line(s) | Change |
|------|---------|--------|
| `docs/project_structure.md` | 45 (and the `android/` block at 20–25) | Remove the root `keystore/` entry. Add `keystore.jks (gitignored)` inside the `android/` block. |
| `CLAUDE.md` | 96 | "Release keystore lives at `android/keystore.jks`." |
| `AGENTS.md` | 96 | Same wording as `CLAUDE.md`. |
| `CLAUDE.md` / `AGENTS.md` | 98 | Gitignore list → `key.properties`, `android/*.jks`, `android/*.keystore`, `build/symbols/`. |
| `docs/release_process.md` | 136, 141 | Path → `android/keystore.jks`; gitignore note → `android/*.jks`. |
| `docs/flutter_build_flavors_guide.md` | 745, 769 | Path → `android/keystore.jks`; `storeFile=../keystore.jks`. |
| `docs/flutter_build_flavors_guide.md` | 94–140 (Steps 1–3) | Rewrite to match the guideline: create the keystore at `android/<name>.jks`, use a relative `storeFile`, gitignore `android/*.jks` / `android/*.keystore`. Keep the backup and password-manager advice unchanged. |

No Dart or Gradle source changes. `android/app/build.gradle.kts` already reads
`storeFile` from `key.properties`, so it needs no edit.

---

## 3. The plan

1. Move the keystore file: `keystore/keystore.jks` → `android/keystore.jks`. Copy first,
   confirm the copy exists and has the same size, then delete the original and the empty
   `keystore/` folder. The keystore is never deleted before the copy is verified.
2. Update `android/key.properties` so `storeFile=../keystore.jks`. No passwords or alias
   values are touched, printed, or written into any plan or log file.
3. Update `.gitignore` with the guideline's scoped signing rules, keeping the existing
   global `*.jks` / `*.keystore` lines too.
4. Update the five docs listed above.
5. Rewrite Steps 1–3 of `docs/flutter_build_flavors_guide.md` so the guide no longer tells
   the reader to keep the keystore outside the project.
6. Verify:
   - `git status` shows no `.jks` or `key.properties` file as tracked or untracked-visible.
   - Run `flutter build apk --flavor prod --release --split-per-abi` to prove the release
     signing config still finds the keystore at its new path. (This is the only real proof;
     it takes a few minutes.)
   - `flutter analyze` — should stay clean (no code changed, run as a safety check).
7. Write the change log to `change_log/`.

---

## 4. Risks and notes

- **Signing identity does not change.** The same keystore file, alias, and passwords are
  used — only the path changes. Existing Play Store updates stay valid.
- **Backups:** if any offline backup script or note points at the old root `keystore/`
  path, it must be updated by hand. I cannot see backups outside this repo.
- **Gitignore narrowing:** the guideline's rules are scoped to `android/`. I will keep the
  broader `*.jks` / `*.keystore` lines as well, so no keystore anywhere in the tree can be
  committed by accident. Tell me if you would rather match the guideline exactly and drop
  the broad lines.
- All paths in this plan and the change log are repository-relative, with no secrets.

---

## 5. Question before I start

Do you want me to run the full release APK build as verification (step 6), or skip it and
just check the paths? The build is the only way to be sure Gradle resolves the new
`storeFile`.
