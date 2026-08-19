# Update `docs/guidelines` submodule to latest version

**Status:** completed

---

## 1. The issue

The `docs/guidelines` git submodule is currently pinned to commit `aed12618ecb03b9aa671453be7a866f75c54b7bd`.
The upstream repository `https://github.com/sreerajp80/Flutter_Guidelines` has newer updates on its `master` branch at commit `2b381bef414cb8e21c5e90153b2b1cb35a536aaf`.
We need to update the submodule in this repository to point to the latest commit on `master`.

---

## 2. Files to change

| File / Path | Change |
|---|---|
| `docs/guidelines` | Update git submodule commit reference from `aed1261` to `2b381be`. |

---

## 3. The plan

1. Run `git submodule update --remote --merge docs/guidelines` (or `git -C docs/guidelines checkout origin/master`) to check out the latest commit in `docs/guidelines`.
2. Verify the submodule status with `git submodule status` and `git status`.
3. Write the change log entry in `change_log/20260818_110500_update-submodule-guidelines.md`.
4. Update this plan's status to `completed`.

---

## 4. Risks and notes

- All paths in this plan and the change log are repository-relative.
- No source code or assets in the main repository are changed.
- No sensitive data or absolute paths are written.
