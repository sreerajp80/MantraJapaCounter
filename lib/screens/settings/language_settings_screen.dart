import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mantra_japa_counter/theme/theme.dart';
import 'package:mantra_japa_counter/l10n/app_localizations.dart';
import 'package:mantra_japa_counter/providers/settings_provider.dart';
import 'package:mantra_japa_counter/widgets/temple_decorations.dart';

/// Dedicated Language selection settings screen.
class LanguageSettingsScreen extends ConsumerWidget {
  const LanguageSettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final settings = ref.watch(settingsNotifierProvider);
    final notifier = ref.read(settingsNotifierProvider.notifier);

    final currentCode = settings.languageCode;

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
                  Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: TempleColors.cardSoft,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: TempleColors.line),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            color: TempleColors.vermillion.withValues(
                              alpha: 0.12,
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Center(
                            child: Icon(
                              Icons.translate_outlined,
                              color: TempleColors.vermillion,
                              size: 24,
                            ),
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                l.appLanguage,
                                style: AppTheme.serif(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                l.sectionLanguageSub,
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
                  ),

                  const SizedBox(height: 20),

                  _buildLanguageOption(
                    title: l.systemDefault,
                    nativeName: l.systemDefault,
                    code: 'system',
                    isSelected: currentCode == null || currentCode == 'system',
                    onTap: () => notifier.setLanguageCode('system'),
                  ),
                  const SizedBox(height: 10),
                  _buildLanguageOption(
                    title: l.englishLanguage,
                    nativeName: 'English (International)',
                    code: 'en',
                    isSelected: currentCode == 'en',
                    onTap: () => notifier.setLanguageCode('en'),
                  ),
                  const SizedBox(height: 10),
                  _buildLanguageOption(
                    title: l.malayalamLanguage,
                    nativeName: 'മലയാളം',
                    code: 'ml',
                    isSelected: currentCode == 'ml',
                    onTap: () => notifier.setLanguageCode('ml'),
                  ),
                  const SizedBox(height: 10),
                  _buildLanguageOption(
                    title: l.sanskritLanguage,
                    nativeName: 'संस्कृतम्',
                    code: 'sa',
                    isSelected: currentCode == 'sa',
                    onTap: () => notifier.setLanguageCode('sa'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLanguageOption({
    required String title,
    required String nativeName,
    required String code,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: TempleColors.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isSelected ? TempleColors.vermillion : TempleColors.line,
          width: isSelected ? 1.4 : 1.0,
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Row(
            children: [
              Icon(
                isSelected
                    ? Icons.radio_button_checked
                    : Icons.radio_button_unchecked,
                color: isSelected ? TempleColors.vermillion : TempleColors.ink3,
                size: 22,
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: AppTheme.sans(
                        fontSize: 16,
                        fontWeight: isSelected
                            ? FontWeight.w600
                            : FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      nativeName,
                      style: AppTheme.sans(
                        fontSize: 13,
                        color: TempleColors.ink2,
                      ),
                    ),
                  ],
                ),
              ),
              if (isSelected)
                const Icon(
                  Icons.check_circle_outline,
                  color: TempleColors.tulsi,
                  size: 20,
                ),
            ],
          ),
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
                  l.settingsLanguageTitle,
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
}
