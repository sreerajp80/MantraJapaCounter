# Play Closed Testing readiness: privacy policy and doc fixes

**Status:** completed

## Issue

A readiness check for Google Play Closed Testing found three problems:

1. **No privacy policy URL.** Google Play needs a public privacy policy URL for every app,
   even a fully offline one. The app asks for the CAMERA permission (for Optical Sync), so
   the Data safety form and the policy must explain it. No policy exists in the repo.
2. **Debug symbol path is hard-coded to an old version.** The release build commands in
   `CLAUDE.md` and `AGENTS.md` always write symbols to `build/symbols/android-prod-v6.10.0/`.
   The app is now at 6.13.5. Every release build writes over the previous release's symbols,
   so crash traces from older releases can no longer be decoded.
3. **Permission lists in the docs are out of date.** `docs/release_process.md` (§8, Security
   checklist) and `docs/security.md` (§11) list `READ_MEDIA_AUDIO` and `READ_EXTERNAL_STORAGE`.
   The real merged release manifest has `VIBRATE`, `CAMERA`, `POST_NOTIFICATIONS` and
   `ACCESS_NOTIFICATION_POLICY`. The storage permissions are removed in the manifest
   (`tools:node="remove"`), and the tone picker uses the system file picker, which needs no
   permission.

## Files to change

| File | Change |
|------|--------|
| `PRIVACY_POLICY.md` (new, repo root) | The public privacy policy |
| `README.md` | Add a "Privacy" link to `PRIVACY_POLICY.md` |
| `CLAUDE.md` | Replace `v6.10.0` in the two symbol paths with a version placeholder |
| `AGENTS.md` | Same change as `CLAUDE.md` |
| `docs/release_process.md` | Fix the permission list in §8; add a checklist item for the privacy policy URL |
| `docs/security.md` | Update the §11 permission table to match the real manifest |

Old files in `plans/` and `change_log/` that mention `v6.10.0` are history and will not be changed.

No app code, no `.arb` files and no dependencies change. `flutter analyze` and `flutter test`
will still be run at the end to confirm nothing broke.

## Plan for the fix

### 1. Privacy policy (`PRIVACY_POLICY.md`)

The GitHub repository is public, so a Markdown file in it gives a stable public URL:

`https://github.com/sreerajp80/MantraJapaCounter/blob/main/PRIVACY_POLICY.md`

This URL goes into Play Console → App content → Privacy policy. Short, simple English. Sections:

- **Summary** — the app is fully offline. It has no internet permission, so it cannot send data
  anywhere. No accounts, no ads, no analytics, no crash reporting, no tracking.
- **Data the app stores** — counter names, counts, sessions, notes and settings. They are kept only
  in the app's private storage on the phone. Android backup is turned off, so they are not copied to
  Google Drive.
- **Permissions and why**
  - `CAMERA` — only for Optical Sync (receiving data from another phone by scanning QR codes).
    Frames are read on the phone and thrown away. No photos or video are saved or sent. Asked
    only when the user starts a camera receive.
  - `POST_NOTIFICATIONS` — local reminders and mala / daily-goal alerts.
  - `VIBRATE` — vibration on mala and daily-goal completion.
  - `ACCESS_NOTIFICATION_POLICY` — optional Do Not Disturb during chanting, only if the user turns
    it on.
- **Export, import and sharing** — the user can export a backup file (optionally encrypted with a
  passphrase) and share it with the Android share sheet. The user chooses where it goes; the app
  itself sends nothing.
- **Deleting data** — delete counters in the app, clear app data, or uninstall.
- **Children** — the app does not knowingly collect any data from anyone, including children.
- **Changes to this policy** — changes are made in this file; the "Last updated" date shows the
  latest version.
- **Contact** — the developer contact email that is already shown publicly on the app's About
  screen.
- **Last updated** — the date of the change.

Notes:
- The page must stay public. If the repository is ever made private, the Play link breaks and
  Play may remove the app. If that becomes a risk, the same file can later move to GitHub Pages.
- No in-app link to the policy is added. The app has no browser-launch dependency and the About
  screen already states the privacy summary. This can be a separate change if wanted.

### 2. Symbol path (`CLAUDE.md`, `AGENTS.md`)

Change `build/symbols/android-prod-v6.10.0/` to `build/symbols/android-prod-v<version>/`, with a
one-line note: "Replace `<version>` with the `pubspec.yaml` version, e.g. `6.13.5`." This matches
the way `docs/release_process.md` §6.1 already writes it, so it never goes stale again.

### 3. Permission docs

- `docs/release_process.md` §8 Security checklist: change the permission item to list `VIBRATE`,
  `CAMERA`, `POST_NOTIFICATIONS` (Android 13+) and `ACCESS_NOTIFICATION_POLICY`, and state that
  storage permissions must be absent.
- `docs/release_process.md` §8 Product And Documentation: add "Privacy policy URL in Play Console
  is reachable and `PRIVACY_POLICY.md` matches the current permissions."
- `docs/security.md` §11: replace the `READ_MEDIA_AUDIO` and `READ_EXTERNAL_STORAGE` rows with
  `CAMERA` and `ACCESS_NOTIFICATION_POLICY` rows (why, when asked, what happens if denied). Note
  that the custom tone picker uses the system file picker and needs no storage permission. Update
  the last bullet that names these permissions.

### 4. Check and log

- Run `dart format --output=none --set-exit-if-changed .`, `flutter analyze`, `flutter test`.
- Write the change log in `change_log/`.
- After you commit and push, open the policy URL in a browser to confirm it loads without login.

## Out of scope (your manual steps)

- Commit and push (the URL only works after the file is on GitHub `main`).
- Rebuild the AAB at 6.13.5+36 with the versioned symbols path.
- Fill in the Play Console forms (privacy policy URL, Data safety, content rating, etc.).
