import 'package:cupertino_ui/cupertino_ui.dart';
import 'package:material_ui/material_ui.dart';
// Material and Cupertino delegates now come from material_ui / cupertino_ui.
// Only the widgets-level delegate still lives in flutter_localizations.
import 'package:flutter_localizations/flutter_localizations.dart'
    show GlobalWidgetsLocalizations;

/// flutter_localizations has no Sanskrit ('sa') translation. This delegate
/// answers for Locale('sa') by loading the English framework strings, so the
/// app's own Sanskrit strings render while Material widgets still work.
class SaMaterialLocalizationsDelegate
    extends LocalizationsDelegate<MaterialLocalizations> {
  const SaMaterialLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => locale.languageCode == 'sa';

  @override
  Future<MaterialLocalizations> load(Locale locale) =>
      GlobalMaterialLocalizations.delegate.load(const Locale('en'));

  @override
  bool shouldReload(covariant LocalizationsDelegate old) => false;
}

class SaCupertinoLocalizationsDelegate
    extends LocalizationsDelegate<CupertinoLocalizations> {
  const SaCupertinoLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => locale.languageCode == 'sa';

  @override
  Future<CupertinoLocalizations> load(Locale locale) =>
      GlobalCupertinoLocalizations.delegate.load(const Locale('en'));

  @override
  bool shouldReload(covariant LocalizationsDelegate old) => false;
}

class SaWidgetsLocalizationsDelegate
    extends LocalizationsDelegate<WidgetsLocalizations> {
  const SaWidgetsLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => locale.languageCode == 'sa';

  @override
  Future<WidgetsLocalizations> load(Locale locale) =>
      GlobalWidgetsLocalizations.delegate.load(const Locale('en'));

  @override
  bool shouldReload(covariant LocalizationsDelegate old) => false;
}
