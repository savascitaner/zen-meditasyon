// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Turkish (`tr`).
class AppLocalizationsTr extends AppLocalizations {
  AppLocalizationsTr([String locale = 'tr']) : super(locale);

  @override
  String get appTitle => 'Zen';

  @override
  String get navToday => 'Bugün';

  @override
  String get navExplore => 'Keşfet';

  @override
  String get navPrograms => 'Programlar';

  @override
  String get navProfile => 'Profil';

  @override
  String get homePlaceholder => 'Günlük pratiğin burada görünecek.';

  @override
  String get explorePlaceholder =>
      'Meditasyonlar ve kategoriler burada görünecek.';

  @override
  String get programsPlaceholder => 'Rehberli programlar burada görünecek.';

  @override
  String get profilePlaceholder => 'Ayarların ve ilerlemen burada görünecek.';

  @override
  String get languageSectionTitle => 'Dil';

  @override
  String get languageEnglish => 'English';

  @override
  String get languageTurkish => 'Türkçe';
}
