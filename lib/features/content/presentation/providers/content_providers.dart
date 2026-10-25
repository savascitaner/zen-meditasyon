import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/local_content_repository.dart';
import '../../domain/content_repository.dart';
import '../../domain/models/category.dart';
import '../../domain/models/meditation.dart';
import '../../domain/models/meditation_filter.dart';
import '../../domain/models/program.dart';

/// Swap the implementation here (or override in tests) when a backend lands.
final contentRepositoryProvider = Provider<ContentRepository>(
  (ref) => LocalContentRepository(),
);

final categoriesProvider = FutureProvider<List<Category>>(
  (ref) => ref.watch(contentRepositoryProvider).getCategories(),
);

/// The whole catalog, loaded once. Explore filters it in memory.
final allMeditationsProvider = FutureProvider<List<Meditation>>(
  (ref) => ref.watch(contentRepositoryProvider).getMeditations(),
);

final meditationsProvider =
    FutureProvider.family<List<Meditation>, MeditationFilter>(
      (ref, filter) => ref
          .watch(contentRepositoryProvider)
          .getMeditations(
            categoryId: filter.categoryId,
            maxDuration: filter.maxDuration,
            includePremium: filter.includePremium,
          ),
    );

final meditationByIdProvider = FutureProvider.family<Meditation?, String>(
  (ref, id) => ref.watch(contentRepositoryProvider).getMeditationById(id),
);

final programsProvider = FutureProvider<List<Program>>(
  (ref) => ref.watch(contentRepositoryProvider).getPrograms(),
);

final programByIdProvider = FutureProvider.family<Program?, String>(
  (ref, id) => ref.watch(contentRepositoryProvider).getProgramById(id),
);
