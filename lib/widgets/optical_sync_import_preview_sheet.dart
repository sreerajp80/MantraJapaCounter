import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../config/locale_config.dart';
import '../config/theme.dart';
import '../providers/optical_sync_provider.dart';

class OpticalSyncImportPreviewSheet extends ConsumerWidget {
  const OpticalSyncImportPreviewSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final receiveState = ref.watch(opticalSyncReceiveProvider);
    final theme = Theme.of(context);

    final counterCount = receiveState.counterCount;
    final sessionCount = receiveState.sessionCount;

    return Container(
      padding: const EdgeInsets.all(24.0),
      decoration: const BoxDecoration(
        color: TempleColors.bg,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.0)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: TempleColors.tulsi.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check_circle_outline,
                  color: TempleColors.tulsi,
                  size: 28,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Optical Sync Stream Complete',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: TempleColors.vermillion,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '100% offline payload reconstructed via camera scanner.',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: TempleColors.ink2,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: TempleColors.line),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatPill(
                  theme,
                  icon: Icons.auto_stories_outlined,
                  label: 'Counters',
                  value: '$counterCount',
                ),
                Container(height: 36, width: 1, color: TempleColors.line),
                _buildStatPill(
                  theme,
                  icon: Icons.history,
                  label: 'Session Logs',
                  value: '$sessionCount',
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: TempleColors.vermillion,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            icon: const Icon(Icons.download_done_rounded),
            label: const Text(
              'Import & Restore Data',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            onPressed: () async {
              final success = await ref
                  .read(opticalSyncReceiveProvider.notifier)
                  .importData();
              if (context.mounted) {
                context.pop(); // Close sheet
                if (success) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Optical sync import successful! Data restored.',
                      ),
                      backgroundColor: TempleColors.tulsi,
                    ),
                  );
                  context.pop(); // Exit scanner screen
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        receiveState.errorMessage ?? 'Failed to import data.',
                      ),
                      backgroundColor: TempleColors.vermillion,
                    ),
                  );
                }
              }
            },
          ),
          const SizedBox(height: 10),
          TextButton(
            onPressed: () => context.pop(),
            child: Text(
              LocaleConfig.strings().cancel,
              style: const TextStyle(color: TempleColors.ink2),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatPill(
    ThemeData theme, {
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Column(
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 18, color: TempleColors.sandal),
            const SizedBox(width: 6),
            Text(
              value,
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: TempleColors.vermillion,
              ),
            ),
          ],
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(color: TempleColors.ink3),
        ),
      ],
    );
  }
}
