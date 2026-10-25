import 'package:freezed_annotation/freezed_annotation.dart';

import 'localized_text.dart';

part 'meditation.freezed.dart';
part 'meditation.g.dart';

@freezed
abstract class Meditation with _$Meditation {
  const factory Meditation({
    required String id,
    required LocalizedText title,
    required LocalizedText description,
    required List<String> categoryIds,
    required int durationMinutes,

    /// An asset path (`assets/...`) or a remote URL.
    required String audioSource,

    /// Null until real cover art exists; the UI shows a placeholder.
    String? coverImage,
    required String narrator,
    @Default(false) bool isPremium,
    @Default(<String>[]) List<String> tags,
  }) = _Meditation;

  factory Meditation.fromJson(Map<String, dynamic> json) =>
      _$MeditationFromJson(json);
}

/// Duration filter steps (minutes) from the business analysis report.
const meditationDurationOptions = [3, 5, 10, 20, 30];
