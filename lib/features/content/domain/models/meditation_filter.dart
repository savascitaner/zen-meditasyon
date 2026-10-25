import 'package:freezed_annotation/freezed_annotation.dart';

import 'meditation.dart';

part 'meditation_filter.freezed.dart';

/// Query for [ContentRepository.getMeditations]; also the `family` key of
/// `meditationsProvider`, so it needs value equality.
@freezed
abstract class MeditationFilter with _$MeditationFilter {
  const factory MeditationFilter({
    String? categoryId,

    /// Keeps meditations of at most this many minutes, see
    /// `meditationDurationOptions`.
    int? maxDuration,
    @Default(true) bool includePremium,
  }) = _MeditationFilter;
}

/// Applies [MeditationFilter] to meditations already in memory, with the same
/// rules as `ContentRepository.getMeditations`.
extension MeditationFilterMatching on MeditationFilter {
  List<Meditation> apply(List<Meditation> meditations) {
    final category = categoryId;
    final maxMinutes = maxDuration;
    return [
      for (final meditation in meditations)
        if ((category == null || meditation.categoryIds.contains(category)) &&
            (maxMinutes == null || meditation.durationMinutes <= maxMinutes) &&
            (includePremium || !meditation.isPremium))
          meditation,
    ];
  }
}
