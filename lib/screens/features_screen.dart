import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../config/theme.dart';
import '../l10n/app_localizations.dart';
import '../widgets/temple_decorations.dart';

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

  static const List<_FeatureCategory> _categories = [
    _FeatureCategory(
      name: 'Sacred Japa & Mala Counting',
      subtitle:
          'Distraction-free chanting, 108 mala mathematics, and fluid gestures',
      icon: Icons.all_inclusive_outlined,
      features: [
        _AppFeature(
          title: '108 Mala Beads Calculation',
          description:
              'Automatically calculates completed malas (1 mala = 108 chants) and keeps track of excess counts and progress rings.',
          icon: Icons.lens_blur_outlined,
          highlights: [
            '108 beads formula',
            'Excess counts counter',
            'Mala completion chime',
          ],
        ),
        _AppFeature(
          title: 'Full-Screen Immersion & Tap Area',
          description:
              'Tap anywhere on the large sacred ring to increment your count effortlessly without needing to look at specific buttons.',
          icon: Icons.touch_app_outlined,
          highlights: [
            'Large touch zone',
            'Subtle haptic pulse',
            'Distraction-free focus',
          ],
        ),
        _AppFeature(
          title: 'Two-Finger Swipe Undo',
          description:
              'Made an accidental count? Simply swipe left or right with two fingers on the ring to decrement the count cleanly.',
          icon: Icons.swipe_outlined,
          highlights: [
            'Horizontal swipe gesture',
            'Instant count reversal',
            'Prevents over-counting',
          ],
        ),
        _AppFeature(
          title: 'Persistent Session Timer & Goals',
          description:
              'Tracks active sitting duration with automatic background pause. Configure daily goals and lifetime dedication targets per mantra.',
          icon: Icons.timer_outlined,
          highlights: [
            'Active duration timer',
            'Per-mantra daily goals',
            'Lifetime dedication target',
          ],
        ),
      ],
    ),
    _FeatureCategory(
      name: 'Optical Air-Gap Sync & Data Safety',
      subtitle:
          '100% offline device-to-device synchronization via camera & QR streaming',
      icon: Icons.sync_outlined,
      features: [
        _AppFeature(
          title: 'High-Density Animated QR Stream',
          description:
              'Transfer complete practice records, counters, and history between phones in seconds using a high-speed optical QR code stream.',
          icon: Icons.qr_code_2_outlined,
          highlights: [
            'Zero Wi-Fi / Bluetooth',
            '10-15 FPS animated stream',
            'Instant phone transfer',
          ],
        ),
        _AppFeature(
          title: 'Luby Transform Fountain Code Recovery',
          description:
              'Transfers data using mathematical fountain codes and CRC32 verification so dropped camera frames are recovered automatically.',
          icon: Icons.auto_fix_high_outlined,
          highlights: [
            'Loss-tolerant recovery',
            'CRC32 checksums',
            'Out-of-order frame assembly',
          ],
        ),
        _AppFeature(
          title: 'Offline JSON Export & Restore',
          description:
              'Export full database backups to a plain JSON file to save on your local storage, share sheet, or restore anytime.',
          icon: Icons.backup_outlined,
          highlights: [
            'Standard JSON schema',
            'One-tap export/import',
            'Room/Gson compatibility',
          ],
        ),
      ],
    ),
    _FeatureCategory(
      name: 'Practice Insights & History',
      subtitle:
          'Comprehensive daily logs, streak counters, and per-counter breakdowns',
      icon: Icons.insights_outlined,
      features: [
        _AppFeature(
          title: 'Daily Practice Log & Breakdown',
          description:
              'Review historical sittings grouped by date with start timestamps, sitting duration, counts chanted, and malas completed.',
          icon: Icons.calendar_month_outlined,
          highlights: [
            'Date-wise grouping',
            'Sitting duration breakdown',
            'Daily mala tally',
          ],
        ),
        _AppFeature(
          title: 'Per-Counter Filtering',
          description:
              'Isolate and view history for individual mantras or view the combined sadhana across all active counters.',
          icon: Icons.filter_alt_outlined,
          highlights: [
            'Specific mantra view',
            'Combined daily view',
            'Lifetime totals',
          ],
        ),
      ],
    ),
    _FeatureCategory(
      name: 'Temple Aesthetics, Audio & Haptics',
      subtitle:
          'Peaceful devotional palette, resonant bell tones, and Malayalam support',
      icon: Icons.palette_outlined,
      features: [
        _AppFeature(
          title: 'Temple Devotional Palette',
          description:
              'Authentic temple palette with sacred cream backgrounds and vermillion, sandal yellow, tulsi green, and rose accents.',
          icon: Icons.color_lens_outlined,
          highlights: [
            'Cream & gold background',
            'Vermillion & Tulsi accents',
            'Serif numeral typography',
          ],
        ),
        _AppFeature(
          title: 'Peaceful Bell Tones & Audio Picker',
          description:
              'Gentle meditation chimes when completing malas or reaching daily goals. Choose system ringtones or pick custom local audio files.',
          icon: Icons.notifications_active_outlined,
          highlights: [
            'Mala & goal bell tones',
            'Custom audio picker',
            'Tone preview in settings',
          ],
        ),
        _AppFeature(
          title: 'Stillness Brightness Mode',
          description:
              'Dim screen brightness to minimal ambient levels for distraction-free early morning, temple, or late-night meditation.',
          icon: Icons.brightness_medium_outlined,
          highlights: [
            'Custom brightness slider',
            '1-tap system restore',
            'OLED battery efficiency',
          ],
        ),
        _AppFeature(
          title: 'Bilingual Malayalam & English UI',
          description:
              'Full Malayalam scripture and interface support alongside English with bundled Noto Sans Malayalam fonts.',
          icon: Icons.translate_outlined,
          highlights: [
            'Full Malayalam localization',
            'Authentic Indic font glyphs',
            '1-tap language switch',
          ],
        ),
      ],
    ),
    _FeatureCategory(
      name: 'Privacy & Offline-First Core',
      subtitle:
          'Zero cloud tracking, zero network requests, and absolute data privacy',
      icon: Icons.security_outlined,
      features: [
        _AppFeature(
          title: '100% Offline with Zero INTERNET Permission',
          description:
              'The application manifest completely lacks internet permissions. No telemetry, ads, or analytics can ever run.',
          icon: Icons.wifi_off_outlined,
          highlights: [
            'No INTERNET permission',
            'Zero cloud telemetry',
            'No tracking or ads',
          ],
        ),
        _AppFeature(
          title: 'Local SQLite Database & Crash Recovery',
          description:
              'Dual-layer persistence saves active counts every 5 taps/5 seconds to prevent accidental data loss during phone reboots.',
          icon: Icons.storage_outlined,
          highlights: [
            'ACID-compliant SQLite v3',
            '5-tap crash recovery',
            'Safe data migrations',
          ],
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
                  for (final category in _categories) ...[
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
                    fontSize: 10,
                    letterSpacing: 3,
                    color: TempleColors.vermillion,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  l.featuresTitle,
                  style: AppTheme.serif(
                    fontSize: 28,
                    fontWeight: FontWeight.w500,
                    color: TempleColors.ink,
                    height: 1,
                  ),
                ),
              ],
            ),
          ),
          const TempleLotusIcon(size: 22, color: TempleColors.vermillion),
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
                    color: TempleColors.ink,
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
                    color: TempleColors.ink,
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
                        color: TempleColors.ink,
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
                      Text(
                        h,
                        style: AppTheme.sans(
                          fontSize: 11.5,
                          fontWeight: FontWeight.w500,
                          color: TempleColors.ink,
                        ),
                      ),
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
