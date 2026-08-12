import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../config/theme.dart';
import '../l10n/app_localizations.dart';
import '../providers/app_providers.dart';
import '../providers/counters_provider.dart';
import '../providers/settings_provider.dart';
import '../widgets/temple_decorations.dart';

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
                  _Section(
                    title: l.sectionDailyGoal,
                    sub: l.sectionDailyGoalSub,
                    iconBuilder: (s, c) =>
                        TempleDiyaIcon(size: s, color: c),
                    children: [
                      _SettingsRow(
                        leading: const Icon(Icons.notifications_outlined,
                            size: 15, color: TempleColors.ink2),
                        title: l.enableNotification,
                        sub: l.enableNotificationSub,
                        toggle: settings.dailyGoalNotificationsEnabled,
                        onToggle:
                            notifier.setDailyGoalNotificationsEnabled,
                      ),
                      _SettingsRow(
                        leading: const Icon(Icons.vibration,
                            size: 15, color: TempleColors.ink2),
                        title: l.vibration,
                        sub: l.vibrationSub,
                        toggle: settings.vibrationEnabled,
                        onToggle: notifier.setVibrationEnabled,
                      ),
                      _SettingsRow(
                        leading: const Icon(Icons.volume_up_outlined,
                            size: 15, color: TempleColors.ink2),
                        title: l.notificationSound,
                        sub: _notificationSoundSubtitle(l, settings),
                        onTap: () => _showNotificationSoundPicker(
                            context, ref, settings, notifier),
                      ),
                      _SettingsRow(
                        leading: const Icon(Icons.play_arrow_outlined,
                            size: 15, color: TempleColors.ink2),
                        title: l.previewTone,
                        sub: l.previewToneSub,
                        right: l.play,
                        onTap: () => ref
                            .read(soundServiceProvider)
                            .playTone(settings.notificationSoundUri),
                      ),
                    ],
                  ),
                  _Section(
                    title: l.sectionMala,
                    sub: l.sectionMalaSub,
                    iconBuilder: (s, c) =>
                        TempleLotusIcon(size: s, color: c),
                    children: [
                      _SettingsRow(
                        leading: const Icon(Icons.access_time,
                            size: 15, color: TempleColors.ink2),
                        title: l.enableMalaSound,
                        sub: l.enableMalaSoundSub,
                        toggle: settings.malaNotificationsEnabled,
                        onToggle: notifier.setMalaNotificationsEnabled,
                      ),
                    ],
                  ),
                  _Section(
                    title: l.sectionStillness,
                    sub: l.sectionStillnessSub,
                    iconBuilder: (s, c) => Icon(
                      Icons.brightness_5_outlined,
                      size: s,
                      color: c,
                    ),
                    children: [
                      _BrightnessRow(
                        value: settings.screenBrightness < 0
                            ? 0.5
                            : settings.screenBrightness,
                        usingSystem: settings.screenBrightness < 0,
                        onChanged: notifier.setScreenBrightness,
                        onReset: () => notifier.setScreenBrightness(-1.0),
                      ),
                    ],
                  ),
                  _Section(
                    title: 'Data Backup & Optical Sync',
                    sub: '100% offline device-to-device sync and backup',
                    iconBuilder: (s, c) => Icon(
                      Icons.sync,
                      size: s,
                      color: c,
                    ),
                    children: [
                      _SettingsRow(
                        leading: const Icon(Icons.qr_code_2_outlined,
                            size: 15, color: TempleColors.ink2),
                        title: 'Optical Air-Gap Sync (Send)',
                        sub: 'Transmit counters & history via animated QR stream',
                        onTap: () => context.push('/backup/optical-sync/transmit'),
                      ),
                      _SettingsRow(
                        leading: const Icon(Icons.qr_code_scanner_outlined,
                            size: 15, color: TempleColors.ink2),
                        title: 'Optical Air-Gap Sync (Receive)',
                        sub: 'Scan animated QR stream from another phone camera',
                        onTap: () => context.push('/backup/optical-sync/receive'),
                      ),
                      _SettingsRow(
                        leading: const Icon(Icons.upload_file_outlined,
                            size: 15, color: TempleColors.ink2),
                        title: 'Export Backup File (JSON)',
                        sub: 'Export all data to a local JSON file & share sheet',
                        onTap: () async {
                          try {
                            await ref.read(exportServiceProvider).exportAndShare();
                          } catch (e) {
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Export failed: $e')),
                              );
                            }
                          }
                        },
                      ),
                      _SettingsRow(
                        leading: const Icon(Icons.download_for_offline_outlined,
                            size: 15, color: TempleColors.ink2),
                        title: 'Import Backup File (JSON)',
                        sub: 'Restore counters and history from a backup file',
                        onTap: () async {
                          try {
                            final result = await FilePicker.pickFiles(
                              type: FileType.custom,
                              allowedExtensions: ['json'],
                            );
                            final pickedPath = result?.files.single.path;
                            if (pickedPath != null) {
                              final jsonString = await File(pickedPath).readAsString();
                              await ref.read(exportServiceProvider).importFromJson(jsonString);
                              ref.invalidate(countersNotifierProvider);
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Data restored successfully!'),
                                    backgroundColor: TempleColors.tulsi,
                                  ),
                                );
                              }
                            }
                          } catch (e) {
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Import failed: $e')),
                              );
                            }
                          }
                        },
                      ),
                    ],
                  ),
                  _Section(
                    title: l.sectionPracticeGuide,
                    sub: l.sectionPracticeGuideSub,
                    iconBuilder: (s, c) => Icon(
                      Icons.menu_book_outlined,
                      size: s,
                      color: c,
                    ),
                    children: [
                      _SettingsRow(
                        leading: const Icon(Icons.swipe_outlined,
                            size: 15, color: TempleColors.ink2),
                        title: l.howItWorks,
                        sub: l.howItWorksSub,
                        onTap: () => context.push('/help'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),
                  _GuidanceCard(),
                  const SizedBox(height: 18),
                  _DangerCard(
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
            child: const Icon(Icons.arrow_back,
                size: 18, color: TempleColors.ink),
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
                  l.settingsTitle,
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

  Future<void> _showNotificationSoundPicker(
    BuildContext context,
    WidgetRef ref,
    AppSettings settings,
    SettingsNotifier notifier,
  ) async {
    final l = AppLocalizations.of(context);
    final soundService = ref.read(soundServiceProvider);
    final ringtones = await soundService.listNotificationRingtones();
    if (!context.mounted) return;

    await showModalBottomSheet<void>(
      context: context,
      backgroundColor: TempleColors.bg,
      showDragHandle: true,
      isScrollControlled: true,
      builder: (sheetContext) {
        final selectedUri = settings.notificationSoundUri;
        return SafeArea(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(sheetContext).size.height * 0.75,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 4, 20, 12),
                  child: Text(
                    l.notificationSound,
                    style: AppTheme.serif(
                      fontSize: 20,
                      color: TempleColors.ink,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Flexible(
                  child: ListView(
                    padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
                    children: [
                      _RingtoneTile(
                        title: l.soundSystemDefault,
                        selected: selectedUri == null,
                        onTap: () async {
                          await notifier.setNotificationSound(null, null);
                          await soundService.playTone(null);
                          if (sheetContext.mounted) {
                            Navigator.pop(sheetContext);
                          }
                        },
                      ),
                      for (final r in ringtones)
                        _RingtoneTile(
                          title: r.title,
                          selected: selectedUri == r.uri,
                          onTap: () async {
                            await notifier.setNotificationSound(
                                r.uri, r.title);
                            await soundService.playTone(r.uri);
                            if (sheetContext.mounted) {
                              Navigator.pop(sheetContext);
                            }
                          },
                        ),
                      const Divider(
                          height: 16, color: TempleColors.line),
                      _RingtoneTile(
                        title: l.browseAudioFile,
                        leading: const Icon(
                          Icons.folder_open_outlined,
                          size: 20,
                          color: TempleColors.vermillion,
                        ),
                        onTap: () async {
                          Navigator.pop(sheetContext);
                          await _browseAudioFile(context, notifier);
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _browseAudioFile(
      BuildContext context, SettingsNotifier notifier) async {
    final result = await FilePicker.pickFiles(type: FileType.audio);
    final picked = result?.files.single;
    if (picked?.path != null) {
      await notifier.setNotificationSound(picked!.path!, picked.name);
    }
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
              child: Text(l.cancel)),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              final repo = ref.read(japaCounterRepositoryProvider);
              await repo.deleteAllSessions();
              await repo.deleteAllCounters();
              ref.invalidate(countersNotifierProvider);
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(l.allDataCleared)),
                );
              }
            },
            child: Text(l.clearAllButton,
                style: const TextStyle(color: TempleColors.vermillionDeep)),
          ),
        ],
      ),
    );
  }
}

// ─── Section card ────────────────────────────────────────────────────────────

class _Section extends StatelessWidget {
  final String title;
  final String sub;
  final Widget Function(double size, Color color) iconBuilder;
  final List<Widget> children;

  const _Section({
    required this.title,
    required this.sub,
    required this.iconBuilder,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(4, 8, 4, 12),
            child: Row(
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: TempleColors.cardSoft,
                    border: Border.fromBorderSide(
                        BorderSide(color: TempleColors.line)),
                  ),
                  child: Center(
                    child: iconBuilder(16, TempleColors.vermillion),
                  ),
                ),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: AppTheme.serif(
                        fontSize: 18,
                        color: TempleColors.ink,
                        fontWeight: FontWeight.w500,
                        height: 1,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      sub,
                      style: AppTheme.sans(
                        fontSize: 12.5,
                        color: TempleColors.ink2,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 0.3,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: TempleColors.card,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: TempleColors.line),
            ),
            clipBehavior: Clip.antiAlias,
            child: Column(children: _interleavedChildren()),
          ),
        ],
      ),
    );
  }

  List<Widget> _interleavedChildren() {
    final out = <Widget>[];
    for (var i = 0; i < children.length; i++) {
      out.add(children[i]);
      if (i < children.length - 1) {
        out.add(const Divider(height: 1, color: TempleColors.line));
      }
    }
    return out;
  }
}

// ─── Settings row ────────────────────────────────────────────────────────────

class _SettingsRow extends StatelessWidget {
  final Widget leading;
  final String title;
  final String? sub;
  final String? right;
  final bool? toggle;
  final ValueChanged<bool>? onToggle;
  final VoidCallback? onTap;

  const _SettingsRow({
    required this.leading,
    required this.title,
    this.sub,
    this.right,
    this.toggle,
    this.onToggle,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: toggle != null && onToggle != null
          ? () => onToggle!(!toggle!)
          : onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
        child: Row(
          children: [
            Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                color: TempleColors.cardSoft,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(child: leading),
            ),
            const SizedBox(width: 12),
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
                  if (sub != null) ...[
                    const SizedBox(height: 3),
                    Text(
                      sub!,
                      style: AppTheme.sans(
                        fontSize: 13,
                        color: TempleColors.ink2,
                        fontWeight: FontWeight.w400,
                        height: 1.35,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            if (right != null)
              Text(
                right!,
                style: AppTheme.serif(
                  fontSize: 13,
                  color: TempleColors.vermillion,
                  fontWeight: FontWeight.w500,
                ),
              )
            else if (toggle != null)
              _Pill(value: toggle!)
            else
              const Icon(Icons.chevron_right,
                  size: 16, color: TempleColors.ink3),
          ],
        ),
      ),
    );
  }
}

class _Pill extends StatelessWidget {
  final bool value;
  const _Pill({required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 22,
      decoration: BoxDecoration(
        color: value ? TempleColors.vermillion : TempleColors.line,
        borderRadius: BorderRadius.circular(11),
      ),
      child: AnimatedAlign(
        duration: const Duration(milliseconds: 160),
        alignment: value ? Alignment.centerRight : Alignment.centerLeft,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 2),
          child: Container(
            width: 18,
            height: 18,
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
          ),
        ),
      ),
    );
  }
}

// ─── Brightness row ──────────────────────────────────────────────────────────

class _BrightnessRow extends StatelessWidget {
  final double value;
  final bool usingSystem;
  final ValueChanged<double> onChanged;
  final VoidCallback onReset;

  const _BrightnessRow({
    required this.value,
    required this.usingSystem,
    required this.onChanged,
    required this.onReset,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
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
                      AppLocalizations.of(context).brightnessLevel,
                      style: AppTheme.sans(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: TempleColors.ink,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      usingSystem
                          ? AppLocalizations.of(context).followingSystem
                          : AppLocalizations.of(context).overrideActive,
                      style: AppTheme.sans(
                        fontSize: 13,
                        color: TempleColors.ink2,
                        fontWeight: FontWeight.w400,
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
                      fontSize: 22,
                      color: TempleColors.vermillion,
                      fontWeight: FontWeight.w500,
                      height: 1,
                    ),
                  ),
                  Text(
                    '%',
                    style: AppTheme.sans(
                      fontSize: 12,
                      color: TempleColors.ink3,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 10),
          Slider(value: value.clamp(0.0, 1.0), onChanged: onChanged),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(AppLocalizations.of(context).brightnessStill,
                    style: AppTheme.serif(
                      fontSize: 10,
                      color: TempleColors.ink3,
                      fontWeight: FontWeight.w400,
                    )),
                TextButton(
                  onPressed: onReset,
                  style: TextButton.styleFrom(
                    visualDensity: VisualDensity.compact,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 6, vertical: 0),
                    minimumSize: Size.zero,
                  ),
                  child: Text(
                    AppLocalizations.of(context).brightnessUseSystem,
                    style: AppTheme.sans(
                      fontSize: 11,
                      color: TempleColors.vermillion,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Text(AppLocalizations.of(context).brightnessFull,
                    style: AppTheme.serif(
                      fontSize: 10,
                      color: TempleColors.ink3,
                      fontWeight: FontWeight.w400,
                    )),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Guidance + danger cards ────────────────────────────────────────────────

class _GuidanceCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: TempleColors.cardSoft,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: TempleColors.line),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const TempleDiyaIcon(size: 20, color: TempleColors.vermillion),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              AppLocalizations.of(context).settingsGuidanceBody,
              style: AppTheme.sans(
                fontSize: 13.5,
                color: TempleColors.ink,
                fontWeight: FontWeight.w400,
                height: 1.55,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DangerCard extends StatelessWidget {
  final VoidCallback onTap;
  const _DangerCard({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: TempleColors.card,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: const BorderSide(color: TempleColors.line),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              const Icon(Icons.delete_outline,
                  color: TempleColors.vermillionDeep, size: 22),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppLocalizations.of(context).clearAllData,
                      style: AppTheme.sans(
                        fontSize: 15,
                        color: TempleColors.vermillionDeep,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      AppLocalizations.of(context).clearAllDataSub,
                      style: AppTheme.sans(
                        fontSize: 13,
                        color: TempleColors.ink2,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Ringtone picker tile ────────────────────────────────────────────────────

class _RingtoneTile extends StatelessWidget {
  final String title;
  final bool selected;
  final Widget? leading;
  final VoidCallback onTap;

  const _RingtoneTile({
    required this.title,
    required this.onTap,
    this.selected = false,
    this.leading,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        child: Row(
          children: [
            SizedBox(
              width: 28,
              child: leading ??
                  Icon(
                    selected
                        ? Icons.radio_button_checked
                        : Icons.radio_button_unchecked,
                    size: 20,
                    color: selected
                        ? TempleColors.vermillion
                        : TempleColors.ink3,
                  ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                title,
                style: AppTheme.sans(
                  fontSize: 15,
                  fontWeight:
                      selected ? FontWeight.w600 : FontWeight.w500,
                  color: TempleColors.ink,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
