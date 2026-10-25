import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/explore/presentation/explore_screen.dart';
import '../../features/home/presentation/home_screen.dart';
import '../../features/meditation_detail/presentation/meditation_detail_screen.dart';
import '../../features/player/presentation/player_placeholder_screen.dart';
import '../../features/profile/presentation/profile_screen.dart';
import '../../features/programs/presentation/programs_screen.dart';
import '../../shared/widgets/app_scaffold_with_nav.dart';
import 'route_names.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  final router = GoRouter(
    initialLocation: RouteNames.homePath,
    routes: [
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) =>
            AppScaffoldWithNav(navigationShell: navigationShell),
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
        path: RouteNames.playerPath,
        name: RouteNames.player,
        builder: (context, state) =>
            PlayerPlaceholderScreen(meditationId: state.pathParameters['id']!),
      ),
    ],
  );
  ref.onDispose(router.dispose);
  return router;
});
