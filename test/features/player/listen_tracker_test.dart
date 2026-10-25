import 'package:flutter_test/flutter_test.dart';
import 'package:zen_meditation/features/player/domain/listen_tracker.dart';
import 'package:zen_meditation/features/player/domain/practice_session.dart';

void main() {
  group('ListenTracker', () {
    test('adds up small steps while playing', () {
      final tracker = ListenTracker();
      for (var s = 0; s <= 10; s++) {
        tracker.onPosition(Duration(seconds: s), playing: true);
      }
      expect(tracker.listened, const Duration(seconds: 10));
    });

    test('ignores jumps and steps backwards', () {
      final tracker = ListenTracker()
        ..onPosition(Duration.zero, playing: true)
        ..onPosition(const Duration(seconds: 1), playing: true)
        ..onPosition(const Duration(seconds: 16), playing: true)
        ..onPosition(const Duration(seconds: 2), playing: true);
      expect(tracker.listened, const Duration(seconds: 1));
    });

    test('ignores movement while not playing', () {
      final tracker = ListenTracker()
        ..onPosition(Duration.zero, playing: false)
        ..onPosition(const Duration(seconds: 1), playing: false);
      expect(tracker.listened, Duration.zero);
    });

    test('reset starts over', () {
      final tracker = ListenTracker()
        ..onPosition(Duration.zero, playing: true)
        ..onPosition(const Duration(seconds: 1), playing: true)
        ..reset();
      expect(tracker.listened, Duration.zero);
    });
  });

  group('isSessionCompleted', () {
    const total = Duration(seconds: 100);

    test('needs 80% of the audio', () {
      expect(isSessionCompleted(const Duration(seconds: 79), total), isFalse);
      expect(isSessionCompleted(const Duration(seconds: 80), total), isTrue);
      expect(isSessionCompleted(total, total), isTrue);
    });

    test('is false for audio of unknown length', () {
      expect(
        isSessionCompleted(const Duration(seconds: 5), Duration.zero),
        isFalse,
      );
    });
  });
}
