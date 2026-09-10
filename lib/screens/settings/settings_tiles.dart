import 'package:flutter/material.dart';
import 'package:mantra_japa_counter/theme/theme.dart';

// ─── Settings card ────────────────────────────────────────────────────────────

class SettingsCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const SettingsCard({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: TempleColors.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: TempleColors.line),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: TempleColors.cardSoft,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: TempleColors.line),
                ),
                child: Center(
                  child: Icon(icon, color: TempleColors.vermillion, size: 22),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: AppTheme.sans(
                        fontSize: 15.5,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      subtitle,
                      style: AppTheme.sans(
                        fontSize: 12.5,
                        color: TempleColors.ink2,
                        height: 1.35,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.chevron_right,
                color: TempleColors.ink3,
                size: 18,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Section card ────────────────────────────────────────────────────────────

class SettingsSection extends StatelessWidget {
  final String title;
  final String sub;
  final Widget Function(double size, Color color) iconBuilder;
  final List<Widget> children;

  const SettingsSection({
    super.key,
    required this.title,
    required this.sub,
    required this.iconBuilder,
    required this.children,
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
                    child: iconBuilder(16, TempleColors.vermillion),
                  ),
                ),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: AppTheme.serif(fontSize: 18, height: 1)),
                    const SizedBox(height: 3),
                    Text(
                      sub,
                      style: AppTheme.sans(
                        fontSize: 12.5,
                        color: TempleColors.ink2,
                        letterSpacing: 0.3,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: TempleColors.card,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: TempleColors.line),
            ),
            clipBehavior: Clip.antiAlias,
            child: Column(children: _interleavedChildren()),
          ),
        ],
      ),
    );
  }

  List<Widget> _interleavedChildren() {
    final out = <Widget>[];
    for (var i = 0; i < children.length; i++) {
      out.add(children[i]);
      if (i < children.length - 1) {
        out.add(const Divider(height: 1, color: TempleColors.line));
      }
    }
    return out;
  }
}

// ─── Settings row ────────────────────────────────────────────────────────────

class SettingsRow extends StatelessWidget {
  final Widget leading;
  final String title;
  final String? sub;
  final String? right;
  final bool? toggle;
  final ValueChanged<bool>? onToggle;
  final VoidCallback? onTap;

  const SettingsRow({
    super.key,
    required this.leading,
    required this.title,
    this.sub,
    this.right,
    this.toggle,
    this.onToggle,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: toggle != null && onToggle != null
          ? () => onToggle!(!toggle!)
          : onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
        child: Row(
          children: [
            Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                color: TempleColors.cardSoft,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(child: leading),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTheme.sans(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  if (sub != null) ...[
                    const SizedBox(height: 3),
                    Text(
                      sub!,
                      style: AppTheme.sans(
                        fontSize: 13,
                        color: TempleColors.ink2,
                        fontWeight: FontWeight.w400,
                        height: 1.35,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            if (right != null)
              Text(
                right!,
                style: AppTheme.serif(
                  fontSize: 13,
                  color: TempleColors.vermillion,
                ),
              )
            else if (toggle != null)
              _Pill(value: toggle!)
            else
              const Icon(
                Icons.chevron_right,
                size: 16,
                color: TempleColors.ink3,
              ),
          ],
        ),
      ),
    );
  }
}

class _Pill extends StatelessWidget {
  final bool value;
  const _Pill({required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 22,
      decoration: BoxDecoration(
        color: value ? TempleColors.vermillion : TempleColors.line,
        borderRadius: BorderRadius.circular(11),
      ),
      child: AnimatedAlign(
        duration: const Duration(milliseconds: 160),
        alignment: value ? Alignment.centerRight : Alignment.centerLeft,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 2),
          child: Container(
            width: 18,
            height: 18,
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
          ),
        ),
      ),
    );
  }
}
