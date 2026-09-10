import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mantra_japa_counter/theme/theme.dart';
import 'package:mantra_japa_counter/l10n/app_localizations.dart';
import 'package:mantra_japa_counter/models/daily_summary.dart';
import 'package:mantra_japa_counter/providers/app_providers.dart';
import 'package:mantra_japa_counter/providers/history_provider.dart';
import 'package:mantra_japa_counter/widgets/temple_decorations.dart';
import 'package:mantra_japa_counter/screens/history/history_hero.dart';
import 'package:mantra_japa_counter/screens/history/history_day_group.dart';

/// Full session history grouped by date — Temple variation.
/// When [filterCounterId] is provided, a devotional hero displays the counter
/// name, lifetime total, and a diya progress marker. Sessions are then listed
/// as "recent offerings" with a numeric day badge.
class HistoryScreen extends ConsumerWidget {
  final String? filterCounterId;
  const HistoryScreen({super.key, this.filterCounterId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final summariesAsync = ref.watch(historySummariesProvider(filterCounterId));
    final counterAsync = filterCounterId == null
        ? null
        : ref.watch(_counterProvider(filterCounterId!));

    return Scaffold(
      backgroundColor: TempleColors.bg,
      body: SafeArea(
        child: Column(
          children: [
            _topBar(context, ref),
            Expanded(
              child: summariesAsync.when(
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (e, _) => Center(child: Text(l.errorWithMessage('$e'))),
                data: (summaries) => _body(
                  l: l,
                  summaries: summaries,
                  counterName: counterAsync?.value?.name,
                  counterGoal: counterAsync?.value?.goal ?? 0,
                  counterDailyGoal: counterAsync?.value?.dailyGoal ?? 0,
                  counterInitialCount: counterAsync?.value?.initialCount ?? 0,
                  showCounterNames: filterCounterId == null,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _topBar(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 18, 18, 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          TempleIconButton(
            onTap: () => context.pop(),
            child: const Icon(
              Icons.arrow_back,
              size: 18,
              color: TempleColors.ink,
            ),
          ),
          const TempleOmBadge(),
          TempleIconButton(
            onTap: () => _confirmClear(context, ref),
            child: const Icon(
              Icons.delete_outline,
              size: 18,
              color: TempleColors.ink,
            ),
          ),
        ],
      ),
    );
  }

  Widget _body({
    required AppLocalizations l,
    required List<DailySummary> summaries,
    String? counterName,
    int counterGoal = 0,
    int counterDailyGoal = 0,
    int counterInitialCount = 0,
    bool showCounterNames = false,
  }) {
    if (summaries.isEmpty && counterInitialCount == 0) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const TempleLotusIcon(size: 48),
              const SizedBox(height: 16),
              Text(
                l.noSessionsRecorded,
                style: AppTheme.serif(
                  fontSize: 14,
                  color: TempleColors.ink2,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
      );
    }

    // Match the Kotlin formula: initialCount + SUM(session.count).
    final lifetimeTotal =
        counterInitialCount +
        summaries.fold<int>(0, (sum, d) => sum + d.totalCount);

    // Running lifetime total at the END of each day. summaries are sorted
    // newest-first, so cumulativeByIndex[0] == lifetimeTotal and each later
    // entry steps backwards by that day's contribution.
    final cumulativeByIndex = List<int>.filled(summaries.length, 0);
    var running = lifetimeTotal;
    for (var i = 0; i < summaries.length; i++) {
      cumulativeByIndex[i] = running;
      running -= summaries[i].totalCount;
    }

    final todayLabel = _formatDate(DateTime.now());

    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: HistoryHero(
            l: l,
            mantraName: counterName,
            lifetimeTotal: lifetimeTotal,
            counterGoal: counterGoal,
            dayCount: summaries.length,
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(18, 14, 18, 28),
          sliver: SliverList.builder(
            itemCount: summaries.length + 1,
            itemBuilder: (ctx, i) {
              if (i == 0) {
                return Padding(
                  padding: const EdgeInsets.only(top: 4, bottom: 12),
                  child: Text(
                    l.recentOfferings,
                    style: AppTheme.eyebrow(
                      letterSpacing: 3,
                      color: TempleColors.ink2,
                    ),
                  ),
                );
              }
              final s = summaries[i - 1];
              final isLast = i == summaries.length;
              return HistoryDayGroup(
                l: l,
                summary: s,
                dayLabel: 'Day ${summaries.length - (i - 1)}',
                isToday: s.date == todayLabel,
                isLast: isLast,
                dayCumulativeTotal: cumulativeByIndex[i - 1],
                counterGoal: counterGoal,
                counterDailyGoal: counterDailyGoal,
                showCounterNames: showCounterNames,
                filterCounterId: filterCounterId,
              );
            },
          ),
        ),
      ],
    );
  }

  // Must match the format produced by JapaCounterRepository._formatDate.
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

  void _confirmClear(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(
          filterCounterId == null
              ? l.clearAllHistoryTitle
              : l.clearCounterHistoryTitle,
        ),
        content: Text(l.clearHistoryMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l.cancel),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              final repo = ref.read(japaCounterRepositoryProvider);
              if (filterCounterId == null) {
                await repo.deleteAllSessions();
              } else {
                await repo.deleteSessionsByCounterId(filterCounterId!);
              }
              ref.invalidate(historySummariesProvider(filterCounterId));
            },
            child: Text(
              l.clear,
              style: const TextStyle(color: TempleColors.vermillionDeep),
            ),
          ),
        ],
      ),
    );
  }
}

// Used to fetch the named counter when the screen is filtered.
final _counterProvider = FutureProvider.autoDispose.family<dynamic, String>((
  ref,
  id,
) {
  return ref.watch(japaCounterRepositoryProvider).getCounterById(id);
});
