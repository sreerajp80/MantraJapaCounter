import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mantra_japa_counter/theme/theme.dart';
import 'package:mantra_japa_counter/l10n/app_localizations.dart';
import 'package:mantra_japa_counter/widgets/temple_decorations.dart';

/// Step-by-step visual tutorial for new and returning users.
class TutorialHelpScreen extends StatelessWidget {
  const TutorialHelpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);

    final steps = [
      _TutorialStep(
        stepNumber: '01',
        title: l.tutorialStep1Title,
        description: l.tutorialStep1Desc,
        icon: Icons.add_circle_outline,
        tip:
            'Choose +1 for single chants, or +108 if you use an external physical mala and log by the mala.',
      ),
      _TutorialStep(
        stepNumber: '02',
        title: l.tutorialStep2Title,
        description: l.tutorialStep2Desc,
        icon: Icons.touch_app_outlined,
        tip:
            'Swipe down anywhere on the screen to undo an accidental tap instantly.',
      ),
      _TutorialStep(
        stepNumber: '03',
        title: l.tutorialStep3Title,
        description: l.tutorialStep3Desc,
        icon: Icons.lens_blur_outlined,
        tip:
            'The 27-segment bead progress strip on the card shows your daily mala progression at a glance.',
      ),
      _TutorialStep(
        stepNumber: '04',
        title: l.tutorialStep4Title,
        description: l.tutorialStep4Desc,
        icon: Icons.celebration_outlined,
        tip:
            'Configure sacred conch shells, bronze bells, or custom ringtones in Settings > Sound & Haptics.',
      ),
      _TutorialStep(
        stepNumber: '05',
        title: l.tutorialStep5Title,
        description: l.tutorialStep5Desc,
        icon: Icons.lock_outline,
        tip:
            'Long-press any counter card to lock it, preventing unintended count modifications.',
      ),
      _TutorialStep(
        stepNumber: '06',
        title: l.tutorialStep6Title,
        description: l.tutorialStep6Desc,
        icon: Icons.qr_code_scanner_outlined,
        tip:
            'Zero cables, zero pairing, and zero internet. Simply scan the animated QR code on the receiving phone.',
      ),
      _TutorialStep(
        stepNumber: '07',
        title: l.tutorialStep7Title,
        description: l.tutorialStep7Desc,
        icon: Icons.shield_outlined,
        tip:
            'Encrypted backups (.enc) use AES-256-GCM. Remember your passphrase; it cannot be recovered if lost.',
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
                  for (final s in steps) ...[
                    _buildStepCard(s),
                    const SizedBox(height: 14),
                  ],
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

class _TutorialStep {
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
