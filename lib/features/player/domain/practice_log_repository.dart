import 'practice_session.dart';

/// Where finished sessions are stored.
abstract interface class PracticeLogRepository {
  Future<void> add(PracticeSession session);

  /// Oldest first.
  Future<List<PracticeSession>> getAll();
}
