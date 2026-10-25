import 'route_names.dart';

/// Keeps onboarding and the rest of the app apart.
///
/// Until onboarding is [completed], every location leads to the welcome
/// screen. Afterwards the onboarding screens lead to Explore, so finishing the
/// survey (or opening an old onboarding link) lands there. Returns null when
/// [location] may stay as it is.
String? onboardingRedirect({
  required bool completed,
  required String location,
}) {
  final inOnboarding =
      location == RouteNames.welcomePath ||
      location.startsWith('${RouteNames.welcomePath}/');
  if (!completed) return inOnboarding ? null : RouteNames.welcomePath;
  return inOnboarding ? RouteNames.explorePath : null;
}
