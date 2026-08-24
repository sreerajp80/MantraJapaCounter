import 'package:flutter/material.dart';
import '../models/japa_session.dart';

/// List tile for a single session in the history screen.
class SessionListTile extends StatelessWidget {
  final JapaSession session;

  const SessionListTile({super.key, required this.session});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        child: Text(
          '${session.malas}',
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
        ),
      ),
      title: Text(
        session.counterName,
        style: const TextStyle(fontWeight: FontWeight.w600),
      ),
      subtitle: Text(
        '${session.count} counts · ${_formatDuration(session.duration)}',
        style: const TextStyle(fontSize: 12),
      ),
      trailing: Text(
        _formatTime(session.timestamp),
        style: const TextStyle(fontSize: 12, color: Colors.grey),
      ),
    );
  }

  String _formatDuration(int ms) {
    final secs = ms ~/ 1000;
    final mins = secs ~/ 60;
    final hours = mins ~/ 60;
    if (hours > 0) return '${hours}h ${mins % 60}m';
    if (mins > 0) return '${mins}m ${secs % 60}s';
    return '${secs}s';
  }

  String _formatTime(int ms) {
    final dt = DateTime.fromMillisecondsSinceEpoch(ms);
    final h = dt.hour.toString().padLeft(2, '0');
    final m = dt.minute.toString().padLeft(2, '0');
    return '$h:$m';
  }
}
