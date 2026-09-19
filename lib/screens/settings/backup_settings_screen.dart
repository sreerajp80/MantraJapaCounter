import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mantra_japa_counter/theme/theme.dart';
import 'package:mantra_japa_counter/l10n/app_localizations.dart';
import 'package:mantra_japa_counter/providers/app_providers.dart';
import 'package:mantra_japa_counter/providers/counters_provider.dart';
import 'package:mantra_japa_counter/widgets/temple_decorations.dart';
import 'package:mantra_japa_counter/screens/settings/settings_tiles.dart';
import 'package:mantra_japa_counter/services/export_service.dart';
import 'package:mantra_japa_counter/widgets/passphrase_dialog.dart';

/// Dedicated Backup & Restore settings screen.
class BackupSettingsScreen extends ConsumerWidget {
  const BackupSettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: TempleColors.bg,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _topBar(context, l),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(18, 12, 18, 32),
                children: [
                  // Air-Gapped Optical Sync Section
                  SettingsSection(
                    title: l.helpCategorySync,
                    sub: l.helpTopicOpticalSyncSub,
                    iconBuilder: (s, c) => Icon(Icons.sync, size: s, color: c),
                    children: [
                      SettingsRow(
                        leading: const Icon(
                          Icons.qr_code_2_outlined,
                          size: 16,
                          color: TempleColors.ink2,
                        ),
                        title: l.settingsOpticalSendTitle,
                        sub: l.settingsOpticalSendSub,
                        onTap: () =>
                            context.push('/backup/optical-sync/transmit'),
                      ),
                      SettingsRow(
                        leading: const Icon(
                          Icons.qr_code_scanner_outlined,
                          size: 16,
                          color: TempleColors.ink2,
                        ),
                        title: l.settingsOpticalReceiveTitle,
                        sub: l.settingsOpticalReceiveSub,
                        onTap: () =>
                            context.push('/backup/optical-sync/receive'),
                      ),
                    ],
                  ),

                  // File Export & Import Section
                  SettingsSection(
                    title: l.settingsBackupTitle,
                    sub: l.settingsBackupSub,
                    iconBuilder: (s, c) =>
                        Icon(Icons.folder_zip_outlined, size: s, color: c),
                    children: [
                      SettingsRow(
                        leading: const Icon(
                          Icons.upload_file_outlined,
                          size: 16,
                          color: TempleColors.ink2,
                        ),
                        title: l.settingsExportTitle,
                        sub: l.settingsExportSub,
                        onTap: () => _doExport(context, ref),
                      ),
                      SettingsRow(
                        leading: const Icon(
                          Icons.download_for_offline_outlined,
                          size: 16,
                          color: TempleColors.ink2,
                        ),
                        title: l.settingsImportTitle,
                        sub: l.settingsImportSub,
                        onTap: () => _doImport(context, ref),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  // Clear all data danger action
                  SettingsSection(
                    title: l.settingsClearDataTitle,
                    sub: l.settingsClearDataSub,
                    iconBuilder: (s, c) => Icon(
                      Icons.delete_forever_outlined,
                      size: s,
                      color: TempleColors.vermillionDeep,
                    ),
                    children: [
                      SettingsRow(
                        leading: const Icon(
                          Icons.warning_amber_rounded,
                          size: 16,
                          color: TempleColors.vermillionDeep,
                        ),
                        title: l.clearAllDataTitle,
                        sub: l.clearAllDataMessage,
                        onTap: () => _confirmClearAll(context, ref),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _topBar(BuildContext context, AppLocalizations l) {
    return Container(
      padding: const EdgeInsets.fromLTRB(18, 18, 18, 14),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: TempleColors.line)),
      ),
      child: Row(
        children: [
          TempleIconButton(
            onTap: () => context.pop(),
            child: const Icon(
              Icons.arrow_back,
              size: 18,
              color: TempleColors.ink,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l.practiceEyebrow,
                  style: AppTheme.eyebrow(
                    letterSpacing: 3,
                    color: TempleColors.vermillion,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  l.settingsBackupTitle,
                  style: AppTheme.serif(fontSize: 26, height: 1),
                ),
              ],
            ),
          ),
          const TempleLotusIcon(size: 22),
        ],
      ),
    );
  }

  Future<void> _doExport(BuildContext context, WidgetRef ref) async {
    final l = AppLocalizations.of(context);
    final result = await showExportPassphraseDialog(context);
    if (result == null) return;

    try {
      await ref
          .read(exportServiceProvider)
          .exportAndShare(
            passphrase: result.encrypt ? result.passphrase : null,
          );
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(l.exportFailed('$e'))));
      }
    }
  }

  Future<void> _doImport(BuildContext context, WidgetRef ref) async {
    final l = AppLocalizations.of(context);
    try {
      final result = await FilePicker.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['json', 'enc'],
      );
      final pickedPath = result?.files.single.path;
      if (pickedPath == null) return;

      final content = await File(pickedPath).readAsString();
      final exportSvc = ref.read(exportServiceProvider);

      try {
        await exportSvc.importFromJson(content);
      } on EncryptedExportException {
        if (!context.mounted) return;
        final passphrase = await showImportPassphraseDialog(context);
        if (passphrase == null || !context.mounted) return;

        try {
          await exportSvc.importEncryptedFromJson(content, passphrase);
        } catch (_) {
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(l.decryptFailed),
                backgroundColor: TempleColors.vermillionDeep,
              ),
            );
          }
          return;
        }
      }

      ref.invalidate(countersNotifierProvider);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l.dataRestoredSuccess),
            backgroundColor: TempleColors.tulsi,
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(l.importFailed('$e'))));
      }
    }
  }

  void _confirmClearAll(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(l.clearAllDataTitle),
        content: Text(l.clearAllDataMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l.cancel),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              final repo = ref.read(japaCounterRepositoryProvider);
              await repo.deleteAllSessions();
              await repo.deleteAllCounters();
              ref.invalidate(countersNotifierProvider);
              if (context.mounted) {
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text(l.allDataCleared)));
              }
            },
            child: Text(
              l.clearAllButton,
              style: const TextStyle(color: TempleColors.vermillionDeep),
            ),
          ),
        ],
      ),
    );
  }
}
