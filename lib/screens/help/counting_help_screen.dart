import 'package:material_ui/material_ui.dart';
import 'package:mantra_japa_counter/theme/theme.dart';
import 'package:mantra_japa_counter/l10n/app_localizations.dart';
import 'package:mantra_japa_counter/screens/help/help_widgets.dart';

class CountingHelpScreen extends StatelessWidget {
  const CountingHelpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: TempleColors.bg,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            HelpDetailTopBar(title: l.helpTopicCountingTitle),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(18, 12, 18, 32),
                children: [
                  HelpIntroCard(l.helpCountingIntro),
                  const SizedBox(height: 20),
                  HelpSection(
                    icon: Icons.touch_app_outlined,
                    title: l.helpCountingTapSection,
                    children: [
                      HelpBullet(
                        l.helpCountingTapBullet1,
                        boldPrefix: l.helpCountingTapBold1,
                      ),
                      HelpBullet(
                        l.helpCountingTapBullet2,
                        boldPrefix: l.helpCountingTapBold2,
                      ),
                      HelpBullet(
                        l.helpCountingTapBullet3,
                        boldPrefix: l.helpCountingTapBold3,
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  HelpSection(
                    icon: Icons.swipe_outlined,
                    title: l.helpCountingUndoSection,
                    children: [
                      HelpBullet(
                        l.helpCountingUndoBullet1,
                        boldPrefix: l.helpCountingUndoBold1,
                      ),
                      HelpBullet(
                        l.helpCountingUndoBullet2,
                        boldPrefix: l.helpCountingUndoBold2,
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  HelpSection(
                    icon: Icons.visibility_outlined,
                    title: l.helpCountingScreenSection,
                    children: [
                      HelpBullet(
                        l.helpCountingScreenBullet1,
                        boldPrefix: l.helpCountingScreenBold1,
                      ),
                      HelpBullet(
                        l.helpCountingScreenBullet2,
                        boldPrefix: l.helpCountingScreenBold2,
                      ),
                      HelpBullet(
                        l.helpCountingScreenBullet3,
                        boldPrefix: l.helpCountingScreenBold3,
                      ),
                      HelpBullet(
                        l.helpCountingScreenBullet4,
                        boldPrefix: l.helpCountingScreenBold4,
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  HelpSection(
                    icon: Icons.save_outlined,
                    title: l.helpCountingSaveSection,
                    children: [
                      HelpBullet(
                        l.helpCountingSaveBullet1,
                        boldPrefix: l.helpCountingSaveBold1,
                      ),
                      HelpBullet(
                        l.helpCountingSaveBullet2,
                        boldPrefix: l.helpCountingSaveBold2,
                      ),
                      HelpBullet(
                        l.helpCountingSaveBullet3,
                        boldPrefix: l.helpCountingSaveBold3,
                      ),
                      HelpBullet(
                        l.helpCountingSaveBullet4,
                        boldPrefix: l.helpCountingSaveBold4,
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  HelpSection(
                    icon: Icons.more_vert,
                    title: l.helpCountingMenuSection,
                    children: [
                      HelpBullet(
                        l.helpCountingMenuBullet1,
                        boldPrefix: l.helpCountingMenuBold1,
                      ),
                      HelpBullet(
                        l.helpCountingMenuBullet2,
                        boldPrefix: l.helpCountingMenuBold2,
                      ),
                      HelpBullet(
                        l.helpCountingMenuBullet3,
                        boldPrefix: l.helpCountingMenuBold3,
                      ),
                      HelpBullet(
                        l.helpCountingMenuBullet4,
                        boldPrefix: l.helpCountingMenuBold4,
                      ),
                      HelpBullet(
                        l.helpCountingMenuBullet5,
                        boldPrefix: l.helpCountingMenuBold5,
                      ),
                      HelpBullet(
                        l.helpCountingMenuBullet6,
                        boldPrefix: l.helpCountingMenuBold6,
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  HelpSection(
                    icon: Icons.spa_outlined,
                    title: l.helpCountingMindfulSection,
                    children: [
                      HelpBullet(
                        l.helpCountingMindfulBullet1,
                        boldPrefix: l.helpCountingMindfulBold1,
                      ),
                      HelpBullet(
                        l.helpCountingMindfulBullet2,
                        boldPrefix: l.helpCountingMindfulBold2,
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
