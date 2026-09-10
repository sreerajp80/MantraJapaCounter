import 'package:flutter/material.dart';
import 'package:mantra_japa_counter/theme/theme.dart';
import 'package:mantra_japa_counter/l10n/app_localizations.dart';

// ─── Brightness row ──────────────────────────────────────────────────────────

class SettingsBrightnessRow extends StatelessWidget {
  final double value;
  final bool usingSystem;
  final ValueChanged<double> onChanged;
  final VoidCallback onReset;

  const SettingsBrightnessRow({
    super.key,
    required this.value,
    required this.usingSystem,
    required this.onChanged,
    required this.onReset,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppLocalizations.of(context).brightnessLevel,
                      style: AppTheme.sans(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      usingSystem
                          ? AppLocalizations.of(context).followingSystem
                          : AppLocalizations.of(context).overrideActive,
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
                    (value * 100).round().toString(),
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
          const SizedBox(height: 10),
          Slider(value: value.clamp(0.0, 1.0), onChanged: onChanged),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  AppLocalizations.of(context).brightnessStill,
                  style: AppTheme.serif(
                    fontSize: 10,
                    color: TempleColors.ink3,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                TextButton(
                  onPressed: onReset,
                  style: TextButton.styleFrom(
                    visualDensity: VisualDensity.compact,
                    padding: const EdgeInsets.symmetric(horizontal: 6),
                    minimumSize: Size.zero,
                  ),
                  child: Text(
                    AppLocalizations.of(context).brightnessUseSystem,
                    style: AppTheme.sans(
                      fontSize: 11,
                      color: TempleColors.vermillion,
                    ),
                  ),
                ),
                Text(
                  AppLocalizations.of(context).brightnessFull,
                  style: AppTheme.serif(
                    fontSize: 10,
                    color: TempleColors.ink3,
                    fontWeight: FontWeight.w400,
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
