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
  /// **'Ensora'**
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

  /// No description provided for @welcomeTagline.
  ///
  /// In en, this message translates to:
  /// **'Breathe, settle, and find a little more calm each day.'**
  String get welcomeTagline;

  /// No description provided for @welcomeGetStarted.
  ///
  /// In en, this message translates to:
  /// **'Get started'**
  String get welcomeGetStarted;

  /// Small print on the welcome screen. Must not make medical claims.
  ///
  /// In en, this message translates to:
  /// **'Ensora supports everyday wellbeing. It isn\'t a substitute for professional care.'**
  String get welcomeDisclaimer;

  /// Progress label at the top of the onboarding survey.
  ///
  /// In en, this message translates to:
  /// **'Step {step} of {total}'**
  String surveyStepOf(int step, int total);

  /// No description provided for @surveyBack.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get surveyBack;

  /// Skips the survey and opens the app.
  ///
  /// In en, this message translates to:
  /// **'Skip for now'**
  String get surveySkip;

  /// No description provided for @surveyContinue.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get surveyContinue;

  /// Last survey button; finishes onboarding and opens Explore.
  ///
  /// In en, this message translates to:
  /// **'Start exploring'**
  String get surveyFinish;

  /// No description provided for @surveyStressTitle.
  ///
  /// In en, this message translates to:
  /// **'How have you been feeling lately?'**
  String get surveyStressTitle;

  /// No description provided for @surveyStressSubtitle.
  ///
  /// In en, this message translates to:
  /// **'There\'s no right or wrong answer. This only helps us shape a gentle place to begin.'**
  String get surveyStressSubtitle;

  /// No description provided for @stressCalmTitle.
  ///
  /// In en, this message translates to:
  /// **'Mostly calm'**
  String get stressCalmTitle;

  /// No description provided for @stressCalmSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Things feel fairly steady.'**
  String get stressCalmSubtitle;

  /// No description provided for @stressSlightlyTenseTitle.
  ///
  /// In en, this message translates to:
  /// **'A little tense'**
  String get stressSlightlyTenseTitle;

  /// No description provided for @stressSlightlyTenseSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Some days feel busier than others.'**
  String get stressSlightlyTenseSubtitle;

  /// No description provided for @stressStressedTitle.
  ///
  /// In en, this message translates to:
  /// **'Often stressed'**
  String get stressStressedTitle;

  /// No description provided for @stressStressedSubtitle.
  ///
  /// In en, this message translates to:
  /// **'My mind is busy or restless much of the time.'**
  String get stressStressedSubtitle;

  /// No description provided for @stressOverwhelmedTitle.
  ///
  /// In en, this message translates to:
  /// **'Overwhelmed'**
  String get stressOverwhelmedTitle;

  /// No description provided for @stressOverwhelmedSubtitle.
  ///
  /// In en, this message translates to:
  /// **'It has all felt like a lot lately.'**
  String get stressOverwhelmedSubtitle;

  /// No description provided for @surveyExperienceTitle.
  ///
  /// In en, this message translates to:
  /// **'How familiar are you with meditation?'**
  String get surveyExperienceTitle;

  /// No description provided for @surveyExperienceSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Every starting point is a good one.'**
  String get surveyExperienceSubtitle;

  /// No description provided for @experienceNewcomerTitle.
  ///
  /// In en, this message translates to:
  /// **'I\'m new to it'**
  String get experienceNewcomerTitle;

  /// No description provided for @experienceNewcomerSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Short, simple sessions are a good start.'**
  String get experienceNewcomerSubtitle;

  /// No description provided for @experienceSomeTitle.
  ///
  /// In en, this message translates to:
  /// **'I\'ve tried it a few times'**
  String get experienceSomeTitle;

  /// No description provided for @experienceSomeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'I know the basics and want to keep going.'**
  String get experienceSomeSubtitle;

  /// No description provided for @experienceRegularTitle.
  ///
  /// In en, this message translates to:
  /// **'I practise regularly'**
  String get experienceRegularTitle;

  /// No description provided for @experienceRegularSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Meditation is already part of my routine.'**
  String get experienceRegularSubtitle;

  /// No description provided for @favoritesTitle.
  ///
  /// In en, this message translates to:
  /// **'My favorites'**
  String get favoritesTitle;

  /// Heart button label (VoiceOver) when the meditation is not a favorite.
  ///
  /// In en, this message translates to:
  /// **'Add to favorites'**
  String get favoriteAdd;

  /// Heart button label (VoiceOver) when the meditation is a favorite.
  ///
  /// In en, this message translates to:
  /// **'Remove from favorites'**
  String get favoriteRemove;

  /// No description provided for @favoritesEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No favorites yet'**
  String get favoritesEmptyTitle;

  /// No description provided for @favoritesEmptyMessage.
  ///
  /// In en, this message translates to:
  /// **'Tap the heart on a meditation you\'d like to come back to, and it will wait for you here.'**
  String get favoritesEmptyMessage;

  /// No description provided for @favoritesEmptyAction.
  ///
  /// In en, this message translates to:
  /// **'Explore meditations'**
  String get favoritesEmptyAction;

  /// No description provided for @greetingMorning.
  ///
  /// In en, this message translates to:
  /// **'Good morning'**
  String get greetingMorning;

  /// No description provided for @greetingAfternoon.
  ///
  /// In en, this message translates to:
  /// **'Good afternoon'**
  String get greetingAfternoon;

  /// No description provided for @greetingEvening.
  ///
  /// In en, this message translates to:
  /// **'Good evening'**
  String get greetingEvening;

  /// No description provided for @recommendationLabel.
  ///
  /// In en, this message translates to:
  /// **'Suggested for today'**
  String get recommendationLabel;

  /// Current streak of practice days.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 day in a row} other{{count} days in a row}}'**
  String streakDays(int count);

  /// No description provided for @streakRestart.
  ///
  /// In en, this message translates to:
  /// **'A good day to begin again.'**
  String get streakRestart;

  /// No description provided for @streakInvite.
  ///
  /// In en, this message translates to:
  /// **'Your first session can start today.'**
  String get streakInvite;

  /// Longest streak so far.
  ///
  /// In en, this message translates to:
  /// **'Your longest run: {count, plural, =1{1 day} other{{count} days}}'**
  String streakLongest(int count);

  /// Screen reader text for the seven weekly dots.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{No practice yet this week} =1{This week you practised 1 day} other{This week you practised {count} days}}'**
  String weekDotsSemantics(int count);

  /// No description provided for @statsMinutes.
  ///
  /// In en, this message translates to:
  /// **'minutes of practice'**
  String get statsMinutes;

  /// No description provided for @statsSessions.
  ///
  /// In en, this message translates to:
  /// **'sessions completed'**
  String get statsSessions;

  /// No description provided for @homeContinueTitle.
  ///
  /// In en, this message translates to:
  /// **'Continue where you left off'**
  String get homeContinueTitle;

  /// No description provided for @homeFavoritesTitle.
  ///
  /// In en, this message translates to:
  /// **'Your favorites'**
  String get homeFavoritesTitle;
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
