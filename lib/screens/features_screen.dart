import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mantra_japa_counter/theme/theme.dart';
import 'package:mantra_japa_counter/l10n/app_localizations.dart';
import 'package:mantra_japa_counter/widgets/temple_decorations.dart';

class _AppFeature {
  final String title;
  final String description;
  final IconData icon;
  final List<String> highlights;

  const _AppFeature({
    required this.title,
    required this.description,
    required this.icon,
    required this.highlights,
  });
}

class _FeatureCategory {
  final String name;
  final String subtitle;
  final IconData icon;
  final List<_AppFeature> features;

  const _FeatureCategory({
    required this.name,
    required this.subtitle,
    required this.icon,
    required this.features,
  });
}

/// Comprehensive Features showcase screen reached from Settings -> Features.
class FeaturesScreen extends StatelessWidget {
  const FeaturesScreen({super.key});

  /// Built from [AppLocalizations] on every build so the catalogue
  /// follows the selected language. All text lives in the ARB files.
  static List<_FeatureCategory> _categories(AppLocalizations l) => [
    _FeatureCategory(
      name: l.featCat1Name,
      subtitle: l.featCat1Sub,
      icon: Icons.all_inclusive_outlined,
      features: [
        _AppFeature(
          title: l.featMalaTitle,
          description: l.featMalaDesc,
          icon: Icons.lens_blur_outlined,
          highlights: [l.featMalaH1, l.featMalaH2, l.featMalaH3],
        ),
        _AppFeature(
          title: l.featImmersionTitle,
          description: l.featImmersionDesc,
          icon: Icons.touch_app_outlined,
          highlights: [l.featImmersionH1, l.featImmersionH2, l.featImmersionH3],
        ),
        _AppFeature(
          title: l.featUndoTitle,
          description: l.featUndoDesc,
          icon: Icons.swipe_outlined,
          highlights: [l.featUndoH1, l.featUndoH2, l.featUndoH3],
        ),
        _AppFeature(
          title: l.featTimerTitle,
          description: l.featTimerDesc,
          icon: Icons.timer_outlined,
          highlights: [l.featTimerH1, l.featTimerH2, l.featTimerH3],
        ),
        _AppFeature(
          title: l.lifetimeGoalCaps,
          description: l.lifetimeSoundSub,
          icon: Icons.stars_outlined,
          highlights: [
            l.notifDailyGoalTitle,
            l.notifLifetimeGoalTitle,
            l.soundTempleBell,
          ],
        ),
      ],
    ),
    _FeatureCategory(
      name: l.featCat2Name,
      subtitle: l.featCat2Sub,
      icon: Icons.sync_outlined,
      features: [
        _AppFeature(
          title: l.featQrStreamTitle,
          description: l.featQrStreamDesc,
          icon: Icons.qr_code_2_outlined,
          highlights: [l.featQrStreamH1, l.featQrStreamH2, l.featQrStreamH3],
        ),
        _AppFeature(
          title: l.featFountainTitle,
          description: l.featFountainDesc,
          icon: Icons.auto_fix_high_outlined,
          highlights: [l.featFountainH1, l.featFountainH2, l.featFountainH3],
        ),
        _AppFeature(
          title: l.featJsonExportTitle,
          description: l.featJsonExportDesc,
          icon: Icons.backup_outlined,
          highlights: [
            l.featJsonExportH1,
            l.featJsonExportH2,
            l.featJsonExportH3,
          ],
        ),
        _AppFeature(
          title: l.encryptBackup,
          description: l.encryptBackupSub,
          icon: Icons.lock_outline,
          highlights: ['AES-256-GCM', 'PBKDF2', l.enterPassphrase],
        ),
      ],
    ),
    _FeatureCategory(
      name: l.featCat3Name,
      subtitle: l.featCat3Sub,
      icon: Icons.insights_outlined,
      features: [
        _AppFeature(
          title: l.featDailyLogTitle,
          description: l.featDailyLogDesc,
          icon: Icons.calendar_month_outlined,
          highlights: [l.featDailyLogH1, l.featDailyLogH2, l.featDailyLogH3],
        ),
        _AppFeature(
          title: l.featFilterTitle,
          description: l.featFilterDesc,
          icon: Icons.filter_alt_outlined,
          highlights: [l.featFilterH1, l.featFilterH2, l.featFilterH3],
        ),
      ],
    ),
    _FeatureCategory(
      name: l.featCat4Name,
      subtitle: l.featCat4Sub,
      icon: Icons.palette_outlined,
      features: [
        _AppFeature(
          title: l.featPaletteTitle,
          description: l.featPaletteDesc,
          icon: Icons.color_lens_outlined,
          highlights: [l.featPaletteH1, l.featPaletteH2, l.featPaletteH3],
        ),
        _AppFeature(
          title: l.featBellTitle,
          description: l.featBellDesc,
          icon: Icons.notifications_active_outlined,
          highlights: [l.featBellH1, l.featBellH2, l.featBellH3],
        ),
        _AppFeature(
          title: l.featBrightnessTitle,
          description: l.featBrightnessDesc,
          icon: Icons.brightness_medium_outlined,
          highlights: [
            l.featBrightnessH1,
            l.featBrightnessH2,
            l.featBrightnessH3,
          ],
        ),
        _AppFeature(
          title: l.featBilingualTitle,
          description: l.featBilingualDesc,
          icon: Icons.translate_outlined,
          highlights: [l.featBilingualH1, l.featBilingualH2, l.featBilingualH3],
        ),
      ],
    ),
    _FeatureCategory(
      name: l.featCat5Name,
      subtitle: l.featCat5Sub,
      icon: Icons.security_outlined,
      features: [
        _AppFeature(
          title: l.featOfflineTitle,
          description: l.featOfflineDesc,
          icon: Icons.wifi_off_outlined,
          highlights: [l.featOfflineH1, l.featOfflineH2, l.featOfflineH3],
        ),
        _AppFeature(
          title: l.featSqliteTitle,
          description: l.featSqliteDesc,
          icon: Icons.storage_outlined,
          highlights: [l.featSqliteH1, l.featSqliteH2, l.featSqliteH3],
        ),
      ],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: TempleColors.bg,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _topBar(context, l),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(18, 12, 18, 32),
                children: [
                  _HeaderCard(
                    title: l.featuresHeaderTitle,
                    subtitle: l.featuresHeaderSub,
                  ),
                  const SizedBox(height: 20),
                  for (final category in _categories(l)) ...[
                    _buildCategoryHeader(category),
                    const SizedBox(height: 8),
                    _buildCategoryCard(category),
                    const SizedBox(height: 22),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _topBar(BuildContext context, AppLocalizations l) {
    return Container(
      padding: const EdgeInsets.fromLTRB(18, 18, 18, 14),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: TempleColors.line)),
      ),
      child: Row(
        children: [
          TempleIconButton(
            onTap: () => context.pop(),
            child: const Icon(
              Icons.arrow_back,
              size: 18,
              color: TempleColors.ink,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l.practiceEyebrow,
                  style: AppTheme.eyebrow(
                    letterSpacing: 3,
                    color: TempleColors.vermillion,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  l.featuresTitle,
                  style: AppTheme.serif(fontSize: 28, height: 1),
                ),
              ],
            ),
          ),
          const TempleLotusIcon(size: 22),
        ],
      ),
    );
  }

  Widget _buildCategoryHeader(_FeatureCategory category) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(category.icon, size: 16, color: TempleColors.vermillion),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  category.name,
                  style: AppTheme.serif(
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 2),
          Text(
            category.subtitle,
            style: AppTheme.sans(fontSize: 12, color: TempleColors.ink2),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryCard(_FeatureCategory category) {
    return Container(
      decoration: BoxDecoration(
        color: TempleColors.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: TempleColors.line),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          for (var i = 0; i < category.features.length; i++) ...[
            _FeatureTile(feature: category.features[i]),
            if (i < category.features.length - 1)
              const Divider(height: 1, color: TempleColors.line),
          ],
        ],
      ),
    );
  }
}

class _HeaderCard extends StatelessWidget {
  final String title;
  final String subtitle;

  const _HeaderCard({required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: TempleColors.cardSoft,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: TempleColors.line),
      ),
      child: Row(
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: TempleColors.vermillion.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Center(
              child: Icon(
                Icons.stars_rounded,
                color: TempleColors.vermillion,
                size: 30,
              ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTheme.serif(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: AppTheme.sans(
                    fontSize: 12.5,
                    color: TempleColors.ink2,
                    height: 1.35,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _FeatureTile extends StatelessWidget {
  final _AppFeature feature;

  const _FeatureTile({required this.feature});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: TempleColors.cardSoft,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: TempleColors.line),
                ),
                child: Center(
                  child: Icon(
                    feature.icon,
                    size: 18,
                    color: TempleColors.vermillion,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      feature.title,
                      style: AppTheme.sans(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      feature.description,
                      style: AppTheme.sans(
                        fontSize: 13,
                        color: TempleColors.ink2,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (feature.highlights.isNotEmpty) ...[
            const SizedBox(height: 12),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: feature.highlights.map((h) {
                return Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 9,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: TempleColors.cardSoft,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: TempleColors.line),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.check_circle_outline,
                        size: 12,
                        color: TempleColors.tulsi,
                      ),
                      const SizedBox(width: 5),
                      Text(h, style: AppTheme.sans(fontSize: 11.5)),
                    ],
                  ),
                );
              }).toList(),
            ),
          ],
        ],
      ),
    );
  }
}
