import 'package:material_ui/material_ui.dart';
import 'package:mantra_japa_counter/theme/theme.dart';
import 'package:mantra_japa_counter/l10n/app_localizations.dart';
import 'package:mantra_japa_counter/screens/help/help_widgets.dart';

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
                    icon: Icons.lens_blur_outlined,
                    title: l.helpAudioMalaSection,
                    children: [
                      HelpBullet(
                        l.helpAudioMalaBullet1,
                        boldPrefix: l.helpAudioMalaBold1,
                      ),
                      HelpBullet(
                        l.helpAudioMalaBullet2,
                        boldPrefix: l.helpAudioMalaBold2,
                      ),
                      HelpBullet(
                        l.helpAudioMalaBullet3,
                        boldPrefix: l.helpAudioMalaBold3,
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  HelpSection(
                    icon: Icons.flag_outlined,
                    title: l.helpAudioGoalSection,
                    children: [
                      HelpBullet(
                        l.helpAudioGoalBullet1,
                        boldPrefix: l.helpAudioGoalBold1,
                      ),
                      HelpBullet(
                        l.helpAudioGoalBullet2,
                        boldPrefix: l.helpAudioGoalBold2,
                      ),
                      HelpBullet(
                        l.helpAudioGoalBullet3,
                        boldPrefix: l.helpAudioGoalBold3,
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  HelpSection(
                    icon: Icons.emoji_events_outlined,
                    title: l.helpAudioLifetimeSection,
                    children: [
                      HelpBullet(
                        l.helpAudioLifetimeBullet1,
                        boldPrefix: l.helpAudioLifetimeBold1,
                      ),
                      HelpBullet(
                        l.helpAudioLifetimeBullet2,
                        boldPrefix: l.helpAudioLifetimeBold2,
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  HelpSection(
                    icon: Icons.alarm_outlined,
                    title: l.helpAudioReminderSection,
                    children: [
                      HelpBullet(
                        l.helpAudioReminderBullet1,
                        boldPrefix: l.helpAudioReminderBold1,
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  HelpSection(
                    icon: Icons.vibration_outlined,
                    title: l.helpAudioVibrationSection,
                    children: [
                      HelpBullet(
                        l.helpAudioVibrationBullet1,
                        boldPrefix: l.helpAudioVibrationBold1,
                      ),
                      HelpBullet(
                        l.helpAudioVibrationBullet2,
                        boldPrefix: l.helpAudioVibrationBold2,
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  HelpSection(
                    icon: Icons.volume_up_outlined,
                    title: l.helpAudioVolumeSection,
                    children: [
                      HelpBullet(
                        l.helpAudioVolumeBullet1,
                        boldPrefix: l.helpAudioVolumeBold1,
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
