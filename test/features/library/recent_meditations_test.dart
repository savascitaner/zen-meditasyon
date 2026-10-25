import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:zen_meditation/features/content/domain/models/localized_text.dart';
import 'package:zen_meditation/features/content/domain/models/meditation.dart';
import 'package:zen_meditation/features/content/presentation/providers/content_providers.dart';
import 'package:zen_meditation/features/library/presentation/providers/library_providers.dart';
import 'package:zen_meditation/features/player/domain/practice_session.dart';
import 'package:zen_meditation/features/player/presentation/player_providers.dart';

import '../../helpers/fake_content_repository.dart';
import '../../helpers/in_memory_practice_log_repository.dart';

PracticeSession at(String id, int day) => PracticeSession(
  meditationId: id,
  startedAt: DateTime(2026, 10, day, 9),
  listenedSeconds: 300,
  completed: true,
);

Meditation med(String id) => Meditation(
  id: id,
  title: LocalizedText(en: id, tr: id),
  description: const LocalizedText(en: '', tr: ''),
  categoryIds: const ['sleep'],
  durationMinutes: 5,
  audioSource: 'assets/audio/sample.mp3',
  narrator: 'Maya',
);

void main() {
  group('recentMeditations', () {
    final catalog = [for (final id in 'abcdefghijkl'.split('')) med(id)];

    test('newest first, each meditation once', () {
      final result = recentMeditations([
        at('a', 1),
        at('b', 2),
        at('a', 3),
        at('c', 4),
      ], catalog);

      expect(result.map((m) => m.id), ['c', 'a', 'b']);
    });

    test('does not depend on the order of the input', () {
      final result = recentMeditations([
        at('c', 4),
        at('a', 1),
        at('b', 2),
      ], catalog);

      expect(result.map((m) => m.id), ['c', 'b', 'a']);
    });

    test('stops at 10 meditations', () {
      final sessions = [for (var i = 0; i < 12; i++) at(catalog[i].id, i + 1)];

      final result = recentMeditations(sessions, catalog);

      expect(result, hasLength(10));
      expect(result.first.id, 'l');
      expect(result.last.id, 'c');
    });

    test('skips meditations that left the catalog', () {
      final result = recentMeditations([
        at('a', 1),
        at('gone', 2),
        at('b', 3),
      ], catalog);

      expect(result.map((m) => m.id), ['b', 'a']);
    });

    test('empty history gives an empty list', () {
      expect(recentMeditations([], catalog), isEmpty);
    });
  });

  test('recentMeditationsProvider follows the saved history', () async {
    final log = InMemoryPracticeLogRepository();
    final container = ProviderContainer(
      overrides: [
        practiceLogRepositoryProvider.overrideWithValue(log),
        contentRepositoryProvider.overrideWithValue(FakeContentRepository()),
      ],
    );
    addTearDown(container.dispose);
    container.listen(recentMeditationsProvider, (_, _) {});

    expect(await container.read(recentMeditationsProvider.future), isEmpty);

    await log.add(at('free-sleep', 1));
    await log.add(at('free-focus', 2));
    await pumpEventQueue();

    expect(container.read(recentMeditationsProvider).value, [
      freeFocus,
      freeSleep,
    ]);
  });
}
