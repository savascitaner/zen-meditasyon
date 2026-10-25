import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zen_meditation/features/player/data/local_practice_log_repository.dart';
import 'package:zen_meditation/features/player/domain/practice_session.dart';

PracticeSession session({
  String id = 'free-sleep',
  int seconds = 120,
  DateTime? at,
  bool completed = true,
}) => PracticeSession(
  meditationId: id,
  startedAt: at ?? DateTime(2026, 10, 25, 9),
  listenedSeconds: seconds,
  completed: completed,
);

Future<SharedPreferences> prefsWith(Map<String, Object> values) async {
  SharedPreferences.setMockInitialValues(values);
  return SharedPreferences.getInstance();
}

void main() {
  test('sessions survive an app restart', () async {
    final prefs = await prefsWith({});
    final first = LocalPracticeLogRepository(prefs);
    final a = session();
    final b = session(id: 'free-focus', at: DateTime(2026, 10, 26, 7));
    await first.add(a);
    await first.add(b);

    // A new repository on the same storage, like after relaunching.
    final second = LocalPracticeLogRepository(prefs);

    expect(await second.getAll(), [a, b]);
  });

  test('watchAll emits the current list, then again on every add', () async {
    final repo = LocalPracticeLogRepository(await prefsWith({}));
    final a = session();
    final b = session(id: 'free-focus');
    final emitted = <List<PracticeSession>>[];
    final sub = repo.watchAll().listen(emitted.add);
    await pumpEventQueue();

    await repo.add(a);
    await repo.add(b);
    await pumpEventQueue();
    await sub.cancel();

    expect(emitted, [
      <PracticeSession>[],
      [a],
      [a, b],
    ]);
  });

  test('sessions under 30 seconds are not stored', () async {
    final prefs = await prefsWith({});
    final repo = LocalPracticeLogRepository(prefs);
    final emitted = <List<PracticeSession>>[];
    final sub = repo.watchAll().listen(emitted.add);

    await repo.add(session(seconds: 29));
    await repo.add(session(seconds: 30, id: 'kept'));
    await pumpEventQueue();
    await sub.cancel();

    expect((await repo.getAll()).map((s) => s.meditationId), ['kept']);
    expect(emitted, hasLength(2));
    expect((await LocalPracticeLogRepository(prefs).getAll()), hasLength(1));
  });

  for (final broken in ['{not json', '{"a": 1}', '"text"', '']) {
    test('unreadable data "$broken" reads as an empty history', () async {
      final repo = LocalPracticeLogRepository(
        await prefsWith({LocalPracticeLogRepository.storageKey: broken}),
      );

      expect(await repo.getAll(), isEmpty);
    });
  }

  test('one broken entry is skipped, the rest is kept', () async {
    final good = session();
    final repo = LocalPracticeLogRepository(
      await prefsWith({
        LocalPracticeLogRepository.storageKey:
            '[{"meditationId": 5}, "oops", ${_json(good)}]',
      }),
    );

    expect(await repo.getAll(), [good]);
  });

  test('adding after broken data starts a clean history', () async {
    final prefs = await prefsWith({
      LocalPracticeLogRepository.storageKey: '{not json',
    });
    final repo = LocalPracticeLogRepository(prefs);
    final a = session();

    await repo.add(a);

    expect(await LocalPracticeLogRepository(prefs).getAll(), [a]);
  });
}

String _json(PracticeSession s) =>
    '{"meditationId":"${s.meditationId}",'
    '"startedAt":"${s.startedAt.toIso8601String()}",'
    '"listenedSeconds":${s.listenedSeconds},"completed":${s.completed}}';
