import 'package:flutter_riverpod/legacy.dart';
import '../repositories/settings_repository.dart';
import 'app_providers.dart';

/// Snapshot of all user settings read from SharedPreferences.
class AppSettings {
  final double screenBrightness;
  final bool dailyGoalNotificationsEnabled;
  final bool malaNotificationsEnabled;
  final String? notificationSoundUri;
  final String? notificationSoundName;
  final bool vibrationEnabled;

  const AppSettings({
    required this.screenBrightness,
    required this.dailyGoalNotificationsEnabled,
    required this.malaNotificationsEnabled,
    this.notificationSoundUri,
    this.notificationSoundName,
    required this.vibrationEnabled,
  });

  AppSettings copyWith({
    double? screenBrightness,
    bool? dailyGoalNotificationsEnabled,
    bool? malaNotificationsEnabled,
    String? notificationSoundUri,
    String? notificationSoundName,
    bool clearNotificationSound = false,
    bool? vibrationEnabled,
  }) {
    return AppSettings(
      screenBrightness: screenBrightness ?? this.screenBrightness,
      dailyGoalNotificationsEnabled:
          dailyGoalNotificationsEnabled ?? this.dailyGoalNotificationsEnabled,
      malaNotificationsEnabled:
          malaNotificationsEnabled ?? this.malaNotificationsEnabled,
      notificationSoundUri: clearNotificationSound
          ? null
          : (notificationSoundUri ?? this.notificationSoundUri),
      notificationSoundName: clearNotificationSound
          ? null
          : (notificationSoundName ?? this.notificationSoundName),
      vibrationEnabled: vibrationEnabled ?? this.vibrationEnabled,
    );
  }
}

class SettingsNotifier extends StateNotifier<AppSettings> {
  final SettingsRepository _repo;

  SettingsNotifier(this._repo)
      : super(AppSettings(
          screenBrightness: _repo.screenBrightness,
          dailyGoalNotificationsEnabled: _repo.dailyGoalNotificationsEnabled,
          malaNotificationsEnabled: _repo.malaNotificationsEnabled,
          notificationSoundUri: _repo.notificationSoundUri,
          notificationSoundName: _repo.notificationSoundName,
          vibrationEnabled: _repo.vibrationEnabled,
        ));

  Future<void> setScreenBrightness(double value) async {
    await _repo.setScreenBrightness(value);
    state = state.copyWith(screenBrightness: value);
  }

  Future<void> setDailyGoalNotificationsEnabled(bool value) async {
    await _repo.setDailyGoalNotificationsEnabled(value);
    state = state.copyWith(dailyGoalNotificationsEnabled: value);
  }

  Future<void> setMalaNotificationsEnabled(bool value) async {
    await _repo.setMalaNotificationsEnabled(value);
    state = state.copyWith(malaNotificationsEnabled: value);
  }

  Future<void> setNotificationSound(String? uri, String? name) async {
    await _repo.setNotificationSound(uri, name);
    state = uri == null
        ? state.copyWith(clearNotificationSound: true)
        : state.copyWith(
            notificationSoundUri: uri,
            notificationSoundName: name,
          );
  }

  Future<void> setVibrationEnabled(bool value) async {
    await _repo.setVibrationEnabled(value);
    state = state.copyWith(vibrationEnabled: value);
  }
}

final settingsNotifierProvider =
    StateNotifierProvider<SettingsNotifier, AppSettings>((ref) {
  return SettingsNotifier(ref.watch(settingsRepositoryProvider));
});
