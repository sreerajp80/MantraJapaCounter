import 'package:flutter/material.dart';
import 'package:mantra_japa_counter/theme/theme.dart';
import 'package:mantra_japa_counter/l10n/app_localizations.dart';
import 'package:mantra_japa_counter/services/encryption_service.dart';

/// Result returned by the passphrase dialog.
class PassphraseDialogResult {
  /// The passphrase entered by the user. Null if encryption was skipped.
  final String? passphrase;

  /// Whether the user chose to encrypt.
  final bool encrypt;

  const PassphraseDialogResult({this.passphrase, this.encrypt = false});

  /// User skipped encryption.
  static const skipped = PassphraseDialogResult();
}

/// Shows a passphrase dialog for encrypting an export.
///
/// Returns a [PassphraseDialogResult] with the passphrase if the user chose
/// to encrypt, or [PassphraseDialogResult.skipped] if they skipped.
/// Returns null if the dialog was dismissed.
Future<PassphraseDialogResult?> showExportPassphraseDialog(
  BuildContext context,
) {
  return showDialog<PassphraseDialogResult>(
    context: context,
    barrierDismissible: false,
    builder: (_) => const _ExportPassphraseDialog(),
  );
}

/// Shows a passphrase dialog for decrypting an import.
///
/// Returns the passphrase string, or null if dismissed.
Future<String?> showImportPassphraseDialog(BuildContext context) {
  return showDialog<String>(
    context: context,
    barrierDismissible: false,
    builder: (_) => const _ImportPassphraseDialog(),
  );
}

// ────────────────────────── Export Passphrase Dialog ──────────────────────────

class _ExportPassphraseDialog extends StatefulWidget {
  const _ExportPassphraseDialog();

  @override
  State<_ExportPassphraseDialog> createState() =>
      _ExportPassphraseDialogState();
}

class _ExportPassphraseDialogState extends State<_ExportPassphraseDialog> {
  bool _encrypt = false;
  bool _obscure1 = true;
  bool _obscure2 = true;
  String? _error;
  final _passController = TextEditingController();
  final _confirmController = TextEditingController();

  @override
  void dispose() {
    _passController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_encrypt) {
      Navigator.pop(context, PassphraseDialogResult.skipped);
      return;
    }

    final pass = _passController.text;
    final confirm = _confirmController.text;
    final l = AppLocalizations.of(context);

    if (pass.length < EncryptionService.minPassphraseLength) {
      setState(() => _error = l.passphraseTooShort);
      return;
    }
    if (pass != confirm) {
      setState(() => _error = l.passphraseMismatch);
      return;
    }

    Navigator.pop(
      context,
      PassphraseDialogResult(passphrase: pass, encrypt: true),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final theme = Theme.of(context);

    return AlertDialog(
      backgroundColor: TempleColors.bg,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: Row(
        children: [
          const Icon(Icons.lock_outline, color: TempleColors.vermillion),
          const SizedBox(width: 10),
          Text(
            l.encryptBackup,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: TempleColors.vermillion,
            ),
          ),
        ],
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Encryption toggle
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(
                l.encryptBackup,
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              subtitle: Text(
                l.encryptBackupSub,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: TempleColors.ink2,
                ),
              ),
              value: _encrypt,
              activeTrackColor: TempleColors.vermillion,
              onChanged: (v) => setState(() {
                _encrypt = v;
                _error = null;
              }),
            ),
            if (_encrypt) ...[
              const SizedBox(height: 12),
              TextField(
                controller: _passController,
                obscureText: _obscure1,
                decoration: InputDecoration(
                  labelText: l.enterPassphrase,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(
                      color: TempleColors.vermillion,
                    ),
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscure1 ? Icons.visibility_off : Icons.visibility,
                    ),
                    onPressed: () => setState(() => _obscure1 = !_obscure1),
                  ),
                ),
                onChanged: (_) {
                  if (_error != null) setState(() => _error = null);
                },
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _confirmController,
                obscureText: _obscure2,
                decoration: InputDecoration(
                  labelText: l.confirmPassphrase,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(
                      color: TempleColors.vermillion,
                    ),
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscure2 ? Icons.visibility_off : Icons.visibility,
                    ),
                    onPressed: () => setState(() => _obscure2 = !_obscure2),
                  ),
                ),
                onChanged: (_) {
                  if (_error != null) setState(() => _error = null);
                },
              ),
            ],
            if (_error != null) ...[
              const SizedBox(height: 8),
              Text(
                _error!,
                style: const TextStyle(
                  color: TempleColors.vermillionDeep,
                  fontSize: 13,
                ),
              ),
            ],
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(
            l.cancel,
            style: const TextStyle(color: TempleColors.ink2),
          ),
        ),
        if (!_encrypt)
          TextButton(
            onPressed: _submit,
            child: Text(
              l.skipEncryption,
              style: const TextStyle(color: TempleColors.vermillion),
            ),
          ),
        if (_encrypt)
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: TempleColors.vermillion,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: _submit,
            child: Text(l.continueAction),
          ),
      ],
    );
  }
}

// ────────────────────────── Import Passphrase Dialog ──────────────────────────

class _ImportPassphraseDialog extends StatefulWidget {
  const _ImportPassphraseDialog();

  @override
  State<_ImportPassphraseDialog> createState() =>
      _ImportPassphraseDialogState();
}

class _ImportPassphraseDialogState extends State<_ImportPassphraseDialog> {
  bool _obscure = true;
  String? _error;
  final _passController = TextEditingController();

  @override
  void dispose() {
    _passController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final theme = Theme.of(context);

    return AlertDialog(
      backgroundColor: TempleColors.bg,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: Row(
        children: [
          const Icon(Icons.lock_open_outlined, color: TempleColors.vermillion),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              l.decryptBackup,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: TempleColors.vermillion,
              ),
            ),
          ),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l.decryptPassphrasePrompt,
            style: theme.textTheme.bodySmall?.copyWith(
              color: TempleColors.ink2,
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _passController,
            obscureText: _obscure,
            autofocus: true,
            decoration: InputDecoration(
              labelText: l.enterPassphrase,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: TempleColors.vermillion),
              ),
              suffixIcon: IconButton(
                icon: Icon(_obscure ? Icons.visibility_off : Icons.visibility),
                onPressed: () => setState(() => _obscure = !_obscure),
              ),
            ),
            onChanged: (_) {
              if (_error != null) setState(() => _error = null);
            },
          ),
          if (_error != null) ...[
            const SizedBox(height: 8),
            Text(
              _error!,
              style: const TextStyle(
                color: TempleColors.vermillionDeep,
                fontSize: 13,
              ),
            ),
          ],
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(
            l.cancel,
            style: const TextStyle(color: TempleColors.ink2),
          ),
        ),
        ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            backgroundColor: TempleColors.vermillion,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          icon: const Icon(Icons.lock_open, size: 18),
          label: Text(l.decryptBackup),
          onPressed: () {
            final pass = _passController.text;
            if (pass.isEmpty) {
              setState(() => _error = l.passphraseTooShort);
              return;
            }
            Navigator.pop(context, pass);
          },
        ),
      ],
    );
  }
}
