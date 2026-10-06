import 'package:mantra_japa_counter/models/active_session.dart';
import 'package:mantra_japa_counter/models/japa_session.dart';
import 'package:mantra_japa_counter/repositories/japa_counter_repository.dart';
import 'package:mantra_japa_counter/repositories/settings_repository.dart';

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

  /// Never throws: this runs in `main()` before `runApp`, so one bad saved
  /// session must not stop the app from starting.
  Future<void> recoverIfNeeded() async {
    for (final saved in _settings.getAllActiveSessions()) {
      try {
        await _recoverOne(saved);
      } catch (_) {
        // Could not reconcile this entry — drop it so it can't keep failing.
        try {
          await _settings.clearActiveSession(saved.counterId);
        } catch (_) {}
      }
    }
  }

  Future<void> _recoverOne(ActiveSession saved) async {
    if (saved.tapCount <= 0 || saved.sessionId.isEmpty) {
      // Empty placeholder — nothing to recover; clear it so we don't try
      // to resume a zero-tap session next time the user opens this counter.
      await _settings.clearActiveSession(saved.counterId);
      return;
    }

    // The counter was deleted — its sessions are gone too. Inserting a row
    // would break the foreign key, so just drop the saved session.
    if (await _repo.getCounterById(saved.counterId) == null) {
      await _settings.clearActiveSession(saved.counterId);
      return;
    }

    // A session carried over from an earlier day may have no taps yet in
    // today's row. Earlier-day rows are already stored — keep the prefs
    // entry so the unfinished mala resumes, but write nothing.
    final rowCount = saved.rowCount;
    if (rowCount <= 0) return;

    final existing = await _repo.getSessionById(saved.sessionId);
    if (existing == null) {
      // Prefs reports taps but no DB row exists — write it now for safety.
      await _repo.insertSession(
        JapaSession(
          id: saved.sessionId,
          counterId: saved.counterId,
          counterName: saved.counterName,
          count: rowCount,
          malas: rowCount ~/ 108,
          chants: rowCount % 108,
          timestamp: saved.startTime,
          duration: saved.rowDuration,
        ),
      );
    } else if (rowCount > existing.count) {
      // Prefs has a more recent count than DB — sync it forward.
      await _repo.updateSession(
        existing.copyWith(
          count: rowCount,
          malas: rowCount ~/ 108,
          chants: rowCount % 108,
          duration: saved.rowDuration,
        ),
      );
    }
    // Leave the prefs entry intact — CountingNotifier.init() consumes it.
  }
}
