import 'package:material_ui/material_ui.dart';
import 'package:mantra_japa_counter/core/constants/app_constants.dart';
import 'package:mantra_japa_counter/theme/theme.dart';

// ─── Percent level slider ────────────────────────────────────────────────────

/// A settings row with a 10–100 % slider, used for the in-app sound volume
/// and vibration strength.
///
/// While the user drags, only the shown number changes. The value is handed
/// to [onChangeEnd] when the finger is lifted, so the setting is saved once
/// and a single sample sound or vibration can play.
class SettingsLevelSlider extends StatefulWidget {
  final IconData icon;
  final String title;
  final String sub;

  /// Optional extra line under the slider (for example a limit to know).
  final String? note;
  final int percent;
  final ValueChanged<int> onChangeEnd;

  const SettingsLevelSlider({
    super.key,
    required this.icon,
    required this.title,
    required this.sub,
    this.note,
    required this.percent,
    required this.onChangeEnd,
  });

  @override
  State<SettingsLevelSlider> createState() => _SettingsLevelSliderState();
}

class _SettingsLevelSliderState extends State<SettingsLevelSlider> {
  static const _min = AppConstants.feedbackLevelMinPercent;
  static const _max = AppConstants.feedbackLevelMaxPercent;

  /// The value while dragging; null when not dragging.
  double? _dragValue;

  @override
  Widget build(BuildContext context) {
    final shown = (_dragValue ?? widget.percent.toDouble()).clamp(
      _min.toDouble(),
      _max.toDouble(),
    );
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 2, right: 10),
                child: Icon(widget.icon, size: 16, color: TempleColors.ink2),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.title,
                      style: AppTheme.sans(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      widget.sub,
                      style: AppTheme.sans(
                        fontSize: 13,
                        color: TempleColors.ink2,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  Text(
                    shown.round().toString(),
                    style: AppTheme.serif(
                      fontSize: 22,
                      color: TempleColors.vermillion,
                      height: 1,
                    ),
                  ),
                  Text(
                    '%',
                    style: AppTheme.sans(
                      fontSize: 12,
                      color: TempleColors.ink3,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 6),
          Slider(
            value: shown,
            min: _min.toDouble(),
            max: _max.toDouble(),
            divisions: (_max - _min) ~/ 10,
            semanticFormatterCallback: (v) => '${v.round()}%',
            onChanged: (v) => setState(() => _dragValue = v),
            onChangeEnd: (v) {
              setState(() => _dragValue = null);
              widget.onChangeEnd(v.round());
            },
          ),
          if (widget.note != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Text(
                widget.note!,
                style: AppTheme.sans(
                  fontSize: 12.5,
                  color: TempleColors.ink3,
                  height: 1.35,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
