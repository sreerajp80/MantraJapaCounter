import 'package:flutter/material.dart';
import '../../config/theme.dart';
import '../../l10n/app_localizations.dart';
import 'help_widgets.dart';

class FaqHelpScreen extends StatelessWidget {
  const FaqHelpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);

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
                  const SizedBox(height: 20),

                  HelpSection(
                    icon: Icons.help_outline,
                    title: l.helpFaqQ1Title,
                    children: [
                      HelpBullet(l.helpFaqQ1Answer),
                    ],
                  ),
                  const SizedBox(height: 20),

                  HelpSection(
                    icon: Icons.help_outline,
                    title: l.helpFaqQ2Title,
                    children: [
                      HelpBullet(l.helpFaqQ2Answer),
                    ],
                  ),
                  const SizedBox(height: 20),

                  HelpSection(
                    icon: Icons.help_outline,
                    title: l.helpFaqQ3Title,
                    children: [
                      HelpBullet(l.helpFaqQ3Answer),
                    ],
                  ),
                  const SizedBox(height: 20),

                  HelpSection(
                    icon: Icons.help_outline,
                    title: l.helpFaqQ4Title,
                    children: [
                      HelpBullet(l.helpFaqQ4Answer),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
