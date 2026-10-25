import 'dart:async';

import 'package:audio_service/audio_service.dart';
import 'package:zen_meditation/features/player/data/audio_handler.dart';

/// A [MeditationAudioHandler] without an audio engine.
///
/// Tests drive time with [emitPosition] and [finish]; [seeks], [loads] and
/// [stopCalls] record what the player asked for.
class FakeAudioHandler extends MeditationAudioHandler {
  FakeAudioHandler({this.length = const Duration(minutes: 10)});

  /// Returned by [load]; null mimics a stream of unknown length.
  Duration? length;

  /// Makes [load] throw, like a missing audio file.
  Object? loadError;

  final List<(MediaItem, String)> loads = [];
  final List<Duration> seeks = [];
  int stopCalls = 0;

  final _positions = StreamController<Duration>.broadcast(sync: true);
  Duration _position = Duration.zero;
  bool _playing = false;

  @override
  Stream<Duration> get positionStream => _positions.stream;

  @override
  Future<Duration?> load(MediaItem item, String source) async {
    final error = loadError;
    if (error != null) throw error;
    loads.add((item, source));
    mediaItem.add(item.copyWith(duration: length));
    _publish();
    return length;
  }

  @override
  Future<void> play() async {
    _playing = true;
    _publish();
  }

  @override
  Future<void> pause() async {
    _playing = false;
    _publish();
  }

  @override
  Future<void> seek(Duration position) async {
    seeks.add(position);
    emitPosition(position);
  }

  @override
  Future<void> stop() async {
    stopCalls++;
    _playing = false;
    _publish(state: AudioProcessingState.idle);
  }

  /// Moves the playhead, as the audio engine does while playing.
  void emitPosition(Duration position) {
    _position = position;
    _publish();
    _positions.add(position);
  }

  /// Plays on from the current position in one-second steps.
  void listenFor(Duration duration) {
    for (var i = 0; i < duration.inSeconds; i++) {
      emitPosition(_position + const Duration(seconds: 1));
    }
  }

  /// The audio reached its end.
  void finish() => _publish(state: AudioProcessingState.completed);

  void _publish({AudioProcessingState state = AudioProcessingState.ready}) {
    playbackState.add(
      PlaybackState(
        playing: _playing,
        processingState: state,
        updatePosition: _position,
        // Zero speed: the position does not drift with the wall clock.
        speed: 0,
      ),
    );
  }
}
