import 'package:mantra_japa_counter/core/constants/app_constants.dart';
import 'package:mantra_japa_counter/models/daily_summary.dart';

/// Data for the "Sadhana Flow" heat-map on the History screen.
///
/// The grid has 7 rows (Monday to Sunday) and [weeks] columns. The last
/// column holds the current week. Cells are stored column by column:
/// `index = column * 7 + row`.
///
/// There are no streaks here on purpose: a missed day is simply an unlit
/// cell, never a broken chain.
class SadhanaFlow {
  /// Number of week columns in the grid.
  final int weeks;

  /// The day in the top-left cell (a Monday).
  final DateTime firstDay;

  /// Chant count for each cell.
  final List<int> counts;

  /// Glow level for each cell: 0 = no practice, 1..4 = brighter glow,
  /// -1 = a future day (not drawn).
  final List<int> levels;

  /// Index of today's cell.
  final int todayIndex;

  /// Days with at least one chant in the current calendar year.
  final int practiceDaysThisYear;

  /// True when the last practice before today was
  /// [AppConstants.sadhanaFlowWelcomeBackDays] or more days ago.
  final bool showWelcomeBack;

  const SadhanaFlow({
    required this.weeks,
    required this.firstDay,
    required this.counts,
    required this.levels,
    required this.todayIndex,
    required this.practiceDaysThisYear,
    required this.showWelcomeBack,
  });

  /// Highest glow level.
  static const int maxLevel = 4;

  /// Builds the heat-map from daily summaries.
  ///
  /// When [dailyGoal] is above 0, glow levels follow progress toward the
  /// daily goal. Otherwise they are relative to the busiest day in the grid.
  factory SadhanaFlow.fromSummaries(
    List<DailySummary> summaries, {
    required DateTime today,
    int dailyGoal = 0,
    int weeks = AppConstants.sadhanaFlowWeeks,
  }) {
    final todayDate = DateTime(today.year, today.month, today.day);

    // Day key -> total count. Summaries are already one per day.
    final byDay = <int, int>{};
    for (final s in summaries) {
      final day = s.day;
      if (day == null) continue;
      byDay[_key(day)] = (byDay[_key(day)] ?? 0) + s.totalCount;
    }

    // Monday of the current week, then back (weeks - 1) whole weeks.
    final firstDay = DateTime(
      todayDate.year,
      todayDate.month,
      todayDate.day - (todayDate.weekday - DateTime.monday) - (weeks - 1) * 7,
    );

    final cellCount = weeks * 7;
    final counts = List<int>.filled(cellCount, 0);
    var todayIndex = 0;
    var maxCount = 0;
    for (var i = 0; i < cellCount; i++) {
      final day = DateTime(firstDay.year, firstDay.month, firstDay.day + i);
      if (_key(day) == _key(todayDate)) todayIndex = i;
      final count = byDay[_key(day)] ?? 0;
      counts[i] = count;
      if (count > maxCount) maxCount = count;
    }

    final levels = List<int>.generate(cellCount, (i) {
      if (i > todayIndex) return -1;
      return _level(counts[i], dailyGoal: dailyGoal, maxCount: maxCount);
    });

    var yearDays = 0;
    DateTime? lastBeforeToday;
    for (final s in summaries) {
      final day = s.day;
      if (day == null || s.totalCount <= 0) continue;
      if (day.year == todayDate.year && !day.isAfter(todayDate)) yearDays++;
      if (day.isBefore(todayDate) &&
          (lastBeforeToday == null || day.isAfter(lastBeforeToday))) {
        lastBeforeToday = day;
      }
    }

    final showWelcomeBack =
        lastBeforeToday != null &&
        _daysBetween(lastBeforeToday, todayDate) >=
            AppConstants.sadhanaFlowWelcomeBackDays;

    return SadhanaFlow(
      weeks: weeks,
      firstDay: firstDay,
      counts: counts,
      levels: levels,
      todayIndex: todayIndex,
      practiceDaysThisYear: yearDays,
      showWelcomeBack: showWelcomeBack,
    );
  }

  static int _level(
    int count, {
    required int dailyGoal,
    required int maxCount,
  }) {
    if (count <= 0) return 0;
    final ratio = dailyGoal > 0 ? count / dailyGoal : count / maxCount;
    if (dailyGoal > 0 && ratio >= 1) return maxLevel;
    if (ratio <= 0.25) return 1;
    if (ratio <= 0.5) return 2;
    if (ratio <= 0.75) return 3;
    return dailyGoal > 0 ? 3 : maxLevel;
  }

  static int _key(DateTime d) => d.year * 10000 + d.month * 100 + d.day;

  /// Whole calendar days from [a] to [b], safe across daylight-saving changes.
  static int _daysBetween(DateTime a, DateTime b) => DateTime.utc(
    b.year,
    b.month,
    b.day,
  ).difference(DateTime.utc(a.year, a.month, a.day)).inDays;
}
