import 'package:flutter_test/flutter_test.dart';
import 'package:mantra_japa_counter/core/utils/sadhana_flow.dart';
import 'package:mantra_japa_counter/models/daily_summary.dart';
import 'package:mantra_japa_counter/models/japa_session.dart';

/// One summary with a single session on [day] (at 9 am local time).
DailySummary _day(DateTime day, int count) {
  final ts = DateTime(day.year, day.month, day.day, 9).millisecondsSinceEpoch;
  return DailySummary(
    date: 'x',
    totalCount: count,
    totalDuration: 0,
    sessions: [
      JapaSession(
        id: 's${day.millisecondsSinceEpoch}',
        counterId: 'c1',
        counterName: 'Om',
        count: count,
        malas: count ~/ 108,
        chants: count % 108,
        timestamp: ts,
        duration: 0,
      ),
    ],
  );
}

void main() {
  // A Wednesday.
  final today = DateTime(2026, 9, 30, 18);

  int indexOf(SadhanaFlow flow, DateTime day) {
    final d = DateTime(day.year, day.month, day.day);
    for (var i = 0; i < flow.counts.length; i++) {
      final cell = DateTime(
        flow.firstDay.year,
        flow.firstDay.month,
        flow.firstDay.day + i,
      );
      if (cell == d) return i;
    }
    return -1;
  }

  test('grid starts on a Monday and ends in the current week', () {
    final flow = SadhanaFlow.fromSummaries(const [], today: today);
    expect(flow.firstDay.weekday, DateTime.monday);
    expect(flow.counts, hasLength(16 * 7));
    // Wednesday is row 2 of the last column.
    expect(flow.todayIndex, 15 * 7 + 2);
    // Thursday to Sunday of this week are future days.
    expect(flow.levels.sublist(flow.todayIndex + 1), everyElement(-1));
    expect(flow.levels[flow.todayIndex], 0);
  });

  test('levels are relative to the busiest day without a daily goal', () {
    final flow = SadhanaFlow.fromSummaries([
      _day(DateTime(2026, 9, 30), 108),
      _day(DateTime(2026, 9, 29), 54),
      _day(DateTime(2026, 9, 28), 10),
    ], today: today);
    expect(flow.levels[indexOf(flow, DateTime(2026, 9, 30))], 4);
    expect(flow.levels[indexOf(flow, DateTime(2026, 9, 29))], 2);
    expect(flow.levels[indexOf(flow, DateTime(2026, 9, 28))], 1);
    expect(flow.counts[indexOf(flow, DateTime(2026, 9, 30))], 108);
  });

  test('levels follow the daily goal when one is set', () {
    final flow = SadhanaFlow.fromSummaries(
      [_day(DateTime(2026, 9, 30), 216), _day(DateTime(2026, 9, 29), 100)],
      today: today,
      dailyGoal: 108,
    );
    expect(flow.levels[indexOf(flow, DateTime(2026, 9, 30))], 4);
    expect(flow.levels[indexOf(flow, DateTime(2026, 9, 29))], 3);
  });

  test('counts practice days in the current year only', () {
    final flow = SadhanaFlow.fromSummaries([
      _day(DateTime(2026, 9, 30), 5),
      _day(DateTime(2026), 5),
      _day(DateTime(2025, 12, 31), 5),
    ], today: today);
    expect(flow.practiceDaysThisYear, 2);
  });

  test('welcome back after a gap of 3 or more days', () {
    // Practised today, previous day 4 days ago.
    expect(
      SadhanaFlow.fromSummaries([
        _day(DateTime(2026, 9, 30), 5),
        _day(DateTime(2026, 9, 26), 5),
      ], today: today).showWelcomeBack,
      isTrue,
    );
    // Not yet practised today, last practice 3 days ago.
    expect(
      SadhanaFlow.fromSummaries([
        _day(DateTime(2026, 9, 27), 5),
      ], today: today).showWelcomeBack,
      isTrue,
    );
  });

  test('no welcome back for regular practice or a first day', () {
    expect(
      SadhanaFlow.fromSummaries([
        _day(DateTime(2026, 9, 30), 5),
        _day(DateTime(2026, 9, 29), 5),
      ], today: today).showWelcomeBack,
      isFalse,
    );
    expect(
      SadhanaFlow.fromSummaries([
        _day(DateTime(2026, 9, 30), 5),
      ], today: today).showWelcomeBack,
      isFalse,
    );
    expect(
      SadhanaFlow.fromSummaries(const [], today: today).showWelcomeBack,
      isFalse,
    );
  });
}
