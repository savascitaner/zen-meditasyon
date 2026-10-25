import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/l10n/locale_controller.dart';
import '../../../content/domain/models/meditation.dart';
import '../../../content/presentation/providers/content_providers.dart';
import '../../../player/domain/practice_session.dart';
import '../../../player/presentation/player_providers.dart';
import '../../data/local_favorites_repository.dart';
import '../../domain/favorites_repository.dart';

/// How many meditations "recently listened" shows.
const recentMeditationsLimit = 10;

final favoritesRepositoryProvider = Provider<FavoritesRepository>(
  (ref) => LocalFavoritesRepository(ref.watch(sharedPreferencesProvider)),
);

final favoritesProvider = NotifierProvider<FavoritesNotifier, List<String>>(
  FavoritesNotifier.new,
);

/// Favorite meditation ids, oldest first. [toggle] updates the state at once
/// and saves in the background.
class FavoritesNotifier extends Notifier<List<String>> {
  @override
  List<String> build() => ref.watch(favoritesRepositoryProvider).load();

  void toggle(String id) {
    state = state.contains(id)
        ? [
            for (final existing in state)
              if (existing != id) existing,
          ]
        : [...state, id];
    unawaited(ref.read(favoritesRepositoryProvider).save(state));
  }
}

/// Every recorded session, oldest first, kept up to date as sessions end.
final practiceHistoryProvider = StreamProvider<List<PracticeSession>>(
  (ref) => ref.watch(practiceLogRepositoryProvider).watchAll(),
);

/// Favorites that still exist in the catalog, in the order they were added.
final favoriteMeditationsProvider = FutureProvider<List<Meditation>>((
  ref,
) async {
  final ids = ref.watch(favoritesProvider);
  final catalog = await ref.watch(allMeditationsProvider.future);
  return resolveMeditations(ids, catalog);
});

/// The last meditations listened to, newest first, without repeats.
final recentMeditationsProvider = FutureProvider<List<Meditation>>((ref) async {
  final sessions = await ref.watch(practiceHistoryProvider.future);
  final catalog = await ref.watch(allMeditationsProvider.future);
  return recentMeditations(sessions, catalog);
});

/// [ids] mapped to meditations, skipping ids no longer in the [catalog].
List<Meditation> resolveMeditations(
  List<String> ids,
  List<Meditation> catalog,
) {
  final byId = {for (final m in catalog) m.id: m};
  return [for (final id in ids) ?byId[id]];
}

/// At most [limit] distinct meditations from [sessions] (oldest first),
/// newest first. Ids missing from the [catalog] are skipped.
List<Meditation> recentMeditations(
  List<PracticeSession> sessions,
  List<Meditation> catalog, {
  int limit = recentMeditationsLimit,
}) {
  final newestFirst = [...sessions]
    ..sort((a, b) => b.startedAt.compareTo(a.startedAt));
  final ids = <String>[];
  for (final session in newestFirst) {
    if (!ids.contains(session.meditationId)) ids.add(session.meditationId);
  }
  return resolveMeditations(ids, catalog).take(limit).toList();
}
