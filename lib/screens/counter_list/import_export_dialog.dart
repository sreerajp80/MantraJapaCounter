import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mantra_japa_counter/theme/theme.dart';
import 'package:mantra_japa_counter/l10n/app_localizations.dart';
import 'package:mantra_japa_counter/providers/counters_provider.dart';
import 'package:mantra_japa_counter/providers/app_providers.dart';
import 'package:mantra_japa_counter/services/export_service.dart';
import 'package:mantra_japa_counter/widgets/passphrase_dialog.dart';

// ─── Import / Export dialog ───────────────────────────────────────────────────

class ImportExportDialog extends StatefulWidget {
  final WidgetRef ref;
  const ImportExportDialog({super.key, required this.ref});

  @override
  State<ImportExportDialog> createState() => _ImportExportDialogState();
}

class _ImportExportDialogState extends State<ImportExportDialog> {
  bool _busy = false;
  String? _error;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return AlertDialog(
      title: Text(l.menuImportExport),
      content: _busy
          ? const SizedBox(
              height: 60,
              child: Center(child: CircularProgressIndicator()),
            )
          : Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (_error != null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Text(
                      _error!,
                      style: const TextStyle(
                        color: TempleColors.vermillionDeep,
                      ),
                    ),
                  ),
                Text(l.importExportBody),
              ],
            ),
      actions: _busy
          ? []
          : [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(l.cancel),
              ),
              TextButton(onPressed: _doExport, child: Text(l.export)),
              TextButton(onPressed: _doImport, child: Text(l.import)),
            ],
    );
  }

  Future<void> _doExport() async {
    final l = AppLocalizations.of(context);

    // Show passphrase dialog (user can skip encryption)
    final passphraseResult = await showExportPassphraseDialog(context);
    if (passphraseResult == null) return; // dismissed

    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      await widget.ref
          .read(exportServiceProvider)
          .exportAndShare(
            passphrase: passphraseResult.encrypt
                ? passphraseResult.passphrase
                : null,
          );
      if (mounted) Navigator.pop(context);
    } catch (e) {
      setState(() {
        _busy = false;
        _error = l.exportFailed('$e');
      });
    }
  }

  Future<void> _doImport() async {
    final l = AppLocalizations.of(context);
    final result = await FilePicker.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['json', 'enc'],
    );
    if (result == null || result.files.single.path == null) return;

    setState(() {
      _busy = true;
      _error = null;
    });

    try {
      final content = await File(result.files.single.path!).readAsString();
      final exportSvc = widget.ref.read(exportServiceProvider);

      try {
        await exportSvc.importFromJson(content);
      } on EncryptedExportException {
        // File is encrypted — prompt for passphrase
        if (!mounted) return;
        setState(() => _busy = false);

        final passphrase = await showImportPassphraseDialog(context);
        if (passphrase == null || !mounted) return;

        setState(() => _busy = true);
        try {
          await exportSvc.importEncryptedFromJson(content, passphrase);
        } catch (_) {
          setState(() {
            _busy = false;
            _error = l.decryptFailed;
          });
          return;
        }
      }

      widget.ref.invalidate(countersNotifierProvider);
      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(l.importSuccessful)));
      }
    } catch (e) {
      setState(() {
        _busy = false;
        _error = l.importFailed('$e');
      });
    }
  }
}
