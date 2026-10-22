# Change log — Daily practice reminders

**Date:** 2026-10-22 20:55
**Plan:** `plans/20261022_035112_daily-practice-reminders.md`

## Summary

The app now has an optional daily practice reminder. In **Settings → Sound & Haptics**
there is a new **Practice reminder** section with a **Daily reminder** switch (off by
default) and a **Reminder time** row (default 06:00). When it is on, one quiet
status-bar notification arrives around that time every day. It is fully offline,
works in English, Malayalam and Sanskrit, and is set again after a phone restart.

## What changed

### Settings and state
- `lib/core/constants/app_constants.dart`: new `daily_reminder` channel id and name;
  named notification ids (daily goal 1, lifetime goal 2, reminder 3); default reminder
  time (360 minutes = 06:00); two new SharedPreferences keys.
- `lib/repositories/settings_repository.dart`: `dailyReminderEnabled` (default off) and
  `dailyReminderMinutes` (minutes after midnight; values outside one day fall back to
  the default).
- `lib/providers/settings_provider.dart`: two new state fields;
  `setDailyReminderEnabled` (asks for the notification permission first and returns
  false, leaving the switch off, if it is refused), `setDailyReminderTime`, and
  `syncDailyReminder` (schedules again with the current time zone and language).
  `setLanguageCode` now calls `syncDailyReminder`, so the text follows the new language.
- `lib/providers/app_providers.dart`: new `timeZoneServiceProvider`.

### Scheduling
- `lib/services/notification_service.dart`: creates the `daily_reminder` channel (no
  sound, no vibration); `scheduleDailyReminder` uses `zonedSchedule` with
  `DateTimeComponents.time` (daily repeat) and
  `AndroidScheduleMode.inexactAllowWhileIdle` (no exact-alarm permission);
  `cancelDailyReminder` cancels only id 3. Unknown time-zone names fall back to UTC.
  The goal alerts now use the named id constants (same values as before).
- New `lib/services/time_zone_service.dart`: reads the phone's time-zone name over the
  existing screen method channel, with a `'UTC'` fallback.
- `pubspec.yaml`: `timezone: ^0.11.1` is now a direct dependency (it was already in the
  lock file through the notifications plugin). The `latest_all` data set is used, so
  older zone names such as `Asia/Calcutta`, which some phones still report, are found.
- `android/app/src/main/kotlin/.../MainActivity.kt`: new `getTimeZoneId` method on the
  screen channel (`TimeZone.getDefault().id`).
- `android/app/src/main/AndroidManifest.xml`: `RECEIVE_BOOT_COMPLETED` permission and
  the plugin's `ScheduledNotificationReceiver` and `ScheduledNotificationBootReceiver`
  (both `exported="false"`).
- `lib/main.dart`: schedules the reminder again (only when it is on) on app start and
  on every resume, so a time-zone change after travel is picked up.

### UI and text
- `lib/screens/settings/sound_settings_screen.dart`: new Practice reminder section.
  The time row shows the time in the app language, opens the time picker, and is dimmed
  and does nothing while the switch is off. A refused permission shows a short message.
- `lib/screens/help/sound_haptics_help_screen.dart`: new "Daily reminder" help section
  that says the reminder comes *around* the chosen time.
- `lib/l10n/app_en.arb`, `app_ml.arb`, `app_sa.arb` (+ generated files): 12 new keys,
  each with an `@key` description in English. The section title is "Practice reminder"
  so it does not repeat the switch title "Daily reminder".

### Docs
- `docs/implementation_progress.md`: reminder item ticked.
- `docs/features.md`: new "Daily Practice Reminder" entry.
- `docs/security.md`: `RECEIVE_BOOT_COMPLETED` row in the permissions table.

### Tests
- `test/services/notification_service_test.dart`: channel, id 3, daily repeat, inexact
  mode, local time and zone, language, UTC fallback, older zone names, cancel, and the
  "later today / tomorrow" time maths.
- `test/repositories/settings_repository_test.dart`: defaults, save/load, out-of-range
  time.
- `test/providers/settings_provider_test.dart`: on schedules, off cancels, refused
  permission stays off, time change, language change, sync only when on, UTC fallback.
- `test/screens/sound_settings_screen_test.dart`: rows shown at 6:00 AM, time row does
  nothing while off, turning on schedules and enables the picker, refused permission
  message.
- New `test/helpers/fake_notification_service.dart` (shared fakes).
- `test/providers/counting_provider_test.dart`: its own notification fake gained the two
  new methods so it still compiles. (Not in the plan's file list; needed because the
  service gained methods.)

## Checks

- `dart format .`: no changes needed.
- `flutter gen-l10n`: generated files are current.
- `flutter analyze`: no issues.
- `flutter test`: all 398 tests pass.
- `flutter build apk --flavor dev --debug`: builds. The merged manifest has
  `RECEIVE_BOOT_COMPLETED` and both receivers. `INTERNET` shows in this **debug**
  manifest only, from the standard debug-only `android/app/src/debug/AndroidManifest.xml`
  (Flutter needs it for hot reload). This was already the case. The main manifest still
  removes it, so release builds stay without it; check the merged release manifest at
  release time as usual.
- Gradle daemons stopped with `gradlew --stop`; one leftover Gradle and one Kotlin daemon
  were ended, and none are left.

## Not done / still to check

- Manual phone check (plan step 9): set a reminder 2 minutes ahead and wait for it;
  restart the phone and check it fires the next day. This needs a real device.
- `PRIVACY_POLICY.md` and the Play Console Data safety form: `docs/security.md` says any
  permission change must also update these. They were not in the plan, so they are not
  changed here.
- The dev build updated the tracked `lib/core/utils/build_date.g.dart` (build date only).
