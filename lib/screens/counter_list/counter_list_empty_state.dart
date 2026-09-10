import 'package:flutter/material.dart';
import 'package:mantra_japa_counter/theme/theme.dart';
import 'package:mantra_japa_counter/l10n/app_localizations.dart';
import 'package:mantra_japa_counter/widgets/temple_decorations.dart';

// ─── Empty state ─────────────────────────────────────────────────────────────

class CounterListEmptyState extends StatelessWidget {
  const CounterListEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const TempleLotusIcon(size: 64),
          const SizedBox(height: 16),
          Text(
            AppLocalizations.of(context).noCountersYet,
            style: AppTheme.serif(fontSize: 22),
          ),
          const SizedBox(height: 8),
          Text(
            AppLocalizations.of(context).noCountersSubtitle,
            style: AppTheme.serif(
              fontSize: 13,
              color: TempleColors.ink3,
              fontWeight: FontWeight.w400,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
