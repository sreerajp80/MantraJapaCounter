import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../config/theme.dart';
import '../widgets/temple_decorations.dart';

/// Brief practice guide. Reached via Settings -> Practice guide -> How it works,
/// or directly via the /help route.
class HelpScreen extends StatelessWidget {
  const HelpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TempleColors.bg,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _topBar(context),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(18, 8, 18, 28),
                children: const [
                  _HelpSection(
                    iconData: Icons.touch_app_outlined,
                    title: 'Counting',
                    body:
                        'Tap anywhere on the bead circle to count one chant. '
                        'Each 108 chants completes one mala — the ring fills as '
                        'the beads pass.',
                  ),
                  _HelpSection(
                    iconData: Icons.swipe_outlined,
                    title: 'Undoing a tap',
                    body:
                        'Place two fingers on the bead circle and swipe — left '
                        'or right — to undo your last chant. The session ends '
                        'gracefully if the count returns to zero.',
                  ),
                  _HelpSection(
                    iconData: Icons.timer_outlined,
                    title: 'Timer & status',
                    body:
                        'The pill at the top shows the time spent in this '
                        'session. The green marker below the count tells you '
                        'how many beads remain in the current mala, or that '
                        'the daily offering is complete.',
                  ),
                  _HelpSection(
                    iconData: Icons.refresh_outlined,
                    title: 'Resetting',
                    body:
                        'Open the menu (the three dots, top right of the '
                        'counting screen) for Reset session and Reset '
                        'counter. Reset session discards the current sitting; '
                        'Reset counter clears all history for that mantra.',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _topBar(BuildContext context) {
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
                  'PRACTICE',
                  style: AppTheme.eyebrow(
                    fontSize: 10,
                    letterSpacing: 3,
                    color: TempleColors.vermillion,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Help',
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
