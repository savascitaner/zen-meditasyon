import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/route_names.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../l10n/app_localizations.dart';
import '../../../shared/extensions/localized_text_x.dart';
import '../../../shared/widgets/empty_state.dart';
import '../../../shared/widgets/error_state.dart';
import '../../content/domain/models/category.dart';
import '../../content/domain/models/meditation.dart';
import '../../content/presentation/providers/content_providers.dart';
import 'providers/explore_filter_provider.dart';
import 'widgets/category_chips.dart';
import 'widgets/duration_filter.dart';
import 'widgets/meditation_card.dart';

/// Browse meditations by category and length.
class ExploreScreen extends ConsumerWidget {
  const ExploreScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final filter = ref.watch(exploreFilterProvider);
    final filterNotifier = ref.read(exploreFilterProvider.notifier);
    final categories = ref.watch(categoriesProvider).value ?? const [];
    final meditations = ref.watch(visibleMeditationsProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.navExplore)),
      body: Column(
        children: [
          CategoryChips(
            categories: categories,
            selectedId: filter.categoryId,
            onSelected: filterNotifier.selectCategory,
          ),
          DurationFilter(
            selectedMinutes: filter.maxDuration,
            onSelected: filterNotifier.selectMaxDuration,
          ),
          Expanded(
            child: meditations.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (_, _) => ErrorState(
                onRetry: () {
                  ref.invalidate(categoriesProvider);
                  ref.invalidate(allMeditationsProvider);
                },
              ),
              data: (items) => items.isEmpty
                  ? EmptyState(
                      icon: Icons.search_off,
                      title: l10n.exploreEmptyTitle,
                      message: l10n.exploreEmptyMessage,
                      actionLabel: l10n.exploreClearFilters,
                      onAction: filterNotifier.clear,
                    )
                  : _MeditationList(
                      meditations: items,
                      categories: categories,
                      selectedCategoryId: filter.categoryId,
                    ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MeditationList extends StatelessWidget {
  const _MeditationList({
    required this.meditations,
    required this.categories,
    required this.selectedCategoryId,
  });

  final List<Meditation> meditations;
  final List<Category> categories;
  final String? selectedCategoryId;

  /// The selected category when the meditation has it, else its first one.
  String? _categoryLabel(BuildContext context, Meditation meditation) {
    final id = meditation.categoryIds.contains(selectedCategoryId)
        ? selectedCategoryId
        : meditation.categoryIds.firstOrNull;
    for (final category in categories) {
      if (category.id == id) return category.title.of(context);
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);

    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.md,
        AppSpacing.sm,
        AppSpacing.md,
        AppSpacing.lg,
      ),
      // The first row is the result count.
      itemCount: meditations.length + 1,
      separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.sm),
      itemBuilder: (context, index) {
        if (index == 0) {
          return Semantics(
            liveRegion: true,
            child: Text(
              l10n.exploreResultCount(meditations.length),
              style: theme.textTheme.labelLarge?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          );
        }
        final meditation = meditations[index - 1];
        return MeditationCard(
          key: ValueKey(meditation.id),
          meditation: meditation,
          categoryLabel: _categoryLabel(context, meditation),
          onTap: () =>
              context.push(RouteNames.meditationDetailLocation(meditation.id)),
        );
      },
    );
  }
}
