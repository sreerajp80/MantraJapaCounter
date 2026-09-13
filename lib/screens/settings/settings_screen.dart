import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mantra_japa_counter/theme/theme.dart';
import 'package:mantra_japa_counter/l10n/app_localizations.dart';
import 'package:mantra_japa_counter/providers/app_providers.dart';
import 'package:mantra_japa_counter/providers/counters_provider.dart';
import 'package:mantra_japa_counter/providers/settings_provider.dart';
import 'package:mantra_japa_counter/widgets/temple_decorations.dart';
import 'package:mantra_japa_counter/screens/settings/notification_sound_picker.dart';
import 'package:mantra_japa_counter/screens/settings/language_picker.dart';
import 'package:mantra_japa_counter/screens/settings/settings_tiles.dart';
import 'package:mantra_japa_counter/screens/settings/settings_brightness_row.dart';
import 'package:mantra_japa_counter/screens/settings/settings_info_cards.dart';

/// App settings — Temple variation. Sectioned cards with a lotus icon header,
/// vermillion toggles, and a serif "still / full" brightness slider.
class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

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
                padding: const EdgeInsets.fromLTRB(18, 8, 18, 28),
                children: [
                  SettingsCard(
                    icon: Icons.palette_outlined,
                    title: l.settingsAppearanceTitle,
                    subtitle: l.settingsAppearanceSub,
                    onTap: () => context.push('/settings/appearance'),
                  ),
                  const SizedBox(height: 10),
                  SettingsCard(
                    icon: Icons.stars_outlined,
                    title: l.settingsFeaturesTitle,
                    subtitle: l.settingsFeaturesSub,
                    onTap: () => context.push('/settings/features'),
                  ),
                  const SizedBox(height: 10),
                  SettingsCard(
                    icon: Icons.help_outline,
                    title: l.settingsHelpTitle,
                    subtitle: l.settingsHelpSub,
                    onTap: () => context.push('/help'),
                  ),
                  const SizedBox(height: 10),
                  SettingsCard(
                    icon: Icons.info_outline,
                    title: l.aboutTitle,
                    subtitle: l.settingsAboutSub,
                    onTap: () => context.push('/about'),
                  ),
                  const SizedBox(height: 12),
                  SettingsSection(
                    title: l.sectionLanguage,
                    sub: l.sectionLanguageSub,
                    iconBuilder: (s, c) =>
                        Icon(Icons.language, size: s, color: c),
                    children: [
                      SettingsRow(
                        leading: const Icon(
                          Icons.translate,
                          size: 15,
                          color: TempleColors.ink2,
                        ),
                        title: l.appLanguage,
                        sub: _languageSubtitle(l, settings.languageCode),
                        right: _languageShortLabel(l, settings.languageCode),
                        onTap: () => showLanguagePicker(
                          context,
                          settings.languageCode,
                          notifier,
                        ),
                      ),
                    ],
                  ),
                  SettingsSection(
                    title: l.sectionDailyGoal,
                    sub: l.sectionDailyGoalSub,
                    iconBuilder: (s, c) => TempleDiyaIcon(size: s, color: c),
                    children: [
                      SettingsRow(
                        leading: const Icon(
                          Icons.notifications_outlined,
                          size: 15,
                          color: TempleColors.ink2,
                        ),
                        title: l.enableNotification,
                        sub: l.enableNotificationSub,
                        toggle: settings.dailyGoalNotificationsEnabled,
                        onToggle: notifier.setDailyGoalNotificationsEnabled,
                      ),
                      SettingsRow(
                        leading: const Icon(
                          Icons.vibration,
                          size: 15,
                          color: TempleColors.ink2,
                        ),
                        title: l.vibration,
                        sub: l.vibrationSub,
                        toggle: settings.vibrationEnabled,
                        onToggle: notifier.setVibrationEnabled,
                      ),
                      SettingsRow(
                        leading: const Icon(
                          Icons.volume_up_outlined,
                          size: 15,
                          color: TempleColors.ink2,
                        ),
                        title: l.notificationSound,
                        sub: _notificationSoundSubtitle(l, settings),
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
                          size: 15,
                          color: TempleColors.ink2,
                        ),
                        title: l.previewTone,
                        sub: l.previewToneSub,
                        right: l.play,
                        onTap: () => ref
                            .read(soundServiceProvider)
                            .playTone(settings.notificationSoundUri),
                      ),
                    ],
                  ),
                  SettingsSection(
                    title: l.sectionMala,
                    sub: l.sectionMalaSub,
                    iconBuilder: (s, c) => TempleLotusIcon(size: s, color: c),
                    children: [
                      SettingsRow(
                        leading: const Icon(
                          Icons.access_time,
                          size: 15,
                          color: TempleColors.ink2,
                        ),
                        title: l.enableMalaSound,
                        sub: l.enableMalaSoundSub,
                        toggle: settings.malaNotificationsEnabled,
                        onToggle: notifier.setMalaNotificationsEnabled,
                      ),
                    ],
                  ),
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
                    ],
                  ),
                  SettingsSection(
                    title: l.settingsBackupTitle,
                    sub: l.settingsBackupSub,
                    iconBuilder: (s, c) => Icon(Icons.sync, size: s, color: c),
                    children: [
                      SettingsRow(
                        leading: const Icon(
                          Icons.qr_code_2_outlined,
                          size: 15,
                          color: TempleColors.ink2,
                        ),
                        title: l.settingsOpticalSendTitle,
                        sub: l.settingsOpticalSendSub,
                        onTap: () =>
                            context.push('/backup/optical-sync/transmit'),
                      ),
                      SettingsRow(
                        leading: const Icon(
                          Icons.qr_code_scanner_outlined,
                          size: 15,
                          color: TempleColors.ink2,
                        ),
                        title: l.settingsOpticalReceiveTitle,
                        sub: l.settingsOpticalReceiveSub,
                        onTap: () =>
                            context.push('/backup/optical-sync/receive'),
                      ),
                      SettingsRow(
                        leading: const Icon(
                          Icons.upload_file_outlined,
                          size: 15,
                          color: TempleColors.ink2,
                        ),
                        title: l.settingsExportTitle,
                        sub: l.settingsExportSub,
                        onTap: () async {
                          try {
                            await ref
                                .read(exportServiceProvider)
                                .exportAndShare();
                          } catch (e) {
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(l.exportFailed('$e'))),
                              );
                            }
                          }
                        },
                      ),
                      SettingsRow(
                        leading: const Icon(
                          Icons.download_for_offline_outlined,
                          size: 15,
                          color: TempleColors.ink2,
                        ),
                        title: l.settingsImportTitle,
                        sub: l.settingsImportSub,
                        onTap: () async {
                          try {
                            final result = await FilePicker.pickFiles(
                              type: FileType.custom,
                              allowedExtensions: ['json'],
                            );
                            final pickedPath = result?.files.single.path;
                            if (pickedPath != null) {
                              final jsonString = await File(
                                pickedPath,
                              ).readAsString();
                              await ref
                                  .read(exportServiceProvider)
                                  .importFromJson(jsonString);
                              ref.invalidate(countersNotifierProvider);
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(l.dataRestoredSuccess),
                                    backgroundColor: TempleColors.tulsi,
                                  ),
                                );
                              }
                            }
                          } catch (e) {
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(l.importFailed('$e'))),
                              );
                            }
                          }
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),
                  const SettingsGuidanceCard(),
                  const SizedBox(height: 18),
                  SettingsDangerCard(
                    onTap: () => _confirmClearAll(context, ref),
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
                  l.settingsTitle,
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

  String _languageSubtitle(AppLocalizations l, String? code) {
    if (code == null || code == 'system') return l.systemDefault;
    if (code == 'en') return l.englishLanguage;
    if (code == 'ml') return l.malayalamLanguage;
    if (code == 'sa') return l.sanskritLanguage;
    return l.systemDefault;
  }

  String _languageShortLabel(AppLocalizations l, String? code) {
    if (code == 'en') return 'English';
    if (code == 'ml') return 'മലയാളം';
    if (code == 'sa') return 'संस्कृतम्';
    return l.systemDefault;
  }

  String _notificationSoundSubtitle(AppLocalizations l, AppSettings s) {
    if (s.notificationSoundUri == null) {
      return l.soundSystemDefaultTapToChange;
    }
    final name = s.notificationSoundName;
    if (name != null && name.isNotEmpty) {
      return l.soundNamedTapToChange(name);
    }
    return l.soundCustomTapToChange;
  }

  void _confirmClearAll(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(l.clearAllDataTitle),
        content: Text(l.clearAllDataMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l.cancel),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              final repo = ref.read(japaCounterRepositoryProvider);
              await repo.deleteAllSessions();
              await repo.deleteAllCounters();
              ref.invalidate(countersNotifierProvider);
              if (context.mounted) {
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text(l.allDataCleared)));
              }
            },
            child: Text(
              l.clearAllButton,
              style: const TextStyle(color: TempleColors.vermillionDeep),
            ),
          ),
        ],
      ),
    );
  }
}
