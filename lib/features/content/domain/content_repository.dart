import 'models/category.dart';
import 'models/meditation.dart';
import 'models/program.dart';

/// Read access to the content catalog.
///
/// The app only depends on this interface, so the local JSON implementation
/// can later be swapped for a backend one.
abstract interface class ContentRepository {
  Future<List<Category>> getCategories();

  /// All meditations, narrowed by every filter that is given.
  Future<List<Meditation>> getMeditations({
    String? categoryId,
    int? maxDuration,
    bool includePremium = true,
  });

  /// Null when no meditation has this id.
  Future<Meditation?> getMeditationById(String id);

  Future<List<Program>> getPrograms();

  /// Null when no program has this id.
  Future<Program?> getProgramById(String id);
}
