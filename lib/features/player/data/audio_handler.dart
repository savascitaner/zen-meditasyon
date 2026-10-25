import 'dart:async';

import 'package:audio_service/audio_service.dart';
import 'package:audio_session/audio_session.dart';
import 'package:just_audio/just_audio.dart';

/// How far the back and forward buttons jump.
const playerSkipInterval = Duration(seconds: 15);

/// What the player needs from the audio layer.
///
/// The notification and lock screen call [play], [pause], [rewind] and
/// [fastForward] on this same object, so the app and the system controls
/// share one code path. Tests replace the audio engine with a fake subclass.
abstract class MeditationAudioHandler extends BaseAudioHandler
    with SeekHandler {
  /// Opens [source] (an `assets/...` path or an http(s) URL) and shows [item]
  /// on the lock screen. Returns the audio length when it is known; throws if
  /// the audio cannot be opened.
  Future<Duration?> load(MediaItem item, String source);

  /// Playback position, updated several times a second while playing.
  Stream<Duration> get positionStream;

  @override
  Future<void> rewind() => seek(_skipTarget(-playerSkipInterval));

  @override
  Future<void> fastForward() => seek(_skipTarget(playerSkipInterval));

  Duration _skipTarget(Duration delta) {
    final target = playbackState.value.position + delta;
    final length = mediaItem.value?.duration;
    if (target.isNegative) return Duration.zero;
    if (length != null && target > length) return length;
    return target;
  }
}

/// Plays through just_audio and mirrors its state to the system controls.
class JustAudioMeditationHandler extends MeditationAudioHandler {
  JustAudioMeditationHandler({AudioPlayer? player})
    : _player = player ?? AudioPlayer() {
    _player.playbackEventStream.listen(
      (event) => playbackState.add(_toPlaybackState()),
      onError: (Object _, StackTrace _) {},
    );
    _player.durationStream.listen((duration) {
      final item = mediaItem.value;
      if (duration != null && item != null) {
        mediaItem.add(item.copyWith(duration: duration));
      }
    });
    _sessionReady = _configureSession();
  }

  final AudioPlayer _player;
  AudioSession? _session;

  /// Completes once the audio session is configured. [play] waits for it, so
  /// an early tap cannot start playback without an active session.
  late final Future<void> _sessionReady;

  /// Speech/meditation audio focus: pauses for phone calls and other apps,
  /// and when headphones are unplugged. It does not resume on its own, so a
  /// call never restarts the session unexpectedly.
  Future<void> _configureSession() async {
    final session = await AudioSession.instance;
    await session.configure(const AudioSessionConfiguration.speech());
    _session = session;
    session.interruptionEventStream.listen((event) {
      if (event.begin) {
        if (event.type == AudioInterruptionType.duck) return;
        pause();
      }
    });
    session.becomingNoisyEventStream.listen((_) => pause());
  }

  @override
  Stream<Duration> get positionStream => _player.positionStream;

  @override
  Future<Duration?> load(MediaItem item, String source) async {
    mediaItem.add(item);
    final audioSource = source.startsWith('http')
        ? AudioSource.uri(Uri.parse(source))
        : AudioSource.asset(source);
    return _player.setAudioSource(audioSource);
  }

  @override
  Future<void> play() async {
    await _sessionReady;
    await _session?.setActive(true);
    await _player.play();
  }

  @override
  Future<void> pause() => _player.pause();

  @override
  Future<void> seek(Duration position) => _player.seek(position);

  @override
  Future<void> stop() async {
    await _player.stop();
    await _session?.setActive(false);
    await super.stop();
  }

  PlaybackState _toPlaybackState() {
    final playing = _player.playing;
    return PlaybackState(
      controls: [
        MediaControl.rewind,
        if (playing) MediaControl.pause else MediaControl.play,
        MediaControl.fastForward,
      ],
      systemActions: const {
        MediaAction.seek,
        MediaAction.rewind,
        MediaAction.fastForward,
      },
      androidCompactActionIndices: const [0, 1, 2],
      processingState: const {
        ProcessingState.idle: AudioProcessingState.idle,
        ProcessingState.loading: AudioProcessingState.loading,
        ProcessingState.buffering: AudioProcessingState.buffering,
        ProcessingState.ready: AudioProcessingState.ready,
        ProcessingState.completed: AudioProcessingState.completed,
      }[_player.processingState]!,
      playing: playing,
      updatePosition: _player.position,
      bufferedPosition: _player.bufferedPosition,
      speed: _player.speed,
    );
  }
}
