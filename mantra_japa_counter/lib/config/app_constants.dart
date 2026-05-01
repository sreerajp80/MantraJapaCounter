/// App-wide constants. No business logic here — values only.
class AppConstants {
  // Database
  static const String dbName = 'japa_counter.db';
  static const int dbVersion = 3;

  // Mala
  static const int malaSize = 108;

  // Crash-recovery batch thresholds (SharedPreferences)
  static const int prefsBatchTapCount = 5;
  static const int prefsBatchIntervalSeconds = 5;

  // Database batch thresholds
  static const int dbBatchTapCount = 20;
  static const int dbBatchIntervalSeconds = 30;

  // Display timer update interval
  static const int displayTimerIntervalSeconds = 2;

  // Notification channel IDs
  static const String dailyGoalChannelId = 'daily_goal_channel';
  static const String dailyGoalChannelName = 'Daily Goal';
  static const String malaChannelId = 'mala_channel';
  static const String malaChannelName = 'Mala Completion';

  // SharedPreferences keys (only the repository should use these)
  // Per-counter active sessions are stored under "$prefsActiveSessionPrefix$counterId".
  // The legacy single-slot key is migrated on first read.
  static const String prefsActiveSessionPrefix = 'active_session_';
  static const String prefsLegacyActiveSessionKey = 'active_session';
  static const String prefsBrightnessKey = 'screen_brightness';
  static const String prefsDailyGoalNotifKey = 'daily_goal_notifications';
  static const String prefsMalaNotifKey = 'mala_notifications';
  static const String prefsNotifSoundUriKey = 'notification_sound_uri';
  static const String prefsNotifSoundNameKey = 'notification_sound_name';
  static const String prefsVibrationKey = 'notification_vibration';

  // Export
  static const int exportFormatVersion = 1;
}
