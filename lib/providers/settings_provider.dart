import 'dart:async';

import 'package:flutter/foundation.dart';

import 'package:flutter_riverpod/legacy.dart';
import 'package:mantra_japa_counter/core/constants/app_constants.dart';
import 'package:mantra_japa_counter/core/locale/locale_config.dart';
import 'package:mantra_japa_counter/models/mala_sound.dart';
import 'package:mantra_japa_counter/repositories/settings_repository.dart';
import 'package:mantra_japa_counter/providers/app_providers.dart';
import 'package:mantra_japa_counter/services/notification_service.dart';
import 'package:mantra_japa_counter/services/screen_service.dart';
import 'package:mantra_japa_counter/services/time_zone_service.dart';
import 'package:mantra_japa_counter/core/logging/app_logger.dart';

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

  /// A short vibration on each counted tap. Off by default (battery).
  final bool tapVibrationEnabled;
  final String? languageCode;
  final bool dndEnabled;
  final bool dimmedChantingMode;
  final bool meruPauseEnabled;
  final int meruPauseSeconds;
  final bool pacingHintEnabled;
  final bool dailyReminderEnabled;

  /// Daily reminder time in minutes after midnight.
  final int dailyReminderMinutes;

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
    this.tapVibrationEnabled = false,
    this.languageCode,
    this.dndEnabled = false,
    this.dimmedChantingMode = false,
    this.meruPauseEnabled = false,
    this.meruPauseSeconds = AppConstants.meruPauseDefaultSeconds,
    this.pacingHintEnabled = true,
    this.dailyReminderEnabled = false,
    this.dailyReminderMinutes = AppConstants.dailyReminderDefaultMinutes,
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
    bool? tapVibrationEnabled,
    String? languageCode,
    bool clearLanguageCode = false,
    bool? dndEnabled,
    bool? dimmedChantingMode,
    bool? meruPauseEnabled,
    int? meruPauseSeconds,
    bool? pacingHintEnabled,
    bool? dailyReminderEnabled,
    int? dailyReminderMinutes,
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
      tapVibrationEnabled: tapVibrationEnabled ?? this.tapVibrationEnabled,
      languageCode: clearLanguageCode
          ? null
          : (languageCode ?? this.languageCode),
      dndEnabled: dndEnabled ?? this.dndEnabled,
      dimmedChantingMode: dimmedChantingMode ?? this.dimmedChantingMode,
      meruPauseEnabled: meruPauseEnabled ?? this.meruPauseEnabled,
      meruPauseSeconds: meruPauseSeconds ?? this.meruPauseSeconds,
      pacingHintEnabled: pacingHintEnabled ?? this.pacingHintEnabled,
      dailyReminderEnabled: dailyReminderEnabled ?? this.dailyReminderEnabled,
      dailyReminderMinutes: dailyReminderMinutes ?? this.dailyReminderMinutes,
    );
  }
}

class SettingsNotifier extends StateNotifier<AppSettings> {
  final SettingsRepository _repo;

  /// Read lazily, only when a goal notification switch is turned on, so
  /// the notification plugin is not needed just to read settings.
  final NotificationService Function()? _notifications;

  /// Applies the brightness setting to the app window. Null in tests that
  /// do not need it.
  final ScreenService? _screen;

  /// Reads the phone's time zone for the daily reminder. When null, UTC is
  /// used.
  final TimeZoneService? _timeZone;

  SettingsNotifier(
    this._repo, [
    this._notifications,
    this._screen,
    this._timeZone,
  ]) : super(
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
           tapVibrationEnabled: _repo.tapVibrationEnabled,
           languageCode: _repo.languageCode,
           dndEnabled: _repo.dndEnabled,
           dimmedChantingMode: _repo.dimmedChantingMode,
           meruPauseEnabled: _repo.meruPauseEnabled,
           meruPauseSeconds: _repo.meruPauseSeconds,
           pacingHintEnabled: _repo.pacingHintEnabled,
           dailyReminderEnabled: _repo.dailyReminderEnabled,
           dailyReminderMinutes: _repo.dailyReminderMinutes,
         ),
       ) {
    // Apply the saved brightness from app start.
    unawaited(_screen?.setAppBrightness(state.screenBrightness));
  }

  /// Saves and applies the brightness. A negative value follows the system.
  Future<void> setScreenBrightness(double value) async {
    await _repo.setScreenBrightness(value);
    state = state.copyWith(screenBrightness: value);
    await _screen?.setAppBrightness(value);
  }

  Future<void> setDailyGoalNotificationsEnabled(bool value) async {
    await _repo.setDailyGoalNotificationsEnabled(value);
    state = state.copyWith(dailyGoalNotificationsEnabled: value);
    if (value) await _requestNotificationPermission();
  }

  Future<void> setLifetimeGoalNotificationsEnabled(bool value) async {
    await _repo.setLifetimeGoalNotificationsEnabled(value);
    state = state.copyWith(lifetimeGoalNotificationsEnabled: value);
    if (value) await _requestNotificationPermission();
  }

  /// The user just turned a goal notification on, so ask Android for the
  /// notification permission (Android 13+) if it is still missing.
  Future<void> _requestNotificationPermission() async {
    final notifications = _notifications;
    if (notifications == null) return;
    await _repo.setNotificationPermissionAsked();
    await notifications().requestPermissionIfNeeded();
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

  Future<void> setTapVibrationEnabled(bool value) async {
    await _repo.setTapVibrationEnabled(value);
    state = state.copyWith(tapVibrationEnabled: value);
  }

  Future<void> setLanguageCode(String? code) async {
    await _repo.setLanguageCode(code);
    state = (code == null || code == 'system')
        ? state.copyWith(clearLanguageCode: true)
        : state.copyWith(languageCode: code);
    // The reminder text is fixed when it is scheduled, so schedule it again
    // in the new language.
    await syncDailyReminder();
  }

  Future<void> setDndEnabled(bool value) async {
    await _repo.setDndEnabled(value);
    state = state.copyWith(dndEnabled: value);
  }

  Future<void> setDimmedChantingMode(bool value) async {
    await _repo.setDimmedChantingMode(value);
    state = state.copyWith(dimmedChantingMode: value);
  }

  Future<void> setMeruPauseEnabled(bool value) async {
    await _repo.setMeruPauseEnabled(value);
    state = state.copyWith(meruPauseEnabled: value);
  }

  Future<void> setMeruPauseSeconds(int value) async {
    await _repo.setMeruPauseSeconds(value);
    state = state.copyWith(meruPauseSeconds: value);
  }

  Future<void> setPacingHintEnabled(bool value) async {
    await _repo.setPacingHintEnabled(value);
    state = state.copyWith(pacingHintEnabled: value);
  }

  /// Turns the daily practice reminder on or off. Turning it on asks for the
  /// notification permission first (Android 13+). Returns false when the
  /// permission is refused; the reminder then stays off.
  Future<bool> setDailyReminderEnabled(bool value) async {
    final notifications = _notifications;
    if (value && notifications != null) {
      await _repo.setNotificationPermissionAsked();
      if (!await notifications().requestPermissionIfNeeded()) return false;
    }
    await _repo.setDailyReminderEnabled(value);
    state = state.copyWith(dailyReminderEnabled: value);
    if (value) {
      await syncDailyReminder();
    } else {
      await _cancelDailyReminder();
    }
    return true;
  }

  /// Saves the reminder time ([minutes] after midnight) and schedules the
  /// reminder again when it is on.
  Future<void> setDailyReminderTime(int minutes) async {
    await _repo.setDailyReminderMinutes(minutes);
    state = state.copyWith(dailyReminderMinutes: minutes);
    await syncDailyReminder();
  }

  /// Schedules the daily reminder again when it is on, with the current time
  /// zone and app language. Called on app start and resume, so travel and
  /// language changes are picked up. Failures are ignored.
  Future<void> syncDailyReminder() async {
    final notifications = _notifications;
    if (!state.dailyReminderEnabled || notifications == null) return;
    try {
      final timeZoneId =
          await _timeZone?.getTimeZoneId() ??
          TimeZoneService.fallbackTimeZoneId;
      await notifications().scheduleDailyReminder(
        minutesAfterMidnight: state.dailyReminderMinutes,
        timeZoneId: timeZoneId,
        locale: LocaleConfig.resolveAppLocale(
          languageCode: state.languageCode,
          deviceLocale: PlatformDispatcher.instance.locale,
        ),
      );
    } catch (e) {
      AppLogger.warning('SettingsNotifier: schedule reminder failed', error: e);
    }
  }

  Future<void> _cancelDailyReminder() async {
    final notifications = _notifications;
    if (notifications == null) return;
    try {
      await notifications().cancelDailyReminder();
    } catch (e) {
      AppLogger.warning('SettingsNotifier: cancel reminder failed', error: e);
    }
  }
}

final settingsNotifierProvider =
    StateNotifierProvider<SettingsNotifier, AppSettings>((ref) {
      return SettingsNotifier(
        ref.watch(settingsRepositoryProvider),
        () => ref.read(notificationServiceProvider),
        ref.read(screenServiceProvider),
        ref.read(timeZoneServiceProvider),
      );
    });
