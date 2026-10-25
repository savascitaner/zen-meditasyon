import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zen_meditation/app.dart';
import 'package:zen_meditation/core/l10n/locale_controller.dart';
import 'package:zen_meditation/features/content/presentation/providers/content_providers.dart';
import 'package:zen_meditation/features/explore/presentation/explore_screen.dart';
import 'package:zen_meditation/features/onboarding/data/local_onboarding_repository.dart';
import 'package:zen_meditation/features/onboarding/domain/onboarding_profile.dart';
import 'package:zen_meditation/features/onboarding/presentation/onboarding_controller.dart';
import 'package:zen_meditation/features/onboarding/presentation/survey_screen.dart';
import 'package:zen_meditation/features/onboarding/presentation/welcome_screen.dart';
import 'package:zen_meditation/features/player/presentation/player_providers.dart';

import '../../helpers/fake_audio_handler.dart';
import '../../helpers/fake_content_repository.dart';

Future<SharedPreferences> pumpApp(
  WidgetTester tester, {
  Map<String, Object> stored = const {},
  Locale device = const Locale('en'),
}) async {
  // The welcome glow loops forever, which would keep pumpAndSettle waiting.
  // Reduce motion turns it off, which is also what a user with that setting
  // sees.
  tester.platformDispatcher.accessibilityFeaturesTestValue =
      const FakeAccessibilityFeatures(disableAnimations: true);
  addTearDown(tester.platformDispatcher.clearAccessibilityFeaturesTestValue);
  SharedPreferences.setMockInitialValues(stored);
  final prefs = await SharedPreferences.getInstance();
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(prefs),
        deviceLocaleProvider.overrideWithValue(device),
        contentRepositoryProvider.overrideWithValue(FakeContentRepository()),
        audioHandlerProvider.overrideWithValue(FakeAudioHandler()),
      ],
      child: const App(),
    ),
  );
  await tester.pumpAndSettle();
  return prefs;
}

void main() {
  group('LocalOnboardingRepository', () {
    test('round-trips answers and ignores unknown values', () async {
      SharedPreferences.setMockInitialValues({
        LocalOnboardingRepository.stressLevelKey: 'nonsense',
      });
      final repository = LocalOnboardingRepository(
        await SharedPreferences.getInstance(),
      );
      expect(repository.load(), const OnboardingProfile());

      const profile = OnboardingProfile(
        stressLevel: StressLevel.stressed,
        experience: MeditationExperience.regular,
        completed: true,
      );
      await repository.save(profile);
      expect(repository.load(), profile);

      await repository.clear();
      expect(repository.load(), const OnboardingProfile());
    });
  });

  group('OnboardingController', () {
    test('saves each answer and completion', () async {
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();
      final container = ProviderContainer(
        overrides: [sharedPreferencesProvider.overrideWithValue(prefs)],
      );
      addTearDown(container.dispose);
      final controller = container.read(onboardingControllerProvider.notifier);

      await controller.selectStressLevel(StressLevel.calm);
      expect(prefs.getString(LocalOnboardingRepository.stressLevelKey), 'calm');
      expect(container.read(onboardingCompletedProvider), false);

      await controller.complete();
      expect(container.read(onboardingCompletedProvider), true);
      expect(prefs.getBool(LocalOnboardingRepository.completedKey), true);

      await controller.reset();
      expect(
        container.read(onboardingControllerProvider),
        const OnboardingProfile(),
      );
    });
  });

  group('flow', () {
    testWidgets('first launch shows the welcome screen, not the tabs', (
      tester,
    ) async {
      await pumpApp(tester);

      expect(find.byType(WelcomeScreen), findsOneWidget);
      expect(find.text('Get started'), findsOneWidget);
      expect(find.byType(NavigationBar), findsNothing);
    });

    testWidgets('welcome copy is shown in Turkish on a Turkish device', (
      tester,
    ) async {
      await pumpApp(tester, device: const Locale('tr'));

      expect(find.text('Başlayalım'), findsOneWidget);
    });

    testWidgets('finished users go straight to the app', (tester) async {
      await pumpApp(
        tester,
        stored: {LocalOnboardingRepository.completedKey: true},
      );

      expect(find.byType(WelcomeScreen), findsNothing);
      expect(find.byType(NavigationBar), findsOneWidget);
    });

    testWidgets('answering both questions saves them and opens Explore', (
      tester,
    ) async {
      final prefs = await pumpApp(tester);

      await tester.tap(find.text('Get started'));
      await tester.pumpAndSettle();
      expect(find.byType(SurveyScreen), findsOneWidget);
      expect(find.text('Step 1 of 2'), findsOneWidget);

      final next = find.widgetWithText(FilledButton, 'Continue');
      expect(tester.widget<FilledButton>(next).onPressed, isNull);

      await tester.tap(find.text('A little tense'));
      await tester.pumpAndSettle();
      await tester.tap(next);
      await tester.pumpAndSettle();
      expect(find.text('Step 2 of 2'), findsOneWidget);

      await tester.tap(find.text("I'm new to it"));
      await tester.pumpAndSettle();
      await tester.tap(find.widgetWithText(FilledButton, 'Start exploring'));
      await tester.pumpAndSettle();

      expect(find.byType(ExploreScreen), findsOneWidget);
      expect(find.byType(NavigationBar), findsOneWidget);
      expect(
        prefs.getString(LocalOnboardingRepository.stressLevelKey),
        'slightlyTense',
      );
      expect(
        prefs.getString(LocalOnboardingRepository.experienceKey),
        'newcomer',
      );
      expect(prefs.getBool(LocalOnboardingRepository.completedKey), true);
    });

    testWidgets('skipping opens Explore with no answers saved', (tester) async {
      final prefs = await pumpApp(tester);

      await tester.tap(find.text('Get started'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Skip for now'));
      await tester.pumpAndSettle();

      expect(find.byType(ExploreScreen), findsOneWidget);
      expect(prefs.getBool(LocalOnboardingRepository.completedKey), true);
      expect(prefs.getString(LocalOnboardingRepository.stressLevelKey), null);
    });

    testWidgets('back on step two returns to the first question', (
      tester,
    ) async {
      await pumpApp(tester);
      await tester.tap(find.text('Get started'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Mostly calm'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Continue'));
      await tester.pumpAndSettle();

      await tester.tap(find.byTooltip('Back'));
      await tester.pumpAndSettle();

      expect(find.text('Step 1 of 2'), findsOneWidget);
      expect(find.byType(WelcomeScreen), findsNothing);
    });

    testWidgets('answers survive leaving halfway', (tester) async {
      await pumpApp(
        tester,
        stored: {LocalOnboardingRepository.experienceKey: 'regular'},
      );
      await tester.tap(find.text('Get started'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Mostly calm'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Continue'));
      await tester.pumpAndSettle();

      // The earlier experience answer is shown as selected.
      final selected = find.bySemanticsLabel(RegExp('I practise regularly'));
      expect(selected, findsOneWidget);
    });
  });
}
