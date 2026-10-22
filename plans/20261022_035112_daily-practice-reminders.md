# Plan — Daily practice reminders

**Status:** completed

**Date:** 2026-10-22 03:51
**Comes from:** `plans/20261022_033000_implementation-gap-fixes.md` §3.3 (you chose Option B: build reminders as a separate plan).
**Change log:** `change_log/20261022_205546_daily-practice-reminders.md`

---

## 1. Issue

`docs/implementation_progress.md` used to list "offline daily reminders" as done, but the
app never had them. `NotificationService` only shows "daily goal reached" and "lifetime
goal reached" alerts. The gap-fix plan changed the doc line to "planned — not built
yet". This plan builds the feature.

---

## 2. What the user gets

- In **Settings → Sound & notifications**, a new **Daily reminder** switch (off by
  default) and a **Reminder time** row (default 06:00) that opens the time picker.
- Each day at that time, one quiet status-bar notification: a title and a short line
  (for example "Time for your japa"). Tapping it opens the app.
- Fully offline. Nothing leaves the phone. No new network permission.
- Works in English, Malayalam and Sanskrit.
- Still fires after the phone restarts.

**Not included:** more than one reminder a day, a reminder per counter, skipping a day
when the goal is already met, and reminder sound choice. These could come later.

---

## 3. Design

### 3.1 Scheduling

- Use `flutter_local_notifications` `zonedSchedule(...)` with
  `matchDateTimeComponents: DateTimeComponents.time`, so it repeats daily.
- Use `AndroidScheduleMode.inexactAllowWhileIdle`. This needs **no exact-alarm
  permission**. Android may deliver it a few minutes late, which is fine for a
  reminder. (Exact alarms need the special `SCHEDULE_EXACT_ALARM` permission and a
  Play Store justification, so we avoid them.)
- New notification channel `daily_reminder` (normal importance, default sound off,
  matching the app's quiet style). Its id and name go in `AppConstants`.
- Fixed notification id (3) so re-scheduling replaces the old one.

### 3.2 Time zone

- `zonedSchedule` needs a `TZDateTime`. Add the `timezone` package as a direct
  dependency (it is already in the lock file through the notifications plugin). It is
  pure Dart with the time-zone data built in, so no network use.
- The device's time-zone name (for example `Asia/Kolkata`) comes from one new method,
  `getTimeZoneId`, on the existing native channel in `MainActivity.kt`
  (`TimeZone.getDefault().id`). This avoids adding a new plugin.
- When the app resumes (the existing check in `main.dart`), it re-checks the time
  zone and re-schedules if it changed (for example after travel).

### 3.3 Restart survival

- Add `RECEIVE_BOOT_COMPLETED` permission and the plugin's
  `ScheduledNotificationBootReceiver` and `ScheduledNotificationReceiver` to
  `android/app/src/main/AndroidManifest.xml`, as the plugin docs require. This is an
  extra permission, so `docs/security.md` gets a line explaining why.

### 3.4 Permission

- Android 13+ needs the notification permission. Turning the switch on calls the
  existing `NotificationService.requestPermissionIfNeeded()`. If it is refused, the
  switch goes back to off and a short message explains why.

### 3.5 Layers (per `docs/architecture.md`)

| Layer | Change |
|-------|--------|
| `services/notification_service.dart` | `scheduleDailyReminder(TimeOfDay-like hour/minute, String timeZoneId)`, `cancelDailyReminder()`; channel created in `initialize`. No `BuildContext`. Strings come from `LocaleConfig.strings()` like the goal alerts. |
| `services/screen_service.dart` or a new small `services/time_zone_service.dart` | `getTimeZoneId()` over the native channel, with `'UTC'` fallback on error. |
| `repositories/settings_repository.dart` | `dailyReminderEnabled` (bool), `dailyReminderMinutes` (int, minutes after midnight, default 360). Keys stay inside the repository. |
| `providers/settings_provider.dart` | State fields + `setDailyReminderEnabled`, `setDailyReminderTime`; each one schedules or cancels. |
| `screens/settings/sound_settings_screen.dart` | Switch + time row. No SQL, keys or channel ids in the widget. |
| `main.dart` | On start and on resume: if enabled, re-schedule (cheap, keeps time zone and language current). |

### 3.6 Language changes

The notification text is fixed when it is scheduled. When the user changes the app
language, the settings provider re-schedules so the next reminder uses the new language.

---

## 4. Files to change

**Changed**
- `pubspec.yaml` (add `timezone` as a direct dependency; run `flutter pub get`)
- `lib/core/constants/app_constants.dart`
- `lib/services/notification_service.dart`
- `lib/services/screen_service.dart` *or* new `lib/services/time_zone_service.dart`
- `lib/repositories/settings_repository.dart`
- `lib/providers/settings_provider.dart`
- `lib/providers/app_providers.dart` (only if a new service is added)
- `lib/screens/settings/sound_settings_screen.dart`
- `lib/main.dart`
- `lib/l10n/app_en.arb`, `app_ml.arb`, `app_sa.arb` (+ `flutter gen-l10n`): switch title and sub-text, time row title, notification title and body, permission-refused message — each with an `@key` description
- `android/app/src/main/kotlin/.../MainActivity.kt` (`getTimeZoneId`)
- `android/app/src/main/AndroidManifest.xml` (boot permission + receivers)
- `lib/screens/help/sound_haptics_help_screen.dart` and its ARB strings (one short help line)
- `docs/implementation_progress.md` (tick reminders), `docs/features.md`, `docs/security.md`

**New tests**
- `test/services/notification_service_test.dart`: schedule uses the reminder channel, id 3, daily repeat, inexact mode, the right local time; cancel removes id 3.
- `test/repositories/settings_repository_test.dart`: defaults and save/load of the two new values.
- `test/providers/settings_provider_test.dart`: switch on schedules, off cancels, time change re-schedules, permission refused leaves it off.
- `test/screens/sound_settings_screen_test.dart`: switch and time row show; time row is disabled while the switch is off.
- `test/l10n/translation_parity_test.dart` already checks the new keys exist in all three languages.

---

## 5. Order of work

1. Settings repository + provider + tests.
2. Time-zone method (Kotlin + Dart) + `timezone` dependency.
3. Notification service scheduling + tests.
4. Manifest changes.
5. Settings screen UI + ARB strings + help line + tests.
6. `main.dart` start/resume re-schedule.
7. `dart format .`, `flutter gen-l10n`, `flutter analyze`, `flutter test`.
8. One `flutter build apk --flavor dev --debug` to check the manifest merge and that
   no `INTERNET` permission appears; then `android\gradlew --stop` and check no
   Gradle/Kotlin daemons are left.
9. Manual check on a phone: set a reminder 2 minutes ahead, wait for it; restart the
   phone and check it still fires the next day. (You do this; I can't run a device
   restart.)
10. Docs and change log; set this plan to `completed`.

---

## 6. Risks

- **Late delivery:** inexact mode can be several minutes late on some phones with strict
  battery saving. The help line will say "around" the chosen time.
- **New permission:** `RECEIVE_BOOT_COMPLETED` is a normal (install-time) permission and
  does not show a prompt, but it does show in the Play Store listing.
- **Pre-release plugin:** the app uses `flutter_local_notifications 23.0.0-dev.3`.
  Scheduling APIs in a dev build may still change; tests pin the behaviour we rely on.
