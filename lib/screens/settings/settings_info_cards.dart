import 'package:flutter/material.dart';
import 'package:mantra_japa_counter/theme/theme.dart';
import 'package:mantra_japa_counter/l10n/app_localizations.dart';
import 'package:mantra_japa_counter/widgets/temple_decorations.dart';

// ─── Guidance + danger cards ────────────────────────────────────────────────

class SettingsGuidanceCard extends StatelessWidget {
  const SettingsGuidanceCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: TempleColors.cardSoft,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: TempleColors.line),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const TempleDiyaIcon(size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              AppLocalizations.of(context).settingsGuidanceBody,
              style: AppTheme.sans(
                fontSize: 13.5,
                fontWeight: FontWeight.w400,
                height: 1.55,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class SettingsDangerCard extends StatelessWidget {
  final VoidCallback onTap;
  const SettingsDangerCard({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: TempleColors.card,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: const BorderSide(color: TempleColors.line),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              const Icon(
                Icons.delete_outline,
                color: TempleColors.vermillionDeep,
                size: 22,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppLocalizations.of(context).clearAllData,
                      style: AppTheme.sans(
                        fontSize: 15,
                        color: TempleColors.vermillionDeep,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      AppLocalizations.of(context).clearAllDataSub,
                      style: AppTheme.sans(
                        fontSize: 13,
                        color: TempleColors.ink2,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
