import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mantra_japa_counter/theme/theme.dart';
import 'package:mantra_japa_counter/l10n/app_localizations.dart';
import 'package:mantra_japa_counter/providers/counter_stats_provider.dart';
import 'package:mantra_japa_counter/widgets/temple_decorations.dart';

// ─── Header ──────────────────────────────────────────────────────────────────

class CounterListHeader extends StatelessWidget {
  final AsyncValue<TodayAggregate> today;
  final VoidCallback onAdd;
  final void Function(String) onMenu;

  const CounterListHeader({
    super.key,
    required this.today,
    required this.onAdd,
    required this.onMenu,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(22, 24, 22, 18),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: TempleColors.line)),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TempleIconButton(
                onTap: onAdd,
                child: const Icon(Icons.add, size: 18, color: TempleColors.ink),
              ),
              const TempleOmBadge(),
              _HeaderMenu(onMenu: onMenu),
            ],
          ),
          const SizedBox(height: 10),
          const TempleArch(),
          Transform.translate(
            offset: const Offset(0, -4),
            child: Text(
              AppLocalizations.of(context).mantraCounters,
              style: AppTheme.serif(fontSize: 32, height: 1),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 16),
          today.when(
            loading: () => const SizedBox(height: 48),
            error: (_, _) => const SizedBox(height: 48),
            data: (t) => _TodaySummaryPill(today: t),
          ),
        ],
      ),
    );
  }
}

class _HeaderMenu extends StatelessWidget {
  final void Function(String) onMenu;
  const _HeaderMenu({required this.onMenu});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return PopupMenuButton<String>(
      onSelected: onMenu,
      tooltip: l.more,
      offset: const Offset(0, 44),
      child: Container(
        width: 38,
        height: 38,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: TempleColors.card,
          border: Border.fromBorderSide(BorderSide(color: TempleColors.line)),
        ),
        child: const Center(
          child: Icon(Icons.more_vert, size: 18, color: TempleColors.ink),
        ),
      ),
      itemBuilder: (_) => [
        PopupMenuItem(value: 'export', child: Text(l.menuImportExport)),
        PopupMenuItem(value: 'settings', child: Text(l.menuSettings)),
        PopupMenuItem(value: 'about', child: Text(l.menuAbout)),
      ],
    );
  }
}

class _TodaySummaryPill extends StatelessWidget {
  final TodayAggregate today;
  const _TodaySummaryPill({required this.today});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
      decoration: BoxDecoration(
        color: TempleColors.cardSoft,
        borderRadius: BorderRadius.circular(100),
        border: Border.all(color: TempleColors.line),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _PillStat(
            value: today.chants.toString(),
            label: l.todayChants,
            color: TempleColors.vermillion,
          ),
          const _PillDivider(),
          _PillStat(
            value: today.malas.toString(),
            label: l.todayMalas,
            color: TempleColors.sandal,
          ),
          const _PillDivider(),
          _PillStat(
            value: today.counters.toString(),
            label: l.todayActive,
            color: TempleColors.tulsi,
          ),
        ],
      ),
    );
  }
}

class _PillStat extends StatelessWidget {
  final String value;
  final String label;
  final Color color;
  const _PillStat({
    required this.value,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 9),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            value,
            style: AppTheme.serif(fontSize: 18, color: color, height: 1),
          ),
          const SizedBox(height: 2),
          Text(label.toUpperCase(), style: AppTheme.eyebrow(fontSize: 9)),
        ],
      ),
    );
  }
}

class _PillDivider extends StatelessWidget {
  const _PillDivider();
  @override
  Widget build(BuildContext context) =>
      Container(width: 1, height: 28, color: TempleColors.line);
}
