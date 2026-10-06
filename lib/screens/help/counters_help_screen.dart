import 'package:material_ui/material_ui.dart';
import 'package:mantra_japa_counter/theme/theme.dart';
import 'package:mantra_japa_counter/l10n/app_localizations.dart';
import 'package:mantra_japa_counter/screens/help/help_widgets.dart';

class CountersHelpScreen extends StatelessWidget {
  const CountersHelpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: TempleColors.bg,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            HelpDetailTopBar(title: l.helpTopicCountersTitle),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(18, 12, 18, 32),
                children: [
                  HelpIntroCard(l.helpCountersIntro),
                  const SizedBox(height: 20),
                  HelpSection(
                    icon: Icons.add_circle_outline,
                    title: l.helpCountersCreateSection,
                    children: [
                      HelpBullet(
                        l.helpCountersCreateBullet1,
                        boldPrefix: l.helpCountersCreateBold1,
                      ),
                      HelpBullet(
                        l.helpCountersCreateBullet2,
                        boldPrefix: l.helpCountersCreateBold2,
                      ),
                      HelpBullet(
                        l.helpCountersCreateBullet3,
                        boldPrefix: l.helpCountersCreateBold3,
                      ),
                      HelpBullet(
                        l.helpCountersCreateBullet4,
                        boldPrefix: l.helpCountersCreateBold4,
                      ),
                      HelpBullet(
                        l.helpCountersCreateBullet5,
                        boldPrefix: l.helpCountersCreateBold5,
                      ),
                      HelpBullet(
                        l.helpCountersCreateBullet6,
                        boldPrefix: l.helpCountersCreateBold6,
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  HelpSection(
                    icon: Icons.home_outlined,
                    title: l.helpCountersHomeSection,
                    children: [
                      HelpBullet(
                        l.helpCountersHomeBullet1,
                        boldPrefix: l.helpCountersHomeBold1,
                      ),
                      HelpBullet(
                        l.helpCountersHomeBullet2,
                        boldPrefix: l.helpCountersHomeBold2,
                      ),
                      HelpBullet(
                        l.helpCountersHomeBullet3,
                        boldPrefix: l.helpCountersHomeBold3,
                      ),
                      HelpBullet(
                        l.helpCountersHomeBullet4,
                        boldPrefix: l.helpCountersHomeBold4,
                      ),
                      HelpBullet(
                        l.helpCountersHomeBullet5,
                        boldPrefix: l.helpCountersHomeBold5,
                      ),
                      HelpBullet(
                        l.helpCountersHomeBullet6,
                        boldPrefix: l.helpCountersHomeBold6,
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  HelpSection(
                    icon: Icons.more_horiz,
                    title: l.helpCountersOptionsSection,
                    children: [
                      HelpBullet(
                        l.helpCountersOptionsBullet1,
                        boldPrefix: l.helpCountersOptionsBold1,
                      ),
                      HelpBullet(
                        l.helpCountersOptionsBullet2,
                        boldPrefix: l.helpCountersOptionsBold2,
                      ),
                      HelpBullet(
                        l.helpCountersOptionsBullet3,
                        boldPrefix: l.helpCountersOptionsBold3,
                      ),
                      HelpBullet(
                        l.helpCountersOptionsBullet4,
                        boldPrefix: l.helpCountersOptionsBold4,
                      ),
                      HelpBullet(
                        l.helpCountersOptionsBullet5,
                        boldPrefix: l.helpCountersOptionsBold5,
                      ),
                      HelpBullet(
                        l.helpCountersOptionsBullet6,
                        boldPrefix: l.helpCountersOptionsBold6,
                      ),
                      HelpBullet(
                        l.helpCountersOptionsBullet7,
                        boldPrefix: l.helpCountersOptionsBold7,
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  HelpSection(
                    icon: Icons.lock_outline,
                    title: l.helpCountersLockSection,
                    children: [
                      HelpBullet(
                        l.helpCountersLockBullet1,
                        boldPrefix: l.helpCountersLockBold1,
                      ),
                      HelpBullet(
                        l.helpCountersLockBullet2,
                        boldPrefix: l.helpCountersLockBold2,
                      ),
                      HelpBullet(
                        l.helpCountersLockBullet3,
                        boldPrefix: l.helpCountersLockBold3,
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
