import 'package:flutter/material.dart';
import 'package:mantra_japa_counter/theme/theme.dart';
import 'package:mantra_japa_counter/l10n/app_localizations.dart';
import 'package:mantra_japa_counter/widgets/temple_decorations.dart';

// ─── Hero ────────────────────────────────────────────────────────────────────

class HistoryHero extends StatelessWidget {
  final AppLocalizations l;
  final String? mantraName;
  final int lifetimeTotal;
  final int counterGoal;
  final int dayCount;

  const HistoryHero({
    super.key,
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
            child: TempleMedallion(size: 120, opacity: 0.08),
          ),
          Column(
            children: [
              if (mantraName != null) ...[
                Text(
                  mantraName!,
                  textAlign: TextAlign.center,
                  style: AppTheme.mal(fontSize: 22),
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
                Text(l.allCounters, style: AppTheme.serif(fontSize: 22)),
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
                child: const TempleDiyaIcon(size: 24, strokeWidth: 1.6),
              ),
            ],
          );
        },
      ),
    );
  }
}
