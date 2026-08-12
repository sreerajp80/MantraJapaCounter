import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../config/theme.dart';
import '../l10n/app_localizations.dart';
import '../widgets/temple_decorations.dart';

/// Brief practice guide. Reached via Settings -> Practice guide -> How it works,
/// or directly via the /help route.
class HelpScreen extends StatelessWidget {
  const HelpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Scaffold(
      backgroundColor: TempleColors.bg,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _topBar(context, l),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(18, 8, 18, 28),
                children: [
                  _HelpSection(
                    iconData: Icons.touch_app_outlined,
                    title: l.helpCountingTitle,
                    body: l.helpCountingBody,
                  ),
                  _HelpSection(
                    iconData: Icons.swipe_outlined,
                    title: l.helpUndoTitle,
                    body: l.helpUndoBody,
                  ),
                  _HelpSection(
                    iconData: Icons.timer_outlined,
                    title: l.helpTimerTitle,
                    body: l.helpTimerBody,
                  ),
                  _HelpSection(
                    iconData: Icons.refresh_outlined,
                    title: l.helpResetTitle,
                    body: l.helpResetBody,
                  ),
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
            child: const Icon(Icons.arrow_back,
                size: 18, color: TempleColors.ink),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l.practiceEyebrow,
                  style: AppTheme.eyebrow(
                    fontSize: 10,
                    letterSpacing: 3,
                    color: TempleColors.vermillion,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  l.helpTitle,
                  style: AppTheme.serif(
                    fontSize: 28,
                    fontWeight: FontWeight.w500,
                    color: TempleColors.ink,
                    height: 1,
                  ),
                ),
              ],
            ),
          ),
          const TempleLotusIcon(size: 22, color: TempleColors.vermillion),
        ],
      ),
    );
  }
}

class _HelpSection extends StatelessWidget {
  final IconData iconData;
  final String title;
  final String body;

  const _HelpSection({
    required this.iconData,
    required this.title,
    required this.body,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(4, 8, 4, 12),
            child: Row(
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: TempleColors.cardSoft,
                    border: Border.fromBorderSide(
                      BorderSide(color: TempleColors.line),
                    ),
                  ),
                  child: Center(
                    child: Icon(
                      iconData,
                      size: 16,
                      color: TempleColors.vermillion,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  title,
                  style: AppTheme.serif(
                    fontSize: 18,
                    color: TempleColors.ink,
                    fontWeight: FontWeight.w500,
                    height: 1,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: TempleColors.card,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: TempleColors.line),
            ),
            child: Text(
              body,
              style: AppTheme.sans(
                fontSize: 13.5,
                color: TempleColors.ink,
                fontWeight: FontWeight.w400,
                height: 1.55,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
