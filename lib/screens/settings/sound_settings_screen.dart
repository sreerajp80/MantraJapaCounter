import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mantra_japa_counter/theme/theme.dart';
import 'package:mantra_japa_counter/l10n/app_localizations.dart';
import 'package:mantra_japa_counter/providers/app_providers.dart';
import 'package:mantra_japa_counter/providers/settings_provider.dart';
import 'package:mantra_japa_counter/models/mala_sound.dart';
import 'package:mantra_japa_counter/widgets/temple_decorations.dart';
import 'package:mantra_japa_counter/screens/settings/settings_tiles.dart';
import 'package:mantra_japa_counter/screens/settings/mala_sound_picker.dart';
import 'package:mantra_japa_counter/screens/settings/notification_sound_picker.dart';

/// Dedicated Sound & Haptics settings screen.
class SoundSettingsScreen extends ConsumerWidget {
  const SoundSettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final settings = ref.watch(settingsNotifierProvider);
    final notifier = ref.read(settingsNotifierProvider.notifier);
    final soundService = ref.read(soundServiceProvider);

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
                  // Mala Section
                  SettingsSection(
                    title: l.sectionMala,
                    sub: l.sectionMalaSub,
                    iconBuilder: (s, c) => TempleLotusIcon(size: s, color: c),
                    children: [
                      SettingsRow(
                        leading: const Icon(
                          Icons.music_note_outlined,
                          size: 16,
                          color: TempleColors.ink2,
                        ),
                        title: l.enableMalaSound,
                        sub: l.enableMalaSoundSub,
                        toggle: settings.malaNotificationsEnabled,
                        onToggle: notifier.setMalaNotificationsEnabled,
                      ),
                      SettingsRow(
                        leading: const Icon(
                          Icons.album_outlined,
                          size: 16,
                          color: TempleColors.ink2,
                        ),
                        title: l.malaSoundTitle,
                        sub: _malaSoundSubtitle(l, settings.malaSound),
                        right: _malaSoundShortLabel(l, settings.malaSound),
                        onTap: () => showMalaSoundPicker(
                          context,
                          ref,
                          settings,
                          notifier,
                        ),
                      ),
                    ],
                  ),

                  // Daily Goal Section
                  SettingsSection(
                    title: l.sectionDailyGoal,
                    sub: l.sectionDailyGoalSub,
                    iconBuilder: (s, c) => TempleDiyaIcon(size: s, color: c),
                    children: [
                      SettingsRow(
                        leading: const Icon(
                          Icons.notifications_outlined,
                          size: 16,
                          color: TempleColors.ink2,
                        ),
                        title: l.enableNotification,
                        sub: l.enableNotificationSub,
                        toggle: settings.dailyGoalNotificationsEnabled,
                        onToggle: notifier.setDailyGoalNotificationsEnabled,
                      ),
                      SettingsRow(
                        leading: const Icon(
                          Icons.volume_up_outlined,
                          size: 16,
                          color: TempleColors.ink2,
                        ),
                        title: l.notificationSound,
                        sub: _soundSubtitle(
                          l,
                          settings.notificationSoundUri,
                          settings.notificationSoundName,
                        ),
                        onTap: () => showNotificationSoundPicker(
                          context,
                          ref,
                          settings,
                          notifier,
                        ),
                      ),
                      SettingsRow(
                        leading: const Icon(
                          Icons.play_arrow_outlined,
                          size: 16,
                          color: TempleColors.ink2,
                        ),
                        title: l.previewTone,
                        sub: l.previewToneSub,
                        right: l.play,
                        onTap: () => soundService.playTone(
                          settings.notificationSoundUri,
                        ),
                      ),
                    ],
                  ),

                  // Lifetime Achievement Section
                  SettingsSection(
                    title: l.lifetimeGoalCaps,
                    sub: l.lifetimeSoundSub,
                    iconBuilder: (s, c) =>
                        Icon(Icons.emoji_events_outlined, size: s, color: c),
                    children: [
                      SettingsRow(
                        leading: const Icon(
                          Icons.stars_outlined,
                          size: 16,
                          color: TempleColors.ink2,
                        ),
                        title: l.enableLifetimeNotification,
                        sub: l.enableLifetimeNotificationSub,
                        toggle: settings.lifetimeGoalNotificationsEnabled,
                        onToggle: notifier.setLifetimeGoalNotificationsEnabled,
                      ),
                      SettingsRow(
                        leading: const Icon(
                          Icons.celebration_outlined,
                          size: 16,
                          color: TempleColors.ink2,
                        ),
                        title: l.lifetimeSoundTitle,
                        sub: _soundSubtitle(
                          l,
                          settings.lifetimeSoundUri,
                          settings.lifetimeSoundName,
                        ),
                        onTap: () => showLifetimeSoundPicker(
                          context,
                          ref,
                          settings,
                          notifier,
                        ),
                      ),
                      SettingsRow(
                        leading: const Icon(
                          Icons.play_arrow_outlined,
                          size: 16,
                          color: TempleColors.ink2,
                        ),
                        title: l.previewTone,
                        sub: l.previewToneSub,
                        right: l.play,
                        onTap: () =>
                            soundService.playTone(settings.lifetimeSoundUri),
                      ),
                    ],
                  ),

                  // Haptics Section
                  SettingsSection(
                    title: l.vibration,
                    sub: l.vibrationSub,
                    iconBuilder: (s, c) =>
                        Icon(Icons.vibration, size: s, color: c),
                    children: [
                      SettingsRow(
                        leading: const Icon(
                          Icons.touch_app_outlined,
                          size: 16,
                          color: TempleColors.ink2,
                        ),
                        title: l.vibration,
                        sub: l.permVibrationDesc,
                        toggle: settings.vibrationEnabled,
                        onToggle: notifier.setVibrationEnabled,
                      ),
                    ],
                  ),

                  // Do Not Disturb Section
                  SettingsSection(
                    title: l.dndTitle,
                    sub: l.dndSub,
                    iconBuilder: (s, c) => Icon(
                      Icons.do_not_disturb_on_outlined,
                      size: s,
                      color: c,
                    ),
                    children: [
                      SettingsRow(
                        leading: const Icon(
                          Icons.do_not_disturb_on_outlined,
                          size: 16,
                          color: TempleColors.ink2,
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
                  l.settingsSoundTitle,
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

  String _soundSubtitle(AppLocalizations l, String? uri, String? name) {
    if (uri == null) return l.soundSystemDefaultTapToChange;
    if (uri == 'sacred:temple_bell') return l.soundTempleBell;
    if (uri == 'sacred:singing_bowl') return l.soundSingingBowl;
    if (uri == 'sacred:shankha') return l.soundSacredShankha;
    if (uri == 'sacred:synthesized_tone') return l.soundSynthesizedTone;
    if (name != null && name.isNotEmpty) return l.soundNamedTapToChange(name);
    return l.soundCustomTapToChange;
  }

  String _malaSoundShortLabel(AppLocalizations l, MalaSound sound) {
    switch (sound) {
      case MalaSound.templeBell:
        return l.soundTempleBell;
      case MalaSound.singingBowl:
        return l.soundSingingBowl;
      case MalaSound.synthesizedTone:
        return l.soundSynthesizedTone;
    }
  }

  String _malaSoundSubtitle(AppLocalizations l, MalaSound sound) {
    switch (sound) {
      case MalaSound.templeBell:
        return l.soundTempleBellSub;
      case MalaSound.singingBowl:
        return l.soundSingingBowlSub;
      case MalaSound.synthesizedTone:
        return l.soundSynthesizedToneSub;
    }
  }
}
