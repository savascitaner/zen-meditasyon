import 'package:freezed_annotation/freezed_annotation.dart';

import '../domain/models/category.dart';
import '../domain/models/meditation.dart';
import '../domain/models/program.dart';

part 'content_catalog.freezed.dart';
part 'content_catalog.g.dart';

/// The shape of `assets/content/catalog.json`.
@freezed
abstract class ContentCatalog with _$ContentCatalog {
  const factory ContentCatalog({
    required List<Category> categories,
    required List<Meditation> meditations,
    required List<Program> programs,
  }) = _ContentCatalog;

  factory ContentCatalog.fromJson(Map<String, dynamic> json) =>
      _$ContentCatalogFromJson(json);
}
