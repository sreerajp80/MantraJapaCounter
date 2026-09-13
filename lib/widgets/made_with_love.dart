import 'package:flutter/material.dart';
import 'package:mantra_japa_counter/l10n/app_localizations.dart';

/// The fixed "Made with ❤️ from India" badge shown at the bottom of every
/// About screen. Text is localized; the heart is always red.
class MadeWithLove extends StatelessWidget {
  const MadeWithLove({super.key});

  static const Color _heartColor = Color(0xFFE53935);

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final base = (theme.textTheme.bodySmall ?? const TextStyle(fontSize: 12))
        .copyWith(color: theme.colorScheme.onSurfaceVariant);

    // Split the localized template around the {heart} placeholder so the
    // heart keeps its own colour in every language. A sentinel that can never
    // appear in translated text makes the split exact.
    const sentinel = '\u0000';
    final parts = l10n.madeWithLove(sentinel).split(sentinel);

    return Semantics(
      label: l10n.madeWithLoveA11y,
      excludeSemantics: true,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 24),
        child: Center(
          child: Text.rich(
            TextSpan(
              children: [
                TextSpan(text: parts.first, style: base),
                WidgetSpan(
                  alignment: PlaceholderAlignment.middle,
                  child: Icon(
                    Icons.favorite,
                    size: (base.fontSize ?? 12) * 1.1,
                    color: _heartColor,
                  ),
                ),
                TextSpan(text: parts.length > 1 ? parts[1] : '', style: base),
              ],
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
