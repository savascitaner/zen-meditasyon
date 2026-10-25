import 'practice_session.dart';

/// Where finished sessions are stored.
///
/// The player is the only writer ([add]); screens read through [watchAll] so
/// they update by themselves when a session ends.
abstract interface class PracticeLogRepository {
  Future<void> add(PracticeSession session);

  /// Oldest first.
  Future<List<PracticeSession>> getAll();

  /// The current sessions (oldest first) right away, then again after every
  /// change.
  Stream<List<PracticeSession>> watchAll();
}
