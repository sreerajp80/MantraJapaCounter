import 'package:flutter/material.dart';
import '../../config/theme.dart';
import '../../l10n/app_localizations.dart';
import 'help_widgets.dart';

class PrivacyOfflineHelpScreen extends StatelessWidget {
  const PrivacyOfflineHelpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: TempleColors.bg,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            HelpDetailTopBar(title: l.helpTopicPrivacyTitle),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(18, 12, 18, 32),
                children: [
                  HelpIntroCard(l.helpPrivacyIntro),
                  const SizedBox(height: 20),

                  HelpSection(
                    icon: Icons.wifi_off_outlined,
                    title: l.helpPrivacyOfflineSection,
                    children: [
                      HelpBullet(
                        l.helpPrivacyOfflineBullet1,
                        boldPrefix: l.helpPrivacyOfflineBold1,
                      ),
                      HelpBullet(
                        l.helpPrivacyOfflineBullet2,
                        boldPrefix: l.helpPrivacyOfflineBold2,
                      ),
                      HelpBullet(
                        l.helpPrivacyOfflineBullet3,
                        boldPrefix: l.helpPrivacyOfflineBold3,
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  HelpSection(
                    icon: Icons.storage_outlined,
                    title: l.helpPrivacyStorageSection,
                    children: [
                      HelpBullet(
                        l.helpPrivacyStorageBullet1,
                        boldPrefix: l.helpPrivacyStorageBold1,
                      ),
                      HelpBullet(
                        l.helpPrivacyStorageBullet2,
                        boldPrefix: l.helpPrivacyStorageBold2,
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
