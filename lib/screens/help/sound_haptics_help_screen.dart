import 'package:flutter/material.dart';
import '../../config/theme.dart';
import '../../l10n/app_localizations.dart';
import 'help_widgets.dart';

class SoundHapticsHelpScreen extends StatelessWidget {
  const SoundHapticsHelpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: TempleColors.bg,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            HelpDetailTopBar(title: l.helpTopicAudioTitle),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(18, 12, 18, 32),
                children: [
                  HelpIntroCard(l.helpAudioIntro),
                  const SizedBox(height: 20),

                  HelpSection(
                    icon: Icons.volume_up_outlined,
                    title: l.helpAudioTonesSection,
                    children: [
                      HelpBullet(l.helpAudioTonesBullet1, boldPrefix: l.helpAudioTonesBold1),
                      HelpBullet(l.helpAudioTonesBullet2, boldPrefix: l.helpAudioTonesBold2),
                      HelpBullet(l.helpAudioTonesBullet3, boldPrefix: l.helpAudioTonesBold3),
                    ],
                  ),
                  const SizedBox(height: 20),

                  HelpSection(
                    icon: Icons.vibration_outlined,
                    title: l.helpAudioVibrationSection,
                    children: [
                      HelpBullet(l.helpAudioVibrationBullet1, boldPrefix: l.helpAudioVibrationBold1),
                      HelpBullet(l.helpAudioVibrationBullet2, boldPrefix: l.helpAudioVibrationBold2),
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
