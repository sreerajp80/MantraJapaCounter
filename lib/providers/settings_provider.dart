import 'package:flutter_riverpod/legacy.dart';
import 'package:mantra_japa_counter/models/mala_sound.dart';
import 'package:mantra_japa_counter/repositories/settings_repository.dart';
import 'package:mantra_japa_counter/providers/app_providers.dart';

/// Snapshot of all user settings read from SharedPreferences.
class AppSettings {
  final double screenBrightness;
  final bool dailyGoalNotificationsEnabled;
  final bool malaNotificationsEnabled;
  final MalaSound malaSound;
  final String? notificationSoundUri;
  final String? notificationSoundName;
  final bool vibrationEnabled;
  final String? languageCode;

  const AppSettings({
    required this.screenBrightness,
    required this.dailyGoalNotificationsEnabled,
    required this.malaNotificationsEnabled,
    this.malaSound = MalaSound.templeBell,
    this.notificationSoundUri,
    this.notificationSoundName,
    required this.vibrationEnabled,
    this.languageCode,
  });

  AppSettings copyWith({
    double? screenBrightness,
    bool? dailyGoalNotificationsEnabled,
    bool? malaNotificationsEnabled,
    MalaSound? malaSound,
    String? notificationSoundUri,
    String? notificationSoundName,
    bool clearNotificationSound = false,
    bool? vibrationEnabled,
    String? languageCode,
    bool clearLanguageCode = false,
  }) {
    return AppSettings(
      screenBrightness: screenBrightness ?? this.screenBrightness,
      dailyGoalNotificationsEnabled:
          dailyGoalNotificationsEnabled ?? this.dailyGoalNotificationsEnabled,
      malaNotificationsEnabled:
          malaNotificationsEnabled ?? this.malaNotificationsEnabled,
      malaSound: malaSound ?? this.malaSound,
      notificationSoundUri: clearNotificationSound
          ? null
          : (notificationSoundUri ?? this.notificationSoundUri),
      notificationSoundName: clearNotificationSound
          ? null
          : (notificationSoundName ?? this.notificationSoundName),
      vibrationEnabled: vibrationEnabled ?? this.vibrationEnabled,
      languageCode: clearLanguageCode
          ? null
          : (languageCode ?? this.languageCode),
    );
  }
}

class SettingsNotifier extends StateNotifier<AppSettings> {
  final SettingsRepository _repo;

  SettingsNotifier(this._repo)
    : super(
        AppSettings(
          screenBrightness: _repo.screenBrightness,
          dailyGoalNotificationsEnabled: _repo.dailyGoalNotificationsEnabled,
          malaNotificationsEnabled: _repo.malaNotificationsEnabled,
          malaSound: _repo.malaSound,
          notificationSoundUri: _repo.notificationSoundUri,
          notificationSoundName: _repo.notificationSoundName,
          vibrationEnabled: _repo.vibrationEnabled,
          languageCode: _repo.languageCode,
        ),
      );

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

  Future<void> setMalaSound(MalaSound sound) async {
    await _repo.setMalaSound(sound);
    state = state.copyWith(malaSound: sound);
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

  Future<void> setLanguageCode(String? code) async {
    await _repo.setLanguageCode(code);
    state = (code == null || code == 'system')
        ? state.copyWith(clearLanguageCode: true)
        : state.copyWith(languageCode: code);
  }
}

final settingsNotifierProvider =
    StateNotifierProvider<SettingsNotifier, AppSettings>((ref) {
      return SettingsNotifier(ref.watch(settingsRepositoryProvider));
    });
