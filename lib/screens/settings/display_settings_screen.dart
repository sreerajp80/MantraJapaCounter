import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mantra_japa_counter/core/constants/app_constants.dart';
import 'package:go_router/go_router.dart';
import 'package:mantra_japa_counter/theme/theme.dart';
import 'package:mantra_japa_counter/l10n/app_localizations.dart';
import 'package:mantra_japa_counter/models/meru_pause_mode.dart';
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
                  SettingsSection(
                    title: l.sectionMindfulCounting,
                    sub: l.sectionMindfulCountingSub,
                    iconBuilder: (s, c) =>
                        Icon(Icons.spa_outlined, size: s, color: c),
                    children: [
                      SettingsRow(
                        leading: const TempleLotusIcon(),
                        title: l.meruPauseSettingTitle,
                        sub: l.meruPauseSettingSub,
                        toggle: settings.meruPauseEnabled,
                        onToggle: notifier.setMeruPauseEnabled,
                      ),
                      if (settings.meruPauseEnabled)
                        Padding(
                          padding: const EdgeInsets.fromLTRB(56, 0, 14, 12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Wrap(
                                spacing: 8,
                                children: [
                                  _choiceChip(
                                    label: l.meruPauseModeTime,
                                    selected:
                                        settings.meruPauseMode ==
                                        MeruPauseMode.time,
                                    onSelected: () => notifier.setMeruPauseMode(
                                      MeruPauseMode.time,
                                    ),
                                  ),
                                  _choiceChip(
                                    label: l.meruPauseModeTaps,
                                    selected:
                                        settings.meruPauseMode ==
                                        MeruPauseMode.taps,
                                    onSelected: () => notifier.setMeruPauseMode(
                                      MeruPauseMode.taps,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              if (settings.meruPauseMode == MeruPauseMode.time)
                                Wrap(
                                  spacing: 8,
                                  children: [
                                    for (final secs
                                        in AppConstants.meruPauseChoicesSeconds)
                                      _choiceChip(
                                        label: l.secondsShort(secs),
                                        selected:
                                            settings.meruPauseSeconds == secs,
                                        onSelected: () =>
                                            notifier.setMeruPauseSeconds(secs),
                                      ),
                                  ],
                                )
                              else
                                _MeruTapStepper(
                                  taps: settings.meruPauseTaps,
                                  onChanged: notifier.setMeruPauseTaps,
                                ),
                            ],
                          ),
                        ),
                      SettingsRow(
                        leading: const Icon(
                          Icons.air,
                          size: 20,
                          color: TempleColors.vermillion,
                        ),
                        title: l.pacingHintSettingTitle,
                        sub: l.pacingHintSettingSub,
                        toggle: settings.pacingHintEnabled,
                        onToggle: notifier.setPacingHintEnabled,
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

  /// A chip in the Meru pause rows, styled like the other temple chips.
  Widget _choiceChip({
    required String label,
    required bool selected,
    required VoidCallback onSelected,
  }) {
    return ChoiceChip(
      label: Text(label),
      selected: selected,
      selectedColor: TempleColors.vermillion,
      labelStyle: TextStyle(color: selected ? Colors.white : TempleColors.ink),
      onSelected: (value) {
        if (value) onSelected();
      },
    );
  }
}

/// `[ − ]  2 taps  [ + ]` setting for the Meru pause by taps. The buttons
/// stop at the allowed range, so a wrong value can never be set.
class _MeruTapStepper extends StatelessWidget {
  final int taps;
  final ValueChanged<int> onChanged;

  const _MeruTapStepper({required this.taps, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final canDecrease = taps > AppConstants.meruPauseMinTaps;
    final canIncrease = taps < AppConstants.meruPauseMaxTaps;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          tooltip: l.meruPauseTapsDecreaseA11y,
          onPressed: canDecrease ? () => onChanged(taps - 1) : null,
          icon: const Icon(Icons.remove_circle_outline),
          color: TempleColors.vermillion,
        ),
        SizedBox(
          width: 80,
          child: Text(
            l.tapsShort(taps),
            textAlign: TextAlign.center,
            style: AppTheme.serif(fontSize: 16),
          ),
        ),
        IconButton(
          tooltip: l.meruPauseTapsIncreaseA11y,
          onPressed: canIncrease ? () => onChanged(taps + 1) : null,
          icon: const Icon(Icons.add_circle_outline),
          color: TempleColors.vermillion,
        ),
      ],
    );
  }
}
