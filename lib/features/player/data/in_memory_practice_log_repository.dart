import '../domain/practice_log_repository.dart';
import '../domain/practice_session.dart';

/// Keeps sessions for the lifetime of the app. Görev 7 replaces it with a
/// persistent implementation.
class InMemoryPracticeLogRepository implements PracticeLogRepository {
  final List<PracticeSession> _sessions = [];

  @override
  Future<void> add(PracticeSession session) async => _sessions.add(session);

  @override
  Future<List<PracticeSession>> getAll() async => List.unmodifiable(_sessions);
}
