# Plan — Add the daily reminder and boot permission to the privacy policy

**Status:** completed

**Date:** 2026-10-22 21:00
**Comes from:** `plans/20261022_035112_daily-practice-reminders.md` (its change log lists this as not done).
**Change log:** `change_log/20261022_210044_privacy-policy-daily-reminder.md`

---

## 1. Issue

The daily practice reminder added the `RECEIVE_BOOT_COMPLETED` permission. `docs/security.md`
§11 says any change to the permission list must also update `PRIVACY_POLICY.md` (and the Play
Console Data safety form). The policy does not yet mention the new permission or the reminder.

---

## 2. Files to change

- `PRIVACY_POLICY.md` (only this file)

---

## 3. Fix

1. **Permissions table** — add one row, after "Do Not Disturb access":

   | Run at startup (`RECEIVE_BOOT_COMPLETED`) | Only for the optional **daily reminder**. After the phone restarts or the app is updated, Android lets the app set the reminder again. Nothing else runs, and nothing is sent. Android grants this at install; there is no prompt. |

2. **Notifications row** — add the reminder to the examples:
   "To show local alerts, such as daily goal reached, lifetime goal reached and the optional
   daily practice reminder. These are made on the phone; nothing is sent from a server."
   (This also drops "mala completion": mala completion is sound and vibration only and no longer
   posts a notification.)

3. **Data the app stores** — in the settings line, add "daily reminder time":
   "app settings (language, sounds, vibration, daily reminder time and so on)."

4. **Last updated** — change to **22 October 2026**.

5. **"You can refuse any of these permissions"** line — keep it, and add: "Run at startup is
   granted at install and cannot be refused, but it does nothing unless the daily reminder is on."

No other text changes.

---

## 4. Not in this plan

- **Play Console Data safety form:** this is done in the Play Console website, so you need to do
  it. The app still collects and shares no data, so the answers should not change. Only the
  permission list shown on the store page changes, and that comes from the app bundle
  automatically.

---

## 5. Checks

- Read the changed file once more for simple English and correct table format.
- No code changes, so no `flutter analyze` / `flutter test` needed.
- Write the change log and set this plan to `completed`.
