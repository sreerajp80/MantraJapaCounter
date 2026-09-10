import 'package:flutter/material.dart';
import 'package:mantra_japa_counter/l10n/app_localizations.dart';
import 'package:mantra_japa_counter/models/counter.dart';

// ─── Add / Edit counter dialog ────────────────────────────────────────────────

class CounterDialog extends StatefulWidget {
  final Counter? existing;
  final void Function(
    String name,
    int startDate,
    int init,
    int step,
    int goal,
    int daily,
  )
  onSave;

  const CounterDialog({super.key, this.existing, required this.onSave});

  @override
  State<CounterDialog> createState() => _CounterDialogState();
}

class _CounterDialogState extends State<CounterDialog> {
  late final TextEditingController _name;
  late final TextEditingController _init;
  late final TextEditingController _step;
  late final TextEditingController _goal;
  late final TextEditingController _daily;
  late int _startDate;
  String? _dailyError;
  String? _stepError;

  @override
  void initState() {
    super.initState();
    final c = widget.existing;
    _name = TextEditingController(text: c?.name ?? '');
    _init = TextEditingController(text: (c?.initialCount ?? 0).toString());
    _step = TextEditingController(text: (c?.incrementStep ?? 1).toString());
    _goal = TextEditingController(text: (c?.goal ?? 0).toString());
    _daily = TextEditingController(text: (c?.dailyGoal ?? 0).toString());
    _startDate = c?.startDate ?? DateTime.now().millisecondsSinceEpoch;
  }

  @override
  void dispose() {
    _name.dispose();
    _init.dispose();
    _step.dispose();
    _goal.dispose();
    _daily.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final isEdit = widget.existing != null;
    return AlertDialog(
      title: Text(isEdit ? l.editCounterTitle : l.newCounterTitle),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _name,
              decoration: InputDecoration(labelText: l.counterNameLabel),
              textCapitalization: TextCapitalization.words,
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _init,
              decoration: InputDecoration(labelText: l.initialCountLabel),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: _step,
              decoration: InputDecoration(
                labelText: l.incrementStepLabel,
                errorText: _stepError,
              ),
              keyboardType: TextInputType.number,
              onChanged: (_) {
                if (_stepError != null) {
                  setState(() => _stepError = null);
                }
              },
            ),
            TextField(
              controller: _goal,
              decoration: InputDecoration(labelText: l.lifetimeGoalFieldLabel),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: _daily,
              decoration: InputDecoration(
                labelText: l.dailyGoalFieldLabel,
                errorText: _dailyError,
              ),
              keyboardType: TextInputType.number,
              onChanged: (_) {
                if (_dailyError != null || _stepError != null) {
                  setState(() {
                    _dailyError = null;
                    _stepError = null;
                  });
                }
              },
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Text(l.startDateLabel),
                TextButton(
                  onPressed: () async {
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: DateTime.fromMillisecondsSinceEpoch(
                        _startDate,
                      ),
                      firstDate: DateTime(2000),
                      lastDate: DateTime.now(),
                    );
                    if (picked != null) {
                      setState(() {
                        _startDate = picked.millisecondsSinceEpoch;
                      });
                    }
                  },
                  child: Text(
                    _formatDate(
                      DateTime.fromMillisecondsSinceEpoch(_startDate),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(l.cancel),
        ),
        TextButton(
          onPressed: () {
            final name = _name.text.trim();
            if (name.isEmpty) return;
            final goal = int.tryParse(_goal.text) ?? 0;
            final daily = int.tryParse(_daily.text) ?? 0;
            final step = int.tryParse(_step.text) ?? 1;
            if (goal > 0 && daily > goal) {
              setState(() {
                _dailyError = l.dailyExceedsLifetime;
              });
              return;
            }
            if (daily > 0 && step >= daily) {
              setState(() {
                _stepError = l.stepExceedsDaily;
              });
              return;
            }
            Navigator.pop(context);
            widget.onSave(
              name,
              _startDate,
              int.tryParse(_init.text) ?? 0,
              step,
              goal,
              daily,
            );
          },
          child: Text(isEdit ? l.save : l.create),
        ),
      ],
    );
  }

  String _formatDate(DateTime dt) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return '${months[dt.month - 1]} ${dt.day}, ${dt.year}';
  }
}
