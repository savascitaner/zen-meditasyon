import 'package:flutter_test/flutter_test.dart';
import 'package:zen_meditation/core/router/onboarding_redirect.dart';
import 'package:zen_meditation/core/router/route_names.dart';

void main() {
  group('before onboarding is completed', () {
    test('sends app locations to the welcome screen', () {
      for (final location in ['/home', '/explore', '/player/abc']) {
        expect(
          onboardingRedirect(completed: false, location: location),
          RouteNames.welcomePath,
        );
      }
    });

    test('lets onboarding screens through', () {
      for (final location in [
        RouteNames.welcomePath,
        RouteNames.onboardingSurveyPath,
      ]) {
        expect(onboardingRedirect(completed: false, location: location), null);
      }
    });
  });

  group('after onboarding is completed', () {
    test('sends onboarding screens to Explore', () {
      for (final location in [
        RouteNames.welcomePath,
        RouteNames.onboardingSurveyPath,
      ]) {
        expect(
          onboardingRedirect(completed: true, location: location),
          RouteNames.explorePath,
        );
      }
    });

    test('leaves app locations alone', () {
      for (final location in ['/home', '/explore', '/profile']) {
        expect(onboardingRedirect(completed: true, location: location), null);
      }
    });
  });
}
