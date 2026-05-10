import 'package:flutter/material.dart';
import '../config/theme.dart';
import '../models/counter.dart';
import '../models/counter_status.dart';
import '../utils/mala.dart';
import 'temple_decorations.dart';

/// Counter card on the list screen — Temple variation.
///
/// Layout:
///   • soft lotus medallion as a top-right watermark in the card's [accent] tone
///   • lotus avatar circle + mantra name
///   • large EB Garamond italic count + "chants · N mala" caption
///   • 27-segment prayer-bead daily-progress strip (mirrors a 108-bead mala
///     scaled down by 4×)
///   • optional lifetime line under the strip
class CounterCard extends StatelessWidget {
  final Counter counter;
  final int totalCount;
  final int todayCount;
  final VoidCallback onTap;
  final VoidCallback onLongPress;

  const CounterCard({
    super.key,
    required this.counter,
    required this.totalCount,
    required this.todayCount,
    required this.onTap,
    required this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    final isDisabled = !counter.isActive;
    final accent = TempleColors.accentForId(counter.id);
    final malas = malaForCount(totalCount);
    final dailyProgress = counter.hasDailyGoal
        ? (todayCount / counter.dailyGoal).clamp(0.0, double.infinity)
        : 0.0;
    final dailyComplete = counter.isDailyGoalAchieved(todayCount);
    final lifetimeRatio = counter.hasLifetimeGoal
        ? (totalCount / counter.goal).clamp(0.0, double.infinity).toDouble()
        : 0.0;
    final lifetimePercent = lifetimeRatio * 100;
    final lifetimeComplete = counter.isLifetimeGoalAchieved(totalCount);

    final cardColor =
        lifetimeComplete && !isDisabled ? TempleColors.cardSoft : TempleColors.card;
    final cardBorder = lifetimeComplete && !isDisabled
        ? TempleColors.sandal
        : TempleColors.line;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 6),
      child: Material(
        color: cardColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: cardBorder, width: lifetimeComplete ? 1.2 : 1),
        ),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: isDisabled ? null : onTap,
          onLongPress: onLongPress,
          child: Stack(
            children: [
              Positioned(
                top: -10,
                right: -10,
                child: TempleMedallion(
                  size: 84,
                  color: lifetimeComplete && !isDisabled
                      ? TempleColors.sandal
                      : accent,
                  opacity: lifetimeComplete && !isDisabled ? 0.16 : 0.10,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _header(accent, dailyComplete, lifetimeComplete, isDisabled),
                    const SizedBox(height: 14),
                    _bigCount(accent, malas),
                    const SizedBox(height: 14),
                    _progressStrip(
                      accent: accent,
                      dailyProgress: dailyProgress,
                      dailyComplete: dailyComplete,
                    ),
                    if (counter.hasLifetimeGoal) ...[
                      const SizedBox(height: 10),
                      _lifetimeRow(lifetimePercent, lifetimeComplete),
                      const SizedBox(height: 5),
                      _LifetimeBar(
                        ratio: lifetimeRatio,
                        accent: accent,
                        complete: lifetimeComplete,
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _header(
    Color accent,
    bool dailyComplete,
    bool lifetimeComplete,
    bool isDisabled,
  ) {
    return Row(
      children: [
        Container(
          width: 38,
          height: 38,
          decoration: const BoxDecoration(
            color: TempleColors.cardSoft,
            shape: BoxShape.circle,
            border: Border.fromBorderSide(BorderSide(color: TempleColors.line)),
          ),
          child: Center(
            child: TempleLotusIcon(size: 18, color: accent),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                counter.name,
                style: AppTheme.mal(
                  fontSize: 17,
                  color: isDisabled ? TempleColors.ink3 : TempleColors.ink,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
        if (isDisabled)
          Icon(
            counter.status == CounterStatus.disabledSuccess
                ? Icons.check_circle
                : Icons.cancel,
            color: counter.status == CounterStatus.disabledSuccess
                ? TempleColors.tulsi
                : TempleColors.ink3,
            size: 20,
          )
        else ...[
          if (dailyComplete)
            Container(
              width: 22,
              height: 22,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: TempleColors.tulsi,
              ),
              child: const Icon(Icons.check, color: Colors.white, size: 13),
            ),
          if (dailyComplete && lifetimeComplete) const SizedBox(width: 6),
          if (lifetimeComplete)
            Container(
              width: 26,
              height: 26,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: TempleColors.sandal,
                border:
                    Border.all(color: TempleColors.vermillionDeep, width: 1),
              ),
              child: const Icon(
                Icons.emoji_events,
                color: Colors.white,
                size: 15,
              ),
            ),
        ],
      ],
    );
  }

  Widget _bigCount(Color accent, int malas) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.baseline,
      textBaseline: TextBaseline.alphabetic,
      children: [
        Text(
          _format(totalCount),
          style: AppTheme.serif(
            fontSize: 38,
            fontWeight: FontWeight.w500,
            color: accent,
            letterSpacing: -0.5,
            height: 1,
          ),
        ),
        const SizedBox(width: 8),
        Flexible(
          child: Text(
            'chants · $malas mala',
            style: AppTheme.serif(
              fontSize: 13,
              color: TempleColors.ink,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  Widget _progressStrip({
    required Color accent,
    required double dailyProgress,
    required bool dailyComplete,
  }) {
    final percentLabel = counter.hasDailyGoal
        ? (dailyComplete
            ? '✓ complete'
            : '${(dailyProgress * 100).clamp(0, 100).round()}% daily')
        : '—';
    final percentColor =
        dailyComplete ? TempleColors.tulsi : TempleColors.vermillion;

    final todayMalas = malaForCount(todayCount);
    final todayCountLabel = counter.hasDailyGoal
        ? '${_format(todayCount)} / ${_format(counter.dailyGoal)}'
        : '${_format(todayCount)} chants';
    final todayMalaLabel = counter.hasDailyGoal
        ? '$todayMalas / ${malaForCount(counter.dailyGoal)} mala'
        : '$todayMalas mala';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: 'TODAY · ',
                      style: AppTheme.eyebrow(
                        fontSize: 11,
                        color: TempleColors.ink2,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    TextSpan(
                      text: percentLabel,
                      style: AppTheme.sans(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: percentColor,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  todayCountLabel,
                  style: AppTheme.eyebrow(
                    fontSize: 11,
                    color: TempleColors.ink2,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  todayMalaLabel,
                  style: AppTheme.serif(
                    fontSize: 11,
                    color: TempleColors.ink2,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 6),
        _BeadStrip(progress: dailyProgress.clamp(0.0, 1.0), accent: accent),
      ],
    );
  }

  Widget _lifetimeRow(double percent, bool complete) {
    final percentText = percent.toStringAsFixed(percent >= 10 ? 0 : 1);
    final percentLabel =
        complete ? 'lifetime · $percentText% ✓' : 'lifetime · $percentText%';
    final textColor = complete ? TempleColors.vermillionDeep : TempleColors.ink;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          percentLabel,
          style: AppTheme.serif(
            fontSize: 12,
            color: textColor,
            fontWeight: FontWeight.w600,
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              '${_format(totalCount)} / ${_format(counter.goal)}',
              style: AppTheme.serif(
                fontSize: 12,
                color: textColor,
                fontStyle: FontStyle.normal,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              '${malaForCount(totalCount)} / ${malaForCount(counter.goal)} mala',
              style: AppTheme.serif(
                fontSize: 11,
                color: TempleColors.ink2,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ],
    );
  }

  static String _format(int n) {
    final s = n.toString();
    final buf = StringBuffer();
    for (var i = 0; i < s.length; i++) {
      buf.write(s[i]);
      final remaining = s.length - i - 1;
      if (remaining > 0 && remaining % 3 == 0) buf.write(',');
    }
    return buf.toString();
  }
}

/// Continuous lifetime progress bar. Visually clamps to 100% width but the
/// caller's label reports the true percentage. When [complete] is true, the
/// bar is filled in [TempleColors.sandal] (gold) to echo the trophy mark.
class _LifetimeBar extends StatelessWidget {
  final double ratio;
  final Color accent;
  final bool complete;

  const _LifetimeBar({
    required this.ratio,
    required this.accent,
    required this.complete,
  });

  @override
  Widget build(BuildContext context) {
    final visualRatio = ratio.clamp(0.0, 1.0);
    final fillColor = complete ? TempleColors.sandal : accent;
    return ClipRRect(
      borderRadius: BorderRadius.circular(3),
      child: Stack(
        children: [
          Container(
            height: 5,
            width: double.infinity,
            color: TempleColors.line,
          ),
          FractionallySizedBox(
            widthFactor: visualRatio,
            child: Container(
              height: 5,
              decoration: BoxDecoration(
                color: fillColor,
                gradient: complete
                    ? const LinearGradient(
                        colors: [TempleColors.sandal, TempleColors.vermillion],
                      )
                    : null,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// 27-segment progress bar that visually echoes a 108-bead mala (each segment
/// = 4 beads). Filled segments use [accent], unfilled use [TempleColors.line].
class _BeadStrip extends StatelessWidget {
  final double progress;
  final Color accent;

  const _BeadStrip({required this.progress, required this.accent});

  @override
  Widget build(BuildContext context) {
    const segments = 27;
    final filled = (progress * segments).round().clamp(0, segments);
    return Row(
      children: List.generate(segments, (i) {
        return Expanded(
          child: Padding(
            padding: EdgeInsets.only(right: i == segments - 1 ? 0 : 3),
            child: Container(
              height: 4,
              decoration: BoxDecoration(
                color: i < filled ? accent : TempleColors.line,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
        );
      }),
    );
  }
}
