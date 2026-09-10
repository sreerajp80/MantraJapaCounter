import 'package:mantra_japa_counter/models/counter.dart';
import 'package:mantra_japa_counter/models/daily_summary.dart';
import 'package:mantra_japa_counter/models/japa_session.dart';
import 'package:mantra_japa_counter/repositories/japa_counter_repository.dart';

/// In-memory stand-in for [JapaCounterRepository], used by screen tests.
///
/// Only the methods the screens reach are implemented. Any other call throws,
/// so a test fails loudly instead of passing by accident.
class FakeJapaCounterRepository implements JapaCounterRepository {
  FakeJapaCounterRepository({
    List<Counter> counters = const [],
    List<JapaSession> sessions = const [],
  }) : counters = [...counters],
       sessions = [...sessions];

  final List<Counter> counters;
  final List<JapaSession> sessions;

  @override
  Future<List<Counter>> getAllCounters() async => [...counters];

  @override
  Future<Counter?> getCounterById(String id) async =>
      counters.where((c) => c.id == id).firstOrNull;

  @override
  Future<void> insertCounter(Counter counter) async => counters.add(counter);

  @override
  Future<void> updateCounter(Counter counter) async {
    final i = counters.indexWhere((c) => c.id == counter.id);
    if (i >= 0) counters[i] = counter;
  }

  @override
  Future<void> deleteCounter(String id) async =>
      counters.removeWhere((c) => c.id == id);

  @override
  Future<void> deleteSession(String id) async =>
      sessions.removeWhere((s) => s.id == id);

  @override
  Future<void> deleteAllSessions() async => sessions.clear();

  @override
  Future<void> deleteSessionsByCounterId(String counterId) async =>
      sessions.removeWhere((s) => s.counterId == counterId);

  @override
  Future<int> getTotalCountForCounter(String counterId) async => sessions
      .where((s) => s.counterId == counterId)
      .fold<int>(0, (sum, s) => sum + s.count);

  @override
  Future<int> getTodayCountForCounter(String counterId) async {
    final now = DateTime.now();
    final midnight = DateTime(
      now.year,
      now.month,
      now.day,
    ).millisecondsSinceEpoch;
    return sessions
        .where((s) => s.counterId == counterId && s.timestamp >= midnight)
        .fold<int>(0, (sum, s) => sum + s.count);
  }

  @override
  Future<double> getAverageDailyCountForCounter(
    String counterId,
    int startDateMs,
  ) async => 0;

  /// Groups sessions by day, newest day first, like the real repository.
  @override
  Future<List<DailySummary>> getDailySummaries({String? counterId}) async {
    final filtered =
        sessions
            .where((s) => counterId == null || s.counterId == counterId)
            .toList()
          ..sort((a, b) => b.timestamp.compareTo(a.timestamp));
    final byDate = <String, List<JapaSession>>{};
    for (final s in filtered) {
      final date = _formatDate(
        DateTime.fromMillisecondsSinceEpoch(s.timestamp),
      );
      byDate.putIfAbsent(date, () => []).add(s);
    }
    return [
      for (final entry in byDate.entries)
        DailySummary(
          date: entry.key,
          totalCount: entry.value.fold<int>(0, (sum, s) => sum + s.count),
          totalDuration: entry.value.fold<int>(0, (sum, s) => sum + s.duration),
          sessions: entry.value,
        ),
    ];
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => throw UnimplementedError(
    'FakeJapaCounterRepository does not implement ${invocation.memberName}',
  );

  static String _formatDate(DateTime dt) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    final day = dt.day.toString().padLeft(2, '0');
    return '${months[dt.month - 1]} $day, ${dt.year}';
  }
}
