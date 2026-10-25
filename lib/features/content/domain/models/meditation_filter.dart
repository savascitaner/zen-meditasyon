import 'package:freezed_annotation/freezed_annotation.dart';

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
