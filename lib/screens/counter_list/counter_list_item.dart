import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mantra_japa_counter/theme/theme.dart';
import 'package:mantra_japa_counter/models/counter.dart';
import 'package:mantra_japa_counter/providers/counters_provider.dart';
import 'package:mantra_japa_counter/providers/counter_stats_provider.dart';
import 'package:mantra_japa_counter/widgets/counter_card.dart';
import 'package:mantra_japa_counter/screens/counter_list/counter_options_sheet.dart';

// ─── Counter card wrapper with stats ─────────────────────────────────────────

class CounterListItem extends ConsumerWidget {
  final Counter counter;
  const CounterListItem({super.key, required this.counter});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statsAsync = ref.watch(counterStatsProvider(counter.id));

    return statsAsync.when(
      loading: () => CounterCard(
        counter: counter,
        totalCount: 0,
        todayCount: 0,
        onTap: () => context.push('/counting/${counter.id}'),
        onLongPress: () => _showOptions(context, ref),
        onToggleLock: () =>
            ref.read(countersNotifierProvider.notifier).toggleLock(counter.id),
      ),
      error: (_, _) => const SizedBox.shrink(),
      data: (stats) => CounterCard(
        counter: counter,
        totalCount: stats.totalCount,
        todayCount: stats.todayCount,
        onTap: () => context.push('/counting/${counter.id}'),
        onLongPress: () => _showOptions(context, ref),
        onToggleLock: () =>
            ref.read(countersNotifierProvider.notifier).toggleLock(counter.id),
      ),
    );
  }

  void _showOptions(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      backgroundColor: TempleColors.card,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        side: BorderSide(color: TempleColors.line),
      ),
      builder: (_) => CounterOptionsSheet(counter: counter, ref: ref),
    );
  }
}
