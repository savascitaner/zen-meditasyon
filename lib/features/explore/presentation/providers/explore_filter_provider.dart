import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../content/domain/models/meditation_filter.dart';

final exploreFilterProvider =
    NotifierProvider<ExploreFilterNotifier, MeditationFilter>(
      ExploreFilterNotifier.new,
    );

/// The category and duration chosen on the Explore tab.
///
/// The screen feeds this filter into `meditationsProvider`, so a change here
/// reloads the list.
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
