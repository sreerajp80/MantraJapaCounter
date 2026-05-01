import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';

/// App info and credits screen.
class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('About')),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          Center(
            child: Icon(Icons.auto_awesome,
                size: 72, color: Theme.of(context).colorScheme.primary),
          ),
          const SizedBox(height: 16),
          const Center(
            child: Text('Mantra Japa Counter',
                style:
                    TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          ),
          Center(
            child: FutureBuilder<PackageInfo>(
              future: PackageInfo.fromPlatform(),
              builder: (context, snapshot) {
                final version = snapshot.data?.version ?? '';
                return Text(
                  version.isEmpty ? '' : 'Version $version',
                  style: const TextStyle(color: Colors.grey),
                );
              },
            ),
          ),
          const SizedBox(height: 32),
          _infoRow(Icons.info_outline, 'Purpose',
              'Track your mantra recitation practice with mala (108-bead round) counting, '
                  'daily and lifetime goals, and full session history.'),
          const SizedBox(height: 16),
          _infoRow(Icons.wifi_off, 'Fully offline',
              'No network access. All data stored only on your device.'),
          const SizedBox(height: 16),
          _infoRow(Icons.lock_outline, 'Privacy',
              'No analytics, no tracking, no data shared with anyone.'),
          const SizedBox(height: 16),
          _infoRow(Icons.backup, 'Backup',
              'Use Import / Export to back up your data to a JSON file.'),
          const SizedBox(height: 32),
          const Center(
            child: Text('Om Namah Shivaya',
                style: TextStyle(
                    fontSize: 16,
                    fontStyle: FontStyle.italic,
                    color: Colors.grey)),
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
