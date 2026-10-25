abstract final class RouteNames {
  static const home = 'home';
  static const explore = 'explore';
  static const programs = 'programs';
  static const profile = 'profile';
  static const meditationDetail = 'meditationDetail';
  static const player = 'player';
  static const favorites = 'favorites';
  static const welcome = 'welcome';
  static const onboardingSurvey = 'onboardingSurvey';

  static const homePath = '/home';
  static const explorePath = '/explore';
  static const programsPath = '/programs';
  static const profilePath = '/profile';
  static const meditationDetailPath = '/meditation/:id';
  static const playerPath = '/player/:id';
  static const favoritesPath = '/favorites';

  /// Every onboarding screen lives under this path.
  static const welcomePath = '/onboarding';
  static const onboardingSurveyPath = '/onboarding/survey';
  static const onboardingSurveySubPath = 'survey';

  static String meditationDetailLocation(String id) =>
      '/meditation/${Uri.encodeComponent(id)}';

  static String playerLocation(String id) =>
      '/player/${Uri.encodeComponent(id)}';
}
