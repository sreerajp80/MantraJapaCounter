import 'package:flutter/material.dart';
import 'package:mantra_japa_counter/theme/theme.dart';
import 'package:mantra_japa_counter/l10n/app_localizations.dart';
import 'package:mantra_japa_counter/providers/settings_provider.dart';

/// Modal bottom sheet for choosing the app language:
/// System default, English, Malayalam, or Sanskrit.
Future<void> showLanguagePicker(
  BuildContext context,
  String? currentLanguageCode,
  SettingsNotifier notifier,
) async {
  final l = AppLocalizations.of(context);

  await showModalBottomSheet<void>(
    context: context,
    backgroundColor: TempleColors.bg,
    showDragHandle: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (sheetContext) {
      final isSystem =
          currentLanguageCode == null || currentLanguageCode == 'system';
      return SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 4, 16, 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 4, 8, 16),
                child: Text(
                  l.selectLanguageTitle,
                  style: AppTheme.serif(fontSize: 22, height: 1.1),
                ),
              ),
              _LanguageTile(
                title: l.systemDefault,
                subtitle: l.sectionLanguageSub,
                selected: isSystem,
                onTap: () async {
                  await notifier.setLanguageCode('system');
                  if (sheetContext.mounted) Navigator.pop(sheetContext);
                },
              ),
              const SizedBox(height: 6),
              _LanguageTile(
                title: l.englishLanguage,
                subtitle: 'English',
                selected: !isSystem && currentLanguageCode == 'en',
                onTap: () async {
                  await notifier.setLanguageCode('en');
                  if (sheetContext.mounted) Navigator.pop(sheetContext);
                },
              ),
              const SizedBox(height: 6),
              _LanguageTile(
                title: l.malayalamLanguage,
                subtitle: 'മലയാളം',
                selected: !isSystem && currentLanguageCode == 'ml',
                onTap: () async {
                  await notifier.setLanguageCode('ml');
                  if (sheetContext.mounted) Navigator.pop(sheetContext);
                },
              ),
              const SizedBox(height: 6),
              _LanguageTile(
                title: l.sanskritLanguage,
                subtitle: 'संस्कृतम्',
                selected: !isSystem && currentLanguageCode == 'sa',
                onTap: () async {
                  await notifier.setLanguageCode('sa');
                  if (sheetContext.mounted) Navigator.pop(sheetContext);
                },
              ),
            ],
          ),
        ),
      );
    },
  );
}

class _LanguageTile extends StatelessWidget {
  final String title;
  final String? subtitle;
  final bool selected;
  final VoidCallback onTap;

  const _LanguageTile({
    required this.title,
    this.subtitle,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: selected ? TempleColors.cardSoft : TempleColors.card,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: selected ? TempleColors.vermillion : TempleColors.line,
          width: selected ? 1.5 : 1,
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: AppTheme.sans(
                        fontSize: 16,
                        fontWeight: selected
                            ? FontWeight.w600
                            : FontWeight.w500,
                        color: selected
                            ? TempleColors.vermillionDeep
                            : TempleColors.ink,
                      ),
                    ),
                    if (subtitle != null && subtitle != title) ...[
                      const SizedBox(height: 2),
                      Text(
                        subtitle!,
                        style: AppTheme.sans(
                          fontSize: 13,
                          color: TempleColors.ink2,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              if (selected)
                const Icon(
                  Icons.check_circle,
                  color: TempleColors.vermillion,
                  size: 20,
                )
              else
                const Icon(
                  Icons.radio_button_unchecked,
                  color: TempleColors.ink3,
                  size: 20,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
