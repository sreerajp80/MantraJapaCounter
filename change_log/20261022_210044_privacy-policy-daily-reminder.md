# Change log — Privacy policy: daily reminder and boot permission

**Date:** 2026-10-22 21:00
**Plan:** `plans/20261022_210006_privacy-policy-daily-reminder.md`

## Summary

`PRIVACY_POLICY.md` now covers the daily practice reminder and the new
`RECEIVE_BOOT_COMPLETED` permission, as `docs/security.md` §11 requires for any permission
change.

## What changed (`PRIVACY_POLICY.md` only)

- **Last updated:** 3 October 2026 → 22 October 2026.
- **Data the app stores:** the settings line now lists "daily reminder time".
- **Notifications row:** examples are now daily goal reached, lifetime goal reached and the
  optional daily practice reminder. "Mala completion" was removed, because mala completion is
  sound and vibration only and no longer posts a notification.
- **New row "Run at startup (`RECEIVE_BOOT_COMPLETED`)":** used only to set the optional daily
  reminder again after a restart or app update; nothing else runs, nothing is sent; granted at
  install with no prompt.
- **Refusing permissions:** added that Run at startup is granted at install and cannot be
  refused, but does nothing unless the daily reminder is on.

## Checks

- Read the changed text again: simple English, table format correct.
- No code changed, so `flutter analyze` / `flutter test` were not run.

## Still to do (by you)

- Play Console Data safety form: check it. The app still collects and shares no data, so the
  answers should not change.
- If the privacy policy is also hosted somewhere else (for example a web page linked from the
  Play Store listing), update that copy too.
