import 'package:material_ui/material_ui.dart';
import 'package:mantra_japa_counter/theme/theme.dart';
import 'package:mantra_japa_counter/l10n/app_localizations.dart';
import 'package:mantra_japa_counter/screens/help/help_widgets.dart';

class DisplayHelpScreen extends StatelessWidget {
  const DisplayHelpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: TempleColors.bg,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            HelpDetailTopBar(title: l.helpTopicDisplayTitle),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(18, 12, 18, 32),
                children: [
                  HelpIntroCard(l.helpDisplayIntro),
                  const SizedBox(height: 20),
                  HelpSection(
                    icon: Icons.brightness_medium_outlined,
                    title: l.helpDisplayBrightSection,
                    children: [
                      HelpBullet(
                        l.helpDisplayBrightBullet1,
                        boldPrefix: l.helpDisplayBrightBold1,
                      ),
                      HelpBullet(
                        l.helpDisplayBrightBullet2,
                        boldPrefix: l.helpDisplayBrightBold2,
                      ),
                      HelpBullet(
                        l.helpDisplayBrightBullet3,
                        boldPrefix: l.helpDisplayBrightBold3,
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  HelpSection(
                    icon: Icons.do_not_disturb_on_outlined,
                    title: l.helpDisplayDndSection,
                    children: [
                      HelpBullet(
                        l.helpDisplayDndBullet1,
                        boldPrefix: l.helpDisplayDndBold1,
                      ),
                      HelpBullet(
                        l.helpDisplayDndBullet2,
                        boldPrefix: l.helpDisplayDndBold2,
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  HelpSection(
                    icon: Icons.spa_outlined,
                    title: l.helpDisplayMindfulSection,
                    children: [
                      HelpBullet(
                        l.helpDisplayMindfulBullet1,
                        boldPrefix: l.helpDisplayMindfulBold1,
                      ),
                      HelpBullet(
                        l.helpDisplayMindfulBullet2,
                        boldPrefix: l.helpDisplayMindfulBold2,
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  HelpSection(
                    icon: Icons.translate_outlined,
                    title: l.helpDisplayLangSection,
                    children: [
                      HelpBullet(
                        l.helpDisplayLangBullet1,
                        boldPrefix: l.helpDisplayLangBold1,
                      ),
                      HelpBullet(
                        l.helpDisplayLangBullet2,
                        boldPrefix: l.helpDisplayLangBold2,
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  HelpSection(
                    icon: Icons.palette_outlined,
                    title: l.helpDisplayLookSection,
                    children: [
                      HelpBullet(
                        l.helpDisplayLookBullet1,
                        boldPrefix: l.helpDisplayLookBold1,
                      ),
                      HelpBullet(
                        l.helpDisplayLookBullet2,
                        boldPrefix: l.helpDisplayLookBold2,
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
