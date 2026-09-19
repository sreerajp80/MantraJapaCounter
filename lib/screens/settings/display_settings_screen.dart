import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mantra_japa_counter/theme/theme.dart';
import 'package:mantra_japa_counter/l10n/app_localizations.dart';
import 'package:mantra_japa_counter/providers/app_providers.dart';
import 'package:mantra_japa_counter/providers/settings_provider.dart';
import 'package:mantra_japa_counter/widgets/temple_decorations.dart';
import 'package:mantra_japa_counter/screens/settings/settings_tiles.dart';
import 'package:mantra_japa_counter/screens/settings/settings_brightness_row.dart';

/// Dedicated Display & Stillness settings screen.
class DisplaySettingsScreen extends ConsumerWidget {
  const DisplaySettingsScreen({super.key});

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
                  // Immersion Guidance
                  Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: TempleColors.cardSoft,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: TempleColors.line),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            color: TempleColors.vermillion.withValues(
                              alpha: 0.12,
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Center(
                            child: Icon(
                              Icons.brightness_medium_outlined,
                              color: TempleColors.vermillion,
                              size: 24,
                            ),
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                l.sectionStillness,
                                style: AppTheme.serif(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                l.featBrightnessDesc,
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
                  ),

                  const SizedBox(height: 20),

                  SettingsSection(
                    title: l.sectionStillness,
                    sub: l.sectionStillnessSub,
                    iconBuilder: (s, c) =>
                        Icon(Icons.brightness_5_outlined, size: s, color: c),
                    children: [
                      SettingsBrightnessRow(
                        value: settings.screenBrightness < 0
                            ? 0.5
                            : settings.screenBrightness,
                        usingSystem: settings.screenBrightness < 0,
                        onChanged: notifier.setScreenBrightness,
                        onReset: () => notifier.setScreenBrightness(-1.0),
                      ),
                      SettingsRow(
                        leading: const Icon(
                          Icons.do_not_disturb_on_outlined,
                          size: 20,
                          color: TempleColors.vermillion,
                        ),
                        title: l.dndTitle,
                        sub: l.dndSub,
                        toggle: settings.dndEnabled,
                        onToggle: (val) async {
                          if (val) {
                            final dnd = ref.read(dndServiceProvider);
                            final granted = await dnd.isDndAccessGranted();
                            if (!granted && context.mounted) {
                              _showDndPermissionDialog(context, ref);
                              return;
                            }
                          } else {
                            ref.read(dndServiceProvider).restoreDnd();
                          }
                          notifier.setDndEnabled(val);
                        },
                      ),
                      SettingsRow(
                        leading: const Icon(
                          Icons.nightlight_outlined,
                          size: 20,
                          color: TempleColors.vermillion,
                        ),
                        title: l.dimmedModeTitle,
                        sub: l.dimmedModeSub,
                        toggle: settings.dimmedChantingMode,
                        onToggle: (val) => notifier.setDimmedChantingMode(val),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showDndPermissionDialog(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(l.dndPermissionTitle),
        content: Text(l.dndPermissionMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l.cancel),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ref.read(dndServiceProvider).openDndSettings();
            },
            child: Text(
              l.dndOpenSettings,
              style: const TextStyle(color: TempleColors.vermillion),
            ),
          ),
        ],
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
                  l.settingsDisplayTitle,
                  style: AppTheme.serif(fontSize: 26, height: 1),
                ),
              ],
            ),
          ),
          const TempleLotusIcon(size: 22),
        ],
      ),
    );
  }
}
