import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import '../l10n/app_localizations.dart';

/// App info and credits screen.
class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(l.aboutTitle)),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          Center(
            child: Icon(Icons.auto_awesome,
                size: 72, color: Theme.of(context).colorScheme.primary),
          ),
          const SizedBox(height: 16),
          Center(
            child: Text(l.appTitle,
                style: const TextStyle(
                    fontSize: 22, fontWeight: FontWeight.bold)),
          ),
          Center(
            child: FutureBuilder<PackageInfo>(
              future: PackageInfo.fromPlatform(),
              builder: (context, snapshot) {
                final version = snapshot.data?.version ?? '';
                return Text(
                  version.isEmpty ? '' : l.versionLabel(version),
                  style: const TextStyle(color: Colors.grey),
                );
              },
            ),
          ),
          const SizedBox(height: 32),
          _infoRow(Icons.info_outline, l.aboutPurposeTitle, l.aboutPurposeBody),
          const SizedBox(height: 16),
          _infoRow(Icons.wifi_off, l.aboutOfflineTitle, l.aboutOfflineBody),
          const SizedBox(height: 16),
          _infoRow(Icons.lock_outline, l.aboutPrivacyTitle, l.aboutPrivacyBody),
          const SizedBox(height: 16),
          _infoRow(Icons.backup, l.aboutBackupTitle, l.aboutBackupBody),
          const SizedBox(height: 32),
          Center(
            child: Text(l.aboutMantraQuote,
                style: const TextStyle(
                    fontSize: 16,
                    fontStyle: FontStyle.italic,
                    color: Colors.grey)),
          ),
          const SizedBox(height: 24),
          Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(l.aboutMadeWithPrefix,
                    style: const TextStyle(fontSize: 14, color: Colors.grey)),
                const Icon(Icons.favorite, color: Colors.red, size: 16),
                Text(l.aboutMadeWithSuffix,
                    style: const TextStyle(fontSize: 14, color: Colors.grey)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoRow(IconData icon, String title, String body) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 24, color: Colors.grey),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 15)),
              const SizedBox(height: 4),
              Text(body,
                  style: const TextStyle(color: Colors.grey, height: 1.4)),
            ],
          ),
        ),
      ],
    );
  }
}
