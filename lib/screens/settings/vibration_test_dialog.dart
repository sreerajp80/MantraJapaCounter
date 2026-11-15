import 'package:material_ui/material_ui.dart';
import 'package:mantra_japa_counter/l10n/app_localizations.dart';
import 'package:mantra_japa_counter/theme/theme.dart';

/// Plays one test vibration and asks "Did you feel a vibration?".
///
/// Shown when the user turns on a vibration setting. Android lets the phone's
/// own vibration settings limit every app, and gives apps no reliable way to
/// read them, so the user's own hand is the test. On "No" the dialog explains
/// this and offers to open the phone's settings. The app setting stays on
/// either way.
///
/// [playTest] plays the test vibration; [openPhoneSettings] opens the phone's
/// Sound & vibration page.
Future<void> showVibrationTestDialog(
  BuildContext context, {
  required Future<void> Function() playTest,
  required Future<void> Function() openPhoneSettings,
}) async {
  await playTest();
  if (!context.mounted) return;
  await showDialog<void>(
    context: context,
    builder: (_) => _VibrationTestDialog(
      playTest: playTest,
      openPhoneSettings: openPhoneSettings,
    ),
  );
}

class _VibrationTestDialog extends StatefulWidget {
  final Future<void> Function() playTest;
  final Future<void> Function() openPhoneSettings;

  const _VibrationTestDialog({
    required this.playTest,
    required this.openPhoneSettings,
  });

  @override
  State<_VibrationTestDialog> createState() => _VibrationTestDialogState();
}

class _VibrationTestDialogState extends State<_VibrationTestDialog> {
  /// False while asking; true after the user answered "No".
  bool _notFelt = false;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    const accent = TextStyle(color: TempleColors.vermillion);

    if (_notFelt) {
      return AlertDialog(
        title: Text(l.vibrationOffTitle),
        content: Text(l.vibrationOffBody),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l.vibrationTestClose),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              widget.openPhoneSettings();
            },
            child: Text(l.openPhoneSettings, style: accent),
          ),
        ],
      );
    }

    return AlertDialog(
      title: Text(l.vibrationTestTitle),
      content: Text(l.vibrationTestBody),
      actions: [
        TextButton(
          onPressed: widget.playTest,
          child: Text(l.vibrationTestAgain),
        ),
        TextButton(
          onPressed: () => setState(() => _notFelt = true),
          child: Text(l.vibrationTestNo),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(l.vibrationTestYes, style: accent),
        ),
      ],
    );
  }
}
