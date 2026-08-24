import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../l10n/app_localizations.dart';
import '../providers/app_providers.dart';
import '../providers/counter_stats_provider.dart';
import '../models/counter.dart';
import '../models/counter_status.dart';
import '../utils/mala.dart';
import '../widgets/circular_progress_widget.dart';

/// Statistics and details screen for a single counter.
class AboutCounterScreen extends ConsumerWidget {
  final String counterId;
  const AboutCounterScreen({super.key, required this.counterId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final counterAsync = ref.watch(_counterDetailProvider(counterId));
    final statsAsync = ref.watch(counterStatsProvider(counterId));
    final averageAsync = ref.watch(
      counterAverageProvider((
        counterId: counterId,
        startDateMs: counterAsync.value?.startDate ?? 0,
      )),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(counterAsync.value?.name ?? l.counterDetailsTitle),
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: () => context.push('/history?counterId=$counterId'),
          ),
        ],
      ),
      body: counterAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text(l.errorWithMessage('$e'))),
        data: (counter) {
          if (counter == null) {
            return Center(child: Text(l.counterNotFound));
          }
          return _CounterDetail(
            counter: counter,
            stats: statsAsync.value,
            averageDaily: averageAsync.value ?? 0.0,
            l: l,
          );
        },
      ),
    );
  }
}

class _CounterDetail extends StatelessWidget {
  final Counter counter;
  final CounterStats? stats;
  final double averageDaily;
  final AppLocalizations l;

  const _CounterDetail({
    required this.counter,
    required this.stats,
    required this.averageDaily,
    required this.l,
  });

  @override
  Widget build(BuildContext context) {
    final total = stats?.totalCount ?? 0;
    final today = stats?.todayCount ?? 0;
    final totalMalas = malaForCount(total);
    final goalMalas = malaForCount(counter.goal);

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // ── Status badge ─────────────────────────────────────────────────────
        if (!counter.isActive)
          Card(
            color: counter.status == CounterStatus.disabledSuccess
                ? Colors.green[50]
                : Colors.red[50],
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  Icon(
                    counter.status == CounterStatus.disabledSuccess
                        ? Icons.check_circle
                        : Icons.cancel,
                    color: counter.status == CounterStatus.disabledSuccess
                        ? Colors.green
                        : Colors.red,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          counter.status == CounterStatus.disabledSuccess
                              ? l.completedSuccessfully
                              : l.statusDisabled,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        if (counter.disabledReason != null)
                          Text(
                            counter.disabledReason!,
                            style: const TextStyle(fontSize: 12),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

        // ── Progress circles ─────────────────────────────────────────────────
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            CircularProgressWidget(
              progress: counter.lifetimeProgress(total),
              centerText: '$total',
              bottomLabel: l.labelTotal,
              color: Colors.blue,
            ),
            CircularProgressWidget(
              progress: counter.dailyProgress(today),
              centerText: '$today',
              bottomLabel: l.labelTodayCap,
              color: Colors.orange,
            ),
            CircularProgressWidget(
              progress: (totalMalas / (goalMalas > 0 ? goalMalas : 1)).clamp(
                0.0,
                1.0,
              ),
              centerText: '$totalMalas',
              bottomLabel: l.labelMalas,
              color: Colors.purple,
            ),
          ],
        ),

        const SizedBox(height: 24),

        // ── Details table ────────────────────────────────────────────────────
        _infoRow(l.infoName, counter.name),
        _infoRow(l.infoStatus, _statusText(counter.status)),
        _infoRow(l.infoIncrementStep, '+${counter.incrementStep}'),
        _infoRow(l.infoInitialCount, '${counter.initialCount}'),
        _infoRow(
          l.infoLifetimeGoal,
          counter.goal > 0 ? '${counter.goal}' : l.notSet,
        ),
        _infoRow(
          l.infoDailyGoal,
          counter.dailyGoal > 0 ? '${counter.dailyGoal}' : l.notSet,
        ),
        _infoRow(l.infoStarted, _formatDate(counter.startDate)),
        _infoRow(l.infoCreated, _formatDate(counter.createdAt)),
        _infoRow(l.infoAvgDaily, averageDaily.toStringAsFixed(1)),
        if (counter.disabledAt != null)
          _infoRow(l.infoDisabled, _formatDate(counter.disabledAt!)),
      ],
    );
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 140,
            child: Text(
              label,
              style: TextStyle(
                color: Colors.grey[800],
                fontWeight: FontWeight.w500,
                fontSize: 14,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w700,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _statusText(CounterStatus s) {
    switch (s) {
      case CounterStatus.active:
        return l.statusActive;
      case CounterStatus.disabledSuccess:
        return l.statusCompleted;
      case CounterStatus.disabledFailure:
        return l.statusDisabled;
    }
  }

  String _formatDate(int ms) {
    if (ms == 0) return '—';
    final dt = DateTime.fromMillisecondsSinceEpoch(ms);
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
    return '${months[dt.month - 1]} ${dt.day.toString().padLeft(2, '0')}, ${dt.year}';
  }
}

final _counterDetailProvider = FutureProvider.autoDispose
    .family<Counter?, String>((ref, id) async {
      return ref.watch(japaCounterRepositoryProvider).getCounterById(id);
    });
