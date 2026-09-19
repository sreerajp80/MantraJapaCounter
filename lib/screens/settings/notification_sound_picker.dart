import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mantra_japa_counter/theme/theme.dart';
import 'package:mantra_japa_counter/l10n/app_localizations.dart';
import 'package:mantra_japa_counter/providers/app_providers.dart';
import 'package:mantra_japa_counter/providers/settings_provider.dart';

/// One sacred audio tone choice available within the sound picker.
class _SacredToneOption {
  final String uri;
  final String title;
  final String subtitle;
  const _SacredToneOption({
    required this.uri,
    required this.title,
    required this.subtitle,
  });
}

/// Generic bottom sheet for choosing custom completion chimes: system
/// default, sacred temple sounds, device ringtones, or an audio file from storage.
Future<void> showCustomSoundPicker({
  required BuildContext context,
  required WidgetRef ref,
  required String title,
  required String? selectedUri,
  required Future<void> Function(String? uri, String? name) onSelect,
}) async {
  final l = AppLocalizations.of(context);
  final soundService = ref.read(soundServiceProvider);
  final ringtones = await soundService.listNotificationRingtones();
  if (!context.mounted) return;

  final sacredTones = [
    _SacredToneOption(
      uri: 'sacred:temple_bell',
      title: l.soundTempleBell,
      subtitle: l.soundTempleBellSub,
    ),
    _SacredToneOption(
      uri: 'sacred:singing_bowl',
      title: l.soundSingingBowl,
      subtitle: l.soundSingingBowlSub,
    ),
    _SacredToneOption(
      uri: 'sacred:shankha',
      title: l.soundSacredShankha,
      subtitle: l.soundSacredShankhaSub,
    ),
    _SacredToneOption(
      uri: 'sacred:synthesized_tone',
      title: l.soundSynthesizedTone,
      subtitle: l.soundSynthesizedToneSub,
    ),
  ];

  await showModalBottomSheet<void>(
    context: context,
    backgroundColor: TempleColors.bg,
    showDragHandle: true,
    isScrollControlled: true,
    builder: (sheetContext) {
      return SafeArea(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(sheetContext).size.height * 0.80,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 4, 20, 12),
                child: Text(title, style: AppTheme.serif(fontSize: 20)),
              ),
              Flexible(
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(8, 0, 8, 16),
                  children: [
                    // System Default
                    _RingtoneTile(
                      title: l.soundSystemDefault,
                      subtitle: l.soundSystemDefaultTapToChange,
                      selected: selectedUri == null,
                      onPreview: () => soundService.playTone(null),
                      onTap: () async {
                        await onSelect(null, null);
                        await soundService.playTone(null);
                        if (sheetContext.mounted) {
                          Navigator.pop(sheetContext);
                        }
                      },
                    ),

                    const Divider(height: 20, color: TempleColors.line),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 4,
                      ),
                      child: Text(
                        l.practiceEyebrow,
                        style: AppTheme.eyebrow(
                          letterSpacing: 2,
                          color: TempleColors.vermillion,
                        ),
                      ),
                    ),

                    // Sacred Chimes
                    for (final s in sacredTones)
                      _RingtoneTile(
                        title: s.title,
                        subtitle: s.subtitle,
                        selected: selectedUri == s.uri,
                        onPreview: () => soundService.playTone(s.uri),
                        onTap: () async {
                          await onSelect(s.uri, s.title);
                          await soundService.playTone(s.uri);
                          if (sheetContext.mounted) {
                            Navigator.pop(sheetContext);
                          }
                        },
                      ),

                    if (ringtones.isNotEmpty) ...[
                      const Divider(height: 20, color: TempleColors.line),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 4,
                        ),
                        child: Text(
                          l.notificationSound,
                          style: AppTheme.eyebrow(
                            letterSpacing: 2,
                            color: TempleColors.ink2,
                          ),
                        ),
                      ),
                      for (final r in ringtones)
                        _RingtoneTile(
                          title: r.title,
                          selected: selectedUri == r.uri,
                          onPreview: () => soundService.playTone(r.uri),
                          onTap: () async {
                            await onSelect(r.uri, r.title);
                            await soundService.playTone(r.uri);
                            if (sheetContext.mounted) {
                              Navigator.pop(sheetContext);
                            }
                          },
                        ),
                    ],

                    const Divider(height: 20, color: TempleColors.line),
                    // File Picker
                    _RingtoneTile(
                      title: l.browseAudioFile,
                      leading: const Icon(
                        Icons.folder_open_outlined,
                        size: 20,
                        color: TempleColors.vermillion,
                      ),
                      onTap: () async {
                        Navigator.pop(sheetContext);
                        await _browseAudioFile(context, onSelect);
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

/// Convenience wrapper preserving backwards compatibility for daily goal picker.
Future<void> showNotificationSoundPicker(
  BuildContext context,
  WidgetRef ref,
  AppSettings settings,
  SettingsNotifier notifier,
) async {
  final l = AppLocalizations.of(context);
  await showCustomSoundPicker(
    context: context,
    ref: ref,
    title: l.notificationSound,
    selectedUri: settings.notificationSoundUri,
    onSelect: notifier.setNotificationSound,
  );
}

/// Convenience wrapper for lifetime goal achievement picker.
Future<void> showLifetimeSoundPicker(
  BuildContext context,
  WidgetRef ref,
  AppSettings settings,
  SettingsNotifier notifier,
) async {
  final l = AppLocalizations.of(context);
  await showCustomSoundPicker(
    context: context,
    ref: ref,
    title: l.lifetimeSoundTitle,
    selectedUri: settings.lifetimeSoundUri,
    onSelect: notifier.setLifetimeSound,
  );
}

Future<void> _browseAudioFile(
  BuildContext context,
  Future<void> Function(String? uri, String? name) onSelect,
) async {
  final result = await FilePicker.pickFiles(type: FileType.audio);
  final picked = result?.files.single;
  if (picked?.path != null) {
    await onSelect(picked!.path!, picked.name);
  }
}

// ─── Ringtone picker tile ────────────────────────────────────────────────────

class _RingtoneTile extends StatelessWidget {
  final String title;
  final String? subtitle;
  final bool selected;
  final Widget? leading;
  final VoidCallback? onPreview;
  final VoidCallback onTap;

  const _RingtoneTile({
    required this.title,
    this.subtitle,
    required this.onTap,
    this.selected = false,
    this.leading,
    this.onPreview,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        child: Row(
          children: [
            SizedBox(
              width: 28,
              child:
                  leading ??
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTheme.sans(
                      fontSize: 15,
                      fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
                    ),
                  ),
                  if (subtitle != null) ...[
                    const SizedBox(height: 2),
                    Text(
                      subtitle!,
                      style: AppTheme.sans(
                        fontSize: 12,
                        color: TempleColors.ink3,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            if (onPreview != null)
              IconButton(
                icon: const Icon(
                  Icons.play_circle_outline,
                  size: 22,
                  color: TempleColors.vermillion,
                ),
                tooltip: 'Preview',
                onPressed: onPreview,
              ),
          ],
        ),
      ),
    );
  }
}
