import 'package:flutter/material.dart';
import '../../config/theme.dart';
import '../../l10n/app_localizations.dart';
import 'help_widgets.dart';

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
                    icon: Icons.timer_outlined,
                    title: l.helpCountingTimerSection,
                    children: [
                      HelpBullet(
                        l.helpCountingTimerBullet1,
                        boldPrefix: l.helpCountingTimerBold1,
                      ),
                      HelpBullet(
                        l.helpCountingTimerBullet2,
                        boldPrefix: l.helpCountingTimerBold2,
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
