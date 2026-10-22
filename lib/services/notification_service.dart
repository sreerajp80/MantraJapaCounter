import 'dart:ui' show Locale;

import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz_data;
import 'package:timezone/timezone.dart' as tz;
import 'package:mantra_japa_counter/core/constants/app_constants.dart';
import 'package:mantra_japa_counter/core/locale/locale_config.dart';

/// Notification service: visible status-bar entries for daily goal
/// completion, lifetime goal completion and the daily practice reminder.
///
/// Sound is played by `SoundService` (user-configured ringtone) and vibration
/// is triggered natively by `HapticFeedbackService` with USAGE_ALARM so it
/// bypasses silent / DND. The channel itself stays silent — it only renders
/// the visible toast. Mala completion is sound + vibration only (no
/// status-bar entry per mala).
///
/// Widgets must not call this directly — use CountingNotifier which decides
/// when to trigger notifications based on business rules.
class NotificationService {
  final FlutterLocalNotificationsPlugin _plugin;

  NotificationService(this._plugin);

  static Future<void> initialize(FlutterLocalNotificationsPlugin plugin) async {
    const initSettings = InitializationSettings(
      android: AndroidInitializationSettings('@mipmap/ic_launcher'),
    );
    await plugin.initialize(settings: initSettings);

    // Create notification channels (Android 8+)
    final android = plugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();
    if (android != null) {
      // Drop any prior channels first — Android caches the sound config from
      // creation time, so a channel that once had `playSound: true` will keep
      // playing the system default even after we flip the flag. The mala
      // channel from older builds is also deleted; mala completion no longer
      // posts a status-bar entry.
      await android.deleteNotificationChannel(
        channelId: AppConstants.dailyGoalChannelId,
      );
      await android.deleteNotificationChannel(
        channelId: AppConstants.malaChannelId,
      );

      await android.createNotificationChannel(
        const AndroidNotificationChannel(
          AppConstants.dailyGoalChannelId,
          AppConstants.dailyGoalChannelName,
          description: 'Alerts when you reach your daily mantra goal',
          playSound: false,
          enableVibration: false,
        ),
      );
      await android.createNotificationChannel(
        const AndroidNotificationChannel(
          AppConstants.lifetimeGoalChannelId,
          AppConstants.lifetimeGoalChannelName,
          description: 'Alerts when you reach your lifetime mantra goal',
          playSound: false,
          enableVibration: false,
        ),
      );
      await android.createNotificationChannel(
        const AndroidNotificationChannel(
          AppConstants.dailyReminderChannelId,
          AppConstants.dailyReminderChannelName,
          description: 'A quiet daily reminder to do your japa',
          playSound: false,
          enableVibration: false,
        ),
      );
    }
  }

  Future<void> notifyDailyGoalReached() async {
    final l10n = LocaleConfig.strings();
    await _plugin.show(
      id: AppConstants.dailyGoalNotificationId,
      title: l10n.notifDailyGoalTitle,
      body: l10n.notifDailyGoalBody,
      notificationDetails: const NotificationDetails(
        android: AndroidNotificationDetails(
          AppConstants.dailyGoalChannelId,
          AppConstants.dailyGoalChannelName,
          enableVibration: false,
          playSound: false,
        ),
      ),
    );
  }

  Future<void> notifyLifetimeGoalReached() async {
    final l10n = LocaleConfig.strings();
    await _plugin.show(
      id: AppConstants.lifetimeGoalNotificationId,
      title: l10n.notifLifetimeGoalTitle,
      body: l10n.notifLifetimeGoalBody,
      notificationDetails: const NotificationDetails(
        android: AndroidNotificationDetails(
          AppConstants.lifetimeGoalChannelId,
          AppConstants.lifetimeGoalChannelName,
          enableVibration: false,
          playSound: false,
        ),
      ),
    );
  }

  /// Schedules the daily practice reminder at [minutesAfterMidnight] local
  /// time in [timeZoneId], repeating every day. Replaces any earlier
  /// reminder. The text uses [locale], or the active app language.
  ///
  /// Inexact mode needs no exact-alarm permission; Android may deliver the
  /// reminder a few minutes late.
  Future<void> scheduleDailyReminder({
    required int minutesAfterMidnight,
    required String timeZoneId,
    Locale? locale,
  }) async {
    final location = reminderLocation(timeZoneId);
    final l10n = LocaleConfig.strings(locale);
    await _plugin.zonedSchedule(
      id: AppConstants.dailyReminderNotificationId,
      title: l10n.notifDailyReminderTitle,
      body: l10n.notifDailyReminderBody,
      scheduledDate: nextReminderTime(
        tz.TZDateTime.now(location),
        minutesAfterMidnight,
      ),
      notificationDetails: const NotificationDetails(
        android: AndroidNotificationDetails(
          AppConstants.dailyReminderChannelId,
          AppConstants.dailyReminderChannelName,
          enableVibration: false,
          playSound: false,
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  Future<void> cancelDailyReminder() async {
    await _plugin.cancel(id: AppConstants.dailyReminderNotificationId);
  }

  /// The time-zone [timeZoneId], or UTC when it is not known. The built-in
  /// time-zone data is loaded on first use (no network).
  @visibleForTesting
  static tz.Location reminderLocation(String timeZoneId) {
    if (!tz.timeZoneDatabase.isInitialized) tz_data.initializeTimeZones();
    try {
      return tz.getLocation(timeZoneId);
    } on tz.LocationNotFoundException {
      return tz.UTC;
    }
  }

  /// The first time at [minutesAfterMidnight] that is after [now], in the
  /// same time zone as [now].
  @visibleForTesting
  static tz.TZDateTime nextReminderTime(
    tz.TZDateTime now,
    int minutesAfterMidnight,
  ) {
    final hour = minutesAfterMidnight ~/ 60;
    final minute = minutesAfterMidnight % 60;
    var next = tz.TZDateTime(
      now.location,
      now.year,
      now.month,
      now.day,
      hour,
      minute,
    );
    if (!next.isAfter(now)) {
      next = tz.TZDateTime(
        now.location,
        now.year,
        now.month,
        now.day + 1,
        hour,
        minute,
      );
    }
    return next;
  }

  /// Asks Android 13+ for the notification permission when it is not
  /// granted yet. Returns true when notifications can be shown.
  Future<bool> requestPermissionIfNeeded() async {
    try {
      final android = _plugin
          .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin
          >();
      if (android == null) return true;
      if (await android.areNotificationsEnabled() ?? false) return true;
      return await android.requestNotificationsPermission() ?? false;
    } catch (_) {
      return false;
    }
  }

  Future<void> cancelAll() async {
    await _plugin.cancelAll();
  }
}
