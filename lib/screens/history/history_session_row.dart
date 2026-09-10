import 'package:flutter/material.dart';
import 'package:mantra_japa_counter/theme/theme.dart';
import 'package:mantra_japa_counter/l10n/app_localizations.dart';
import 'package:mantra_japa_counter/models/japa_session.dart';

// ─── Individual session row ──────────────────────────────────────────────────

class HistorySessionRow extends StatelessWidget {
  final AppLocalizations l;
  final JapaSession session;
  final bool showCounterName;
  final VoidCallback onDelete;

  const HistorySessionRow({
    super.key,
    required this.l,
    required this.session,
    required this.showCounterName,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(58, 6, 0, 6),
      child: Row(
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: TempleColors.tulsi,
            ),
          ),
          const SizedBox(width: 10),
          SizedBox(
            width: 44,
            child: Text(
              _formatTime(session.timestamp),
              style: AppTheme.serif(fontSize: 13, color: TempleColors.ink2),
            ),
          ),
          const SizedBox(width: 6),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        _detailLine(),
                        style: AppTheme.serif(
                          fontSize: 13,
                          color: TempleColors.ink2,
                          fontWeight: FontWeight.w400,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                if (showCounterName)
                  Padding(
                    padding: const EdgeInsets.only(top: 2),
                    child: Text(
                      session.counterName,
                      style: AppTheme.sans(
                        fontSize: 11,
                        color: TempleColors.ink2,
                        fontWeight: FontWeight.w400,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
              ],
            ),
          ),
          IconButton(
            onPressed: onDelete,
            icon: const Icon(
              Icons.delete_outline,
              size: 18,
              color: TempleColors.ink2,
            ),
            visualDensity: VisualDensity.compact,
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
            tooltip: l.deleteSessionTooltip,
          ),
        ],
      ),
    );
  }

  String _detailLine() {
    final parts = <String>[l.chantsCount(session.count.toString())];
    if (session.malas > 0) {
      parts.add(l.malaCount(session.malas));
    }
    if (session.duration > 0) {
      parts.add(_formatDuration(session.duration));
    }
    return parts.join(' · ');
  }

  String _formatTime(int ms) {
    final dt = DateTime.fromMillisecondsSinceEpoch(ms);
    final h = dt.hour.toString().padLeft(2, '0');
    final m = dt.minute.toString().padLeft(2, '0');
    return '$h:$m';
  }

  String _formatDuration(int ms) {
    final mins = ms ~/ 60000;
    final hours = mins ~/ 60;
    if (hours > 0) return '${hours}h ${mins % 60}m';
    if (mins > 0) return '${mins}m';
    final secs = ms ~/ 1000;
    return '${secs}s';
  }
}
