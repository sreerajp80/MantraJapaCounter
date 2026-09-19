import 'package:flutter_riverpod/legacy.dart';
import 'package:mantra_japa_counter/models/mala_sound.dart';
import 'package:mantra_japa_counter/repositories/settings_repository.dart';
import 'package:mantra_japa_counter/providers/app_providers.dart';

/// Snapshot of all user settings read from SharedPreferences.
class AppSettings {
  final double screenBrightness;
  final bool dailyGoalNotificationsEnabled;
  final bool lifetimeGoalNotificationsEnabled;
  final bool malaNotificationsEnabled;
  final MalaSound malaSound;
  final String? notificationSoundUri;
  final String? notificationSoundName;
  final String? lifetimeSoundUri;
  final String? lifetimeSoundName;
  final bool vibrationEnabled;
  final String? languageCode;
  final bool dndEnabled;
  final bool dimmedChantingMode;

  const AppSettings({
    required this.screenBrightness,
    required this.dailyGoalNotificationsEnabled,
    this.lifetimeGoalNotificationsEnabled = true,
    required this.malaNotificationsEnabled,
    this.malaSound = MalaSound.templeBell,
    this.notificationSoundUri,
    this.notificationSoundName,
    this.lifetimeSoundUri,
    this.lifetimeSoundName,
    required this.vibrationEnabled,
    this.languageCode,
    this.dndEnabled = false,
    this.dimmedChantingMode = false,
  });

  AppSettings copyWith({
    double? screenBrightness,
    bool? dailyGoalNotificationsEnabled,
    bool? lifetimeGoalNotificationsEnabled,
    bool? malaNotificationsEnabled,
    MalaSound? malaSound,
    String? notificationSoundUri,
    String? notificationSoundName,
    bool clearNotificationSound = false,
    String? lifetimeSoundUri,
    String? lifetimeSoundName,
    bool clearLifetimeSound = false,
    bool? vibrationEnabled,
    String? languageCode,
    bool clearLanguageCode = false,
    bool? dndEnabled,
    bool? dimmedChantingMode,
  }) {
    return AppSettings(
      screenBrightness: screenBrightness ?? this.screenBrightness,
      dailyGoalNotificationsEnabled:
          dailyGoalNotificationsEnabled ?? this.dailyGoalNotificationsEnabled,
      lifetimeGoalNotificationsEnabled:
          lifetimeGoalNotificationsEnabled ??
          this.lifetimeGoalNotificationsEnabled,
      malaNotificationsEnabled:
          malaNotificationsEnabled ?? this.malaNotificationsEnabled,
      malaSound: malaSound ?? this.malaSound,
      notificationSoundUri: clearNotificationSound
          ? null
          : (notificationSoundUri ?? this.notificationSoundUri),
      notificationSoundName: clearNotificationSound
          ? null
          : (notificationSoundName ?? this.notificationSoundName),
      lifetimeSoundUri: clearLifetimeSound
          ? null
          : (lifetimeSoundUri ?? this.lifetimeSoundUri),
      lifetimeSoundName: clearLifetimeSound
          ? null
          : (lifetimeSoundName ?? this.lifetimeSoundName),
      vibrationEnabled: vibrationEnabled ?? this.vibrationEnabled,
      languageCode: clearLanguageCode
          ? null
          : (languageCode ?? this.languageCode),
      dndEnabled: dndEnabled ?? this.dndEnabled,
      dimmedChantingMode: dimmedChantingMode ?? this.dimmedChantingMode,
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
          lifetimeGoalNotificationsEnabled:
              _repo.lifetimeGoalNotificationsEnabled,
          malaNotificationsEnabled: _repo.malaNotificationsEnabled,
          malaSound: _repo.malaSound,
          notificationSoundUri: _repo.notificationSoundUri,
          notificationSoundName: _repo.notificationSoundName,
          lifetimeSoundUri: _repo.lifetimeSoundUri,
          lifetimeSoundName: _repo.lifetimeSoundName,
          vibrationEnabled: _repo.vibrationEnabled,
          languageCode: _repo.languageCode,
          dndEnabled: _repo.dndEnabled,
          dimmedChantingMode: _repo.dimmedChantingMode,
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

  Future<void> setLifetimeGoalNotificationsEnabled(bool value) async {
    await _repo.setLifetimeGoalNotificationsEnabled(value);
    state = state.copyWith(lifetimeGoalNotificationsEnabled: value);
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

  Future<void> setLifetimeSound(String? uri, String? name) async {
    await _repo.setLifetimeSound(uri, name);
    state = uri == null
        ? state.copyWith(clearLifetimeSound: true)
        : state.copyWith(lifetimeSoundUri: uri, lifetimeSoundName: name);
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

  Future<void> setDndEnabled(bool value) async {
    await _repo.setDndEnabled(value);
    state = state.copyWith(dndEnabled: value);
  }

  Future<void> setDimmedChantingMode(bool value) async {
    await _repo.setDimmedChantingMode(value);
    state = state.copyWith(dimmedChantingMode: value);
  }
}

final settingsNotifierProvider =
    StateNotifierProvider<SettingsNotifier, AppSettings>((ref) {
      return SettingsNotifier(ref.watch(settingsRepositoryProvider));
    });
