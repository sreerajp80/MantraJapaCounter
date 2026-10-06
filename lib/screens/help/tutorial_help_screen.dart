import 'package:material_ui/material_ui.dart';
import 'package:go_router/go_router.dart';
import 'package:mantra_japa_counter/theme/theme.dart';
import 'package:mantra_japa_counter/l10n/app_localizations.dart';
import 'package:mantra_japa_counter/widgets/temple_decorations.dart';

/// Step-by-step tutorial that walks through every feature of the app,
/// grouped into chapters.
class TutorialHelpScreen extends StatelessWidget {
  const TutorialHelpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);

    final items = <_TutorialItem>[
      _TutorialChapter(l.tutorialChapter1),
      _TutorialStep(
        stepNumber: '01',
        title: l.tutorialStep1Title,
        description: l.tutorialStep1Desc,
        icon: Icons.waving_hand_outlined,
        tip: l.tutorialStep1Tip,
      ),
      _TutorialStep(
        stepNumber: '02',
        title: l.tutorialStep2Title,
        description: l.tutorialStep2Desc,
        icon: Icons.translate_outlined,
        tip: l.tutorialStep2Tip,
      ),
      _TutorialChapter(l.tutorialChapter2),
      _TutorialStep(
        stepNumber: '03',
        title: l.tutorialStep3Title,
        description: l.tutorialStep3Desc,
        icon: Icons.add_circle_outline,
        tip: l.tutorialStep3Tip,
      ),
      _TutorialStep(
        stepNumber: '04',
        title: l.tutorialStep4Title,
        description: l.tutorialStep4Desc,
        icon: Icons.style_outlined,
        tip: l.tutorialStep4Tip,
      ),
      _TutorialStep(
        stepNumber: '05',
        title: l.tutorialStep5Title,
        description: l.tutorialStep5Desc,
        icon: Icons.today_outlined,
        tip: l.tutorialStep5Tip,
      ),
      _TutorialStep(
        stepNumber: '06',
        title: l.tutorialStep6Title,
        description: l.tutorialStep6Desc,
        icon: Icons.more_horiz,
        tip: l.tutorialStep6Tip,
      ),
      _TutorialStep(
        stepNumber: '07',
        title: l.tutorialStep7Title,
        description: l.tutorialStep7Desc,
        icon: Icons.lock_outline,
        tip: l.tutorialStep7Tip,
      ),
      _TutorialChapter(l.tutorialChapter3),
      _TutorialStep(
        stepNumber: '08',
        title: l.tutorialStep8Title,
        description: l.tutorialStep8Desc,
        icon: Icons.open_in_new,
        tip: l.tutorialStep8Tip,
      ),
      _TutorialStep(
        stepNumber: '09',
        title: l.tutorialStep9Title,
        description: l.tutorialStep9Desc,
        icon: Icons.touch_app_outlined,
        tip: l.tutorialStep9Tip,
      ),
      _TutorialStep(
        stepNumber: '10',
        title: l.tutorialStep10Title,
        description: l.tutorialStep10Desc,
        icon: Icons.swipe_outlined,
        tip: l.tutorialStep10Tip,
      ),
      _TutorialStep(
        stepNumber: '11',
        title: l.tutorialStep11Title,
        description: l.tutorialStep11Desc,
        icon: Icons.visibility_outlined,
        tip: l.tutorialStep11Tip,
      ),
      _TutorialStep(
        stepNumber: '12',
        title: l.tutorialStep12Title,
        description: l.tutorialStep12Desc,
        icon: Icons.exit_to_app,
        tip: l.tutorialStep12Tip,
      ),
      _TutorialStep(
        stepNumber: '13',
        title: l.tutorialStep13Title,
        description: l.tutorialStep13Desc,
        icon: Icons.more_vert,
        tip: l.tutorialStep13Tip,
      ),
      _TutorialChapter(l.tutorialChapter4),
      _TutorialStep(
        stepNumber: '14',
        title: l.tutorialStep14Title,
        description: l.tutorialStep14Desc,
        icon: Icons.lens_blur_outlined,
        tip: l.tutorialStep14Tip,
      ),
      _TutorialStep(
        stepNumber: '15',
        title: l.tutorialStep15Title,
        description: l.tutorialStep15Desc,
        icon: Icons.celebration_outlined,
        tip: l.tutorialStep15Tip,
      ),
      _TutorialStep(
        stepNumber: '16',
        title: l.tutorialStep16Title,
        description: l.tutorialStep16Desc,
        icon: Icons.spa_outlined,
        tip: l.tutorialStep16Tip,
      ),
      _TutorialStep(
        stepNumber: '17',
        title: l.tutorialStep17Title,
        description: l.tutorialStep17Desc,
        icon: Icons.speed_outlined,
        tip: l.tutorialStep17Tip,
      ),
      _TutorialChapter(l.tutorialChapter5),
      _TutorialStep(
        stepNumber: '18',
        title: l.tutorialStep18Title,
        description: l.tutorialStep18Desc,
        icon: Icons.history_outlined,
        tip: l.tutorialStep18Tip,
      ),
      _TutorialStep(
        stepNumber: '19',
        title: l.tutorialStep19Title,
        description: l.tutorialStep19Desc,
        icon: Icons.calendar_month_outlined,
        tip: l.tutorialStep19Tip,
      ),
      _TutorialStep(
        stepNumber: '20',
        title: l.tutorialStep20Title,
        description: l.tutorialStep20Desc,
        icon: Icons.insights_outlined,
        tip: l.tutorialStep20Tip,
      ),
      _TutorialChapter(l.tutorialChapter6),
      _TutorialStep(
        stepNumber: '21',
        title: l.tutorialStep21Title,
        description: l.tutorialStep21Desc,
        icon: Icons.volume_up_outlined,
        tip: l.tutorialStep21Tip,
      ),
      _TutorialStep(
        stepNumber: '22',
        title: l.tutorialStep22Title,
        description: l.tutorialStep22Desc,
        icon: Icons.vibration_outlined,
        tip: l.tutorialStep22Tip,
      ),
      _TutorialStep(
        stepNumber: '23',
        title: l.tutorialStep23Title,
        description: l.tutorialStep23Desc,
        icon: Icons.brightness_medium_outlined,
        tip: l.tutorialStep23Tip,
      ),
      _TutorialStep(
        stepNumber: '24',
        title: l.tutorialStep24Title,
        description: l.tutorialStep24Desc,
        icon: Icons.palette_outlined,
        tip: l.tutorialStep24Tip,
      ),
      _TutorialChapter(l.tutorialChapter7),
      _TutorialStep(
        stepNumber: '25',
        title: l.tutorialStep25Title,
        description: l.tutorialStep25Desc,
        icon: Icons.upload_file_outlined,
        tip: l.tutorialStep25Tip,
      ),
      _TutorialStep(
        stepNumber: '26',
        title: l.tutorialStep26Title,
        description: l.tutorialStep26Desc,
        icon: Icons.restore_outlined,
        tip: l.tutorialStep26Tip,
      ),
      _TutorialStep(
        stepNumber: '27',
        title: l.tutorialStep27Title,
        description: l.tutorialStep27Desc,
        icon: Icons.qr_code_scanner_outlined,
        tip: l.tutorialStep27Tip,
      ),
      _TutorialStep(
        stepNumber: '28',
        title: l.tutorialStep28Title,
        description: l.tutorialStep28Desc,
        icon: Icons.delete_forever_outlined,
        tip: l.tutorialStep28Tip,
      ),
      _TutorialChapter(l.tutorialChapter8),
      _TutorialStep(
        stepNumber: '29',
        title: l.tutorialStep29Title,
        description: l.tutorialStep29Desc,
        icon: Icons.shield_outlined,
        tip: l.tutorialStep29Tip,
      ),
      _TutorialStep(
        stepNumber: '30',
        title: l.tutorialStep30Title,
        description: l.tutorialStep30Desc,
        icon: Icons.verified_user_outlined,
        tip: l.tutorialStep30Tip,
      ),
    ];

    return Scaffold(
      backgroundColor: TempleColors.bg,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _topBar(context, l),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(18, 12, 18, 32),
                children: [
                  _headerCard(l),
                  const SizedBox(height: 20),
                  for (final item in items)
                    switch (item) {
                      _TutorialChapter() => _buildChapterHeader(item),
                      _TutorialStep() => Padding(
                        padding: const EdgeInsets.only(bottom: 14),
                        child: _buildStepCard(item),
                      ),
                    },
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _topBar(BuildContext context, AppLocalizations l) {
    return Container(
      padding: const EdgeInsets.fromLTRB(18, 18, 18, 14),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: TempleColors.line)),
      ),
      child: Row(
        children: [
          TempleIconButton(
            onTap: () => context.pop(),
            child: const Icon(
              Icons.arrow_back,
              size: 18,
              color: TempleColors.ink,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l.practiceEyebrow,
                  style: AppTheme.eyebrow(
                    letterSpacing: 3,
                    color: TempleColors.vermillion,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  l.tutorialTitle,
                  style: AppTheme.serif(fontSize: 26, height: 1),
                ),
              ],
            ),
          ),
          const TempleLotusIcon(size: 22),
        ],
      ),
    );
  }

  Widget _headerCard(AppLocalizations l) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: TempleColors.cardSoft,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: TempleColors.line),
      ),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: TempleColors.vermillion.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Center(
              child: Icon(
                Icons.auto_stories_outlined,
                color: TempleColors.vermillion,
                size: 28,
              ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l.tutorialTitle,
                  style: AppTheme.serif(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  l.tutorialSub,
                  style: AppTheme.sans(
                    fontSize: 12.5,
                    color: TempleColors.ink2,
                    height: 1.35,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChapterHeader(_TutorialChapter chapter) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 8, 4, 10),
      child: Row(
        children: [
          Container(
            width: 4,
            height: 18,
            decoration: BoxDecoration(
              color: TempleColors.vermillion,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              chapter.title,
              style: AppTheme.serif(fontSize: 18, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStepCard(_TutorialStep step) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: TempleColors.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: TempleColors.line),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: TempleColors.vermillion.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: Text(
                    step.stepNumber,
                    style: AppTheme.eyebrow(
                      color: TempleColors.vermillion,
                      fontWeight: FontWeight.w800,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  step.title,
                  style: AppTheme.sans(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Icon(step.icon, color: TempleColors.vermillion, size: 22),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            step.description,
            style: AppTheme.sans(
              fontSize: 13.5,
              color: TempleColors.ink2,
              height: 1.45,
            ),
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: TempleColors.cardSoft,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: TempleColors.line),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(
                  Icons.lightbulb_outline,
                  color: TempleColors.sandal,
                  size: 16,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    step.tip,
                    style: AppTheme.sans(
                      fontSize: 12,
                      color: TempleColors.ink2,
                      height: 1.35,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// One row in the tutorial list: a chapter heading or a step card.
sealed class _TutorialItem {
  const _TutorialItem();
}

class _TutorialChapter extends _TutorialItem {
  final String title;

  const _TutorialChapter(this.title);
}

class _TutorialStep extends _TutorialItem {
  final String stepNumber;
  final String title;
  final String description;
  final IconData icon;
  final String tip;

  const _TutorialStep({
    required this.stepNumber,
    required this.title,
    required this.description,
    required this.icon,
    required this.tip,
  });
}
