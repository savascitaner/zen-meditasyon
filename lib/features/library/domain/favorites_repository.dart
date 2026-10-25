/// Which meditations the user has marked as favorites.
abstract interface class FavoritesRepository {
  /// Meditation ids in the order they were added.
  List<String> load();

  Future<void> save(List<String> ids);
}
