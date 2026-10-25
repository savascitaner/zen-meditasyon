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
  String get programsPlaceholder => 'Guided programs will appear here.';

  @override
  String get profilePlaceholder =>
      'Your settings and progress will appear here.';

  @override
  String get exploreAllCategories => 'All';

  @override
  String get exploreAnyDuration => 'Any length';

  @override
  String exploreDurationUpTo(int minutes) {
    return 'Up to $minutes min';
  }

  @override
  String get exploreCategoryFilterLabel => 'Categories';

  @override
  String get exploreDurationFilterLabel => 'Length';

  @override
  String exploreResultCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count meditations',
      one: '1 meditation',
    );
    return '$_temp0';
  }

  @override
  String get exploreEmptyTitle => 'No meditations match';

  @override
  String get exploreEmptyMessage => 'Try another category or a longer length.';

  @override
  String get exploreClearFilters => 'Clear filters';

  @override
  String get errorTitle => 'This couldn\'t load';

  @override
  String get errorMessage => 'Please check your connection and try again.';

  @override
  String get retry => 'Try again';

  @override
  String durationMinutes(int minutes) {
    return '$minutes min';
  }

  @override
  String get premiumLabel => 'Premium';

  @override
  String get premiumLockedSemantics => 'Premium, locked';

  @override
  String detailNarratedBy(String name) {
    return 'Narrated by $name';
  }

  @override
  String get detailStart => 'Start';

  @override
  String get detailUnlockPremium => 'Unlock with Premium';

  @override
  String get detailPremiumComingSoon => 'Premium plans are coming soon.';

  @override
  String get detailNotFoundTitle => 'This meditation isn\'t available';

  @override
  String get detailNotFoundMessage => 'It may have been moved or removed.';

  @override
  String get playerTitle => 'Player';

  @override
  String get playerPlaceholder => 'The player will appear here soon.';

  @override
  String get languageSectionTitle => 'Language';

  @override
  String get languageEnglish => 'English';

  @override
  String get languageTurkish => 'Türkçe';
}
