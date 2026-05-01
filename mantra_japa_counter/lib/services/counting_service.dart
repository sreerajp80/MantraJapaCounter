import 'dart:async';
import '../config/app_constants.dart';
import '../models/active_session.dart';
import '../models/japa_session.dart';
import '../repositories/japa_counter_repository.dart';
import '../repositories/settings_repository.dart';

// uuid is not in pubspec yet — use a simple helper until added
// For now inline a deterministic UUID v4 stub using dart:math
String _newId() {
  final r = DateTime.now().microsecondsSinceEpoch;
  return 'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'.splitMapJoin(
    RegExp(r'[xy]'),
    onMatch: (m) {
      final c = m.group(0)!;
      final v = (r ^ (r >> 16)) & 0xf;
      return (c == 'x' ? v : (v & 0x3 | 0x8)).toRadixString(16);
    },
    onNonMatch: (s) => s,
  );
}

/// Business logic for an active counting session.
///
/// Handles mala calculation, increment/decrement, and the dual-write
/// crash-recovery strategy (SharedPreferences + batched sqflite).
class CountingService {
  final JapaCounterRepository _repo;
  final SettingsRepository _settings;

  CountingService(this._repo, this._settings);

  // ──────────────────────────── Mala calculation ──────────────────────────────

  /// Integer division: count ÷ 108.
  static int calculateMalas(int count) => count ~/ AppConstants.malaSize;

  /// Remainder: count % 108.
  static int calculateChants(int count) => count % AppConstants.malaSize;

  // ──────────────────────────── Tap ───────────────────────────────────────────

  /// Returns updated session after applying one increment step.
  ActiveSession onTap(ActiveSession session) {
    return session.copyWith(tapCount: session.tapCount + session.incrementStep);
  }

  /// Returns updated session after decrementing by one increment step (min 0).
  ActiveSession onDecrement(ActiveSession session) {
    final newCount = (session.tapCount - session.incrementStep).clamp(0, 999999);
    return session.copyWith(tapCount: newCount);
  }

  // ──────────────────────────── Crash-recovery writes ─────────────────────────

  /// Write active session to SharedPreferences (crash-recovery batch).
  Future<void> flushToPrefs(ActiveSession session) async {
    await _settings.saveActiveSession(session);
  }

  Future<void> clearPrefs(String counterId) async {
    await _settings.clearActiveSession(counterId);
  }

  // ──────────────────────────── Session completion ────────────────────────────

  /// Saves the completed session to the database and clears crash-recovery state.
  Future<JapaSession> completeSession(ActiveSession session) async {
    final now = DateTime.now().millisecondsSinceEpoch;
    final japaSession = JapaSession(
      id: _newId(),
      counterId: session.counterId,
      counterName: session.counterName,
      count: session.tapCount,
      malas: calculateMalas(session.tapCount),
      chants: calculateChants(session.tapCount),
      timestamp: now,
      duration: session.duration,
    );
    await _repo.insertSession(japaSession);
    await _settings.clearActiveSession(session.counterId);
    return japaSession;
  }
}
