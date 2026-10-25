import 'package:freezed_annotation/freezed_annotation.dart';

part 'localized_text.freezed.dart';
part 'localized_text.g.dart';

/// A piece of content text in every supported language.
@freezed
abstract class LocalizedText with _$LocalizedText {
  const LocalizedText._();

  const factory LocalizedText({required String en, required String tr}) =
      _LocalizedText;

  factory LocalizedText.fromJson(Map<String, dynamic> json) =>
      _$LocalizedTextFromJson(json);

  /// Turkish for `tr`, English for every other language code.
  String resolve(String languageCode) => languageCode == 'tr' ? tr : en;
}
