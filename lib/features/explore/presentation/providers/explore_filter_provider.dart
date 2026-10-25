import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../content/domain/models/meditation.dart';
import '../../../content/domain/models/meditation_filter.dart';
import '../../../content/presentation/providers/content_providers.dart';

final exploreFilterProvider =
    NotifierProvider<ExploreFilterNotifier, MeditationFilter>(
      ExploreFilterNotifier.new,
    );

/// The category and duration chosen on the Explore tab.
///
/// The screen filters the cached catalog with it, so a change here updates the
/// list at once.
class ExploreFilterNotifier extends Notifier<MeditationFilter> {
  @override
  MeditationFilter build() => const MeditationFilter();

  /// Null shows every category.
  void selectCategory(String? categoryId) =>
      state = state.copyWith(categoryId: categoryId);

  /// Null shows every duration.
  void selectMaxDuration(int? minutes) =>
      state = state.copyWith(maxDuration: minutes);

  void clear() => state = const MeditationFilter();
}

/// The meditations that match the current filter.
///
/// Filtering happens in memory on the cached catalog, so changing a filter
/// never shows a loading state.
final visibleMeditationsProvider = Provider<AsyncValue<List<Meditation>>>((
  ref,
) {
  final filter = ref.watch(exploreFilterProvider);
  return ref
      .watch(allMeditationsProvider)
      .whenData((meditations) => filter.apply(meditations));
});
