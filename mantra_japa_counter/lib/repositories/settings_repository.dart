import 'package:shared_preferences/shared_preferences.dart';
import '../config/app_constants.dart';
import '../models/active_session.dart';

/// All SharedPreferences access: user settings and active-session crash recovery.
///
/// Widgets and services must not use SharedPreferences keys directly.
class SettingsRepository {
  final SharedPreferences _prefs;

  SettingsRepository(this._prefs);

  // ──────────────────────────── Active session (crash recovery + pause) ──────
  //
  // Each counter gets its own slot keyed by counterId so a paused session for
  // counter A is not overwritten when the user opens counter B.

  String _keyFor(String counterId) =>
      '${AppConstants.prefsActiveSessionPrefix}$counterId';

  Future<void> saveActiveSession(ActiveSession session) async {
    await _prefs.setString(_keyFor(session.counterId), session.toJson());
  }

  Future<void> clearActiveSession(String counterId) async {
    await _prefs.remove(_keyFor(counterId));
  }

  ActiveSession? getActiveSession(String counterId) {
    final migrated = _migrateLegacyIfMatches(counterId);
    if (migrated != null) return migrated;
    final json = _prefs.getString(_keyFor(counterId));
    if (json == null) return null;
    try {
      return ActiveSession.fromJson(json);
    } catch (_) {
      return null;
    }
  }

  /// Returns every per-counter active session currently stored.
  /// Used at app startup by [SessionRecoveryService] to reconcile each
  /// pending session with the database.
  List<ActiveSession> getAllActiveSessions() {
    _migrateLegacyIfMatches(null);
    final result = <ActiveSession>[];
    for (final key in _prefs.getKeys()) {
      if (!key.startsWith(AppConstants.prefsActiveSessionPrefix)) continue;
      final json = _prefs.getString(key);
      if (json == null) continue;
      try {
        result.add(ActiveSession.fromJson(json));
      } catch (_) {
        // Bad JSON — drop it so it doesn't keep tripping startup.
        _prefs.remove(key);
      }
    }
    return result;
  }

  /// One-shot migration of the pre-pause-feature single-slot key into the
  /// per-counter scheme. Returns the migrated session if its counterId
  /// matches [forCounterId] (or any counter when [forCounterId] is null).
  ActiveSession? _migrateLegacyIfMatches(String? forCounterId) {
    final json = _prefs.getString(AppConstants.prefsLegacyActiveSessionKey);
    if (json == null) return null;
    try {
      final session = ActiveSession.fromJson(json);
      _prefs.setString(_keyFor(session.counterId), json);
      _prefs.remove(AppConstants.prefsLegacyActiveSessionKey);
      if (forCounterId == null || session.counterId == forCounterId) {
        return session;
      }
    } catch (_) {
      _prefs.remove(AppConstants.prefsLegacyActiveSessionKey);
    }
    return null;
  }

  // ──────────────────────────── User settings ─────────────────────────────────

  double get screenBrightness =>
      _prefs.getDouble(AppConstants.prefsBrightnessKey) ?? -1.0; // -1 = system default

  Future<void> setScreenBrightness(double value) async {
    await _prefs.setDouble(AppConstants.prefsBrightnessKey, value);
  }

  bool get dailyGoalNotificationsEnabled =>
      _prefs.getBool(AppConstants.prefsDailyGoalNotifKey) ?? true;

  Future<void> setDailyGoalNotificationsEnabled(bool value) async {
    await _prefs.setBool(AppConstants.prefsDailyGoalNotifKey, value);
  }

  bool get malaNotificationsEnabled =>
      _prefs.getBool(AppConstants.prefsMalaNotifKey) ?? false;

  Future<void> setMalaNotificationsEnabled(bool value) async {
    await _prefs.setBool(AppConstants.prefsMalaNotifKey, value);
  }

  String? get notificationSoundUri =>
      _prefs.getString(AppConstants.prefsNotifSoundUriKey);

  String? get notificationSoundName =>
      _prefs.getString(AppConstants.prefsNotifSoundNameKey);

  Future<void> setNotificationSound(String? uri, String? name) async {
    if (uri == null) {
      await _prefs.remove(AppConstants.prefsNotifSoundUriKey);
      await _prefs.remove(AppConstants.prefsNotifSoundNameKey);
    } else {
      await _prefs.setString(AppConstants.prefsNotifSoundUriKey, uri);
      if (name == null || name.isEmpty) {
        await _prefs.remove(AppConstants.prefsNotifSoundNameKey);
      } else {
        await _prefs.setString(AppConstants.prefsNotifSoundNameKey, name);
      }
    }
  }

  bool get vibrationEnabled =>
      _prefs.getBool(AppConstants.prefsVibrationKey) ?? true;

  Future<void> setVibrationEnabled(bool value) async {
    await _prefs.setBool(AppConstants.prefsVibrationKey, value);
  }
}
