import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mantra_japa_counter/theme/theme.dart';
import 'package:mantra_japa_counter/l10n/app_localizations.dart';
import 'package:mantra_japa_counter/providers/app_providers.dart';
import 'package:mantra_japa_counter/providers/settings_provider.dart';

/// Bottom sheet for choosing the daily-goal notification sound: system
/// default, a device ringtone, or an audio file picked from storage.
Future<void> showNotificationSoundPicker(
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
                  style: AppTheme.serif(fontSize: 20),
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
                          await notifier.setNotificationSound(r.uri, r.title);
                          await soundService.playTone(r.uri);
                          if (sheetContext.mounted) {
                            Navigator.pop(sheetContext);
                          }
                        },
                      ),
                    const Divider(height: 16, color: TempleColors.line),
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
  BuildContext context,
  SettingsNotifier notifier,
) async {
  final result = await FilePicker.pickFiles(type: FileType.audio);
  final picked = result?.files.single;
  if (picked?.path != null) {
    await notifier.setNotificationSound(picked!.path!, picked.name);
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
              child: Text(
                title,
                style: AppTheme.sans(
                  fontSize: 15,
                  fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
