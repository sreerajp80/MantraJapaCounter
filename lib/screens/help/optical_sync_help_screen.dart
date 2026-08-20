import 'package:flutter/material.dart';
import '../../config/theme.dart';
import '../../l10n/app_localizations.dart';
import 'help_widgets.dart';

class OpticalSyncHelpScreen extends StatelessWidget {
  const OpticalSyncHelpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: TempleColors.bg,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            HelpDetailTopBar(title: l.helpTopicOpticalSyncTitle),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(18, 12, 18, 32),
                children: [
                  HelpIntroCard(l.helpOpticalIntro),
                  const SizedBox(height: 20),

                  HelpSection(
                    icon: Icons.qr_code_2_outlined,
                    title: l.helpOpticalHowSection,
                    children: [
                      HelpBullet(l.helpOpticalHowBullet1, boldPrefix: l.helpOpticalHowBold1),
                      HelpBullet(l.helpOpticalHowBullet2, boldPrefix: l.helpOpticalHowBold2),
                      HelpBullet(l.helpOpticalHowBullet3, boldPrefix: l.helpOpticalHowBold3),
                    ],
                  ),
                  const SizedBox(height: 20),

                  HelpSection(
                    icon: Icons.tips_and_updates_outlined,
                    title: l.helpOpticalTipsSection,
                    children: [
                      HelpBullet(l.helpOpticalTipsBullet1, boldPrefix: l.helpOpticalTipsBold1),
                      HelpBullet(l.helpOpticalTipsBullet2, boldPrefix: l.helpOpticalTipsBold2),
                      HelpBullet(l.helpOpticalTipsBullet3, boldPrefix: l.helpOpticalTipsBold3),
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
