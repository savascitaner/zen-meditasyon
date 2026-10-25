// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Ensora';

  @override
  String get navToday => 'Today';

  @override
  String get navExplore => 'Explore';

  @override
  String get navPrograms => 'Programs';

  @override
  String get navProfile => 'Profile';

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
  String get playerPlay => 'Play';

  @override
  String get playerPause => 'Pause';

  @override
  String get playerBack15 => 'Back 15 seconds';

  @override
  String get playerForward15 => 'Forward 15 seconds';

  @override
  String playerRemaining(String time) {
    return '$time left';
  }

  @override
  String get playerClose => 'Close player';

  @override
  String get playerReplay => 'Listen again';

  @override
  String get playerUnavailableTitle => 'This audio can\'t be played right now';

  @override
  String get playerUnavailableMessage => 'Please try again in a moment.';

  @override
  String get sessionCompleteTitle => 'Session complete';

  @override
  String get sessionCompleteMessage =>
      'Thank you for taking this time for yourself. Carry this calm with you for as long as it feels good.';

  @override
  String get sessionCompleteDone => 'Done';

  @override
  String get languageSectionTitle => 'Language';

  @override
  String get languageEnglish => 'English';

  @override
  String get languageTurkish => 'Türkçe';

  @override
  String get welcomeTagline =>
      'Breathe, settle, and find a little more calm each day.';

  @override
  String get welcomeGetStarted => 'Get started';

  @override
  String get welcomeDisclaimer =>
      'Ensora supports everyday wellbeing. It isn\'t a substitute for professional care.';

  @override
  String surveyStepOf(int step, int total) {
    return 'Step $step of $total';
  }

  @override
  String get surveyBack => 'Back';

  @override
  String get surveySkip => 'Skip for now';

  @override
  String get surveyContinue => 'Continue';

  @override
  String get surveyFinish => 'Start exploring';

  @override
  String get surveyStressTitle => 'How have you been feeling lately?';

  @override
  String get surveyStressSubtitle =>
      'There\'s no right or wrong answer. This only helps us shape a gentle place to begin.';

  @override
  String get stressCalmTitle => 'Mostly calm';

  @override
  String get stressCalmSubtitle => 'Things feel fairly steady.';

  @override
  String get stressSlightlyTenseTitle => 'A little tense';

  @override
  String get stressSlightlyTenseSubtitle =>
      'Some days feel busier than others.';

  @override
  String get stressStressedTitle => 'Often stressed';

  @override
  String get stressStressedSubtitle =>
      'My mind is busy or restless much of the time.';

  @override
  String get stressOverwhelmedTitle => 'Overwhelmed';

  @override
  String get stressOverwhelmedSubtitle => 'It has all felt like a lot lately.';

  @override
  String get surveyExperienceTitle => 'How familiar are you with meditation?';

  @override
  String get surveyExperienceSubtitle => 'Every starting point is a good one.';

  @override
  String get experienceNewcomerTitle => 'I\'m new to it';

  @override
  String get experienceNewcomerSubtitle =>
      'Short, simple sessions are a good start.';

  @override
  String get experienceSomeTitle => 'I\'ve tried it a few times';

  @override
  String get experienceSomeSubtitle =>
      'I know the basics and want to keep going.';

  @override
  String get experienceRegularTitle => 'I practise regularly';

  @override
  String get experienceRegularSubtitle =>
      'Meditation is already part of my routine.';

  @override
  String get favoritesTitle => 'My favorites';

  @override
  String get favoriteAdd => 'Add to favorites';

  @override
  String get favoriteRemove => 'Remove from favorites';

  @override
  String get favoritesEmptyTitle => 'No favorites yet';

  @override
  String get favoritesEmptyMessage =>
      'Tap the heart on a meditation you\'d like to come back to, and it will wait for you here.';

  @override
  String get favoritesEmptyAction => 'Explore meditations';

  @override
  String get greetingMorning => 'Good morning';

  @override
  String get greetingAfternoon => 'Good afternoon';

  @override
  String get greetingEvening => 'Good evening';

  @override
  String get recommendationLabel => 'Suggested for today';

  @override
  String streakDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count days in a row',
      one: '1 day in a row',
    );
    return '$_temp0';
  }

  @override
  String get streakRestart => 'A good day to begin again.';

  @override
  String get streakInvite => 'Your first session can start today.';

  @override
  String streakLongest(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count days',
      one: '1 day',
    );
    return 'Your longest run: $_temp0';
  }

  @override
  String weekDotsSemantics(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'This week you practised $count days',
      one: 'This week you practised 1 day',
      zero: 'No practice yet this week',
    );
    return '$_temp0';
  }

  @override
  String get statsMinutes => 'minutes of practice';

  @override
  String get statsSessions => 'sessions completed';

  @override
  String get homeContinueTitle => 'Continue where you left off';

  @override
  String get homeFavoritesTitle => 'Your favorites';
}
