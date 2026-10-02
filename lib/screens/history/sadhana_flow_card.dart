import 'dart:math' as math;

import 'package:material_ui/material_ui.dart';
import 'package:mantra_japa_counter/core/utils/sadhana_flow.dart';
import 'package:mantra_japa_counter/l10n/app_localizations.dart';
import 'package:mantra_japa_counter/theme/theme.dart';
import 'package:mantra_japa_counter/widgets/temple_decorations.dart';

/// "Sadhana Flow" — a calendar of practice days that glow like diyas.
///
/// Shows the last few weeks as a grid (Monday at the top), a line about
/// practice days this year, and a warm welcome when the user returns after
/// a break. No streaks and no "missed day" marks.
class SadhanaFlowCard extends StatelessWidget {
  final AppLocalizations l;
  final SadhanaFlow flow;

  const SadhanaFlowCard({super.key, required this.l, required this.flow});

  static const double _gap = 3;
  static const double _maxCell = 18;

  /// Glow colour for a level (0 = unlit).
  static Color levelColor(int level) {
    switch (level) {
      case 1:
        return TempleColors.sandal.withValues(alpha: 0.30);
      case 2:
        return TempleColors.sandal.withValues(alpha: 0.60);
      case 3:
        return TempleColors.sandal;
      case 4:
        return TempleColors.vermillion;
      default:
        return TempleColors.line.withValues(alpha: 0.55);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(18, 16, 18, 0),
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
      decoration: BoxDecoration(
        color: TempleColors.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: TempleColors.line),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const TempleDiyaIcon(size: 16),
              const SizedBox(width: 8),
              Text(
                l.sadhanaFlowTitle,
                style: AppTheme.eyebrow(
                  letterSpacing: 3,
                  color: TempleColors.ink2,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Semantics(
            label: l.sadhanaFlowA11y(flow.weeks),
            child: ExcludeSemantics(child: _grid()),
          ),
          const SizedBox(height: 8),
          _legend(),
          const SizedBox(height: 12),
          Text(
            l.sadhanaFlowYearDays(flow.practiceDaysThisYear),
            style: AppTheme.serif(fontSize: 14),
          ),
          if (flow.showWelcomeBack) ...[
            const SizedBox(height: 6),
            Text(
              l.sadhanaFlowWelcomeBack,
              style: AppTheme.serif(
                fontSize: 13,
                color: TempleColors.vermillionDeep,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _grid() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final cell = math.min(
          _maxCell,
          (constraints.maxWidth - _gap * (flow.weeks - 1)) / flow.weeks,
        );
        return Center(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              for (var col = 0; col < flow.weeks; col++)
                Padding(
                  padding: EdgeInsets.only(
                    right: col == flow.weeks - 1 ? 0 : _gap,
                  ),
                  child: Column(
                    children: [
                      for (var row = 0; row < 7; row++)
                        Padding(
                          padding: EdgeInsets.only(bottom: row == 6 ? 0 : _gap),
                          child: _cell(col * 7 + row, cell),
                        ),
                    ],
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _cell(int index, double size) {
    final level = flow.levels[index];
    if (level < 0) return SizedBox(width: size, height: size);
    final isToday = index == flow.todayIndex;
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: levelColor(level),
        borderRadius: BorderRadius.circular(size * 0.3),
        border: isToday
            ? Border.all(color: TempleColors.ink2, width: 1.2)
            : null,
        boxShadow: level >= 3
            ? [
                BoxShadow(
                  color: TempleColors.sandal.withValues(alpha: 0.45),
                  blurRadius: 4,
                ),
              ]
            : null,
      ),
    );
  }

  Widget _legend() {
    final labelStyle = AppTheme.sans(fontSize: 10, color: TempleColors.ink3);
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Text(l.sadhanaFlowLess, style: labelStyle),
        const SizedBox(width: 6),
        for (var level = 0; level <= SadhanaFlow.maxLevel; level++)
          Padding(
            padding: const EdgeInsets.only(right: 3),
            child: Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(
                color: levelColor(level),
                borderRadius: BorderRadius.circular(3),
              ),
            ),
          ),
        const SizedBox(width: 3),
        Text(l.sadhanaFlowMore, style: labelStyle),
      ],
    );
  }
}
