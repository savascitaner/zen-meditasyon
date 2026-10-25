import 'package:freezed_annotation/freezed_annotation.dart';

import 'localized_text.dart';

part 'category.freezed.dart';
part 'category.g.dart';

@freezed
abstract class Category with _$Category {
  const factory Category({
    required String id,
    required LocalizedText title,
    required LocalizedText description,
  }) = _Category;

  factory Category.fromJson(Map<String, dynamic> json) =>
      _$CategoryFromJson(json);
}

/// The fixed category ids from the business analysis report.
abstract final class CategoryIds {
  static const breath = 'breath';
  static const sleep = 'sleep';
  static const stress = 'stress';
  static const anxiety = 'anxiety';
  static const focus = 'focus';
  static const lovingKindness = 'loving-kindness';
  static const bodyScan = 'body-scan';
  static const zen = 'zen';
  static const walking = 'walking';

  static const all = [
    breath,
    sleep,
    stress,
    anxiety,
    focus,
    lovingKindness,
    bodyScan,
    zen,
    walking,
  ];
}
