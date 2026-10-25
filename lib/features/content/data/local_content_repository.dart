import 'dart:convert';

import 'package:flutter/services.dart';

import '../domain/content_repository.dart';
import '../domain/models/category.dart';
import '../domain/models/meditation.dart';
import '../domain/models/program.dart';
import 'content_catalog.dart';

/// Reads the content catalog from a bundled JSON asset.
///
/// The file is parsed once, on first use, and kept in memory.
class LocalContentRepository implements ContentRepository {
  LocalContentRepository({AssetBundle? bundle, this.assetPath = defaultAsset})
    : _bundle = bundle ?? rootBundle;

  static const defaultAsset = 'assets/content/catalog.json';

  final AssetBundle _bundle;
  final String assetPath;
  Future<ContentCatalog>? _catalog;

  Future<ContentCatalog> _load() => _catalog ??= _bundle
      .loadString(assetPath)
      .then(
        (raw) =>
            ContentCatalog.fromJson(jsonDecode(raw) as Map<String, dynamic>),
      );

  @override
  Future<List<Category>> getCategories() async => (await _load()).categories;

  @override
  Future<List<Meditation>> getMeditations({
    String? categoryId,
    int? maxDuration,
    bool includePremium = true,
  }) async {
    final meditations = (await _load()).meditations;
    return [
      for (final meditation in meditations)
        if ((categoryId == null ||
                meditation.categoryIds.contains(categoryId)) &&
            (maxDuration == null ||
                meditation.durationMinutes <= maxDuration) &&
            (includePremium || !meditation.isPremium))
          meditation,
    ];
  }

  @override
  Future<Meditation?> getMeditationById(String id) async {
    for (final meditation in (await _load()).meditations) {
      if (meditation.id == id) return meditation;
    }
    return null;
  }

  @override
  Future<List<Program>> getPrograms() async => (await _load()).programs;

  @override
  Future<Program?> getProgramById(String id) async {
    for (final program in (await _load()).programs) {
      if (program.id == id) return program;
    }
    return null;
  }
}
