import 'dart:convert';

/// Mutable in-progress session state held by CountingNotifier.
///
/// Serialised to SharedPreferences for crash recovery and pause/resume.
/// Mirrors the Kotlin app's [ActiveSession] data class — the
/// [sessionId] is the same id used as the row's primary key in the
/// `japa_sessions` table, so the active session can be looked up,
/// updated, or deleted in the database without ambiguity.
///
/// Duration tracking excludes time the session was paused (user left
/// the counting screen mid-mala) so [duration] reflects only active
/// counting time. [accumulatedMs] holds active time from completed
/// segments; [lastResumeTimeMs] is the start of the current active
/// segment (equal to [startTime] on first start). When [isPaused] is
/// true, no segment is in progress and [duration] equals
/// [accumulatedMs].
class ActiveSession {
  final String sessionId;
  final String counterId;
  final String counterName;
  final int startTime;          // epoch ms — original start, never changes
  final int tapCount;           // total count in this session
  final int incrementStep;
  final int accumulatedMs;      // active duration from completed segments
  final int lastResumeTimeMs;   // epoch ms — start of current active segment
  final bool isPaused;          // true while waiting to resume on next tap

  const ActiveSession({
    required this.sessionId,
    required this.counterId,
    required this.counterName,
    required this.startTime,
    required this.tapCount,
    required this.incrementStep,
    this.accumulatedMs = 0,
    required this.lastResumeTimeMs,
    this.isPaused = false,
  });

  int get malas => tapCount ~/ 108;
  int get chants => tapCount % 108;

  /// Active counting time so far. Excludes paused gaps.
  int get duration {
    if (isPaused) return accumulatedMs;
    return accumulatedMs +
        (DateTime.now().millisecondsSinceEpoch - lastResumeTimeMs);
  }

  ActiveSession copyWith({
    String? sessionId,
    String? counterId,
    String? counterName,
    int? startTime,
    int? tapCount,
    int? incrementStep,
    int? accumulatedMs,
    int? lastResumeTimeMs,
    bool? isPaused,
  }) {
    return ActiveSession(
      sessionId: sessionId ?? this.sessionId,
      counterId: counterId ?? this.counterId,
      counterName: counterName ?? this.counterName,
      startTime: startTime ?? this.startTime,
      tapCount: tapCount ?? this.tapCount,
      incrementStep: incrementStep ?? this.incrementStep,
      accumulatedMs: accumulatedMs ?? this.accumulatedMs,
      lastResumeTimeMs: lastResumeTimeMs ?? this.lastResumeTimeMs,
      isPaused: isPaused ?? this.isPaused,
    );
  }

  Map<String, dynamic> toMap() => {
    'sessionId': sessionId,
    'counterId': counterId,
    'counterName': counterName,
    'startTime': startTime,
    'tapCount': tapCount,
    'incrementStep': incrementStep,
    'accumulatedMs': accumulatedMs,
    'lastResumeTimeMs': lastResumeTimeMs,
    'isPaused': isPaused,
  };

  factory ActiveSession.fromMap(Map<String, dynamic> map) {
    final start = map['startTime'] as int;
    return ActiveSession(
      sessionId: map['sessionId'] as String? ?? '',
      counterId: map['counterId'] as String,
      counterName: map['counterName'] as String,
      startTime: start,
      tapCount: map['tapCount'] as int,
      incrementStep: map['incrementStep'] as int? ?? 1,
      accumulatedMs: (map['accumulatedMs'] as num?)?.toInt() ?? 0,
      lastResumeTimeMs:
          (map['lastResumeTimeMs'] as num?)?.toInt() ?? start,
      isPaused: map['isPaused'] as bool? ?? false,
    );
  }

  String toJson() => jsonEncode(toMap());

  factory ActiveSession.fromJson(String json) =>
      ActiveSession.fromMap(jsonDecode(json) as Map<String, dynamic>);
}
