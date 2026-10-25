import 'package:freezed_annotation/freezed_annotation.dart';

import '../../content/domain/models/meditation.dart';
import 'practice_session.dart';

part 'player_state.freezed.dart';

enum PlayerStatus { loading, paused, playing, ended, error }

enum PlayerError {
  /// No meditation with that id.
  notFound,

  /// The audio file is missing or could not be opened.
  audioUnavailable,
}

@freezed
abstract class PlayerState with _$PlayerState {
  const PlayerState._();

  const factory PlayerState({
    @Default(PlayerStatus.loading) PlayerStatus status,
    @Default(Duration.zero) Duration position,
    @Default(Duration.zero) Duration duration,
    Meditation? meditation,
    PlayerError? error,

    /// Set when the audio played to its end and the session counted as
    /// completed; the screen shows the completion sheet for it.
    PracticeSession? completedSession,
  }) = _PlayerState;

  bool get isPlaying => status == PlayerStatus.playing;

  Duration get remaining {
    final left = duration - position;
    return left.isNegative ? Duration.zero : left;
  }

  /// 0.0 to 1.0.
  double get progress => duration.inMilliseconds == 0
      ? 0
      : (position.inMilliseconds / duration.inMilliseconds).clamp(0.0, 1.0);
}
