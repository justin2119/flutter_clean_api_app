import 'package:flutter/widgets.dart';

/// Petit dictionnaire bilingue : une solution simple et lisible pour débuter.
class AppLocalizations {
  const AppLocalizations(this.locale);
  final Locale locale;

  static const supportedLocales = [Locale('fr'), Locale('en')];
  bool get isFrench => locale.languageCode == 'fr';

  String get appTitle => isFrench ? 'Actualités' : 'News';
  String get home => isFrench ? 'Accueil' : 'Home';
  String get bookmarks => isFrench ? 'Favoris' : 'Bookmarks';
  String get search => isFrench ? 'Rechercher' : 'Search';
  String get settings => isFrench ? 'Réglages' : 'Settings';
  String get language => isFrench ? 'Langue' : 'Language';
  String get noResults => isFrench ? 'Aucun résultat' : 'No results';
  String get retry => isFrench ? 'Réessayer' : 'Retry';

  static AppLocalizations of(BuildContext context) =>
      Localizations.of<AppLocalizations>(context, AppLocalizations)!;
}

class AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const AppLocalizationsDelegate();
  @override
  bool isSupported(Locale locale) => ['fr', 'en'].contains(locale.languageCode);
  @override
  Future<AppLocalizations> load(Locale locale) async => AppLocalizations(locale);
  @override
  bool shouldReload(AppLocalizationsDelegate old) => false;
}
