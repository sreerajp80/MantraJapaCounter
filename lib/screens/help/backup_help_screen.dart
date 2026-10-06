import 'package:material_ui/material_ui.dart';
import 'package:mantra_japa_counter/theme/theme.dart';
import 'package:mantra_japa_counter/l10n/app_localizations.dart';
import 'package:mantra_japa_counter/screens/help/help_widgets.dart';

class BackupHelpScreen extends StatelessWidget {
  const BackupHelpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: TempleColors.bg,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            HelpDetailTopBar(title: l.helpTopicBackupTitle),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(18, 12, 18, 32),
                children: [
                  HelpIntroCard(l.helpBackupIntro),
                  const SizedBox(height: 20),
                  HelpSection(
                    icon: Icons.place_outlined,
                    title: l.helpBackupWhereSection,
                    children: [
                      HelpBullet(
                        l.helpBackupWhereBullet1,
                        boldPrefix: l.helpBackupWhereBold1,
                      ),
                      HelpBullet(
                        l.helpBackupWhereBullet2,
                        boldPrefix: l.helpBackupWhereBold2,
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  HelpSection(
                    icon: Icons.upload_file_outlined,
                    title: l.helpBackupExportSection,
                    children: [
                      HelpBullet(
                        l.helpBackupExportBullet1,
                        boldPrefix: l.helpBackupExportBold1,
                      ),
                      HelpBullet(
                        l.helpBackupExportBullet2,
                        boldPrefix: l.helpBackupExportBold2,
                      ),
                      HelpBullet(
                        l.helpBackupExportBullet3,
                        boldPrefix: l.helpBackupExportBold3,
                      ),
                      HelpBullet(
                        l.helpBackupExportBullet4,
                        boldPrefix: l.helpBackupExportBold4,
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  HelpSection(
                    icon: Icons.restore_outlined,
                    title: l.helpBackupImportSection,
                    children: [
                      HelpBullet(
                        l.helpBackupImportBullet1,
                        boldPrefix: l.helpBackupImportBold1,
                      ),
                      HelpBullet(
                        l.helpBackupImportBullet2,
                        boldPrefix: l.helpBackupImportBold2,
                      ),
                      HelpBullet(
                        l.helpBackupImportBullet3,
                        boldPrefix: l.helpBackupImportBold3,
                      ),
                      HelpBullet(
                        l.helpBackupImportBullet4,
                        boldPrefix: l.helpBackupImportBold4,
                      ),
                      HelpBullet(
                        l.helpBackupImportBullet5,
                        boldPrefix: l.helpBackupImportBold5,
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  HelpSection(
                    icon: Icons.delete_forever_outlined,
                    title: l.helpBackupClearSection,
                    children: [
                      HelpBullet(
                        l.helpBackupClearBullet1,
                        boldPrefix: l.helpBackupClearBold1,
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
