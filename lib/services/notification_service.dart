import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../config/app_constants.dart';
import '../config/locale_config.dart';

/// Notification service: visible status-bar entry for daily goal completion.
///
/// Sound is played by `SoundService` (user-configured ringtone) and vibration
/// is triggered natively by `HapticFeedbackService` with USAGE_ALARM so it
/// bypasses silent / DND. The channel itself stays silent — it only renders
/// the visible toast. Mala completion is sound + vibration only (matches the
/// original Kotlin app — no status-bar entry per 108 counts).
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
          importance: Importance.defaultImportance,
          playSound: false,
          enableVibration: false,
        ),
      );
    }
  }

  Future<void> notifyDailyGoalReached() async {
    final l10n = LocaleConfig.strings();
    await _plugin.show(
      id: 1,
      title: l10n.notifDailyGoalTitle,
      body: l10n.notifDailyGoalBody,
      notificationDetails: const NotificationDetails(
        android: AndroidNotificationDetails(
          AppConstants.dailyGoalChannelId,
          AppConstants.dailyGoalChannelName,
          importance: Importance.defaultImportance,
          priority: Priority.defaultPriority,
          enableVibration: false,
          playSound: false,
        ),
      ),
    );
  }

  Future<void> cancelAll() async {
    await _plugin.cancelAll();
  }
}
