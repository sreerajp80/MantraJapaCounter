# Change log: Play Closed Testing readiness — privacy policy and doc fixes

**Plan:** [plans/20261003_095948_play-closed-testing-readiness-docs.md](../plans/20261003_095948_play-closed-testing-readiness-docs.md)

## What changed

### New: `PRIVACY_POLICY.md`
- A public privacy policy in simple English, for the Google Play privacy policy URL:
  `https://github.com/sreerajp80/MantraJapaCounter/blob/main/PRIVACY_POLICY.md`
- It covers: fully offline, no data collected or shared, what is stored on the phone, why each
  permission (Camera, Notifications, Vibrate, Do Not Disturb access) is used, export/import and
  sharing, how to delete data, children, policy changes, and contact.
- The contact is the developer email that is already public in `assets/config/app_config.json`
  and on the About screen.

### `CLAUDE.md`, `AGENTS.md`
- The release build symbol path changed from the fixed `android-prod-v6.10.0/` to
  `android-prod-v<version>/`, with a note to use the `pubspec.yaml` version. Each release now
  keeps its own debug symbols.

### `README.md`
- Added a "11. Privacy" section that links to `PRIVACY_POLICY.md`. License is now section 12.
- Extra fix (same issue as the symbol path): §6 build commands used a fixed `v6.12.2` symbol
  path. They now use `v<version>` like the other docs.

### `docs/release_process.md`
- §8 Security: the permission item now lists the real permissions (VIBRATE, CAMERA,
  POST_NOTIFICATIONS, ACCESS_NOTIFICATION_POLICY) and says storage and RECORD_AUDIO must be absent.
- §8 Product And Documentation: new item to check the privacy policy URL and keep
  `PRIVACY_POLICY.md` in step with the app.

### `docs/security.md`
- §11 permission table: removed the out-of-date `READ_MEDIA_AUDIO` and `READ_EXTERNAL_STORAGE`
  rows; added `CAMERA` and `ACCESS_NOTIFICATION_POLICY` rows. Noted that the tone picker needs no
  storage permission and which permissions are removed in the manifest.
- New rule: a permission change must also update `PRIVACY_POLICY.md` and the Play Data safety form.

## Checks
- `dart format --output=none --set-exit-if-changed .` — 0 files changed.
- `flutter analyze` — no issues.
- `flutter test` — all 228 tests passed.

## Still to do (manual)
- Commit and push, then open the policy URL in a browser to confirm it loads without login.
- Rebuild the AAB at 6.13.5+36 using the versioned symbol path.
- Enter the URL in Play Console → App content → Privacy policy, and fill the Data safety form.
