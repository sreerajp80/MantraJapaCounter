import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../config/theme.dart';
import '../models/daily_summary.dart';
import '../models/japa_session.dart';
import '../providers/app_providers.dart';
import '../providers/history_provider.dart';
import '../widgets/temple_decorations.dart';

/// Full session history grouped by date — Temple variation.
/// When [filterCounterId] is provided, a devotional hero displays the counter
/// name, lifetime total, and a diya progress marker. Sessions are then listed
/// as "recent offerings" with a numeric day badge.
class HistoryScreen extends ConsumerWidget {
  final String? filterCounterId;
  const HistoryScreen({super.key, this.filterCounterId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final summariesAsync =
        ref.watch(historySummariesProvider(filterCounterId));
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
                loading: () =>
                    const Center(child: CircularProgressIndicator()),
                error: (e, _) => Center(child: Text('Error: $e')),
                data: (summaries) => _body(
                  summaries: summaries,
                  counterName: counterAsync?.value?.name,
                  counterGoal: counterAsync?.value?.goal ?? 0,
                  counterInitialCount:
                      counterAsync?.value?.initialCount ?? 0,
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
            child: const Icon(Icons.arrow_back,
                size: 18, color: TempleColors.ink),
          ),
          const TempleOmBadge(),
          TempleIconButton(
            onTap: () => _confirmClear(context, ref),
            child: const Icon(Icons.delete_outline,
                size: 18, color: TempleColors.ink),
          ),
        ],
      ),
    );
  }

  Widget _body({
    required List<DailySummary> summaries,
    String? counterName,
    int counterGoal = 0,
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
              const TempleLotusIcon(
                  size: 48, color: TempleColors.vermillion),
              const SizedBox(height: 16),
              Text('No sessions recorded yet.',
                  style: AppTheme.serif(
                    fontSize: 14,
                    color: TempleColors.ink3,
                    fontWeight: FontWeight.w400,
                  )),
            ],
          ),
        ),
      );
    }

    // Match the Kotlin formula: initialCount + SUM(session.count).
    final lifetimeTotal = counterInitialCount +
        summaries.fold<int>(0, (sum, d) => sum + d.totalCount);

    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: _Hero(
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
                  child: Text('RECENT OFFERINGS',
                      style: AppTheme.eyebrow(
                          fontSize: 10, letterSpacing: 3)),
                );
              }
              final s = summaries[i - 1];
              final isLast = i == summaries.length;
              return _DayGroup(
                summary: s,
                dayLabel: 'Day ${summaries.length - (i - 1)}',
                isToday: i == 1,
                isLast: isLast,
                lifetimeTotal: lifetimeTotal,
                counterGoal: counterGoal,
                showCounterNames: showCounterNames,
                filterCounterId: filterCounterId,
              );
            },
          ),
        ),
      ],
    );
  }

  void _confirmClear(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(filterCounterId == null
            ? 'Clear all history?'
            : 'Clear this counter\'s history?'),
        content: const Text('Sessions will be permanently deleted.'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel')),
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
            child: const Text('Clear',
                style: TextStyle(color: TempleColors.vermillionDeep)),
          ),
        ],
      ),
    );
  }
}

// ─── Hero ────────────────────────────────────────────────────────────────────

class _Hero extends StatelessWidget {
  final String? mantraName;
  final int lifetimeTotal;
  final int counterGoal;
  final int dayCount;

  const _Hero({
    required this.mantraName,
    required this.lifetimeTotal,
    required this.counterGoal,
    required this.dayCount,
  });

  @override
  Widget build(BuildContext context) {
    final pct = counterGoal > 0
        ? (lifetimeTotal / counterGoal * 100).clamp(0.0, 100.0)
        : null;

    return Container(
      padding: const EdgeInsets.fromLTRB(22, 8, 22, 22),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: TempleColors.line)),
      ),
      child: Stack(
        alignment: Alignment.topCenter,
        children: [
          const Positioned(
            top: -8,
            child: TempleMedallion(
              size: 120,
              color: TempleColors.vermillion,
              opacity: 0.08,
            ),
          ),
          Column(
            children: [
              if (mantraName != null) ...[
                Text(
                  mantraName!,
                  textAlign: TextAlign.center,
                  style: AppTheme.mal(fontSize: 22, color: TempleColors.ink),
                ),
                const SizedBox(height: 4),
                Text(
                  'a record of devotion',
                  style: AppTheme.serif(
                    fontSize: 13,
                    color: TempleColors.ink3,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ] else
                Text(
                  'All counters',
                  style: AppTheme.serif(
                    fontSize: 22,
                    color: TempleColors.ink,
                  ),
                ),
              const SizedBox(height: 22),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  Text(
                    lifetimeTotal.toString(),
                    style: AppTheme.serif(
                      fontSize: 64,
                      color: TempleColors.vermillion,
                      fontWeight: FontWeight.w500,
                      height: 0.85,
                      letterSpacing: -2,
                    ),
                  ),
                  if (counterGoal > 0) ...[
                    const SizedBox(width: 8),
                    Text(
                      '/ $counterGoal',
                      style: AppTheme.serif(
                        fontSize: 16,
                        color: TempleColors.ink3,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ],
              ),
              const SizedBox(height: 6),
              Text(
                pct == null
                    ? 'CHANTS OFFERED · $dayCount DAY${dayCount == 1 ? '' : 'S'}'
                    : 'CHANTS OFFERED · ${pct.toStringAsFixed(pct >= 10 ? 0 : 2)}% OF VOW',
                style: AppTheme.eyebrow(
                  fontSize: 10,
                  letterSpacing: 2,
                ),
              ),
              if (pct != null) ...[
                const SizedBox(height: 18),
                _DiyaProgress(percent: pct),
              ],
            ],
          ),
        ],
      ),
    );
  }
}

class _DiyaProgress extends StatelessWidget {
  final double percent;
  const _DiyaProgress({required this.percent});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 24,
      child: LayoutBuilder(
        builder: (context, c) {
          final pct = (percent / 100).clamp(0.0, 1.0);
          final fillWidth = c.maxWidth * pct;
          final diyaLeft = (fillWidth - 12).clamp(0.0, c.maxWidth - 24);
          return Stack(
            children: [
              Positioned(
                top: 11,
                left: 0,
                right: 0,
                child: Container(height: 2, color: TempleColors.line),
              ),
              Positioned(
                top: 10,
                left: 0,
                child: Container(
                  width: fillWidth,
                  height: 4,
                  decoration: BoxDecoration(
                    color: TempleColors.vermillion,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              Positioned(
                top: 0,
                left: diyaLeft,
                child: const TempleDiyaIcon(
                  size: 24,
                  color: TempleColors.vermillion,
                  strokeWidth: 1.6,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

// ─── Day group ───────────────────────────────────────────────────────────────

class _DayGroup extends ConsumerWidget {
  final DailySummary summary;
  final String dayLabel;
  final bool isToday;
  final bool isLast;
  final int lifetimeTotal;
  final int counterGoal;
  final bool showCounterNames;
  final String? filterCounterId;

  const _DayGroup({
    required this.summary,
    required this.dayLabel,
    required this.isToday,
    required this.isLast,
    required this.lifetimeTotal,
    required this.counterGoal,
    required this.showCounterNames,
    required this.filterCounterId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dayMalas = summary.totalCount ~/ 108;
    final goalProgress = counterGoal > 0
        ? (lifetimeTotal / counterGoal * 100).clamp(0.0, 100.0)
        : null;
    final sessionCount = summary.sessions.length;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14),
      decoration: BoxDecoration(
        border: Border(
          bottom: isLast
              ? BorderSide.none
              : const BorderSide(color: TempleColors.line),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color:
                      isToday ? TempleColors.vermillion : TempleColors.cardSoft,
                  border: Border.all(
                    color: isToday
                        ? TempleColors.vermillionDeep
                        : TempleColors.line,
                  ),
                ),
                child: Center(
                  child: Text(
                    _dayNumber(dayLabel),
                    style: AppTheme.serif(
                      fontSize: 18,
                      color: isToday ? Colors.white : TempleColors.vermillion,
                      fontWeight: FontWeight.w500,
                      height: 1,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          isToday ? 'Today' : summary.date,
                          style: AppTheme.sans(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: TempleColors.ink,
                          ),
                        ),
                        Text(
                          '$sessionCount session${sessionCount == 1 ? '' : 's'}',
                          style: AppTheme.serif(
                            fontSize: 12,
                            color: TempleColors.ink3,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        _Pair(
                          label: 'chants',
                          value: summary.totalCount.toString(),
                        ),
                        const SizedBox(width: 14),
                        _Pair(label: 'mala', value: dayMalas.toString()),
                        const SizedBox(width: 14),
                        if (goalProgress != null)
                          Flexible(
                            child: Text(
                              '$lifetimeTotal · ${goalProgress.toStringAsFixed(goalProgress >= 10 ? 0 : 2)}%',
                              style: AppTheme.serif(
                                fontSize: 12,
                                color: TempleColors.vermillion,
                                fontWeight: FontWeight.w400,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          )
                        else
                          Text(
                            _formatDuration(summary.totalDuration),
                            style: AppTheme.serif(
                              fontSize: 12,
                              color: TempleColors.ink3,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ...summary.sessions.map(
            (s) => _SessionRow(
              session: s,
              showCounterName: showCounterNames,
              onDelete: () => _confirmDelete(context, ref, s),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _confirmDelete(
    BuildContext context,
    WidgetRef ref,
    JapaSession session,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Delete session?'),
        content: Text(
          'This session of ${session.count} chant${session.count == 1 ? '' : 's'} will be permanently removed.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text(
              'Delete',
              style: TextStyle(color: TempleColors.vermillionDeep),
            ),
          ),
        ],
      ),
    );
    if (confirmed != true) return;
    await ref.read(japaCounterRepositoryProvider).deleteSession(session.id);
    ref.invalidate(historySummariesProvider(filterCounterId));
  }

  String _dayNumber(String dayLabel) {
    final m = RegExp(r'\d+').firstMatch(dayLabel);
    return m?.group(0) ?? '';
  }

  String _formatDuration(int ms) {
    final mins = ms ~/ 60000;
    final hours = mins ~/ 60;
    if (hours > 0) return '${hours}h ${mins % 60}m';
    return '${mins}m';
  }
}

// ─── Individual session row ──────────────────────────────────────────────────

class _SessionRow extends StatelessWidget {
  final JapaSession session;
  final bool showCounterName;
  final VoidCallback onDelete;

  const _SessionRow({
    required this.session,
    required this.showCounterName,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(58, 6, 0, 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: TempleColors.tulsi,
            ),
          ),
          const SizedBox(width: 10),
          SizedBox(
            width: 44,
            child: Text(
              _formatTime(session.timestamp),
              style: AppTheme.serif(
                fontSize: 13,
                color: TempleColors.ink2,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(width: 6),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        _detailLine(),
                        style: AppTheme.serif(
                          fontSize: 13,
                          color: TempleColors.ink2,
                          fontWeight: FontWeight.w400,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                if (showCounterName)
                  Padding(
                    padding: const EdgeInsets.only(top: 2),
                    child: Text(
                      session.counterName,
                      style: AppTheme.sans(
                        fontSize: 11,
                        color: TempleColors.ink3,
                        fontWeight: FontWeight.w400,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
              ],
            ),
          ),
          IconButton(
            onPressed: onDelete,
            icon: const Icon(
              Icons.delete_outline,
              size: 18,
              color: TempleColors.ink3,
            ),
            visualDensity: VisualDensity.compact,
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
            tooltip: 'Delete session',
          ),
        ],
      ),
    );
  }

  String _detailLine() {
    final parts = <String>['${session.count} chants'];
    if (session.malas > 0) {
      parts.add('${session.malas} mala');
    }
    if (session.duration > 0) {
      parts.add(_formatDuration(session.duration));
    }
    return parts.join(' · ');
  }

  String _formatTime(int ms) {
    final dt = DateTime.fromMillisecondsSinceEpoch(ms);
    final h = dt.hour.toString().padLeft(2, '0');
    final m = dt.minute.toString().padLeft(2, '0');
    return '$h:$m';
  }

  String _formatDuration(int ms) {
    final mins = ms ~/ 60000;
    final hours = mins ~/ 60;
    if (hours > 0) return '${hours}h ${mins % 60}m';
    if (mins > 0) return '${mins}m';
    final secs = ms ~/ 1000;
    return '${secs}s';
  }
}

class _Pair extends StatelessWidget {
  final String label;
  final String value;
  const _Pair({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          value,
          style: AppTheme.serif(
            fontSize: 14,
            color: TempleColors.ink2,
            fontWeight: FontWeight.w500,
            fontStyle: FontStyle.normal,
          ),
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: AppTheme.sans(
            fontSize: 12,
            color: TempleColors.ink2,
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }
}

// Used to fetch the named counter when the screen is filtered.
final _counterProvider =
    FutureProvider.autoDispose.family<dynamic, String>((ref, id) {
  return ref.watch(japaCounterRepositoryProvider).getCounterById(id);
});
