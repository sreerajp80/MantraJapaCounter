import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mantra_japa_counter/theme/theme.dart';
import 'package:mantra_japa_counter/l10n/app_localizations.dart';
import 'package:mantra_japa_counter/providers/settings_provider.dart';
import 'package:mantra_japa_counter/widgets/temple_decorations.dart';

/// Appearance preferences screen reached from Settings -> Appearance.
/// Provides screen brightness controls and Stillness mode configuration.
/// The palette and typography notes live on the About screen.
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

                  _sectionHeader(
                    l.appearanceBrightnessSection,
                    Icons.brightness_6_outlined,
                  ),
                  const SizedBox(height: 8),
                  _BrightnessCard(
                    value: settings.screenBrightness < 0
                        ? 0.5
                        : settings.screenBrightness,
                    usingSystem: settings.screenBrightness < 0,
                    onChanged: notifier.setScreenBrightness,
                    onReset: () => notifier.setScreenBrightness(-1.0),
                  ),
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
                  l.appearanceTitle,
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
              style: AppTheme.serif(fontSize: 16, fontWeight: FontWeight.w600),
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
            child: const Center(child: TempleDiyaIcon(size: 26)),
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
                  style: AppTheme.serif(fontSize: 11, color: TempleColors.ink3),
                ),
                TextButton(
                  onPressed: onReset,
                  style: TextButton.styleFrom(
                    visualDensity: VisualDensity.compact,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 2,
                    ),
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
                  style: AppTheme.serif(fontSize: 11, color: TempleColors.ink3),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
