import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../utils/mala.dart';
import 'app_providers.dart';
import 'counters_provider.dart';

class CounterStats {
  final int totalCount;
  final int todayCount;
  final int totalMalas;
  final int todayMalas;
  final double averageDaily;

  const CounterStats({
    required this.totalCount,
    required this.todayCount,
    required this.totalMalas,
    required this.todayMalas,
    required this.averageDaily,
  });
}

/// Per-counter statistics used by CounterListScreen cards and AboutCounterScreen.
///
/// Matches the Kotlin app's formula:
///   totalCount = counter.initialCount + SUM(session.count) for the counter
///   todayCount = SUM(session.count) for sessions since today's midnight
final counterStatsProvider = FutureProvider.autoDispose
    .family<CounterStats, String>((ref, counterId) async {
      final repo = ref.watch(japaCounterRepositoryProvider);
      // Watch the counters list so edits (e.g. changing initialCount) refresh stats
      // immediately without needing to leave and re-enter the screen.
      final counters = await ref.watch(countersNotifierProvider.future);
      final counter = counters.where((c) => c.id == counterId).firstOrNull;
      final dbTotal = await repo.getTotalCountForCounter(counterId);
      final today = await repo.getTodayCountForCounter(counterId);
      final initial = counter?.initialCount ?? 0;
      final total = initial + dbTotal;
      return CounterStats(
        totalCount: total,
        todayCount: today,
        totalMalas: malaForCount(total),
        todayMalas: malaForCount(today),
        averageDaily: 0, // computed separately for the about screen
      );
    });

final counterAverageProvider = FutureProvider.autoDispose
    .family<double, ({String counterId, int startDateMs})>((ref, args) async {
      final repo = ref.watch(japaCounterRepositoryProvider);
      return repo.getAverageDailyCountForCounter(
        args.counterId,
        args.startDateMs,
      );
    });

/// Aggregate "today" stats across all active counters — drives the summary
/// pill at the top of CounterListScreen.
class TodayAggregate {
  final int chants;
  final int malas;
  final int counters;
  const TodayAggregate({
    required this.chants,
    required this.malas,
    required this.counters,
  });
}

final todayAggregateProvider = FutureProvider.autoDispose<TodayAggregate>((
  ref,
) async {
  final repo = ref.watch(japaCounterRepositoryProvider);
  final counters = await ref.watch(countersNotifierProvider.future);
  final active = counters.where((c) => c.isActive).toList();
  var totalChants = 0;
  var usedToday = 0;
  for (final c in active) {
    final today = await repo.getTodayCountForCounter(c.id);
    if (today > 0) usedToday++;
    totalChants += today;
  }
  return TodayAggregate(
    chants: totalChants,
    malas: malaForCount(totalChants),
    counters: usedToday,
  );
});
