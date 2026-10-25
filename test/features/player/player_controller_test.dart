import 'dart:ui';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zen_meditation/core/l10n/locale_controller.dart';
import 'package:zen_meditation/features/content/presentation/providers/content_providers.dart';
import 'package:zen_meditation/features/player/domain/player_state.dart';
import 'package:zen_meditation/features/player/presentation/player_controller.dart';
import 'package:zen_meditation/features/player/presentation/player_providers.dart';

import '../../helpers/fake_audio_handler.dart';
import '../../helpers/fake_content_repository.dart';
import '../../helpers/in_memory_practice_log_repository.dart';

final startTime = DateTime(2026, 10, 25, 9);

class Setup {
  Setup._(this.handler, this.log, this.container);

  final FakeAudioHandler handler;
  final InMemoryPracticeLogRepository log;
  final ProviderContainer container;

  final provider = playerControllerProvider(freeSleep.id);

  PlayerController get controller => container.read(provider.notifier);
  PlayerState get state => container.read(provider);

  /// Leaving the player screen disposes the controller.
  void leave() => container.dispose();

  static Future<Setup> create({
    Duration length = const Duration(seconds: 100),
    Object? loadError,
    String meditationId = 'free-sleep',
  }) async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    final handler = FakeAudioHandler(length: length)..loadError = loadError;
    final log = InMemoryPracticeLogRepository();
    final container = ProviderContainer(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(prefs),
        deviceLocaleProvider.overrideWithValue(const Locale('en')),
        audioHandlerProvider.overrideWithValue(handler),
        practiceLogRepositoryProvider.overrideWithValue(log),
        clockProvider.overrideWithValue(() => startTime),
        contentRepositoryProvider.overrideWithValue(FakeContentRepository()),
      ],
    );
    final setup = Setup._(handler, log, container);
    // autoDispose providers need a listener to stay alive.
    container.listen(playerControllerProvider(meditationId), (_, _) {});
    await pumpEventQueue();
    return setup;
  }
}

void main() {
  test('loads the meditation and waits for play', () async {
    final s = await Setup.create();

    expect(s.state.status, PlayerStatus.paused);
    expect(s.state.meditation, freeSleep);
    expect(s.state.duration, const Duration(seconds: 100));
    final (item, source) = s.handler.loads.single;
    expect(source, 'assets/audio/sample.mp3');
    expect(item.title, 'Winding down');
    expect(item.artist, 'Maya');
  });

  test('play and pause switch the status', () async {
    final s = await Setup.create();

    await s.controller.togglePlayPause();
    expect(s.state.status, PlayerStatus.playing);
    expect(s.state.isPlaying, isTrue);

    await s.controller.togglePlayPause();
    expect(s.state.status, PlayerStatus.paused);

    await s.controller.togglePlayPause();
    expect(s.state.status, PlayerStatus.playing);
  });

  test('pausing from the lock screen updates the status', () async {
    final s = await Setup.create();
    await s.controller.togglePlayPause();

    await s.handler.pause();

    expect(s.state.status, PlayerStatus.paused);
  });

  test('position and remaining time follow the audio', () async {
    final s = await Setup.create();
    await s.controller.togglePlayPause();

    s.handler.listenFor(const Duration(seconds: 25));

    expect(s.state.position, const Duration(seconds: 25));
    expect(s.state.remaining, const Duration(seconds: 75));
    expect(s.state.progress, closeTo(0.25, 0.001));
  });

  test('skips 15 seconds back and forward, within the audio', () async {
    final s = await Setup.create();
    await s.controller.togglePlayPause();
    s.handler.listenFor(const Duration(seconds: 10));

    await s.controller.skipBack();
    expect(s.handler.seeks.last, Duration.zero);

    await s.controller.skipForward();
    expect(s.handler.seeks.last, const Duration(seconds: 15));

    s.handler.emitPosition(const Duration(seconds: 95));
    await s.controller.skipForward();
    expect(s.handler.seeks.last, const Duration(seconds: 100));
  });

  group('practice log', () {
    test('listening to the end records a completed session', () async {
      final s = await Setup.create();
      await s.controller.togglePlayPause();

      s.handler
        ..listenFor(const Duration(seconds: 100))
        ..finish();
      await pumpEventQueue();

      expect(s.state.status, PlayerStatus.ended);
      final session = s.state.completedSession;
      expect(session, isNotNull);
      final saved = (await s.log.getAll()).single;
      expect(saved, session);
      expect(saved.meditationId, 'free-sleep');
      expect(saved.startedAt, startTime);
      expect(saved.listenedSeconds, 100);
      expect(saved.completed, isTrue);

      // Leaving afterwards does not record it a second time.
      s.leave();
      expect(await s.log.getAll(), hasLength(1));
    });

    test('leaving at 80% counts as completed', () async {
      final s = await Setup.create();
      await s.controller.togglePlayPause();
      s.handler.listenFor(const Duration(seconds: 80));

      s.leave();

      final saved = (await s.log.getAll()).single;
      expect(saved.listenedSeconds, 80);
      expect(saved.completed, isTrue);
    });

    test('leaving below 80% records completed: false', () async {
      final s = await Setup.create();
      await s.controller.togglePlayPause();
      s.handler.listenFor(const Duration(seconds: 79));

      s.leave();

      final saved = (await s.log.getAll()).single;
      expect(saved.listenedSeconds, 79);
      expect(saved.completed, isFalse);
      expect(s.handler.stopCalls, 1);
    });

    test('skipping ahead does not count as listening', () async {
      final s = await Setup.create();
      await s.controller.togglePlayPause();
      s.handler.listenFor(const Duration(seconds: 10));
      await s.controller.skipForward();
      await s.controller.skipForward();
      await s.controller.skipForward();
      s.handler.listenFor(const Duration(seconds: 5));

      s.leave();

      final saved = (await s.log.getAll()).single;
      expect(saved.listenedSeconds, 15);
      expect(saved.completed, isFalse);
    });

    test('reaching the end by skipping is not completed', () async {
      final s = await Setup.create();
      await s.controller.togglePlayPause();
      s.handler.listenFor(const Duration(seconds: 5));
      s.handler.emitPosition(const Duration(seconds: 100));
      s.handler.finish();
      await pumpEventQueue();

      final saved = (await s.log.getAll()).single;
      expect(saved.completed, isFalse);
      expect(s.state.completedSession, isNull);
      expect(s.state.status, PlayerStatus.ended);
    });

    test('leaving without playing records nothing', () async {
      final s = await Setup.create();

      s.leave();

      expect(await s.log.getAll(), isEmpty);
      expect(s.handler.stopCalls, 1);
    });

    test('playing again after the end starts a new session', () async {
      final s = await Setup.create();
      await s.controller.togglePlayPause();
      s.handler
        ..listenFor(const Duration(seconds: 100))
        ..finish();
      await pumpEventQueue();

      await s.controller.togglePlayPause();
      expect(s.state.status, PlayerStatus.playing);
      expect(s.state.completedSession, isNull);
      s.handler.listenFor(const Duration(seconds: 10));
      s.leave();

      final saved = await s.log.getAll();
      expect(saved, hasLength(2));
      expect(saved.last.listenedSeconds, 10);
      expect(saved.last.completed, isFalse);
    });
  });

  group('errors', () {
    test('a missing audio file shows an error state', () async {
      final s = await Setup.create(loadError: StateError('no such asset'));

      expect(s.state.status, PlayerStatus.error);
      expect(s.state.error, PlayerError.audioUnavailable);
      await s.controller.togglePlayPause();
      expect(s.state.status, PlayerStatus.error);
    });

    test('retry works once the audio is available', () async {
      final s = await Setup.create(loadError: StateError('no such asset'));

      s.handler.loadError = null;
      s.controller.retry();
      await pumpEventQueue();

      expect(s.state.status, PlayerStatus.paused);
      expect(s.state.error, isNull);
    });

    test('an unknown meditation id is reported as not found', () async {
      final s = await Setup.create(meditationId: 'nope');
      final state = s.container.read(playerControllerProvider('nope'));

      expect(state.status, PlayerStatus.error);
      expect(state.error, PlayerError.notFound);
    });
  });
}
