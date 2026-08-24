import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../config/theme.dart';
import '../../l10n/app_localizations.dart';
import '../../widgets/temple_decorations.dart';

/// Main Help hub reached from Settings -> Help.
class HelpHomeScreen extends StatelessWidget {
  const HelpHomeScreen({super.key});

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
                    title: l.helpHeaderTitle,
                    subtitle: l.helpHeaderSub,
                  ),
                  const SizedBox(height: 20),

                  _sectionHeader(
                    l.helpCategoryCounting,
                    Icons.touch_app_outlined,
                  ),
                  const SizedBox(height: 8),
                  _TopicCard(
                    icon: Icons.touch_app_outlined,
                    title: l.helpTopicCountingTitle,
                    subtitle: l.helpTopicCountingSub,
                    onTap: () => context.push('/help/counting'),
                  ),
                  const SizedBox(height: 10),
                  _TopicCard(
                    icon: Icons.lens_blur_outlined,
                    title: l.helpTopicMalaTitle,
                    subtitle: l.helpTopicMalaSub,
                    onTap: () => context.push('/help/mala'),
                  ),
                  const SizedBox(height: 22),

                  _sectionHeader(l.helpCategorySync, Icons.sync_outlined),
                  const SizedBox(height: 8),
                  _TopicCard(
                    icon: Icons.qr_code_2_outlined,
                    title: l.helpTopicOpticalSyncTitle,
                    subtitle: l.helpTopicOpticalSyncSub,
                    onTap: () => context.push('/help/optical-sync'),
                  ),
                  const SizedBox(height: 10),
                  _TopicCard(
                    icon: Icons.backup_outlined,
                    title: l.helpTopicBackupTitle,
                    subtitle: l.helpTopicBackupSub,
                    onTap: () => context.push('/help/backup'),
                  ),
                  const SizedBox(height: 22),

                  _sectionHeader(
                    l.helpCategoryAudio,
                    Icons.notifications_active_outlined,
                  ),
                  const SizedBox(height: 8),
                  _TopicCard(
                    icon: Icons.volume_up_outlined,
                    title: l.helpTopicAudioTitle,
                    subtitle: l.helpTopicAudioSub,
                    onTap: () => context.push('/help/sound-haptics'),
                  ),
                  const SizedBox(height: 22),

                  _sectionHeader(
                    l.helpCategoryPrivacy,
                    Icons.security_outlined,
                  ),
                  const SizedBox(height: 8),
                  _TopicCard(
                    icon: Icons.shield_outlined,
                    title: l.helpTopicPrivacyTitle,
                    subtitle: l.helpTopicPrivacySub,
                    onTap: () => context.push('/help/privacy'),
                  ),
                  const SizedBox(height: 10),
                  _TopicCard(
                    icon: Icons.quiz_outlined,
                    title: l.helpTopicFaqTitle,
                    subtitle: l.helpTopicFaqSub,
                    onTap: () => context.push('/help/faqs'),
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
                    fontSize: 10,
                    letterSpacing: 3,
                    color: TempleColors.vermillion,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  l.helpTitle,
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
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: TempleColors.vermillion.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Center(
              child: Icon(
                Icons.help_outline_rounded,
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

class _TopicCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _TopicCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: TempleColors.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: TempleColors.line),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: TempleColors.cardSoft,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: TempleColors.line),
                ),
                child: Center(
                  child: Icon(icon, color: TempleColors.vermillion, size: 22),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: AppTheme.sans(
                        fontSize: 15,
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
              const Icon(
                Icons.chevron_right,
                color: TempleColors.ink3,
                size: 18,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
