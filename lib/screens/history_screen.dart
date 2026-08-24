import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../config/theme.dart';
import '../l10n/app_localizations.dart';
import '../models/daily_summary.dart';
import '../models/japa_session.dart';
import '../providers/app_providers.dart';
import '../providers/history_provider.dart';
import '../utils/mala.dart';
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
              const TempleLotusIcon(size: 48, color: TempleColors.vermillion),
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
          child: _Hero(
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
                      fontSize: 10,
                      letterSpacing: 3,
                      color: TempleColors.ink2,
                    ),
                  ),
                );
              }
              final s = summaries[i - 1];
              final isLast = i == summaries.length;
              return _DayGroup(
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

// ─── Hero ────────────────────────────────────────────────────────────────────

class _Hero extends StatelessWidget {
  final AppLocalizations l;
  final String? mantraName;
  final int lifetimeTotal;
  final int counterGoal;
  final int dayCount;

  const _Hero({
    required this.l,
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
                  l.recordOfDevotion,
                  style: AppTheme.serif(
                    fontSize: 13,
                    color: TempleColors.ink2,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ] else
                Text(
                  l.allCounters,
                  style: AppTheme.serif(fontSize: 22, color: TempleColors.ink),
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
                        color: TempleColors.ink2,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ],
              ),
              const SizedBox(height: 6),
              Text(
                pct == null
                    ? l.chantsOfferedDays(dayCount)
                    : l.chantsOfferedPercent(
                        pct.toStringAsFixed(pct >= 10 ? 0 : 2),
                      ),
                style: AppTheme.eyebrow(
                  fontSize: 10,
                  letterSpacing: 2,
                  color: TempleColors.ink2,
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

class _DayGroup extends ConsumerStatefulWidget {
  final AppLocalizations l;
  final DailySummary summary;
  final String dayLabel;
  final bool isToday;
  final bool isLast;
  final int dayCumulativeTotal;
  final int counterGoal;
  final int counterDailyGoal;
  final bool showCounterNames;
  final String? filterCounterId;

  const _DayGroup({
    required this.l,
    required this.summary,
    required this.dayLabel,
    required this.isToday,
    required this.isLast,
    required this.dayCumulativeTotal,
    required this.counterGoal,
    required this.counterDailyGoal,
    required this.showCounterNames,
    required this.filterCounterId,
  });

  @override
  ConsumerState<_DayGroup> createState() => _DayGroupState();
}

class _DayGroupState extends ConsumerState<_DayGroup> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final summary = widget.summary;
    final dayMalas = malaForCount(summary.totalCount);
    final goalProgress = widget.counterGoal > 0
        ? (widget.dayCumulativeTotal / widget.counterGoal * 100).clamp(
            0.0,
            100.0,
          )
        : null;
    final isDailyComplete =
        widget.counterDailyGoal > 0 &&
        summary.totalCount >= widget.counterDailyGoal;
    final isLifetimeComplete =
        widget.counterGoal > 0 &&
        widget.dayCumulativeTotal >= widget.counterGoal;
    final sessionCount = summary.sessions.length;

    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: widget.isLast
              ? BorderSide.none
              : const BorderSide(color: TempleColors.line),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: () => setState(() => _expanded = !_expanded),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 14),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: widget.isToday
                          ? TempleColors.vermillion
                          : TempleColors.cardSoft,
                      border: Border.all(
                        color: widget.isToday
                            ? TempleColors.vermillionDeep
                            : TempleColors.line,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        _dayNumber(widget.dayLabel),
                        style: AppTheme.serif(
                          fontSize: 18,
                          color: widget.isToday
                              ? Colors.white
                              : TempleColors.vermillion,
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
                            Expanded(
                              child: Row(
                                children: [
                                  Flexible(
                                    child: Text(
                                      widget.isToday
                                          ? widget.l.today
                                          : summary.date,
                                      style: AppTheme.sans(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        color: TempleColors.ink,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  if (isDailyComplete) ...[
                                    const SizedBox(width: 6),
                                    const Icon(
                                      Icons.check_circle,
                                      size: 16,
                                      color: TempleColors.tulsi,
                                    ),
                                  ],
                                ],
                              ),
                            ),
                            Text(
                              widget.l.sessionCount(sessionCount),
                              style: AppTheme.serif(
                                fontSize: 12,
                                color: TempleColors.ink2,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            const SizedBox(width: 6),
                            AnimatedRotation(
                              turns: _expanded ? 0.5 : 0,
                              duration: const Duration(milliseconds: 180),
                              child: const Icon(
                                Icons.keyboard_arrow_down,
                                size: 18,
                                color: TempleColors.ink2,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            _Pair(
                              label: widget.l.labelChants,
                              value: summary.totalCount.toString(),
                            ),
                            const SizedBox(width: 14),
                            _Pair(
                              label: widget.l.labelMala,
                              value: dayMalas.toString(),
                            ),
                            const SizedBox(width: 14),
                            if (goalProgress != null)
                              Flexible(
                                child: Text(
                                  '${widget.dayCumulativeTotal} / ${widget.counterGoal} · ${goalProgress.toStringAsFixed(goalProgress >= 10 ? 0 : 2)}%',
                                  style: AppTheme.serif(
                                    fontSize: 12,
                                    color: isLifetimeComplete
                                        ? TempleColors.tulsi
                                        : TempleColors.vermillion,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              )
                            else
                              Text(
                                _formatDuration(summary.totalDuration),
                                style: AppTheme.serif(
                                  fontSize: 12,
                                  color: TempleColors.ink2,
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
            ),
          ),
          AnimatedSize(
            duration: const Duration(milliseconds: 180),
            curve: Curves.easeOut,
            alignment: Alignment.topCenter,
            child: _expanded
                ? Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: summary.sessions
                          .map(
                            (s) => _SessionRow(
                              l: widget.l,
                              session: s,
                              showCounterName: widget.showCounterNames,
                              onDelete: () => _confirmDelete(context, ref, s),
                            ),
                          )
                          .toList(),
                    ),
                  )
                : const SizedBox.shrink(),
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
    final l = widget.l;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(l.deleteSessionTitle),
        content: Text(l.deleteSessionMessage(session.count)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(l.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(
              l.delete,
              style: const TextStyle(color: TempleColors.vermillionDeep),
            ),
          ),
        ],
      ),
    );
    if (confirmed != true) return;
    await ref.read(japaCounterRepositoryProvider).deleteSession(session.id);
    ref.invalidate(historySummariesProvider(widget.filterCounterId));
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
  final AppLocalizations l;
  final JapaSession session;
  final bool showCounterName;
  final VoidCallback onDelete;

  const _SessionRow({
    required this.l,
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
                        color: TempleColors.ink2,
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
              color: TempleColors.ink2,
            ),
            visualDensity: VisualDensity.compact,
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
            tooltip: l.deleteSessionTooltip,
          ),
        ],
      ),
    );
  }

  String _detailLine() {
    final parts = <String>[l.chantsCount(session.count.toString())];
    if (session.malas > 0) {
      parts.add(l.malaCount(session.malas));
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
final _counterProvider = FutureProvider.autoDispose.family<dynamic, String>((
  ref,
  id,
) {
  return ref.watch(japaCounterRepositoryProvider).getCounterById(id);
});
