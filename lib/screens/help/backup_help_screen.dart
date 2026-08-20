import 'package:flutter/material.dart';
import '../../config/theme.dart';
import '../../l10n/app_localizations.dart';
import 'help_widgets.dart';

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
                    icon: Icons.upload_file_outlined,
                    title: l.helpBackupExportSection,
                    children: [
                      HelpBullet(l.helpBackupExportBullet1, boldPrefix: l.helpBackupExportBold1),
                      HelpBullet(l.helpBackupExportBullet2, boldPrefix: l.helpBackupExportBold2),
                      HelpBullet(l.helpBackupExportBullet3, boldPrefix: l.helpBackupExportBold3),
                    ],
                  ),
                  const SizedBox(height: 20),

                  HelpSection(
                    icon: Icons.download_for_offline_outlined,
                    title: l.helpBackupImportSection,
                    children: [
                      HelpBullet(l.helpBackupImportBullet1, boldPrefix: l.helpBackupImportBold1),
                      HelpBullet(l.helpBackupImportBullet2, boldPrefix: l.helpBackupImportBold2),
                      HelpBullet(l.helpBackupImportBullet3, boldPrefix: l.helpBackupImportBold3),
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
