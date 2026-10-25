import 'dart:async';

import 'package:zen_meditation/features/player/domain/practice_log_repository.dart';
import 'package:zen_meditation/features/player/domain/practice_session.dart';

/// Keeps every session in memory, with no minimum length, so player tests
/// can check exactly what the controller recorded.
class InMemoryPracticeLogRepository implements PracticeLogRepository {
  final List<PracticeSession> _sessions = [];
  final _changes = StreamController<List<PracticeSession>>.broadcast();

  @override
  Future<void> add(PracticeSession session) async {
    _sessions.add(session);
    _changes.add(List.unmodifiable(_sessions));
  }

  @override
  Future<List<PracticeSession>> getAll() async => List.unmodifiable(_sessions);

  @override
  Stream<List<PracticeSession>> watchAll() {
    // Subscribes to the changes in the same step as it emits the current
    // list, so an add in between cannot be missed.
    late final StreamController<List<PracticeSession>> controller;
    StreamSubscription<List<PracticeSession>>? changes;
    controller = StreamController(
      onListen: () {
        controller.add(List.unmodifiable(_sessions));
        changes = _changes.stream.listen(controller.add);
      },
      onCancel: () => changes?.cancel(),
    );
    return controller.stream;
  }
}
