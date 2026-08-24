import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:uuid/uuid.dart';
import '../config/app_constants.dart';
import '../models/active_session.dart';
import '../models/japa_session.dart';
import 'app_providers.dart';
import 'counter_stats_provider.dart';
import 'counters_provider.dart';
import 'history_provider.dart';

const _uuid = Uuid();

/// State for the active counting screen.
///
/// [lifetimeTotal] and [todayTotal] are snapshots of `initialCount + DB SUM`
/// at the moment of the last database write — they already include this
/// session's taps up to [lastDbWrittenCount]. To get the live, real-time
/// total, callers should add `session.tapCount - lastDbWrittenCount` (the
/// "unflushed" taps that haven't reached SQLite yet). This matches the
/// Kotlin app's `getTotalCountForCounter` formula.
class CountingState {
  final ActiveSession? session;
  final int lifetimeTotal;
  final int todayTotal;
  final int lastDbWrittenCount;
  final bool isCompleting;

  const CountingState({
    this.session,
    this.lifetimeTotal = 0,
    this.todayTotal = 0,
    this.lastDbWrittenCount = 0,
    this.isCompleting = false,
  });

  /// Unflushed taps in the current session — the delta still in memory.
  int get unflushedCount {
    final s = session;
    if (s == null) return 0;
    return (s.tapCount - lastDbWrittenCount).clamp(0, 1 << 31);
  }

  /// Live lifetime total including unflushed taps.
  int get liveLifetimeTotal => lifetimeTotal + unflushedCount;

  /// Live today total including unflushed taps.
  int get liveTodayTotal => todayTotal + unflushedCount;

  CountingState copyWith({
    ActiveSession? session,
    int? lifetimeTotal,
    int? todayTotal,
    int? lastDbWrittenCount,
    bool? isCompleting,
  }) {
    return CountingState(
      session: session ?? this.session,
      lifetimeTotal: lifetimeTotal ?? this.lifetimeTotal,
      todayTotal: todayTotal ?? this.todayTotal,
      lastDbWrittenCount: lastDbWrittenCount ?? this.lastDbWrittenCount,
      isCompleting: isCompleting ?? this.isCompleting,
    );
  }
}

/// Manages the active counting session — mirrors the Kotlin app's behaviour:
///
///   • First tap inserts a session row into the DB immediately for safety.
///   • Subsequent taps update the same row, batched (every 30s or 20 taps).
///   • SharedPreferences is updated batched (every 5s or 5 taps).
///   • Decrementing to zero cancels the session (deletes the DB row).
///   • Reset cancels the active session and starts a fresh one.
///   • Save-and-exit force-flushes pending writes.
///
/// History therefore reflects the active session in real time, exactly as
/// in the Kotlin app.
class CountingNotifier extends StateNotifier<CountingState> {
  final Ref _ref;
  final String _counterId;

  // Per-session DB tracking — matches Kotlin's lastDbWrittenCount semantics.
  String? _sessionDbId; // id of the row in japa_sessions for this session
  bool _isSessionInDb = false; // has the row been inserted yet?
  int _lastDbWrittenCount = 0; // count value last persisted to DB

  // Captured at init() so the daily-goal threshold check stays cheap.
  // Editing the counter mid-session does not retroactively change the goal.
  int _dailyGoal = 0;

  // Batching state
  Timer? _prefsTimer;
  Timer? _dbTimer;
  Timer? _prefsDebounce;
  Timer? _dbDebounce;
  int _tapsSinceLastPrefsFlush = 0;
  int _tapsSinceLastDbFlush = 0;
  int _lastPrefsWriteMs = 0;
  int _lastDbWriteMs = 0;

  CountingNotifier(this._ref, this._counterId) : super(const CountingState());

  // ───────────────────────────── init / recovery ──────────────────────────

  Future<void> init() async {
    final repo = _ref.read(japaCounterRepositoryProvider);
    final settings = _ref.read(settingsRepositoryProvider);

    final counter = await repo.getCounterById(_counterId);
    if (counter == null) return;
    _dailyGoal = counter.dailyGoal;

    final saved = settings.getActiveSession(_counterId);
    final now = DateTime.now().millisecondsSinceEpoch;

    ActiveSession session;
    if (saved != null && saved.counterId == _counterId) {
      // Resume the abandoned/paused session for this counter.
      session = saved;
      _sessionDbId = saved.sessionId;
      final existing = _sessionDbId == null
          ? null
          : await repo.getSessionById(_sessionDbId!);
      if (existing == null && saved.tapCount > 0) {
        // Prefs had taps but no DB row — write it now to recover.
        final id = _sessionDbId ?? _uuid.v4();
        _sessionDbId = id;
        await repo.insertSession(
          JapaSession(
            id: id,
            counterId: counter.id,
            counterName: counter.name,
            count: saved.tapCount,
            malas: saved.tapCount ~/ 108,
            chants: saved.tapCount % 108,
            timestamp: saved.startTime,
            duration: saved.duration,
          ),
        );
        _isSessionInDb = true;
        _lastDbWrittenCount = saved.tapCount;
      } else if (existing != null) {
        _isSessionInDb = true;
        if (saved.tapCount > existing.count) {
          // Prefs had more recent data — update DB.
          await repo.updateSession(
            existing.copyWith(
              count: saved.tapCount,
              malas: saved.tapCount ~/ 108,
              chants: saved.tapCount % 108,
              duration: saved.duration,
            ),
          );
          _lastDbWrittenCount = saved.tapCount;
        } else {
          _lastDbWrittenCount = existing.count;
        }
      }
    } else {
      // Fresh session — no DB row yet (Kotlin inserts on first tap).
      session = ActiveSession(
        sessionId: _uuid.v4(),
        counterId: counter.id,
        counterName: counter.name,
        startTime: now,
        tapCount: 0,
        incrementStep: counter.incrementStep,
        lastResumeTimeMs: now,
      );
      _sessionDbId = session.sessionId;
      _isSessionInDb = false;
      _lastDbWrittenCount = 0;
    }

    state = CountingState(
      session: session,
      lastDbWrittenCount: _lastDbWrittenCount,
    );
    await _refreshTotals(counter.initialCount);

    _startTimers();
    // Make sure stats and history reflect any DB write we just performed.
    _invalidateStatsAndHistory();
  }

  /// Refreshes [CountingState.lifetimeTotal] and [CountingState.todayTotal]
  /// from the database. Includes `counter.initialCount` in the lifetime
  /// total to match the Kotlin formula: `initialCount + DB SUM`.
  Future<void> _refreshTotals(int initialCount) async {
    final repo = _ref.read(japaCounterRepositoryProvider);
    final dbTotal = await repo.getTotalCountForCounter(_counterId);
    final today = await repo.getTodayCountForCounter(_counterId);
    state = state.copyWith(
      lifetimeTotal: initialCount + dbTotal,
      todayTotal: today,
      lastDbWrittenCount: _lastDbWrittenCount,
    );
  }

  Future<void> _refreshTotalsFromCounter() async {
    final counter = await _ref
        .read(japaCounterRepositoryProvider)
        .getCounterById(_counterId);
    await _refreshTotals(counter?.initialCount ?? 0);
  }

  // ───────────────────────────── timers ────────────────────────────────────

  void _startTimers() {
    _prefsTimer = Timer.periodic(
      const Duration(seconds: AppConstants.prefsBatchIntervalSeconds),
      (_) => _flushPrefsIfNeeded(),
    );
    _dbTimer = Timer.periodic(
      const Duration(seconds: AppConstants.dbBatchIntervalSeconds),
      (_) => _flushDbIfNeeded(),
    );
  }

  void _stopTimers() {
    _prefsTimer?.cancel();
    _dbTimer?.cancel();
    _prefsDebounce?.cancel();
    _dbDebounce?.cancel();
    _prefsTimer = null;
    _dbTimer = null;
    _prefsDebounce = null;
    _dbDebounce = null;
  }

  // ───────────────────────────── tap / decrement ──────────────────────────

  Future<void> tap() async {
    final session = state.session;
    if (session == null) return;

    final resumed = _resumeIfPaused(session);
    final wasZero = resumed.tapCount == 0;
    final updated = resumed.copyWith(
      tapCount: resumed.tapCount + resumed.incrementStep,
    );
    state = state.copyWith(session: updated);

    if (wasZero) {
      // First tap of this session — insert into DB immediately for data safety.
      await _insertSessionRow(updated);
      await _writePrefsImmediately(updated);
    } else {
      _tapsSinceLastDbFlush++;
      _tapsSinceLastPrefsFlush++;
      _scheduleDbWrite(updated);
      _schedulePrefsWrite(updated);
    }

    _checkNotifications(updated);
    _invalidateStatsAndHistory();
  }

  Future<void> decrement() async {
    final session = state.session;
    if (session == null) return;
    if (session.tapCount < session.incrementStep) return;

    final resumed = _resumeIfPaused(session);
    final newCount = resumed.tapCount - resumed.incrementStep;
    final updated = resumed.copyWith(tapCount: newCount);
    state = state.copyWith(session: updated);

    if (newCount <= 0) {
      // Reached zero — cancel session (delete DB row, clear prefs).
      await _cancelSession();
    } else {
      _tapsSinceLastDbFlush++;
      _tapsSinceLastPrefsFlush++;
      _scheduleDbWrite(updated);
      _schedulePrefsWrite(updated);
    }

    _invalidateStatsAndHistory();
  }

  /// If the session was paused (user left and came back), start a fresh
  /// active segment now. Idle time between pause and resume is excluded
  /// from session duration.
  ActiveSession _resumeIfPaused(ActiveSession session) {
    if (!session.isPaused) return session;
    return session.copyWith(
      isPaused: false,
      lastResumeTimeMs: DateTime.now().millisecondsSinceEpoch,
    );
  }

  // ───────────────────────────── DB write helpers ─────────────────────────

  Future<void> _insertSessionRow(ActiveSession session) async {
    final repo = _ref.read(japaCounterRepositoryProvider);
    final id = _sessionDbId ?? _uuid.v4();
    _sessionDbId = id;
    final row = JapaSession(
      id: id,
      counterId: session.counterId,
      counterName: session.counterName,
      count: session.tapCount,
      malas: session.tapCount ~/ 108,
      chants: session.tapCount % 108,
      timestamp: session.startTime,
      duration: session.duration,
    );
    await repo.insertSession(row);
    _isSessionInDb = true;
    _lastDbWrittenCount = session.tapCount;
    _lastDbWriteMs = DateTime.now().millisecondsSinceEpoch;
    _tapsSinceLastDbFlush = 0;
    await _refreshTotalsFromCounter();
  }

  Future<void> _updateSessionRow(ActiveSession session) async {
    if (!_isSessionInDb || _sessionDbId == null) {
      await _insertSessionRow(session);
      return;
    }
    final repo = _ref.read(japaCounterRepositoryProvider);
    final existing = await repo.getSessionById(_sessionDbId!);
    if (existing == null) {
      // Row was deleted out from under us — re-insert.
      await _insertSessionRow(session);
      return;
    }
    await repo.updateSession(
      JapaSession(
        id: existing.id,
        counterId: existing.counterId,
        counterName: existing.counterName,
        count: session.tapCount,
        malas: session.tapCount ~/ 108,
        chants: session.tapCount % 108,
        timestamp: existing.timestamp,
        duration: session.duration,
      ),
    );
    _lastDbWrittenCount = session.tapCount;
    _lastDbWriteMs = DateTime.now().millisecondsSinceEpoch;
    _tapsSinceLastDbFlush = 0;
    await _refreshTotalsFromCounter();
  }

  void _scheduleDbWrite(ActiveSession session) {
    final now = DateTime.now().millisecondsSinceEpoch;
    final elapsedMs = _lastDbWriteMs == 0 ? 1 << 30 : now - _lastDbWriteMs;
    final shouldNow =
        elapsedMs >= AppConstants.dbBatchIntervalSeconds * 1000 ||
        _tapsSinceLastDbFlush >= AppConstants.dbBatchTapCount;
    _dbDebounce?.cancel();
    if (shouldNow) {
      _updateSessionRow(session);
    } else {
      final waitMs = AppConstants.dbBatchIntervalSeconds * 1000 - elapsedMs;
      _dbDebounce = Timer(
        Duration(milliseconds: waitMs.clamp(50, 60000)),
        () => _updateSessionRow(state.session ?? session),
      );
    }
  }

  Future<void> _flushDbIfNeeded() async {
    final session = state.session;
    if (session == null || session.tapCount == 0) return;
    if (session.tapCount == _lastDbWrittenCount) return;
    await _updateSessionRow(session);
    _invalidateStatsAndHistory();
  }

  // ───────────────────────────── prefs write helpers ──────────────────────

  Future<void> _writePrefsImmediately(ActiveSession session) async {
    await _ref.read(settingsRepositoryProvider).saveActiveSession(session);
    _lastPrefsWriteMs = DateTime.now().millisecondsSinceEpoch;
    _tapsSinceLastPrefsFlush = 0;
    _prefsDebounce?.cancel();
  }

  void _schedulePrefsWrite(ActiveSession session) {
    final now = DateTime.now().millisecondsSinceEpoch;
    final elapsedMs = _lastPrefsWriteMs == 0
        ? 1 << 30
        : now - _lastPrefsWriteMs;
    final shouldNow =
        elapsedMs >= AppConstants.prefsBatchIntervalSeconds * 1000 ||
        _tapsSinceLastPrefsFlush >= AppConstants.prefsBatchTapCount;
    _prefsDebounce?.cancel();
    if (shouldNow) {
      _writePrefsImmediately(session);
    } else {
      final waitMs = AppConstants.prefsBatchIntervalSeconds * 1000 - elapsedMs;
      _prefsDebounce = Timer(
        Duration(milliseconds: waitMs.clamp(50, 60000)),
        () => _writePrefsImmediately(state.session ?? session),
      );
    }
  }

  Future<void> _flushPrefsIfNeeded() async {
    final session = state.session;
    if (session == null) return;
    await _writePrefsImmediately(session);
  }

  // ───────────────────────────── high-level actions ───────────────────────

  /// Exit the counting screen.
  ///
  /// If the session has counts but is mid-mala (`tapCount % 108 != 0`),
  /// pause it so the next visit to this counter resumes the same session.
  /// Otherwise finalize and clear crash-recovery prefs.
  ///
  /// Special case: when the user has a sub-mala daily goal (e.g. 50 chants)
  /// and has already met it today, finishing mid-mala is the natural stop
  /// point — don't pause, just finalize.
  Future<JapaSession?> completeSession() async {
    final session = state.session;
    if (session == null || state.isCompleting) return null;

    state = state.copyWith(isCompleting: true);
    _stopTimers();

    final subMalaDailyGoalMet =
        _dailyGoal > 0 &&
        _dailyGoal < 108 &&
        state.liveTodayTotal >= _dailyGoal;
    final shouldPause =
        session.tapCount > 0 &&
        session.tapCount % 108 != 0 &&
        !subMalaDailyGoalMet;

    if (shouldPause) {
      // Freeze the active segment into accumulatedMs and persist as paused.
      final paused = session.isPaused
          ? session
          : session.copyWith(isPaused: true, accumulatedMs: session.duration);
      state = state.copyWith(session: paused);
      await _updateSessionRow(paused);
      await _writePrefsImmediately(paused);
      _invalidateStatsAndHistory();
      return null;
    }

    JapaSession? result;
    if (session.tapCount > 0) {
      // Force-save the final count to DB.
      if (_isSessionInDb && _sessionDbId != null) {
        await _updateSessionRow(session);
        result = await _ref
            .read(japaCounterRepositoryProvider)
            .getSessionById(_sessionDbId!);
      } else {
        await _insertSessionRow(session);
        result = await _ref
            .read(japaCounterRepositoryProvider)
            .getSessionById(_sessionDbId!);
      }
    } else {
      // Empty session — just remove any DB row that might have been created.
      await _deleteCurrentDbRow();
    }

    await _ref.read(settingsRepositoryProvider).clearActiveSession(_counterId);
    _resetTrackingState();
    _invalidateStatsAndHistory();
    return result;
  }

  /// Reset the current session — matches Kotlin's `cancelSession` flow.
  /// Deletes the in-progress DB row and starts a fresh session.
  Future<void> resetSession() async {
    _stopTimers();
    await _cancelSession();

    final repo = _ref.read(japaCounterRepositoryProvider);
    final counter = await repo.getCounterById(_counterId);
    if (counter == null) return;

    final now = DateTime.now().millisecondsSinceEpoch;
    final newSession = ActiveSession(
      sessionId: _uuid.v4(),
      counterId: counter.id,
      counterName: counter.name,
      startTime: now,
      tapCount: 0,
      incrementStep: counter.incrementStep,
      lastResumeTimeMs: now,
    );
    _sessionDbId = newSession.sessionId;
    _isSessionInDb = false;
    _lastDbWrittenCount = 0;
    state = CountingState(session: newSession);
    await _refreshTotals(counter.initialCount);
    _startTimers();
    _invalidateStatsAndHistory();
  }

  /// Reset the entire counter — matches Kotlin's `resetCounter`.
  /// Deletes ALL sessions for the counter without saving the current one.
  Future<void> resetCounter() async {
    _stopTimers();
    final repo = _ref.read(japaCounterRepositoryProvider);
    await repo.deleteSessionsByCounterId(_counterId);
    await _ref.read(settingsRepositoryProvider).clearActiveSession(_counterId);

    final counter = await repo.getCounterById(_counterId);
    if (counter == null) return;
    final now = DateTime.now().millisecondsSinceEpoch;
    final newSession = ActiveSession(
      sessionId: _uuid.v4(),
      counterId: counter.id,
      counterName: counter.name,
      startTime: now,
      tapCount: 0,
      incrementStep: counter.incrementStep,
      lastResumeTimeMs: now,
    );
    _sessionDbId = newSession.sessionId;
    _isSessionInDb = false;
    _lastDbWrittenCount = 0;
    state = CountingState(session: newSession);
    await _refreshTotals(counter.initialCount);
    _startTimers();
    _invalidateStatsAndHistory();
  }

  /// Lifecycle: flush pending writes when the app goes background.
  Future<void> onPause() async {
    final session = state.session;
    if (session == null) return;
    await _writePrefsImmediately(session);
    if (session.tapCount > _lastDbWrittenCount) {
      await _updateSessionRow(session);
    }
    _invalidateStatsAndHistory();
  }

  // ───────────────────────────── internals ────────────────────────────────

  Future<void> _cancelSession() async {
    await _deleteCurrentDbRow();
    await _ref.read(settingsRepositoryProvider).clearActiveSession(_counterId);
    _resetTrackingState();
    state = state.copyWith(lastDbWrittenCount: 0);
    await _refreshTotalsFromCounter();
  }

  Future<void> _deleteCurrentDbRow() async {
    if (_sessionDbId != null && _isSessionInDb) {
      await _ref
          .read(japaCounterRepositoryProvider)
          .deleteSession(_sessionDbId!);
    }
  }

  void _resetTrackingState() {
    _sessionDbId = null;
    _isSessionInDb = false;
    _lastDbWrittenCount = 0;
    _tapsSinceLastDbFlush = 0;
    _tapsSinceLastPrefsFlush = 0;
    _lastDbWriteMs = 0;
    _lastPrefsWriteMs = 0;
  }

  void _invalidateStatsAndHistory() {
    _ref.invalidate(counterStatsProvider(_counterId));
    _ref.invalidate(todayAggregateProvider);
    _ref.invalidate(historySummariesProvider(_counterId));
    _ref.invalidate(historySummariesProvider(null));
    _ref.invalidate(countersNotifierProvider);
  }

  void _checkNotifications(ActiveSession session) {
    final settings = _ref.read(settingsRepositoryProvider);
    final notif = _ref.read(notificationServiceProvider);
    final sound = _ref.read(soundServiceProvider);
    final haptic = _ref.read(hapticFeedbackServiceProvider);

    // Daily-goal threshold: fire only on the tap that crosses the goal. If the
    // user already met the goal earlier today, [liveTodayTotal] starts above
    // [_dailyGoal] at session start, so no transition occurs and we don't
    // re-fire after restarts.
    if (_dailyGoal > 0 && settings.dailyGoalNotificationsEnabled) {
      final newTodayTotal = state.liveTodayTotal;
      final prevTodayTotal = newTodayTotal - session.incrementStep;
      if (prevTodayTotal < _dailyGoal && newTodayTotal >= _dailyGoal) {
        notif.notifyDailyGoalReached();
        if (settings.vibrationEnabled) haptic.vibrateDailyGoal();
        sound.playTone(settings.notificationSoundUri);
        return; // Skip mala chime on the same tap — daily goal supersedes it.
      }
    }

    if (settings.malaNotificationsEnabled) {
      final prevMalas = (session.tapCount - session.incrementStep) ~/ 108;
      final newMalas = session.tapCount ~/ 108;
      if (newMalas > prevMalas) {
        // Built-in beep + vibration via native ToneGenerator / VibrationEffect.
        // Both use USAGE_ALARM-style attributes so they bypass silent / DND.
        haptic.playMalaTone();
        if (settings.vibrationEnabled) haptic.vibrateMala();
      }
    }
  }

  @override
  void dispose() {
    _stopTimers();
    super.dispose();
  }
}

final countingNotifierProvider = StateNotifierProvider.autoDispose
    .family<CountingNotifier, CountingState, String>(
      (ref, counterId) => CountingNotifier(ref, counterId),
    );
