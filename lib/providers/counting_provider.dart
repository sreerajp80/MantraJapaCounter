import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:uuid/uuid.dart';
import 'package:mantra_japa_counter/core/constants/app_constants.dart';
import 'package:mantra_japa_counter/core/utils/day.dart';
import 'package:mantra_japa_counter/models/active_session.dart';
import 'package:mantra_japa_counter/models/japa_session.dart';
import 'package:mantra_japa_counter/providers/app_providers.dart';
import 'package:mantra_japa_counter/providers/counter_stats_provider.dart';
import 'package:mantra_japa_counter/providers/counters_provider.dart';
import 'package:mantra_japa_counter/providers/history_provider.dart';

const _uuid = Uuid();

/// Current time in milliseconds. Overridden in tests to control the pacing
/// hint.
final countingClockProvider = Provider<int Function()>(
  (ref) =>
      () => DateTime.now().millisecondsSinceEpoch,
);

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

  /// True during the Meru pause after a completed mala. Taps are not counted
  /// while it is on.
  final bool isMeruPause;

  /// Length of the current (or next) Meru pause, for the countdown ring.
  final int meruPauseSeconds;

  /// True while the user taps faster than a natural chanting pace. Only a
  /// hint — counting is never blocked.
  final bool isRushing;

  /// True when the screen opened on an unfinished mala whose taps were made
  /// on an earlier day, and no tap has been made yet. Drives the
  /// "Start new" banner.
  final bool resumedFromEarlierDay;

  const CountingState({
    this.session,
    this.lifetimeTotal = 0,
    this.todayTotal = 0,
    this.lastDbWrittenCount = 0,
    this.isCompleting = false,
    this.isMeruPause = false,
    this.meruPauseSeconds = AppConstants.meruPauseDefaultSeconds,
    this.isRushing = false,
    this.resumedFromEarlierDay = false,
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
    bool? isMeruPause,
    int? meruPauseSeconds,
    bool? isRushing,
    bool? resumedFromEarlierDay,
  }) {
    return CountingState(
      session: session ?? this.session,
      lifetimeTotal: lifetimeTotal ?? this.lifetimeTotal,
      todayTotal: todayTotal ?? this.todayTotal,
      lastDbWrittenCount: lastDbWrittenCount ?? this.lastDbWrittenCount,
      isCompleting: isCompleting ?? this.isCompleting,
      isMeruPause: isMeruPause ?? this.isMeruPause,
      meruPauseSeconds: meruPauseSeconds ?? this.meruPauseSeconds,
      isRushing: isRushing ?? this.isRushing,
      resumedFromEarlierDay:
          resumedFromEarlierDay ?? this.resumedFromEarlierDay,
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

  // Captured at init() so the daily/lifetime goal threshold checks stay cheap.
  // Editing the counter mid-session does not retroactively change the goal.
  int _dailyGoal = 0;
  int _lifetimeGoal = 0;

  // Batching state
  Timer? _prefsTimer;
  Timer? _dbTimer;
  Timer? _prefsDebounce;
  Timer? _dbDebounce;
  int _tapsSinceLastPrefsFlush = 0;
  int _tapsSinceLastDbFlush = 0;
  int _lastPrefsWriteMs = 0;
  int _lastDbWriteMs = 0;

  // Meru pause and pacing hint
  Timer? _meruTimer;
  Timer? _rushTimer;
  final List<int> _recentTapMs = [];

  CountingNotifier(this._ref, this._counterId) : super(const CountingState());

  // ───────────────────────────── init / recovery ──────────────────────────

  Future<void> init() async {
    final repo = _ref.read(japaCounterRepositoryProvider);
    final settings = _ref.read(settingsRepositoryProvider);

    final counter = await repo.getCounterById(_counterId);
    if (counter == null) return;
    _dailyGoal = counter.dailyGoal;
    _lifetimeGoal = counter.goal;

    final saved = settings.getActiveSession(_counterId);

    ActiveSession session;
    var resumedFromEarlierDay = false;
    if (saved != null && saved.counterId == _counterId) {
      // Resume the abandoned/paused session for this counter.
      session = saved;
      _sessionDbId = saved.sessionId;
      // The DB row holds only this row's part of the session; taps carried
      // from earlier-day rows are already stored there.
      final rowCount = saved.rowCount;
      _lastDbWrittenCount = saved.carriedCount;
      final existing = _sessionDbId == null
          ? null
          : await repo.getSessionById(_sessionDbId!);
      if (existing == null && rowCount > 0) {
        // Prefs had taps but no DB row — write it now to recover.
        final id = _sessionDbId ?? _uuid.v4();
        _sessionDbId = id;
        await repo.insertSession(
          JapaSession(
            id: id,
            counterId: counter.id,
            counterName: counter.name,
            count: rowCount,
            malas: rowCount ~/ 108,
            chants: rowCount % 108,
            timestamp: saved.startTime,
            duration: saved.rowDuration,
          ),
        );
        _isSessionInDb = true;
        _lastDbWrittenCount = saved.tapCount;
      } else if (existing != null) {
        _isSessionInDb = true;
        if (rowCount > existing.count) {
          // Prefs had more recent data — update DB.
          await repo.updateSession(
            existing.copyWith(
              count: rowCount,
              malas: rowCount ~/ 108,
              chants: rowCount % 108,
              duration: saved.rowDuration,
            ),
          );
          _lastDbWrittenCount = saved.tapCount;
        } else {
          _lastDbWrittenCount = existing.count + saved.carriedCount;
        }
      }
      resumedFromEarlierDay =
          saved.tapCount > 0 && _isOnEarlierDay(saved.startTime);
    } else {
      // Fresh session — no DB row yet (Kotlin inserts on first tap).
      session = _startFreshSession(
        counterId: counter.id,
        counterName: counter.name,
        incrementStep: counter.incrementStep,
      );
    }

    state = CountingState(
      session: session,
      lastDbWrittenCount: _lastDbWrittenCount,
      resumedFromEarlierDay: resumedFromEarlierDay,
    );
    await _refreshTotals(counter.initialCount);

    _startTimers();
    // Make sure stats and history reflect any DB write we just performed.
    _invalidateStatsAndHistory();
    await _askNotificationPermissionOnce();
  }

  /// Goal notifications need the Android 13+ notification permission. Ask
  /// one time, the first time a counter with a goal is opened while goal
  /// notifications are on. After that, the Settings switches ask instead.
  Future<void> _askNotificationPermissionOnce() async {
    final settings = _ref.read(settingsRepositoryProvider);
    if (settings.notificationPermissionAsked) return;
    final wantsGoalAlert =
        (_dailyGoal > 0 && settings.dailyGoalNotificationsEnabled) ||
        (_lifetimeGoal > 0 && settings.lifetimeGoalNotificationsEnabled);
    if (!wantsGoalAlert) return;
    await settings.setNotificationPermissionAsked();
    try {
      // Not awaited: the system dialog waits for the user, and counting
      // must not wait for it.
      unawaited(
        _ref.read(notificationServiceProvider).requestPermissionIfNeeded(),
      );
    } catch (_) {
      // Best-effort — the Settings switches can ask again later.
    }
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
    var session = state.session;
    if (session == null) return;
    // The Meru bead is not crossed: taps during the pause are not counted.
    if (state.isMeruPause) return;

    if (_isOnEarlierDay(session.startTime)) {
      // A new day: today's taps go into a new row dated today.
      await _startNewDayRow(session);
      session = state.session;
      if (session == null) return;
    }

    final resumed = _resumeIfPaused(session);
    final isFirstRowTap = !_isSessionInDb;
    final updated = resumed.copyWith(
      tapCount: resumed.tapCount + resumed.incrementStep,
    );
    state = state.copyWith(session: updated, resumedFromEarlierDay: false);

    if (isFirstRowTap) {
      // First tap of this row — insert into DB immediately for data safety.
      await _insertSessionRow(updated);
      await _writePrefsImmediately(updated);
    } else {
      _tapsSinceLastDbFlush++;
      _tapsSinceLastPrefsFlush++;
      _scheduleDbWrite(updated);
      _schedulePrefsWrite(updated);
    }

    _checkNotifications(updated);
    _trackPacing();
    _startMeruPauseIfMalaDone(updated);
    _invalidateStatsAndHistory();
  }

  // ───────────────────────────── Meru pause / pacing ──────────────────────

  /// Starts the Meru pause when this tap completed a mala and the setting is
  /// on.
  void _startMeruPauseIfMalaDone(ActiveSession session) {
    final settings = _ref.read(settingsRepositoryProvider);
    if (!settings.meruPauseEnabled) return;
    final prevMalas =
        (session.tapCount - session.incrementStep) ~/ AppConstants.malaSize;
    final newMalas = session.tapCount ~/ AppConstants.malaSize;
    if (newMalas <= prevMalas) return;

    final seconds = settings.meruPauseSeconds;
    _meruTimer?.cancel();
    _meruTimer = Timer(Duration(seconds: seconds), endMeruPause);
    // Rushing does not matter during a pause; start fresh after it.
    _clearPacing();
    state = state.copyWith(isMeruPause: true, meruPauseSeconds: seconds);
  }

  /// Ends the Meru pause now. Called by its timer, by undo, and when the
  /// app leaves the screen.
  void endMeruPause() {
    _meruTimer?.cancel();
    _meruTimer = null;
    if (mounted && state.isMeruPause) {
      state = state.copyWith(isMeruPause: false);
    }
  }

  /// Records this tap's time and turns the pacing hint on when the last few
  /// taps came faster than a natural chanting pace.
  void _trackPacing() {
    if (!_ref.read(settingsRepositoryProvider).pacingHintEnabled) return;
    final now = _ref.read(countingClockProvider)();
    _recentTapMs.add(now);
    if (_recentTapMs.length > AppConstants.pacingWindowTaps) {
      _recentTapMs.removeAt(0);
    }
    if (_recentTapMs.length < AppConstants.pacingWindowTaps) return;

    final spanMs = _recentTapMs.last - _recentTapMs.first;
    final gaps = _recentTapMs.length - 1;
    final tooFast = spanMs * AppConstants.pacingMaxTapsPerSecond < gaps * 1000;
    if (!tooFast) return;

    _rushTimer?.cancel();
    _rushTimer = Timer(
      const Duration(milliseconds: AppConstants.pacingHintHoldMs),
      () {
        if (mounted) state = state.copyWith(isRushing: false);
      },
    );
    if (!state.isRushing) state = state.copyWith(isRushing: true);
  }

  void _clearPacing() {
    _rushTimer?.cancel();
    _rushTimer = null;
    _recentTapMs.clear();
    if (mounted && state.isRushing) state = state.copyWith(isRushing: false);
  }

  Future<void> decrement() async {
    final session = state.session;
    if (session == null) return;
    // Taps already stored on an earlier day cannot be undone.
    if (session.rowCount < session.incrementStep) return;
    if (_isOnEarlierDay(session.startTime)) return;

    // Undo also ends a Meru pause.
    endMeruPause();

    final resumed = _resumeIfPaused(session);
    final newCount = resumed.tapCount - resumed.incrementStep;
    final updated = resumed.copyWith(tapCount: newCount);
    state = state.copyWith(session: updated);

    if (newCount > 0 && updated.rowCount <= 0) {
      // Undid all of today's taps of a carried-over mala. Drop today's row
      // but keep the session, so the unfinished mala stays.
      _dbDebounce?.cancel();
      await _deleteCurrentDbRow();
      _isSessionInDb = false;
      _lastDbWrittenCount = updated.tapCount;
      _tapsSinceLastDbFlush = 0;
      await _writePrefsImmediately(updated);
      await _refreshTotalsFromCounter();
    } else if (newCount <= 0) {
      // Reached zero — cancel session (delete DB row, clear prefs), then
      // start a fresh one. The fresh session's id is used for both the
      // prefs entry and the DB row, so recovery can never create a second
      // row for the same taps.
      await _cancelSession();
      final fresh = _startFreshSession(
        counterId: updated.counterId,
        counterName: updated.counterName,
        incrementStep: updated.incrementStep,
      );
      state = state.copyWith(session: fresh);
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

  bool _isOnEarlierDay(int ms) =>
      isEarlierLocalDay(ms, _ref.read(countingClockProvider)());

  /// Moves the session onto a new row dated today. The current row keeps
  /// the taps made on its own day (unsaved ones are written first); the
  /// mala itself carries on, so [ActiveSession.tapCount] is unchanged.
  Future<void> _startNewDayRow(ActiveSession session) async {
    final oldId = _sessionDbId;
    final oldInDb = _isSessionInDb;
    final oldUnsaved = session.tapCount != _lastDbWrittenCount;

    // Switch to the new row before any await, so a second tap arriving
    // meanwhile does not split again.
    final now = _ref.read(countingClockProvider)();
    final next = session.copyWith(
      sessionId: _uuid.v4(),
      startTime: now,
      carriedCount: session.tapCount,
      carriedDurationMs: session.duration,
    );
    _dbDebounce?.cancel();
    _sessionDbId = next.sessionId;
    _isSessionInDb = false;
    _lastDbWrittenCount = session.tapCount;
    _tapsSinceLastDbFlush = 0;
    state = state.copyWith(
      session: next,
      lastDbWrittenCount: _lastDbWrittenCount,
      resumedFromEarlierDay: false,
    );

    final repo = _ref.read(japaCounterRepositoryProvider);
    final oldCount = session.rowCount;
    if (oldId != null && oldCount > 0 && (oldUnsaved || !oldInDb)) {
      final existing = oldInDb ? await repo.getSessionById(oldId) : null;
      final row = JapaSession(
        id: oldId,
        counterId: session.counterId,
        counterName: session.counterName,
        count: oldCount,
        malas: oldCount ~/ 108,
        chants: oldCount % 108,
        timestamp: existing?.timestamp ?? session.startTime,
        duration: session.rowDuration,
      );
      if (existing != null) {
        await repo.updateSession(row);
      } else {
        await repo.insertSession(row);
      }
    }
    await _writePrefsImmediately(state.session ?? next);
    // "Today" has moved on — reload the daily total.
    await _refreshTotalsFromCounter();
  }

  // ───────────────────────────── DB write helpers ─────────────────────────

  Future<void> _insertSessionRow(ActiveSession session) async {
    final repo = _ref.read(japaCounterRepositoryProvider);
    // Use the session's own id so the prefs entry and the DB row match.
    final id = _sessionDbId ?? session.sessionId;
    _sessionDbId = id;
    // Never store an empty row (e.g. a late batch write after undo).
    final rowCount = session.rowCount;
    if (rowCount <= 0) return;
    final row = JapaSession(
      id: id,
      counterId: session.counterId,
      counterName: session.counterName,
      count: rowCount,
      malas: rowCount ~/ 108,
      chants: rowCount % 108,
      timestamp: session.startTime,
      duration: session.rowDuration,
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
        count: session.rowCount,
        malas: session.rowCount ~/ 108,
        chants: session.rowCount % 108,
        timestamp: existing.timestamp,
        duration: session.rowDuration,
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
    if (session == null || session.rowCount <= 0) return;
    if (_tapsSinceLastDbFlush == 0 || session.tapCount == _lastDbWrittenCount) {
      return;
    }
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
    if (session == null || _tapsSinceLastPrefsFlush == 0) return;
    await _writePrefsImmediately(session);
  }

  // ───────────────────────────── high-level actions ───────────────────────

  /// Exit the counting screen.
  ///
  /// If the session has counts but is mid-mala (`tapCount % 108 != 0`),
  /// pause it so the next visit to this counter resumes the same session.
  /// Otherwise finalize and clear crash-recovery prefs.
  ///
  /// This holds even when today's daily goal is already met: the leftover
  /// count is kept. To close an unfinished mala, use [finishAndStartNew].
  Future<JapaSession?> completeSession() async {
    final session = state.session;
    if (session == null || state.isCompleting) return null;

    state = state.copyWith(isCompleting: true);
    _stopTimers();

    final shouldPause = session.tapCount > 0 && session.tapCount % 108 != 0;

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
    if (session.rowCount > 0) {
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

  /// Close the current session and start a fresh one at 0.
  ///
  /// Unlike [resetSession], nothing is deleted: the counts made so far stay
  /// in history on the day they were made. Used by the "Start new" banner
  /// and the "Finish & start new" menu item.
  Future<void> finishAndStartNew() async {
    final session = state.session;
    if (session == null || state.isCompleting) return;
    _stopTimers();
    endMeruPause();
    _clearPacing();

    if (session.rowCount > 0) {
      await _updateSessionRow(session);
    } else {
      await _deleteCurrentDbRow();
    }
    await _ref.read(settingsRepositoryProvider).clearActiveSession(_counterId);
    _resetTrackingState();

    final repo = _ref.read(japaCounterRepositoryProvider);
    final counter = await repo.getCounterById(_counterId);
    if (counter == null) return;
    final newSession = _startFreshSession(
      counterId: counter.id,
      counterName: counter.name,
      incrementStep: counter.incrementStep,
    );
    state = CountingState(session: newSession);
    await _refreshTotals(counter.initialCount);
    _startTimers();
    _invalidateStatsAndHistory();
  }

  /// Reset the current session — matches Kotlin's `cancelSession` flow.
  /// Deletes the in-progress DB row and starts a fresh session.
  Future<void> resetSession() async {
    _stopTimers();
    endMeruPause();
    _clearPacing();
    await _cancelSession();

    final repo = _ref.read(japaCounterRepositoryProvider);
    final counter = await repo.getCounterById(_counterId);
    if (counter == null) return;

    final newSession = _startFreshSession(
      counterId: counter.id,
      counterName: counter.name,
      incrementStep: counter.incrementStep,
    );
    state = CountingState(session: newSession);
    await _refreshTotals(counter.initialCount);
    _startTimers();
    _invalidateStatsAndHistory();
  }

  /// Reset the entire counter — matches Kotlin's `resetCounter`.
  /// Deletes ALL sessions for the counter without saving the current one.
  Future<void> resetCounter() async {
    _stopTimers();
    endMeruPause();
    _clearPacing();
    final repo = _ref.read(japaCounterRepositoryProvider);
    await repo.deleteSessionsByCounterId(_counterId);
    await _ref.read(settingsRepositoryProvider).clearActiveSession(_counterId);

    final counter = await repo.getCounterById(_counterId);
    if (counter == null) return;
    final newSession = _startFreshSession(
      counterId: counter.id,
      counterName: counter.name,
      incrementStep: counter.incrementStep,
    );
    state = CountingState(session: newSession);
    await _refreshTotals(counter.initialCount);
    _startTimers();
    _invalidateStatsAndHistory();
  }

  /// Lifecycle: flush pending writes and stop timers when the app goes background.
  Future<void> onPause() async {
    _stopTimers();
    endMeruPause();
    _clearPacing();
    final session = state.session;
    if (session == null) return;
    if (_tapsSinceLastPrefsFlush > 0) {
      await _writePrefsImmediately(session);
    }
    if (session.tapCount > _lastDbWrittenCount) {
      await _updateSessionRow(session);
    }
    _invalidateStatsAndHistory();
  }

  /// Lifecycle: restart periodic batching timers when returning to foreground.
  void onResume() {
    final session = state.session;
    if (session != null && !session.isPaused) {
      _startTimers();
    }
  }

  // ───────────────────────────── internals ────────────────────────────────

  /// Builds a new, empty session and points DB tracking at its id, so the
  /// saved prefs session and the DB row always share one id.
  ActiveSession _startFreshSession({
    required String counterId,
    required String counterName,
    required int incrementStep,
  }) {
    final now = DateTime.now().millisecondsSinceEpoch;
    final session = ActiveSession(
      sessionId: _uuid.v4(),
      counterId: counterId,
      counterName: counterName,
      startTime: now,
      tapCount: 0,
      incrementStep: incrementStep,
      lastResumeTimeMs: now,
    );
    _sessionDbId = session.sessionId;
    _isSessionInDb = false;
    _lastDbWrittenCount = 0;
    return session;
  }

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

    // Lifetime-goal threshold: fire only on the tap that crosses the goal.
    if (_lifetimeGoal > 0 && settings.lifetimeGoalNotificationsEnabled) {
      final newLifetimeTotal = state.liveLifetimeTotal;
      final prevLifetimeTotal = newLifetimeTotal - session.incrementStep;
      if (prevLifetimeTotal < _lifetimeGoal &&
          newLifetimeTotal >= _lifetimeGoal) {
        notif.notifyLifetimeGoalReached();
        if (settings.vibrationEnabled) haptic.vibrateDailyGoal();
        sound.playTone(settings.lifetimeSoundUri);
        return; // Skip daily goal and mala chime — lifetime milestone supersedes.
      }
    }

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
        sound.playMalaSound(settings.malaSound);
        if (settings.vibrationEnabled) haptic.vibrateMala();
      }
    }
  }

  @override
  void dispose() {
    _stopTimers();
    _meruTimer?.cancel();
    _rushTimer?.cancel();
    super.dispose();
  }
}

final countingNotifierProvider = StateNotifierProvider.autoDispose
    .family<CountingNotifier, CountingState, String>(
      (ref, counterId) => CountingNotifier(ref, counterId),
    );
