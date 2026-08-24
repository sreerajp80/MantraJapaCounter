import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../config/theme.dart';
import '../../l10n/app_localizations.dart';
import '../../widgets/temple_decorations.dart';

/// Top bar for individual help topic screens.
class HelpDetailTopBar extends StatelessWidget {
  final String title;

  const HelpDetailTopBar({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
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
                    fontSize: 10,
                    letterSpacing: 3,
                    color: TempleColors.vermillion,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  title,
                  style: AppTheme.serif(
                    fontSize: 24,
                    fontWeight: FontWeight.w500,
                    color: TempleColors.ink,
                    height: 1,
                  ),
                ),
              ],
            ),
          ),
          const TempleLotusIcon(size: 20, color: TempleColors.vermillion),
        ],
      ),
    );
  }
}

/// Introductory callout banner on a help topic screen.
class HelpIntroCard extends StatelessWidget {
  final String text;

  const HelpIntroCard(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: TempleColors.cardSoft,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: TempleColors.line),
      ),
      child: Text(
        text,
        style: AppTheme.sans(
          fontSize: 13.5,
          color: TempleColors.ink,
          height: 1.5,
        ),
      ),
    );
  }
}

/// Section container holding related bullet points or paragraphs.
class HelpSection extends StatelessWidget {
  final IconData icon;
  final String title;
  final List<Widget> children;

  const HelpSection({
    super.key,
    required this.icon,
    required this.title,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 16, color: TempleColors.vermillion),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                title,
                style: AppTheme.serif(
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                  color: TempleColors.ink,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: TempleColors.card,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: TempleColors.line),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: children,
          ),
        ),
      ],
    );
  }
}

/// Bullet point item with temple dot indicator.
class HelpBullet extends StatelessWidget {
  final String text;
  final String? boldPrefix;

  const HelpBullet(this.text, {super.key, this.boldPrefix});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 6, right: 10),
            width: 6,
            height: 6,
            decoration: const BoxDecoration(
              color: TempleColors.vermillion,
              shape: BoxShape.circle,
            ),
          ),
          Expanded(
            child: RichText(
              text: TextSpan(
                style: AppTheme.sans(
                  fontSize: 13,
                  color: TempleColors.ink,
                  height: 1.45,
                ),
                children: [
                  if (boldPrefix != null)
                    TextSpan(
                      text: '$boldPrefix ',
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                  TextSpan(text: text),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
