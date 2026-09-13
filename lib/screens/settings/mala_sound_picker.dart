import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mantra_japa_counter/theme/theme.dart';
import 'package:mantra_japa_counter/l10n/app_localizations.dart';
import 'package:mantra_japa_counter/models/mala_sound.dart';
import 'package:mantra_japa_counter/providers/app_providers.dart';
import 'package:mantra_japa_counter/providers/settings_provider.dart';

/// Bottom sheet for choosing the mala completion soundscape:
/// Temple Bronze Bell, Tibetan Singing Bowl, or Synthesized Tone.
Future<void> showMalaSoundPicker(
  BuildContext context,
  WidgetRef ref,
  AppSettings settings,
  SettingsNotifier notifier,
) async {
  final l = AppLocalizations.of(context);
  final soundService = ref.read(soundServiceProvider);

  await showModalBottomSheet<void>(
    context: context,
    backgroundColor: TempleColors.bg,
    showDragHandle: true,
    isScrollControlled: true,
    builder: (sheetContext) {
      final selectedSound = settings.malaSound;
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
                  l.malaSoundTitle,
                  style: AppTheme.serif(fontSize: 20),
                ),
              ),
              Flexible(
                child: ListView(
                  shrinkWrap: true,
                  padding: const EdgeInsets.fromLTRB(8, 0, 8, 16),
                  children: [
                    _MalaSoundTile(
                      sound: MalaSound.templeBell,
                      title: l.soundTempleBell,
                      subtitle: l.soundTempleBellSub,
                      selected: selectedSound == MalaSound.templeBell,
                      onPreview: () =>
                          soundService.playMalaSound(MalaSound.templeBell),
                      onTap: () async {
                        await notifier.setMalaSound(MalaSound.templeBell);
                        await soundService.playMalaSound(MalaSound.templeBell);
                        if (sheetContext.mounted) {
                          Navigator.pop(sheetContext);
                        }
                      },
                    ),
                    _MalaSoundTile(
                      sound: MalaSound.singingBowl,
                      title: l.soundSingingBowl,
                      subtitle: l.soundSingingBowlSub,
                      selected: selectedSound == MalaSound.singingBowl,
                      onPreview: () =>
                          soundService.playMalaSound(MalaSound.singingBowl),
                      onTap: () async {
                        await notifier.setMalaSound(MalaSound.singingBowl);
                        await soundService.playMalaSound(MalaSound.singingBowl);
                        if (sheetContext.mounted) {
                          Navigator.pop(sheetContext);
                        }
                      },
                    ),
                    _MalaSoundTile(
                      sound: MalaSound.synthesizedTone,
                      title: l.soundSynthesizedTone,
                      subtitle: l.soundSynthesizedToneSub,
                      selected: selectedSound == MalaSound.synthesizedTone,
                      onPreview: () =>
                          soundService.playMalaSound(MalaSound.synthesizedTone),
                      onTap: () async {
                        await notifier.setMalaSound(MalaSound.synthesizedTone);
                        await soundService.playMalaSound(
                          MalaSound.synthesizedTone,
                        );
                        if (sheetContext.mounted) {
                          Navigator.pop(sheetContext);
                        }
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

class _MalaSoundTile extends StatelessWidget {
  final MalaSound sound;
  final String title;
  final String subtitle;
  final bool selected;
  final VoidCallback onPreview;
  final VoidCallback onTap;

  const _MalaSoundTile({
    required this.sound,
    required this.title,
    required this.subtitle,
    required this.selected,
    required this.onPreview,
    required this.onTap,
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
              child: Icon(
                selected
                    ? Icons.radio_button_checked
                    : Icons.radio_button_unchecked,
                size: 20,
                color: selected ? TempleColors.vermillion : TempleColors.ink3,
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
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: AppTheme.sans(
                      fontSize: 12,
                      color: TempleColors.ink3,
                    ),
                  ),
                ],
              ),
            ),
            IconButton(
              icon: const Icon(
                Icons.play_circle_outline,
                size: 24,
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
