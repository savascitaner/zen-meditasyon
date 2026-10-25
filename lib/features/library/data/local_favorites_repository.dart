import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../domain/favorites_repository.dart';

/// Keeps favorite ids in [SharedPreferences] as a JSON list, in the order
/// they were added. Unreadable data reads as no favorites.
class LocalFavoritesRepository implements FavoritesRepository {
  LocalFavoritesRepository(this._prefs);

  static const storageKey = 'favorites_v1';

  final SharedPreferences _prefs;

  @override
  List<String> load() {
    final raw = _prefs.getString(storageKey);
    if (raw == null) return [];
    try {
      final decoded = jsonDecode(raw);
      if (decoded is! List) return [];
      return [
        for (final id in decoded)
          if (id is String) id,
      ];
    } catch (_) {
      return [];
    }
  }

  @override
  Future<void> save(List<String> ids) =>
      _prefs.setString(storageKey, jsonEncode(ids));
}
