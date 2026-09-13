import 'package:flutter/material.dart';
import 'package:mantra_japa_counter/core/config/app_config.dart';
import 'package:mantra_japa_counter/core/config/config_service.dart';
import 'package:mantra_japa_counter/core/flavor/flavor_config.dart';
import 'package:mantra_japa_counter/l10n/app_localizations.dart';
import 'package:mantra_japa_counter/core/utils/build_date.g.dart';
import 'package:mantra_japa_counter/widgets/made_with_love.dart';

/// App info and credits screen.
/// Data-driven: reads values from `ConfigService` and iterates `AppConfig.details` dynamically.
class AboutScreen extends StatelessWidget {
  final ConfigService _configService;

  AboutScreen({super.key, ConfigService? configService})
    : _configService = configService ?? ConfigService();

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final lang = Localizations.localeOf(context).languageCode;
    return Scaffold(
      appBar: AppBar(title: Text(l.aboutTitle)),
      body: FutureBuilder<AppConfig>(
        future: _configService.loadAndVerify(),
        builder: (context, snapshot) {
          final config = snapshot.data ?? AppConfig.fallback;
          final displayedAppName = _resolveAppName(l, config.appName, lang);
          final displayedDescription = _resolveDescription(
            l,
            config.description,
            lang,
          );

          return ListView(
            padding: const EdgeInsets.all(24),
            children: [
              Center(
                child: Icon(
                  Icons.auto_awesome,
                  size: 72,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              const SizedBox(height: 16),
              Center(
                child: Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  alignment: WrapAlignment.center,
                  spacing: 8,
                  runSpacing: 4,
                  children: [
                    Text(
                      displayedAppName,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (AppFlavorConfig.isDev)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primaryContainer,
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(
                            color: Theme.of(
                              context,
                            ).colorScheme.primary.withValues(alpha: 0.35),
                          ),
                        ),
                        child: Text(
                          'DEV',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.8,
                            color: Theme.of(
                              context,
                            ).colorScheme.onPrimaryContainer,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 4),
              Center(
                child: Text(
                  config.version.isNotEmpty
                      ? l.versionLabel('${config.version}+${config.build}')
                      : '',
                  style: const TextStyle(color: Colors.grey),
                ),
              ),
              if (kBuildDate.isNotEmpty) ...[
                const SizedBox(height: 2),
                Center(
                  child: Text(
                    l.aboutBuildDate(kBuildDate),
                    style: const TextStyle(color: Colors.grey, fontSize: 13),
                  ),
                ),
              ],
              if (displayedDescription.isNotEmpty) ...[
                const SizedBox(height: 12),
                Center(
                  child: Text(
                    displayedDescription,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                ),
              ],
              const SizedBox(height: 32),
              _infoRow(
                Icons.info_outline,
                l.aboutPurposeTitle,
                l.aboutPurposeBody,
              ),
              const SizedBox(height: 16),
              _infoRow(Icons.wifi_off, l.aboutOfflineTitle, l.aboutOfflineBody),
              const SizedBox(height: 16),
              _infoRow(
                Icons.lock_outline,
                l.aboutPrivacyTitle,
                l.aboutPrivacyBody,
              ),
              const SizedBox(height: 16),
              _infoRow(Icons.backup, l.aboutBackupTitle, l.aboutBackupBody),
              const SizedBox(height: 24),
              const Divider(),
              const SizedBox(height: 8),
              // Dynamic details rendered from AppConfig.details
              for (final entry in config.details.entries)
                if (entry.key.trim().isNotEmpty &&
                    entry.value.resolve(lang).trim().isNotEmpty)
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(
                      aboutDetailLabel(l, entry.key),
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                    subtitle: Text(
                      entry.value.resolve(lang),
                      style: const TextStyle(color: Colors.grey),
                    ),
                  ),
              const SizedBox(height: 24),
              Center(
                child: Text(
                  l.aboutMantraQuote,
                  style: const TextStyle(
                    fontSize: 16,
                    fontStyle: FontStyle.italic,
                    color: Colors.grey,
                  ),
                ),
              ),
              const MadeWithLove(),
            ],
          );
        },
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
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                body,
                style: const TextStyle(color: Colors.grey, height: 1.4),
              ),
            ],
          ),
        ),
      ],
    );
  }

  String _resolveAppName(
    AppLocalizations l,
    LocalizedText configAppName,
    String lang,
  ) {
    final text = configAppName.resolve(lang).trim();
    if (text.isEmpty ||
        text == 'SreerajP MantraJapa Counter' ||
        text == 'SreerajP MantraJapa Counter Dev') {
      return l.appTitle;
    }
    return text;
  }

  String _resolveDescription(
    AppLocalizations l,
    LocalizedText configDescription,
    String lang,
  ) {
    final text = configDescription.resolve(lang).trim();
    const defaultDesc =
        'Offline-first application for tracking mantra recitation practice with customizable counters and session history.';
    if (text.isEmpty || text == defaultDesc) {
      return l.aboutDescription;
    }
    return text;
  }

  static String aboutDetailLabel(AppLocalizations l10n, String key) {
    switch (key.trim()) {
      case 'author':
      case 'Author':
        return l10n.aboutDetailAuthor;
      case 'email':
      case 'Email':
        return l10n.aboutDetailEmail;
      case 'license':
      case 'License':
        return l10n.aboutDetailLicense;
      case 'aiUsed':
      case 'AI used':
        return l10n.aboutDetailAiUsed;
      case 'ideUsed':
      case 'IDE used':
        return l10n.aboutDetailIdeUsed;
      default:
        return key;
    }
  }
}
