import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../config/theme.dart';
import '../l10n/app_localizations.dart';
import '../providers/settings_provider.dart';
import '../widgets/temple_decorations.dart';

/// Appearance preferences screen reached from Settings -> Appearance.
/// Provides screen brightness controls, Stillness mode configuration,
/// temple devotional color palette explanation, and typography details.
class AppearanceScreen extends ConsumerWidget {
  const AppearanceScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final settings = ref.watch(settingsNotifierProvider);
    final notifier = ref.read(settingsNotifierProvider.notifier);

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
                    title: l.appearanceHeaderTitle,
                    subtitle: l.appearanceHeaderSub,
                  ),
                  const SizedBox(height: 20),

                  _sectionHeader(l.appearanceBrightnessSection, Icons.brightness_6_outlined),
                  const SizedBox(height: 8),
                  _BrightnessCard(
                    value: settings.screenBrightness < 0 ? 0.5 : settings.screenBrightness,
                    usingSystem: settings.screenBrightness < 0,
                    onChanged: notifier.setScreenBrightness,
                    onReset: () => notifier.setScreenBrightness(-1.0),
                  ),
                  const SizedBox(height: 22),

                  _sectionHeader(l.appearancePaletteSection, Icons.color_lens_outlined),
                  const SizedBox(height: 8),
                  _ColorPaletteCard(),
                  const SizedBox(height: 22),

                  _sectionHeader(l.appearanceTypographySection, Icons.font_download_outlined),
                  const SizedBox(height: 8),
                  _TypographyCard(),
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
            child: const Icon(Icons.arrow_back, size: 18, color: TempleColors.ink),
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
                  l.appearanceTitle,
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

  Widget _sectionHeader(String title, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
      child: Row(
        children: [
          Icon(icon, size: 16, color: TempleColors.vermillion),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              title,
              style: AppTheme.serif(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: TempleColors.ink,
              ),
            ),
          ),
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
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: TempleColors.vermillion.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Center(
              child: TempleDiyaIcon(size: 26, color: TempleColors.vermillion),
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
                const SizedBox(height: 3),
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

class _BrightnessCard extends StatelessWidget {
  final double value;
  final bool usingSystem;
  final ValueChanged<double> onChanged;
  final VoidCallback onReset;

  const _BrightnessCard({
    required this.value,
    required this.usingSystem,
    required this.onChanged,
    required this.onReset,
  });

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: TempleColors.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: TempleColors.line),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l.brightnessLevel,
                      style: AppTheme.sans(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: TempleColors.ink,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      usingSystem ? l.followingSystem : l.overrideActive,
                      style: AppTheme.sans(
                        fontSize: 13,
                        color: TempleColors.ink2,
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  Text(
                    (value * 100).round().toString(),
                    style: AppTheme.serif(
                      fontSize: 24,
                      color: TempleColors.vermillion,
                      fontWeight: FontWeight.w600,
                      height: 1,
                    ),
                  ),
                  Text(
                    '%',
                    style: AppTheme.sans(
                      fontSize: 13,
                      color: TempleColors.ink3,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          Slider(
            value: value.clamp(0.0, 1.0),
            activeColor: TempleColors.vermillion,
            inactiveColor: TempleColors.line,
            onChanged: onChanged,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  l.brightnessStill,
                  style: AppTheme.serif(
                    fontSize: 11,
                    color: TempleColors.ink3,
                  ),
                ),
                TextButton(
                  onPressed: onReset,
                  style: TextButton.styleFrom(
                    visualDensity: VisualDensity.compact,
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    minimumSize: Size.zero,
                  ),
                  child: Text(
                    l.brightnessUseSystem,
                    style: AppTheme.sans(
                      fontSize: 12,
                      color: TempleColors.vermillion,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Text(
                  l.brightnessFull,
                  style: AppTheme.serif(
                    fontSize: 11,
                    color: TempleColors.ink3,
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

class _ColorPaletteCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: TempleColors.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: TempleColors.line),
      ),
      child: Column(
        children: [
          _ColorRow(
            color: TempleColors.vermillion,
            name: l.paletteVermillionName,
            role: l.paletteVermillionRole,
          ),
          const Divider(height: 16, color: TempleColors.line),
          _ColorRow(
            color: TempleColors.tulsi,
            name: l.paletteTulsiName,
            role: l.paletteTulsiRole,
          ),
          const Divider(height: 16, color: TempleColors.line),
          _ColorRow(
            color: TempleColors.sandal,
            name: l.paletteSandalName,
            role: l.paletteSandalRole,
          ),
          const Divider(height: 16, color: TempleColors.line),
          _ColorRow(
            color: TempleColors.rose,
            name: l.paletteRoseName,
            role: l.paletteRoseRole,
          ),
          const Divider(height: 16, color: TempleColors.line),
          _ColorRow(
            color: TempleColors.bg,
            borderColor: TempleColors.line,
            name: l.paletteCreamName,
            role: l.paletteCreamRole,
          ),
        ],
      ),
    );
  }
}

class _ColorRow extends StatelessWidget {
  final Color color;
  final Color? borderColor;
  final String name;
  final String role;

  const _ColorRow({
    required this.color,
    this.borderColor,
    required this.name,
    required this.role,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 28,
          height: 28,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
            border: Border.all(color: borderColor ?? Colors.transparent, width: 1.5),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.06),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: AppTheme.sans(
                  fontSize: 14.5,
                  fontWeight: FontWeight.w600,
                  color: TempleColors.ink,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                role,
                style: AppTheme.sans(
                  fontSize: 12.5,
                  color: TempleColors.ink2,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _TypographyCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: TempleColors.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: TempleColors.line),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _TypeSample(
            title: l.typographySerifTitle,
            sub: l.typographySerifSub,
            sample: '108 · ॐ नमः शिवाय',
            style: AppTheme.serif(fontSize: 18, color: TempleColors.vermillion),
          ),
          const Divider(height: 20, color: TempleColors.line),
          _TypeSample(
            title: l.typographySansTitle,
            sub: l.typographySansSub,
            sample: 'Daily Sadhana Progress · 12 Malas',
            style: AppTheme.sans(fontSize: 14, fontWeight: FontWeight.w600),
          ),
          const Divider(height: 20, color: TempleColors.line),
          _TypeSample(
            title: l.typographyMalTitle,
            sub: l.typographyMalSub,
            sample: 'ഓം നമഃ ശിവായ · ഹരേ കൃഷ്ണ',
            style: AppTheme.mal(fontSize: 15, color: TempleColors.ink),
          ),
        ],
      ),
    );
  }
}

class _TypeSample extends StatelessWidget {
  final String title;
  final String sub;
  final String sample;
  final TextStyle style;

  const _TypeSample({
    required this.title,
    required this.sub,
    required this.sample,
    required this.style,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppTheme.sans(
            fontSize: 14.5,
            fontWeight: FontWeight.w600,
            color: TempleColors.ink,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          sub,
          style: AppTheme.sans(fontSize: 12, color: TempleColors.ink2),
        ),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: TempleColors.cardSoft,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: TempleColors.line),
          ),
          child: Text(sample, style: style),
        ),
      ],
    );
  }
}
