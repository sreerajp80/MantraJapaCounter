import 'package:material_ui/material_ui.dart';
import 'package:mantra_japa_counter/theme/theme.dart';
import 'package:mantra_japa_counter/l10n/app_localizations.dart';
import 'package:mantra_japa_counter/screens/help/help_widgets.dart';

class FaqHelpScreen extends StatelessWidget {
  const FaqHelpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);

    final faqs = [
      (l.helpFaqQ1Title, l.helpFaqQ1Answer),
      (l.helpFaqQ2Title, l.helpFaqQ2Answer),
      (l.helpFaqQ3Title, l.helpFaqQ3Answer),
      (l.helpFaqQ4Title, l.helpFaqQ4Answer),
      (l.helpFaqQ5Title, l.helpFaqQ5Answer),
      (l.helpFaqQ6Title, l.helpFaqQ6Answer),
      (l.helpFaqQ7Title, l.helpFaqQ7Answer),
      (l.helpFaqQ8Title, l.helpFaqQ8Answer),
      (l.helpFaqQ9Title, l.helpFaqQ9Answer),
      (l.helpFaqQ10Title, l.helpFaqQ10Answer),
      (l.helpFaqQ11Title, l.helpFaqQ11Answer),
      (l.helpFaqQ12Title, l.helpFaqQ12Answer),
      (l.helpFaqQ13Title, l.helpFaqQ13Answer),
      (l.helpFaqQ14Title, l.helpFaqQ14Answer),
    ];

    return Scaffold(
      backgroundColor: TempleColors.bg,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            HelpDetailTopBar(title: l.helpTopicFaqTitle),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(18, 12, 18, 32),
                children: [
                  HelpIntroCard(l.helpFaqIntro),
                  for (final (question, answer) in faqs) ...[
                    const SizedBox(height: 20),
                    HelpSection(
                      icon: Icons.help_outline,
                      title: question,
                      children: [HelpBullet(answer)],
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
