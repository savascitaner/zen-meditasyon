import 'package:freezed_annotation/freezed_annotation.dart';

part 'practice_session.freezed.dart';
part 'practice_session.g.dart';

/// Share of the audio that has to be listened to for a session to count as
/// completed.
const sessionCompletionThreshold = 0.8;

/// Whether [listened] of a [total]-long audio counts as a completed session.
bool isSessionCompleted(Duration listened, Duration total) =>
    total > Duration.zero &&
    listened.inMilliseconds >=
        (total.inMilliseconds * sessionCompletionThreshold).round();

/// One sitting with one meditation. Streaks and statistics are built from
/// these.
@freezed
abstract class PracticeSession with _$PracticeSession {
  const factory PracticeSession({
    required String meditationId,
    required DateTime startedAt,

    /// Seconds actually listened to; skipping ahead does not count.
    ///
    /// The fields below default so records saved by older versions stay
    /// readable.
    @Default(0) int listenedSeconds,
    @Default(false) bool completed,
  }) = _PracticeSession;

  factory PracticeSession.fromJson(Map<String, dynamic> json) =>
      _$PracticeSessionFromJson(json);
}
