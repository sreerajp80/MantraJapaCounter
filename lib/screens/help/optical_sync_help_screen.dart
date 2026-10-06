import 'package:material_ui/material_ui.dart';
import 'package:mantra_japa_counter/theme/theme.dart';
import 'package:mantra_japa_counter/l10n/app_localizations.dart';
import 'package:mantra_japa_counter/screens/help/help_widgets.dart';

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
                    icon: Icons.sync_alt,
                    title: l.helpOpticalHowSection,
                    children: [
                      HelpBullet(
                        l.helpOpticalHowBullet1,
                        boldPrefix: l.helpOpticalHowBold1,
                      ),
                      HelpBullet(
                        l.helpOpticalHowBullet2,
                        boldPrefix: l.helpOpticalHowBold2,
                      ),
                      HelpBullet(
                        l.helpOpticalHowBullet3,
                        boldPrefix: l.helpOpticalHowBold3,
                      ),
                      HelpBullet(
                        l.helpOpticalHowBullet4,
                        boldPrefix: l.helpOpticalHowBold4,
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  HelpSection(
                    icon: Icons.qr_code_2_outlined,
                    title: l.helpOpticalSendSection,
                    children: [
                      HelpBullet(
                        l.helpOpticalSendBullet1,
                        boldPrefix: l.helpOpticalSendBold1,
                      ),
                      HelpBullet(
                        l.helpOpticalSendBullet2,
                        boldPrefix: l.helpOpticalSendBold2,
                      ),
                      HelpBullet(
                        l.helpOpticalSendBullet3,
                        boldPrefix: l.helpOpticalSendBold3,
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  HelpSection(
                    icon: Icons.qr_code_scanner_outlined,
                    title: l.helpOpticalReceiveSection,
                    children: [
                      HelpBullet(
                        l.helpOpticalReceiveBullet1,
                        boldPrefix: l.helpOpticalReceiveBold1,
                      ),
                      HelpBullet(
                        l.helpOpticalReceiveBullet2,
                        boldPrefix: l.helpOpticalReceiveBold2,
                      ),
                      HelpBullet(
                        l.helpOpticalReceiveBullet3,
                        boldPrefix: l.helpOpticalReceiveBold3,
                      ),
                      HelpBullet(
                        l.helpOpticalReceiveBullet4,
                        boldPrefix: l.helpOpticalReceiveBold4,
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  HelpSection(
                    icon: Icons.tips_and_updates_outlined,
                    title: l.helpOpticalTipsSection,
                    children: [
                      HelpBullet(
                        l.helpOpticalTipsBullet1,
                        boldPrefix: l.helpOpticalTipsBold1,
                      ),
                      HelpBullet(
                        l.helpOpticalTipsBullet2,
                        boldPrefix: l.helpOpticalTipsBold2,
                      ),
                      HelpBullet(
                        l.helpOpticalTipsBullet3,
                        boldPrefix: l.helpOpticalTipsBold3,
                      ),
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
