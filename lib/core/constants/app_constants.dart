/// App-wide constants. No business logic here — values only.
class AppConstants {
  // Database
  static const String dbName = 'japa_counter.db';
  static const int dbVersion = 4;

  // Mala
  static const int malaSize = 108;

  // Meru pause after each mala (seconds). Choices shown in Settings.
  static const List<int> meruPauseChoicesSeconds = [3, 5, 10];
  static const int meruPauseDefaultSeconds = 5;

  // Pacing hint: taps faster than this rate (averaged over the last
  // [pacingWindowTaps] taps) count as rushing. The hint clears
  // [pacingHintHoldMs] after the last fast tap.
  static const double pacingMaxTapsPerSecond = 3.0;
  static const int pacingWindowTaps = 5;
  static const int pacingHintHoldMs = 3000;

  // Sadhana Flow heat-map: number of weeks shown on the History screen.
  static const int sadhanaFlowWeeks = 16;
  // A gap of this many days since the last practice shows "welcome back".
  static const int sadhanaFlowWelcomeBackDays = 3;

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
  static const String lifetimeGoalChannelId = 'lifetime_goal_channel';
  static const String lifetimeGoalChannelName = 'Lifetime Goal';
  static const String malaChannelId = 'mala_channel';
  static const String malaChannelName = 'Mala Completion';

  // SharedPreferences keys (only the repository should use these)
  // Per-counter active sessions are stored under "$prefsActiveSessionPrefix$counterId".
  // The legacy single-slot key is migrated on first read.
  static const String prefsActiveSessionPrefix = 'active_session_';
  static const String prefsLegacyActiveSessionKey = 'active_session';
  static const String prefsBrightnessKey = 'screen_brightness';
  static const String prefsDailyGoalNotifKey = 'daily_goal_notifications';
  static const String prefsLifetimeGoalNotifKey = 'lifetime_goal_notifications';
  static const String prefsMalaNotifKey = 'mala_notifications';
  static const String prefsMalaSoundKey = 'mala_sound';
  static const String prefsNotifSoundUriKey = 'notification_sound_uri';
  static const String prefsNotifSoundNameKey = 'notification_sound_name';
  static const String prefsLifetimeSoundUriKey = 'lifetime_sound_uri';
  static const String prefsLifetimeSoundNameKey = 'lifetime_sound_name';
  static const String prefsVibrationKey = 'notification_vibration';
  static const String prefsLanguageCodeKey = 'app_language_code';
  static const String prefsDndKey = 'dnd_enabled';
  static const String prefsNotifPermissionAskedKey =
      'notification_permission_asked';
  static const String prefsDimmedChantingKey = 'dimmed_chanting_mode';
  static const String prefsMeruPauseKey = 'meru_pause_enabled';
  static const String prefsMeruPauseSecondsKey = 'meru_pause_seconds';
  static const String prefsPacingHintKey = 'pacing_hint_enabled';

  // Export
  static const int exportFormatVersion = 1;
}
