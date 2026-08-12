# Release keystore moved to `android/` to match the shared guidelines

Implements [plans/20260812_211832_keystore-location-align-guidelines.md](../plans/20260812_211832_keystore-location-align-guidelines.md).

---

## Why

The project docs said the release keystore lives at `keystore/keystore.jks` in the
repository root. The shared guidelines submodule (`docs/guidelines/guideline.md` §2.1–§2.3)
says the keystore MUST live directly in `android/`. The user decided the shared guidelines
are the authority, so the real file and every doc that named its location were moved to
`android/`.

---

## What changed

### Real files

- **Keystore**: moved from `keystore/keystore.jks` to `android/keystore.jks`. The file was
  copied first and the copy checked byte-for-byte (same size, same SHA-256 hash) before the
  original was deleted. The now-empty root `keystore/` folder was removed.
- **`android/key.properties`**: `storeFile` changed from `../../keystore/keystore.jks` to
  `../keystore.jks`. Gradle resolves this path from `android/app/`, so it points at
  `android/keystore.jks`. No password, alias, or other value in the file was touched.
- **`.gitignore`**: added the guideline's scoped signing rules `android/*.jks` and
  `android/*.keystore` next to the existing `android/key.properties` line. The broader
  `*.jks` / `*.keystore` lines were kept as a catch-all, so no keystore anywhere in the tree
  can be committed by accident.

### Docs

- **`CLAUDE.md`** and **`AGENTS.md`** (Signing / keystore section): keystore path is now
  `android/keystore.jks`, with a pointer to `docs/guidelines/guideline.md` §2.1. Added a note
  that `storeFile` is `../keystore.jks`. Gitignore list updated to the scoped form.
- **`docs/project_structure.md`**: removed the root `keystore/` entry from the tree; added
  `keystore.jks (gitignored)` inside the `android/` block.
- **`docs/release_process.md`**: keystore path updated; the "stored outside the project
  directory" line changed to "kept in `android/` and git-ignored, backed up outside the
  repository"; the gitignore rule updated to `android/*.jks`, `android/*.keystore`.
- **`docs/flutter_build_flavors_guide.md`**:
  - Project-specific section: keystore path and the `key.properties` template now use
    `android/keystore.jks` / `storeFile=../keystore.jks`.
  - Steps 1–3 of the generic guide were rewritten. They previously told the reader to keep
    the keystore **outside** the project and use an **absolute** `storeFile`, which
    contradicted both the shared guideline and the project section of the same file. They now
    generate the keystore into `android/<name>.jks`, use a relative `storeFile`, and list the
    scoped gitignore rules. Backup and password-manager advice was kept.
  - Release checklist gitignore line updated to the scoped form.

No Dart or Gradle source changed. `android/app/build.gradle.kts` already reads `storeFile`
from `key.properties`, so it needed no edit.

The `docs/guidelines/` submodule was not modified — it is the authority, not a target.
Older files in `plans/` and `change_log/` were left as-is because they are historical records.

---

## Verification

- `git check-ignore -v android/keystore.jks android/key.properties` — both ignored
  (via `android/.gitignore`). `git ls-files` confirms the keystore is not tracked.
- `flutter build apk --flavor prod --release --split-per-abi` — succeeded, exit code 0.
  All three ABI APKs were freshly written, which proves the release signing config found the
  keystore at its new path. (If the path were wrong, Gradle would fail with
  "Keystore file ... not found for signing config 'release'".)
- `flutter analyze` — no issues found.

---

## Notes

- The signing identity is unchanged: same keystore file, same alias, same passwords. Only
  the path moved, so existing Play Store updates remain valid.
- If any offline backup note or script points at the old root `keystore/` path, update it by
  hand — backups outside this repository were not visible to this change.
