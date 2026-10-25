import 'dart:async';
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../domain/practice_log_repository.dart';
import '../domain/practice_session.dart';

/// Keeps the practice history in [SharedPreferences] (NSUserDefaults on iOS)
/// as a JSON list. Nothing leaves the device.
///
/// Unreadable data reads as an empty history instead of crashing the app;
/// single broken entries are skipped.
class LocalPracticeLogRepository implements PracticeLogRepository {
  LocalPracticeLogRepository(this._prefs);

  static const storageKey = 'practice_log_v1';

  /// Shorter sittings (opened by accident) are not recorded, so they cannot
  /// inflate streaks or statistics.
  static const minListenedSeconds = 30;

  final SharedPreferences _prefs;
  final _changes = StreamController<List<PracticeSession>>.broadcast();
  late List<PracticeSession> _sessions = _read();

  // Writes run one after another so two quick sessions never overwrite each
  // other.
  Future<void> _lastWrite = Future.value();

  @override
  Future<void> add(PracticeSession session) {
    if (session.listenedSeconds < minListenedSeconds) return Future.value();
    _sessions = [..._sessions, session];
    _changes.add(List.unmodifiable(_sessions));
    final encoded = jsonEncode([for (final s in _sessions) s.toJson()]);
    return _lastWrite = _lastWrite
        .catchError((Object _) => false)
        .then((_) => _prefs.setString(storageKey, encoded));
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

  List<PracticeSession> _read() {
    final raw = _prefs.getString(storageKey);
    if (raw == null) return [];
    try {
      final decoded = jsonDecode(raw);
      if (decoded is! List) return [];
      final sessions = <PracticeSession>[];
      for (final entry in decoded) {
        try {
          sessions.add(
            PracticeSession.fromJson(Map<String, dynamic>.from(entry as Map)),
          );
        } catch (_) {
          // Skip a single broken entry, keep the rest.
        }
      }
      return sessions;
    } catch (_) {
      return [];
    }
  }
}
