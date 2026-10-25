import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/route_names.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../l10n/app_localizations.dart';
import '../../../shared/extensions/localized_text_x.dart';
import '../../../shared/widgets/empty_state.dart';
import '../../../shared/widgets/error_state.dart';
import '../../../shared/widgets/zen_background.dart';
import '../../content/presentation/providers/content_providers.dart';
import '../../explore/presentation/widgets/meditation_card.dart';
import 'providers/library_providers.dart';

/// The meditations the user has marked as favorites.
class FavoritesScreen extends ConsumerWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final favorites = ref.watch(favoriteMeditationsProvider);
    final categories = ref.watch(categoriesProvider).value ?? const [];

    return ZenBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(title: Text(l10n.favoritesTitle)),
        body: favorites.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (_, _) =>
              ErrorState(onRetry: () => ref.invalidate(allMeditationsProvider)),
          data: (meditations) {
            if (meditations.isEmpty) {
              return EmptyState(
                icon: Icons.favorite_border,
                title: l10n.favoritesEmptyTitle,
                message: l10n.favoritesEmptyMessage,
                actionLabel: l10n.favoritesEmptyAction,
                onAction: () => context.go(RouteNames.explorePath),
              );
            }
            // One shared blur for every glass card in the list.
            return BackdropGroup(
              child: ListView.separated(
                padding: const EdgeInsets.all(AppSpacing.gutter),
                itemCount: meditations.length,
                separatorBuilder: (_, _) =>
                    const SizedBox(height: AppSpacing.cardGap),
                itemBuilder: (context, index) {
                  final meditation = meditations[index];
                  final id = meditation.categoryIds.firstOrNull;
                  String? label;
                  for (final category in categories) {
                    if (category.id == id) label = category.title.of(context);
                  }
                  return MeditationCard(
                    meditation: meditation,
                    categoryLabel: label,
                    onTap: () => context.push(
                      RouteNames.meditationDetailLocation(meditation.id),
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
