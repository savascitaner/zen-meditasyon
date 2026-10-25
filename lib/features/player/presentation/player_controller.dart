import 'dart:async';

import 'package:audio_service/audio_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/l10n/locale_controller.dart';
import '../../content/domain/models/meditation.dart';
import '../../content/presentation/providers/content_providers.dart';
import '../data/audio_handler.dart';
import '../domain/listen_tracker.dart';
import '../domain/player_state.dart';
import '../domain/practice_log_repository.dart';
import '../domain/practice_session.dart';
import 'player_providers.dart';

final playerControllerProvider = NotifierProvider.autoDispose
    .family<PlayerController, PlayerState, String>(PlayerController.new);

/// Plays one meditation and records the session.
///
/// Leaving the screen (which disposes this controller) stops playback and
/// saves the session, with `completed: false` when less than 80% was heard.
class PlayerController extends Notifier<PlayerState> {
  PlayerController(this.meditationId);

  final String meditationId;

  late final MeditationAudioHandler _handler;
  late final PracticeLogRepository _log;
  late final DateTime Function() _now;
  final _subscriptions = <StreamSubscription<Object?>>[];
  final _tracker = ListenTracker();
  // Kept apart from `state`, which cannot be read while disposing.
  Duration _duration = Duration.zero;
  DateTime? _startedAt;
  bool _recorded = false;
  bool _disposed = false;

  @override
  PlayerState build() {
    _handler = ref.watch(audioHandlerProvider);
    _log = ref.watch(practiceLogRepositoryProvider);
    _now = ref.watch(clockProvider);
    ref.onDispose(_dispose);
    // build() must return before the state can change.
    Future.microtask(_load);
    return const PlayerState();
  }

  Future<void> _load() async {
    final Meditation? meditation;
    try {
      meditation = await ref
          .read(contentRepositoryProvider)
          .getMeditationById(meditationId);
    } catch (_) {
      return _fail(PlayerError.audioUnavailable);
    }
    if (_disposed) return;
    if (meditation == null) return _fail(PlayerError.notFound);

    final languageCode = ref.read(localeControllerProvider).languageCode;
    final item = MediaItem(
      id: meditation.id,
      title: meditation.title.resolve(languageCode),
      artist: meditation.narrator,
      duration: Duration(minutes: meditation.durationMinutes),
      // Flutter assets cannot be shown by the system, only remote images.
      artUri: meditation.coverImage?.startsWith('http') ?? false
          ? Uri.parse(meditation.coverImage!)
          : null,
    );
    final Duration? length;
    try {
      length = await _handler.load(item, meditation.audioSource);
    } catch (_) {
      return _fail(PlayerError.audioUnavailable);
    }
    if (_disposed) return;

    _duration = length ?? item.duration!;
    state = state.copyWith(
      status: PlayerStatus.paused,
      meditation: meditation,
      duration: _duration,
    );
    _subscriptions
      ..add(_handler.positionStream.listen(_onPosition))
      ..add(_handler.playbackState.listen(_onPlaybackState));
  }

  void _fail(PlayerError error) {
    if (_disposed) return;
    state = state.copyWith(status: PlayerStatus.error, error: error);
  }

  void _onPosition(Duration position) {
    if (state.status == PlayerStatus.loading) return;
    _tracker.onPosition(position, playing: state.isPlaying);
    state = state.copyWith(position: position);
  }

  void _onPlaybackState(PlaybackState playback) {
    if (state.status == PlayerStatus.loading ||
        state.status == PlayerStatus.error) {
      return;
    }
    if (playback.processingState == AudioProcessingState.completed) {
      if (state.status != PlayerStatus.ended) _onEnded();
      return;
    }
    if (state.status == PlayerStatus.ended) {
      // Play pressed on the lock screen after the end: a new session.
      if (!playback.playing) return;
      _resetSession();
    }
    if (playback.playing) _startedAt ??= _now();
    state = state.copyWith(
      status: playback.playing ? PlayerStatus.playing : PlayerStatus.paused,
    );
  }

  void _onEnded() {
    final session = _record();
    state = state.copyWith(
      status: PlayerStatus.ended,
      position: state.duration,
      completedSession: session != null && session.completed ? session : null,
    );
  }

  /// Saves the session once. Does nothing if playback never started.
  PracticeSession? _record() {
    final startedAt = _startedAt;
    if (_recorded || startedAt == null) return null;
    _recorded = true;
    final total = _duration;
    final listened = _tracker.listened > total ? total : _tracker.listened;
    final session = PracticeSession(
      meditationId: meditationId,
      startedAt: startedAt,
      listenedSeconds: listened.inSeconds,
      completed: isSessionCompleted(listened, total),
    );
    unawaited(_log.add(session));
    return session;
  }

  Future<void> togglePlayPause() async {
    switch (state.status) {
      case PlayerStatus.playing:
        await _handler.pause();
      case PlayerStatus.paused:
        await _handler.play();
      case PlayerStatus.ended:
        await _restart();
      case PlayerStatus.loading || PlayerStatus.error:
        break;
    }
  }

  /// Plays again from the start as a new session.
  Future<void> _restart() async {
    _resetSession();
    state = state.copyWith(status: PlayerStatus.paused);
    await _handler.seek(Duration.zero);
    await _handler.play();
  }

  void _resetSession() {
    _tracker.reset();
    _startedAt = null;
    _recorded = false;
    state = state.copyWith(position: Duration.zero, completedSession: null);
  }

  Future<void> skipBack() => _handler.rewind();

  Future<void> skipForward() => _handler.fastForward();

  /// Starts over after an error, e.g. a missing audio file.
  void retry() {
    if (state.status != PlayerStatus.error) return;
    _duration = Duration.zero;
    state = const PlayerState();
    Future.microtask(_load);
  }

  void _dispose() {
    _disposed = true;
    for (final subscription in _subscriptions) {
      subscription.cancel();
    }
    _record();
    unawaited(_handler.stop());
  }
}
