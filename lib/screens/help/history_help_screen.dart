import 'package:material_ui/material_ui.dart';
import 'package:mantra_japa_counter/theme/theme.dart';
import 'package:mantra_japa_counter/l10n/app_localizations.dart';
import 'package:mantra_japa_counter/screens/help/help_widgets.dart';

class HistoryHelpScreen extends StatelessWidget {
  const HistoryHelpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: TempleColors.bg,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            HelpDetailTopBar(title: l.helpTopicHistoryTitle),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(18, 12, 18, 32),
                children: [
                  HelpIntroCard(l.helpHistoryIntro),
                  const SizedBox(height: 20),
                  HelpSection(
                    icon: Icons.history_outlined,
                    title: l.helpHistoryLogSection,
                    children: [
                      HelpBullet(
                        l.helpHistoryLogBullet1,
                        boldPrefix: l.helpHistoryLogBold1,
                      ),
                      HelpBullet(
                        l.helpHistoryLogBullet2,
                        boldPrefix: l.helpHistoryLogBold2,
                      ),
                      HelpBullet(
                        l.helpHistoryLogBullet3,
                        boldPrefix: l.helpHistoryLogBold3,
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  HelpSection(
                    icon: Icons.delete_outline,
                    title: l.helpHistoryDeleteSection,
                    children: [
                      HelpBullet(
                        l.helpHistoryDeleteBullet1,
                        boldPrefix: l.helpHistoryDeleteBold1,
                      ),
                      HelpBullet(
                        l.helpHistoryDeleteBullet2,
                        boldPrefix: l.helpHistoryDeleteBold2,
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  HelpSection(
                    icon: Icons.calendar_month_outlined,
                    title: l.helpHistoryFlowSection,
                    children: [
                      HelpBullet(
                        l.helpHistoryFlowBullet1,
                        boldPrefix: l.helpHistoryFlowBold1,
                      ),
                      HelpBullet(
                        l.helpHistoryFlowBullet2,
                        boldPrefix: l.helpHistoryFlowBold2,
                      ),
                      HelpBullet(
                        l.helpHistoryFlowBullet3,
                        boldPrefix: l.helpHistoryFlowBold3,
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  HelpSection(
                    icon: Icons.insights_outlined,
                    title: l.helpHistoryStatsSection,
                    children: [
                      HelpBullet(
                        l.helpHistoryStatsBullet1,
                        boldPrefix: l.helpHistoryStatsBold1,
                      ),
                      HelpBullet(
                        l.helpHistoryStatsBullet2,
                        boldPrefix: l.helpHistoryStatsBold2,
                      ),
                      HelpBullet(
                        l.helpHistoryStatsBullet3,
                        boldPrefix: l.helpHistoryStatsBold3,
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
