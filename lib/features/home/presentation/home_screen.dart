import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/route_names.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../l10n/app_localizations.dart';
import '../../../shared/extensions/localized_text_x.dart';
import '../../content/domain/models/meditation.dart';
import '../../content/presentation/providers/content_providers.dart';
import '../../library/presentation/providers/library_providers.dart';
import '../../player/presentation/player_providers.dart';
import 'providers/home_providers.dart';
import 'widgets/greeting_header.dart';
import 'widgets/horizontal_meditation_strip.dart';
import 'widgets/recommendation_card.dart';
import 'widgets/stats_row.dart';
import 'widgets/streak_card.dart';

/// The opening tab: today's suggestion, a gentle streak, totals, and ways
/// back to recent and favorite meditations. Strips with nothing in them are
/// left out.
class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  /// A day may have passed while the app was in the background.
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      ref.invalidate(practiceStatsProvider);
      ref.invalidate(todayRecommendationProvider);
    }
  }

  void _open(Meditation meditation) =>
      context.push(RouteNames.meditationDetailLocation(meditation.id));

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final firstDay = MaterialLocalizations.of(context).firstDayOfWeekIndex;
    final now = ref.watch(clockProvider)();
    final stats = ref.watch(practiceStatsProvider(firstDay)).value;
    final recommendation = ref.watch(todayRecommendationProvider).value;
    final recent = ref.watch(recentMeditationsProvider).value ?? const [];
    final favorites = ref.watch(favoriteMeditationsProvider).value ?? const [];
    final categories = ref.watch(categoriesProvider).value ?? const [];

    String? categoryLabel(Meditation m) {
      final id = m.categoryIds.firstOrNull;
      for (final category in categories) {
        if (category.id == id) return category.title.of(context);
      }
      return null;
    }

    const gap = SizedBox(height: AppSpacing.lg);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.navToday)),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.md),
        children: [
          GreetingHeader(now: now),
          gap,
          if (recommendation != null) ...[
            RecommendationCard(
              meditation: recommendation,
              categoryLabel: categoryLabel(recommendation),
              onTap: () => _open(recommendation),
            ),
            gap,
          ],
          if (stats != null) ...[
            StreakCard(stats: stats, firstDayOfWeekIndex: firstDay),
            if (stats.hasHistory) ...[
              const SizedBox(height: AppSpacing.md),
              StatsRow(stats: stats),
            ],
            gap,
          ],
          if (recent.isNotEmpty) ...[
            HorizontalMeditationStrip(
              title: l10n.homeContinueTitle,
              meditations: recent,
              onTap: _open,
            ),
            gap,
          ],
          if (favorites.isNotEmpty)
            HorizontalMeditationStrip(
              title: l10n.homeFavoritesTitle,
              meditations: favorites,
              onTap: _open,
            ),
        ],
      ),
    );
  }
}
