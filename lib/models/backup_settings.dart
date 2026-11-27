/// User settings stored in a backup file (the optional `settings` object).
///
/// Every field is optional. A field that is null was not in the file, and
/// import leaves the phone's own value for it unchanged. Enum settings are
/// stored by their saved id string (for example `MalaSound.id`).
///
/// Device-only settings (custom notification sound links, the "permission
/// already asked" flag) are never part of a backup.
///
/// Every later app version must still read this object — never rename or
/// remove a field.
class BackupSettings {
  final double? screenBrightness;
  final bool? dailyGoalNotificationsEnabled;
  final bool? lifetimeGoalNotificationsEnabled;
  final bool? malaNotificationsEnabled;
  final String? malaSound;
  final bool? vibrationEnabled;
  final bool? tapVibrationEnabled;
  final int? feedbackVolumePercent;
  final int? vibrationStrengthPercent;

  /// Saved app language. The empty string means "follow the phone".
  final String? languageCode;
  final bool? dndEnabled;
  final bool? dimmedChantingMode;
  final bool? meruPauseEnabled;
  final int? meruPauseSeconds;
  final String? meruPauseMode;
  final int? meruPauseTaps;
  final bool? pacingHintEnabled;
  final bool? dailyReminderEnabled;
  final int? dailyReminderMinutes;

  const BackupSettings({
    this.screenBrightness,
    this.dailyGoalNotificationsEnabled,
    this.lifetimeGoalNotificationsEnabled,
    this.malaNotificationsEnabled,
    this.malaSound,
    this.vibrationEnabled,
    this.tapVibrationEnabled,
    this.feedbackVolumePercent,
    this.vibrationStrengthPercent,
    this.languageCode,
    this.dndEnabled,
    this.dimmedChantingMode,
    this.meruPauseEnabled,
    this.meruPauseSeconds,
    this.meruPauseMode,
    this.meruPauseTaps,
    this.pacingHintEnabled,
    this.dailyReminderEnabled,
    this.dailyReminderMinutes,
  });

  /// Writes only the fields that are set.
  Map<String, dynamic> toJson() => {
    'screenBrightness': ?screenBrightness,
    'dailyGoalNotificationsEnabled': ?dailyGoalNotificationsEnabled,
    'lifetimeGoalNotificationsEnabled': ?lifetimeGoalNotificationsEnabled,
    'malaNotificationsEnabled': ?malaNotificationsEnabled,
    'malaSound': ?malaSound,
    'vibrationEnabled': ?vibrationEnabled,
    'tapVibrationEnabled': ?tapVibrationEnabled,
    'feedbackVolumePercent': ?feedbackVolumePercent,
    'vibrationStrengthPercent': ?vibrationStrengthPercent,
    'languageCode': ?languageCode,
    'dndEnabled': ?dndEnabled,
    'dimmedChantingMode': ?dimmedChantingMode,
    'meruPauseEnabled': ?meruPauseEnabled,
    'meruPauseSeconds': ?meruPauseSeconds,
    'meruPauseMode': ?meruPauseMode,
    'meruPauseTaps': ?meruPauseTaps,
    'pacingHintEnabled': ?pacingHintEnabled,
    'dailyReminderEnabled': ?dailyReminderEnabled,
    'dailyReminderMinutes': ?dailyReminderMinutes,
  };

  /// Reads the object. Missing fields become null. A field with the wrong
  /// type throws a [TypeError], so the caller can refuse the whole file.
  /// Unknown fields are ignored.
  factory BackupSettings.fromJson(Map<String, dynamic> json) => BackupSettings(
    screenBrightness: (json['screenBrightness'] as num?)?.toDouble(),
    dailyGoalNotificationsEnabled:
        json['dailyGoalNotificationsEnabled'] as bool?,
    lifetimeGoalNotificationsEnabled:
        json['lifetimeGoalNotificationsEnabled'] as bool?,
    malaNotificationsEnabled: json['malaNotificationsEnabled'] as bool?,
    malaSound: json['malaSound'] as String?,
    vibrationEnabled: json['vibrationEnabled'] as bool?,
    tapVibrationEnabled: json['tapVibrationEnabled'] as bool?,
    feedbackVolumePercent: _int(json['feedbackVolumePercent']),
    vibrationStrengthPercent: _int(json['vibrationStrengthPercent']),
    languageCode: json['languageCode'] as String?,
    dndEnabled: json['dndEnabled'] as bool?,
    dimmedChantingMode: json['dimmedChantingMode'] as bool?,
    meruPauseEnabled: json['meruPauseEnabled'] as bool?,
    meruPauseSeconds: _int(json['meruPauseSeconds']),
    meruPauseMode: json['meruPauseMode'] as String?,
    meruPauseTaps: _int(json['meruPauseTaps']),
    pacingHintEnabled: json['pacingHintEnabled'] as bool?,
    dailyReminderEnabled: json['dailyReminderEnabled'] as bool?,
    dailyReminderMinutes: _int(json['dailyReminderMinutes']),
  );

  /// Accepts whole numbers only (also `5.0`). Throws on anything else.
  static int? _int(Object? value) {
    if (value == null) return null;
    final n = value as num;
    if (n != n.truncate()) {
      throw const FormatException('Expected a whole number');
    }
    return n.toInt();
  }
}
