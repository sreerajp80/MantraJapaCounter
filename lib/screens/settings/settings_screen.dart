import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mantra_japa_counter/theme/theme.dart';
import 'package:mantra_japa_counter/l10n/app_localizations.dart';
import 'package:mantra_japa_counter/providers/settings_provider.dart';
import 'package:mantra_japa_counter/widgets/temple_decorations.dart';
import 'package:mantra_japa_counter/screens/settings/settings_tiles.dart';
import 'package:mantra_japa_counter/screens/settings/settings_info_cards.dart';

/// App settings hub — Temple variation. Every setting is presented as a
/// card that navigates to its dedicated sub-settings screen.
class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final settings = ref.watch(settingsNotifierProvider);

    return Scaffold(
      backgroundColor: TempleColors.bg,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _topBar(context, l),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(18, 12, 18, 28),
                children: [
                  // Appearance Card
                  SettingsCard(
                    icon: Icons.palette_outlined,
                    title: l.settingsAppearanceTitle,
                    subtitle: l.settingsAppearanceSub,
                    onTap: () => context.push('/settings/appearance'),
                  ),
                  const SizedBox(height: 10),

                  // Sound & Haptics Card
                  SettingsCard(
                    icon: Icons.volume_up_outlined,
                    title: l.settingsSoundTitle,
                    subtitle: l.settingsSoundSub,
                    onTap: () => context.push('/settings/sound'),
                  ),
                  const SizedBox(height: 10),

                  // Display & Stillness Card
                  SettingsCard(
                    icon: Icons.brightness_medium_outlined,
                    title: l.settingsDisplayTitle,
                    subtitle: l.settingsDisplaySub,
                    onTap: () => context.push('/settings/display'),
                  ),
                  const SizedBox(height: 10),

                  // Language Card
                  SettingsCard(
                    icon: Icons.translate_outlined,
                    title: l.settingsLanguageTitle,
                    subtitle: _languageSubtitle(l, settings.languageCode),
                    onTap: () => context.push('/settings/language'),
                  ),
                  const SizedBox(height: 10),

                  // Backup & Restore Card
                  SettingsCard(
                    icon: Icons.backup_outlined,
                    title: l.settingsBackupTitle,
                    subtitle: l.settingsBackupSub,
                    onTap: () => context.push('/settings/backup'),
                  ),
                  const SizedBox(height: 10),

                  // Features Card
                  SettingsCard(
                    icon: Icons.stars_outlined,
                    title: l.settingsFeaturesTitle,
                    subtitle: l.settingsFeaturesSub,
                    onTap: () => context.push('/settings/features'),
                  ),
                  const SizedBox(height: 10),

                  // Permissions Card
                  SettingsCard(
                    icon: Icons.shield_outlined,
                    title: l.settingsPermissionsTitle,
                    subtitle: l.settingsPermissionsSub,
                    onTap: () => context.push('/settings/permissions'),
                  ),
                  const SizedBox(height: 10),

                  // Help & Tutorial Card
                  SettingsCard(
                    icon: Icons.help_outline,
                    title: l.settingsHelpTitle,
                    subtitle: l.settingsHelpSub,
                    onTap: () => context.push('/help'),
                  ),
                  const SizedBox(height: 10),

                  // About Card
                  SettingsCard(
                    icon: Icons.info_outline,
                    title: l.aboutTitle,
                    subtitle: l.settingsAboutSub,
                    onTap: () => context.push('/about'),
                  ),
                  const SizedBox(height: 16),

                  // Guidance Card
                  const SettingsGuidanceCard(),
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
}
