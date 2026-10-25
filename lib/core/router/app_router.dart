import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/explore/presentation/explore_screen.dart';
import '../../features/home/presentation/home_screen.dart';
import '../../features/library/presentation/favorites_screen.dart';
import '../../features/meditation_detail/presentation/meditation_detail_screen.dart';
import '../../features/onboarding/presentation/onboarding_controller.dart';
import '../../features/onboarding/presentation/survey_screen.dart';
import '../../features/onboarding/presentation/welcome_screen.dart';
import '../../features/player/presentation/player_screen.dart';
import '../../features/profile/presentation/about_screen.dart';
import '../../features/profile/presentation/profile_screen.dart';
import '../../features/programs/presentation/programs_screen.dart';
import '../../features/reminders/presentation/reminder_controller.dart';
import '../../features/safety/presentation/crisis_support_screen.dart';
import '../../features/safety/presentation/safety_notice_sheet.dart';
import '../../shared/widgets/app_scaffold_with_nav.dart';
import 'onboarding_redirect.dart';
import 'route_names.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  // The router is built once; this notifier tells it to re-run its redirect
  // when onboarding finishes or is reset.
  final onboardingCompleted = ValueNotifier(
    ref.read(onboardingCompletedProvider),
  );
  ref.listen(
    onboardingCompletedProvider,
    (_, completed) => onboardingCompleted.value = completed,
  );

  final router = GoRouter(
    initialLocation: RouteNames.homePath,
    refreshListenable: onboardingCompleted,
    redirect: (context, state) => onboardingRedirect(
      completed: onboardingCompleted.value,
      location: state.uri.path,
    ),
    routes: [
      GoRoute(
        path: RouteNames.welcomePath,
        name: RouteNames.welcome,
        builder: (context, state) => const WelcomeScreen(),
        routes: [
          // Nested, so the welcome screen stays below it and the iOS back
          // swipe returns to it.
          GoRoute(
            path: RouteNames.onboardingSurveySubPath,
            name: RouteNames.onboardingSurvey,
            builder: (context, state) => const SurveyScreen(),
          ),
        ],
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) => SafetyNoticeGate(
          child: AppScaffoldWithNav(navigationShell: navigationShell),
        ),
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: RouteNames.homePath,
                name: RouteNames.home,
                builder: (context, state) => const HomeScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: RouteNames.explorePath,
                name: RouteNames.explore,
                builder: (context, state) => const ExploreScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: RouteNames.programsPath,
                name: RouteNames.programs,
                builder: (context, state) => const ProgramsScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: RouteNames.profilePath,
                name: RouteNames.profile,
                builder: (context, state) => const ProfileScreen(),
              ),
            ],
          ),
        ],
      ),
      // Full-screen routes above the tab bar.
      GoRoute(
        path: RouteNames.meditationDetailPath,
        name: RouteNames.meditationDetail,
        builder: (context, state) =>
            MeditationDetailScreen(meditationId: state.pathParameters['id']!),
      ),
      GoRoute(
        path: RouteNames.favoritesPath,
        name: RouteNames.favorites,
        builder: (context, state) => const FavoritesScreen(),
      ),
      GoRoute(
        path: RouteNames.aboutPath,
        name: RouteNames.about,
        builder: (context, state) => const AboutScreen(),
      ),
      GoRoute(
        path: RouteNames.crisisSupportPath,
        name: RouteNames.crisisSupport,
        builder: (context, state) => const CrisisSupportScreen(),
      ),
      GoRoute(
        path: RouteNames.playerPath,
        name: RouteNames.player,
        builder: (context, state) =>
            PlayerScreen(meditationId: state.pathParameters['id']!),
      ),
    ],
  );
  // Tapping a daily reminder opens the Today tab.
  final reminderTaps = ref
      .read(reminderSchedulerProvider)
      .taps
      .listen((_) => router.go(RouteNames.homePath));
  ref.onDispose(() {
    reminderTaps.cancel();
    router.dispose();
    onboardingCompleted.dispose();
  });
  return router;
});
