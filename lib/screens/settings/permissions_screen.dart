import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mantra_japa_counter/theme/theme.dart';
import 'package:mantra_japa_counter/l10n/app_localizations.dart';
import 'package:mantra_japa_counter/widgets/temple_decorations.dart';

/// Screen detailing all implicit, explicit, and prohibited permissions.
class PermissionsScreen extends StatelessWidget {
  const PermissionsScreen({super.key});

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
                  // Overview Header Card
                  _headerCard(l),
                  const SizedBox(height: 20),

                  // Explicit Permissions Section
                  _sectionHeader(
                    title: l.permissionsExplicitHeader,
                    subtitle: l.permissionsExplicitSub,
                    icon: Icons.touch_app_outlined,
                  ),
                  const SizedBox(height: 8),
                  _buildCategoryCard([
                    _PermissionTile(
                      icon: Icons.camera_alt_outlined,
                      title: l.permCameraTitle,
                      tag: 'Explicit / Runtime',
                      tagColor: TempleColors.vermillion,
                      description: l.permCameraDesc,
                    ),
                    _PermissionTile(
                      icon: Icons.notifications_active_outlined,
                      title: l.permNotificationTitle,
                      tag: 'Explicit / Runtime (Android 13+)',
                      tagColor: TempleColors.vermillion,
                      description: l.permNotificationDesc,
                    ),
                    _PermissionTile(
                      icon: Icons.do_not_disturb_on_outlined,
                      title: l.dndTitle,
                      tag: 'Explicit / Special Access',
                      tagColor: TempleColors.vermillion,
                      description: l.dndSub,
                    ),
                  ]),
                  const SizedBox(height: 22),

                  // Implicit Permissions Section
                  _sectionHeader(
                    title: l.permissionsImplicitHeader,
                    subtitle: l.permissionsImplicitSub,
                    icon: Icons.check_circle_outline,
                  ),
                  const SizedBox(height: 8),
                  _buildCategoryCard([
                    _PermissionTile(
                      icon: Icons.vibration,
                      title: l.permVibrationTitle,
                      tag: 'Implicit / Install-Time',
                      tagColor: TempleColors.tulsi,
                      description: l.permVibrationDesc,
                    ),
                    _PermissionTile(
                      icon: Icons.volume_up_outlined,
                      title: l.permAudioTitle,
                      tag: 'Implicit / Normal',
                      tagColor: TempleColors.tulsi,
                      description: l.permAudioDesc,
                    ),
                  ]),
                  const SizedBox(height: 22),

                  // Zero-Trust Excluded Permissions Section
                  _sectionHeader(
                    title: l.permissionsPrivacyHeader,
                    subtitle: l.permissionsPrivacySub,
                    icon: Icons.shield_outlined,
                  ),
                  const SizedBox(height: 8),
                  _buildCategoryCard([
                    _PermissionTile(
                      icon: Icons.wifi_off_outlined,
                      title: l.permNoInternetTitle,
                      tag: 'Zero-Trust / No Access',
                      tagColor: TempleColors.sandal,
                      description: l.permNoInternetDesc,
                    ),
                    _PermissionTile(
                      icon: Icons.folder_off_outlined,
                      title: l.permNoStorageTitle,
                      tag: 'Zero-Trust / No Access',
                      tagColor: TempleColors.sandal,
                      description: l.permNoStorageDesc,
                    ),
                  ]),
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
                  l.settingsPermissionsTitle,
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

  Widget _headerCard(AppLocalizations l) {
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
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: TempleColors.vermillion.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Center(
              child: Icon(
                Icons.security_outlined,
                color: TempleColors.vermillion,
                size: 28,
              ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l.settingsPermissionsTitle,
                  style: AppTheme.serif(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  l.settingsPermissionsSub,
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

  Widget _sectionHeader({
    required String title,
    required String subtitle,
    required IconData icon,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 16, color: TempleColors.vermillion),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
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
            subtitle,
            style: AppTheme.sans(fontSize: 12, color: TempleColors.ink2),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryCard(List<_PermissionTile> tiles) {
    return Container(
      decoration: BoxDecoration(
        color: TempleColors.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: TempleColors.line),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          for (var i = 0; i < tiles.length; i++) ...[
            tiles[i],
            if (i < tiles.length - 1)
              const Divider(height: 1, color: TempleColors.line),
          ],
        ],
      ),
    );
  }
}

class _PermissionTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String tag;
  final Color tagColor;
  final String description;

  const _PermissionTile({
    required this.icon,
    required this.title,
    required this.tag,
    required this.tagColor,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: TempleColors.cardSoft,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: TempleColors.line),
            ),
            child: Center(
              child: Icon(icon, size: 20, color: TempleColors.vermillion),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: AppTheme.sans(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: tagColor.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        tag,
                        style: AppTheme.eyebrow(
                          color: tagColor,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  description,
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
    );
  }
}
