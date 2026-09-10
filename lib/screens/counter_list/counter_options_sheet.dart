import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mantra_japa_counter/theme/theme.dart';
import 'package:mantra_japa_counter/l10n/app_localizations.dart';
import 'package:mantra_japa_counter/models/counter.dart';
import 'package:mantra_japa_counter/models/counter_status.dart';
import 'package:mantra_japa_counter/providers/counters_provider.dart';
import 'package:mantra_japa_counter/screens/counter_list/counter_dialog.dart';

// ─── Options bottom sheet ─────────────────────────────────────────────────────

class CounterOptionsSheet extends StatelessWidget {
  final Counter counter;
  final WidgetRef ref;
  const CounterOptionsSheet({
    super.key,
    required this.counter,
    required this.ref,
  });

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 8),
          Container(
            width: 32,
            height: 4,
            decoration: BoxDecoration(
              color: TempleColors.line,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 12),
          ListTile(
            leading: const Icon(
              Icons.info_outline,
              color: TempleColors.vermillion,
            ),
            title: Text(l.aboutCounter),
            onTap: () {
              Navigator.pop(context);
              context.push('/counter/${counter.id}');
            },
          ),
          ListTile(
            leading: const Icon(Icons.history, color: TempleColors.vermillion),
            title: Text(l.history),
            onTap: () {
              Navigator.pop(context);
              context.push('/history?counterId=${counter.id}');
            },
          ),
          ListTile(
            leading: const Icon(Icons.edit, color: TempleColors.vermillion),
            title: Text(l.edit),
            onTap: () {
              Navigator.pop(context);
              showDialog(
                context: context,
                builder: (_) => CounterDialog(
                  existing: counter,
                  onSave: (name, startDate, init, step, goal, daily) {
                    ref
                        .read(countersNotifierProvider.notifier)
                        .updateCounter(
                          counter.copyWith(
                            name: name,
                            startDate: startDate,
                            initialCount: init,
                            incrementStep: step,
                            goal: goal,
                            dailyGoal: daily,
                          ),
                        );
                  },
                ),
              );
            },
          ),
          if (counter.isActive) ...[
            ListTile(
              leading: Icon(
                counter.isLocked ? Icons.lock_open : Icons.lock_outline,
                color: TempleColors.vermillion,
              ),
              title: Text(counter.isLocked ? l.unlockCounter : l.lockCounter),
              onTap: () {
                Navigator.pop(context);
                ref
                    .read(countersNotifierProvider.notifier)
                    .toggleLock(counter.id);
              },
            ),
            ListTile(
              leading: const Icon(
                Icons.check_circle,
                color: TempleColors.tulsi,
              ),
              title: Text(l.disableSuccess),
              onTap: () {
                Navigator.pop(context);
                _confirmDisable(context, CounterStatus.disabledSuccess);
              },
            ),
            ListTile(
              leading: const Icon(Icons.cancel, color: TempleColors.sandal),
              title: Text(l.disableFailure),
              onTap: () {
                Navigator.pop(context);
                _confirmDisable(context, CounterStatus.disabledFailure);
              },
            ),
          ],
          ListTile(
            leading: const Icon(
              Icons.delete,
              color: TempleColors.vermillionDeep,
            ),
            title: Text(
              l.delete,
              style: const TextStyle(color: TempleColors.vermillionDeep),
            ),
            onTap: () {
              Navigator.pop(context);
              _confirmDelete(context);
            },
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  void _confirmDelete(BuildContext context) {
    final l = AppLocalizations.of(context);
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(l.deleteCounterTitle),
        content: Text(l.deleteCounterMessage(counter.name)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(l.cancel),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              ref
                  .read(countersNotifierProvider.notifier)
                  .deleteCounter(counter.id);
            },
            child: Text(
              l.delete,
              style: const TextStyle(color: TempleColors.vermillionDeep),
            ),
          ),
        ],
      ),
    );
  }

  void _confirmDisable(BuildContext context, CounterStatus status) {
    final l = AppLocalizations.of(context);
    final reasonController = TextEditingController();
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(
          status == CounterStatus.disabledSuccess
              ? l.disableAsCompletedTitle
              : l.disableCounterTitle,
        ),
        content: TextField(
          controller: reasonController,
          decoration: InputDecoration(
            labelText: l.reasonOptional,
            hintText: l.reasonHint,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(l.cancel),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              ref
                  .read(countersNotifierProvider.notifier)
                  .disableCounter(
                    counter.id,
                    status,
                    reasonController.text.trim().isEmpty
                        ? null
                        : reasonController.text.trim(),
                  );
            },
            child: Text(l.confirm),
          ),
        ],
      ),
    );
  }
}
