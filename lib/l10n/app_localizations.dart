import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_tr.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('tr'),
  ];

  /// Application name shown in the OS task switcher.
  ///
  /// In en, this message translates to:
  /// **'Zen'**
  String get appTitle;

  /// Bottom navigation label for the home tab.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get navToday;

  /// Bottom navigation label for the explore tab.
  ///
  /// In en, this message translates to:
  /// **'Explore'**
  String get navExplore;

  /// Bottom navigation label for the programs tab.
  ///
  /// In en, this message translates to:
  /// **'Programs'**
  String get navPrograms;

  /// Bottom navigation label for the profile tab.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get navProfile;

  /// No description provided for @homePlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Your daily practice will appear here.'**
  String get homePlaceholder;

  /// No description provided for @programsPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Guided programs will appear here.'**
  String get programsPlaceholder;

  /// No description provided for @profilePlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Your settings and progress will appear here.'**
  String get profilePlaceholder;

  /// Category chip that removes the category filter.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get exploreAllCategories;

  /// Duration chip that removes the length filter.
  ///
  /// In en, this message translates to:
  /// **'Any length'**
  String get exploreAnyDuration;

  /// Duration filter chip; keeps meditations of at most this length.
  ///
  /// In en, this message translates to:
  /// **'Up to {minutes} min'**
  String exploreDurationUpTo(int minutes);

  /// Screen reader label for the category chip row.
  ///
  /// In en, this message translates to:
  /// **'Categories'**
  String get exploreCategoryFilterLabel;

  /// Screen reader label for the duration chip row.
  ///
  /// In en, this message translates to:
  /// **'Length'**
  String get exploreDurationFilterLabel;

  /// Number of meditations matching the current filters.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 meditation} other{{count} meditations}}'**
  String exploreResultCount(int count);

  /// No description provided for @exploreEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No meditations match'**
  String get exploreEmptyTitle;

  /// No description provided for @exploreEmptyMessage.
  ///
  /// In en, this message translates to:
  /// **'Try another category or a longer length.'**
  String get exploreEmptyMessage;

  /// No description provided for @exploreClearFilters.
  ///
  /// In en, this message translates to:
  /// **'Clear filters'**
  String get exploreClearFilters;

  /// Generic title when content fails to load.
  ///
  /// In en, this message translates to:
  /// **'This couldn\'t load'**
  String get errorTitle;

  /// No description provided for @errorMessage.
  ///
  /// In en, this message translates to:
  /// **'Please check your connection and try again.'**
  String get errorMessage;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Try again'**
  String get retry;

  /// Length of a meditation.
  ///
  /// In en, this message translates to:
  /// **'{minutes} min'**
  String durationMinutes(int minutes);

  /// Badge on content that needs a subscription.
  ///
  /// In en, this message translates to:
  /// **'Premium'**
  String get premiumLabel;

  /// Screen reader text for the premium badge.
  ///
  /// In en, this message translates to:
  /// **'Premium, locked'**
  String get premiumLockedSemantics;

  /// No description provided for @detailNarratedBy.
  ///
  /// In en, this message translates to:
  /// **'Narrated by {name}'**
  String detailNarratedBy(String name);

  /// No description provided for @detailStart.
  ///
  /// In en, this message translates to:
  /// **'Start'**
  String get detailStart;

  /// Start button label on premium content.
  ///
  /// In en, this message translates to:
  /// **'Unlock with Premium'**
  String get detailUnlockPremium;

  /// Snack bar shown until the paywall exists.
  ///
  /// In en, this message translates to:
  /// **'Premium plans are coming soon.'**
  String get detailPremiumComingSoon;

  /// No description provided for @detailNotFoundTitle.
  ///
  /// In en, this message translates to:
  /// **'This meditation isn\'t available'**
  String get detailNotFoundTitle;

  /// No description provided for @detailNotFoundMessage.
  ///
  /// In en, this message translates to:
  /// **'It may have been moved or removed.'**
  String get detailNotFoundMessage;

  /// No description provided for @playerTitle.
  ///
  /// In en, this message translates to:
  /// **'Player'**
  String get playerTitle;

  /// No description provided for @playerPlay.
  ///
  /// In en, this message translates to:
  /// **'Play'**
  String get playerPlay;

  /// No description provided for @playerPause.
  ///
  /// In en, this message translates to:
  /// **'Pause'**
  String get playerPause;

  /// No description provided for @playerBack15.
  ///
  /// In en, this message translates to:
  /// **'Back 15 seconds'**
  String get playerBack15;

  /// No description provided for @playerForward15.
  ///
  /// In en, this message translates to:
  /// **'Forward 15 seconds'**
  String get playerForward15;

  /// No description provided for @playerRemaining.
  ///
  /// In en, this message translates to:
  /// **'{time} left'**
  String playerRemaining(String time);

  /// No description provided for @playerClose.
  ///
  /// In en, this message translates to:
  /// **'Close player'**
  String get playerClose;

  /// No description provided for @playerReplay.
  ///
  /// In en, this message translates to:
  /// **'Listen again'**
  String get playerReplay;

  /// No description provided for @playerUnavailableTitle.
  ///
  /// In en, this message translates to:
  /// **'This audio can\'t be played right now'**
  String get playerUnavailableTitle;

  /// No description provided for @playerUnavailableMessage.
  ///
  /// In en, this message translates to:
  /// **'Please try again in a moment.'**
  String get playerUnavailableMessage;

  /// No description provided for @sessionCompleteTitle.
  ///
  /// In en, this message translates to:
  /// **'Session complete'**
  String get sessionCompleteTitle;

  /// No description provided for @sessionCompleteMessage.
  ///
  /// In en, this message translates to:
  /// **'Thank you for taking this time for yourself. Carry this calm with you for as long as it feels good.'**
  String get sessionCompleteMessage;

  /// No description provided for @sessionCompleteDone.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get sessionCompleteDone;

  /// Heading above the language selector on the profile screen.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get languageSectionTitle;

  /// No description provided for @languageEnglish.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get languageEnglish;

  /// Always written in Turkish so users can recognise their language.
  ///
  /// In en, this message translates to:
  /// **'Türkçe'**
  String get languageTurkish;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'tr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'tr':
      return AppLocalizationsTr();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
