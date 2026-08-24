import '../models/japa_session.dart';
import '../repositories/japa_counter_repository.dart';
import '../repositories/settings_repository.dart';

/// Reconciles any in-progress session persisted in SharedPreferences with the
/// `japa_sessions` table on app start.
///
/// Since the Kotlin-style flow inserts the session row on the first tap and
/// updates it as taps occur, prefs and DB usually agree. We only need to
/// handle the edge case where a crash happened between a prefs write and the
/// next DB flush.
///
/// We DO NOT clear the prefs entry here — `CountingNotifier.init()` resumes
/// the active session when the user re-enters the counting screen.
class SessionRecoveryService {
  final JapaCounterRepository _repo;
  final SettingsRepository _settings;

  SessionRecoveryService(this._repo, this._settings);

  Future<void> recoverIfNeeded() async {
    for (final saved in _settings.getAllActiveSessions()) {
      if (saved.tapCount <= 0 || saved.sessionId.isEmpty) {
        // Empty placeholder — nothing to recover; clear it so we don't try
        // to resume a zero-tap session next time the user opens this counter.
        await _settings.clearActiveSession(saved.counterId);
        continue;
      }

      final existing = await _repo.getSessionById(saved.sessionId);
      if (existing == null) {
        // Prefs reports taps but no DB row exists — write it now for safety.
        await _repo.insertSession(
          JapaSession(
            id: saved.sessionId,
            counterId: saved.counterId,
            counterName: saved.counterName,
            count: saved.tapCount,
            malas: saved.tapCount ~/ 108,
            chants: saved.tapCount % 108,
            timestamp: saved.startTime,
            duration: saved.duration,
          ),
        );
      } else if (saved.tapCount > existing.count) {
        // Prefs has a more recent count than DB — sync it forward.
        await _repo.updateSession(
          existing.copyWith(
            count: saved.tapCount,
            malas: saved.tapCount ~/ 108,
            chants: saved.tapCount % 108,
            duration: saved.duration,
          ),
        );
      }
      // Leave the prefs entry intact — CountingNotifier.init() consumes it.
    }
  }
}
