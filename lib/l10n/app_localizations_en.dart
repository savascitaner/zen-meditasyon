// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Zen';

  @override
  String get navToday => 'Today';

  @override
  String get navExplore => 'Explore';

  @override
  String get navPrograms => 'Programs';

  @override
  String get navProfile => 'Profile';

  @override
  String get homePlaceholder => 'Your daily practice will appear here.';

  @override
  String get explorePlaceholder =>
      'Meditations and categories will appear here.';

  @override
  String get programsPlaceholder => 'Guided programs will appear here.';

  @override
  String get profilePlaceholder =>
      'Your settings and progress will appear here.';

  @override
  String get languageSectionTitle => 'Language';

  @override
  String get languageEnglish => 'English';

  @override
  String get languageTurkish => 'Türkçe';
}
