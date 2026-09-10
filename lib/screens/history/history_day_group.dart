import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mantra_japa_counter/theme/theme.dart';
import 'package:mantra_japa_counter/l10n/app_localizations.dart';
import 'package:mantra_japa_counter/models/daily_summary.dart';
import 'package:mantra_japa_counter/models/japa_session.dart';
import 'package:mantra_japa_counter/providers/app_providers.dart';
import 'package:mantra_japa_counter/providers/history_provider.dart';
import 'package:mantra_japa_counter/core/utils/mala.dart';
import 'package:mantra_japa_counter/screens/history/history_session_row.dart';

// ─── Day group ───────────────────────────────────────────────────────────────

class HistoryDayGroup extends ConsumerStatefulWidget {
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

  const HistoryDayGroup({
    super.key,
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
  ConsumerState<HistoryDayGroup> createState() => _HistoryDayGroupState();
}

class _HistoryDayGroupState extends ConsumerState<HistoryDayGroup> {
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

    return DecoratedBox(
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
                            (s) => HistorySessionRow(
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
