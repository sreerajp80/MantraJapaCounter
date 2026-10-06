import 'package:material_ui/material_ui.dart';
import 'package:mantra_japa_counter/theme/theme.dart';
import 'package:mantra_japa_counter/l10n/app_localizations.dart';
import 'package:mantra_japa_counter/screens/help/help_widgets.dart';

class MalaMathHelpScreen extends StatelessWidget {
  const MalaMathHelpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: TempleColors.bg,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            HelpDetailTopBar(title: l.helpTopicMalaTitle),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(18, 12, 18, 32),
                children: [
                  HelpIntroCard(l.helpMalaIntro),
                  const SizedBox(height: 20),
                  HelpSection(
                    icon: Icons.lens_blur_outlined,
                    title: l.helpMalaBeadsSection,
                    children: [
                      HelpBullet(
                        l.helpMalaBeadsBullet1,
                        boldPrefix: l.helpMalaBeadsBold1,
                      ),
                      HelpBullet(
                        l.helpMalaBeadsBullet2,
                        boldPrefix: l.helpMalaBeadsBold2,
                      ),
                      HelpBullet(
                        l.helpMalaBeadsBullet3,
                        boldPrefix: l.helpMalaBeadsBold3,
                      ),
                      HelpBullet(
                        l.helpMalaBeadsBullet4,
                        boldPrefix: l.helpMalaBeadsBold4,
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  HelpSection(
                    icon: Icons.flag_outlined,
                    title: l.helpMalaGoalsSection,
                    children: [
                      HelpBullet(
                        l.helpMalaGoalsBullet1,
                        boldPrefix: l.helpMalaGoalsBold1,
                      ),
                      HelpBullet(
                        l.helpMalaGoalsBullet2,
                        boldPrefix: l.helpMalaGoalsBold2,
                      ),
                      HelpBullet(
                        l.helpMalaGoalsBullet3,
                        boldPrefix: l.helpMalaGoalsBold3,
                      ),
                      HelpBullet(
                        l.helpMalaGoalsBullet4,
                        boldPrefix: l.helpMalaGoalsBold4,
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  HelpSection(
                    icon: Icons.style_outlined,
                    title: l.helpMalaCardSection,
                    children: [
                      HelpBullet(
                        l.helpMalaCardBullet1,
                        boldPrefix: l.helpMalaCardBold1,
                      ),
                      HelpBullet(
                        l.helpMalaCardBullet2,
                        boldPrefix: l.helpMalaCardBold2,
                      ),
                      HelpBullet(
                        l.helpMalaCardBullet3,
                        boldPrefix: l.helpMalaCardBold3,
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
