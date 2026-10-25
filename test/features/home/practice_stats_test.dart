import 'package:flutter_test/flutter_test.dart';
import 'package:zen_meditation/features/home/domain/practice_stats.dart';
import 'package:zen_meditation/features/player/domain/practice_session.dart';

PracticeSession done(DateTime at, {int seconds = 600}) => PracticeSession(
  meditationId: 'm',
  startedAt: at,
  listenedSeconds: seconds,
  completed: true,
);

PracticeSession partial(DateTime at, {int seconds = 120}) => PracticeSession(
  meditationId: 'm',
  startedAt: at,
  listenedSeconds: seconds,
  completed: false,
);

// Sunday 25 October 2026.
final now = DateTime(2026, 10, 25, 10);

PracticeStats stats(
  List<PracticeSession> sessions, {
  DateTime? at,
  int firstDay = 1,
}) => PracticeStats.fromSessions(
  sessions,
  at ?? now,
  firstDayOfWeekIndex: firstDay,
);

void main() {
  test('empty history', () {
    final s = stats([]);

    expect(s.currentStreak, 0);
    expect(s.longestStreak, 0);
    expect(s.totalMinutes, 0);
    expect(s.completedSessions, 0);
    expect(s.hasHistory, isFalse);
    expect(s.weekDays, everyElement(isFalse));
  });

  test('a single day today', () {
    final s = stats([done(DateTime(2026, 10, 25, 7))]);

    expect(s.currentStreak, 1);
    expect(s.longestStreak, 1);
    expect(s.completedSessions, 1);
    expect(s.totalMinutes, 10);
  });

  test('several sessions on one day count as one day', () {
    final s = stats([
      done(DateTime(2026, 10, 25, 7)),
      done(DateTime(2026, 10, 25, 21)),
    ]);

    expect(s.currentStreak, 1);
    expect(s.completedSessions, 2);
  });

  test('consecutive days build a streak', () {
    final s = stats([
      done(DateTime(2026, 10, 23, 8)),
      done(DateTime(2026, 10, 24, 8)),
      done(DateTime(2026, 10, 25, 8)),
    ]);

    expect(s.currentStreak, 3);
    expect(s.longestStreak, 3);
  });

  test('the streak stays alive while today has no practice yet', () {
    final s = stats([
      done(DateTime(2026, 10, 23, 8)),
      done(DateTime(2026, 10, 24, 22)),
    ]);

    expect(s.currentStreak, 2);
  });

  test('a streak is broken after a missed day', () {
    final s = stats([
      done(DateTime(2026, 10, 20, 8)),
      done(DateTime(2026, 10, 21, 8)),
      done(DateTime(2026, 10, 22, 8)),
    ]);

    expect(s.currentStreak, 0);
    expect(s.longestStreak, 3);
  });

  test('the longest streak is kept after a newer, shorter one', () {
    final s = stats([
      for (var d = 1; d <= 4; d++) done(DateTime(2026, 10, d, 8)),
      done(DateTime(2026, 10, 24, 8)),
      done(DateTime(2026, 10, 25, 8)),
    ]);

    expect(s.currentStreak, 2);
    expect(s.longestStreak, 4);
  });

  test('unfinished sessions add time but not streak days', () {
    final s = stats([
      partial(DateTime(2026, 10, 25, 8), seconds: 90),
      done(DateTime(2026, 10, 24, 8), seconds: 30),
    ]);

    expect(s.currentStreak, 1);
    expect(s.completedSessions, 1);
    expect(s.totalMinutes, 2);
    expect(s.hasHistory, isTrue);
    expect(s.weekDays[s.todayIndex], isFalse);
  });

  test('only unfinished sessions give no streak', () {
    final s = stats([partial(DateTime(2026, 10, 25, 8))]);

    expect(s.currentStreak, 0);
    expect(s.longestStreak, 0);
    expect(s.totalMinutes, 2);
  });

  group('midnight', () {
    test('23:59 and 00:01 are different days', () {
      final s = stats([
        done(DateTime(2026, 10, 24, 23, 59)),
        done(DateTime(2026, 10, 25, 0, 1)),
      ], at: DateTime(2026, 10, 25, 0, 30));

      expect(s.currentStreak, 2);
    });

    test('a session just before midnight keeps yesterday alive', () {
      final s = stats([
        done(DateTime(2026, 10, 24, 23, 59)),
      ], at: DateTime(2026, 10, 25, 0, 1));

      expect(s.currentStreak, 1);
    });

    test('two days later the streak is gone', () {
      final s = stats([
        done(DateTime(2026, 10, 24, 23, 59)),
      ], at: DateTime(2026, 10, 26, 0, 1));

      expect(s.currentStreak, 0);
      expect(s.longestStreak, 1);
    });
  });

  group('daylight saving', () {
    // Clocks change in Europe on 29 March and 25 October 2026 (the 25-hour
    // day) and in the US on 8 March and 1 November. The days are compared
    // as calendar dates, so the result is the same in any time zone.
    test('across the spring change', () {
      final s = stats([
        done(DateTime(2026, 3, 28, 23, 30)),
        done(DateTime(2026, 3, 29, 0, 30)),
        done(DateTime(2026, 3, 30, 23, 30)),
      ], at: DateTime(2026, 3, 30, 23, 45));

      expect(s.currentStreak, 3);
      expect(s.longestStreak, 3);
    });

    test('across the autumn change', () {
      final s = stats([
        done(DateTime(2026, 10, 24, 23, 30)),
        done(DateTime(2026, 10, 25, 0, 30)),
        done(DateTime(2026, 10, 26, 0, 30)),
      ], at: DateTime(2026, 10, 26, 12));

      expect(s.currentStreak, 3);
    });

    test('across the US autumn change', () {
      final s = stats([
        done(DateTime(2026, 10, 31, 23, 30)),
        done(DateTime(2026, 11, 1, 0, 30)),
        done(DateTime(2026, 11, 2, 23, 30)),
      ], at: DateTime(2026, 11, 2, 23, 45));

      expect(s.currentStreak, 3);
    });

    test('the week on the day of the change', () {
      final s = stats([
        done(DateTime(2026, 10, 26, 8)),
      ], at: DateTime(2026, 10, 28, 8));

      // Monday-first week of 26 October: Monday is the first slot.
      expect(s.weekDays, [true, false, false, false, false, false, false]);
      expect(s.todayIndex, 2);
    });
  });

  group('this week', () {
    final sessions = [
      done(DateTime(2026, 10, 19, 8)), // Monday
      done(DateTime(2026, 10, 21, 8)), // Wednesday
      done(DateTime(2026, 10, 25, 8)), // Sunday
      done(DateTime(2026, 10, 18, 8)), // Sunday of the week before
    ];

    test('starts on Monday when the locale says so', () {
      final s = stats(sessions);

      expect(s.weekDays, [true, false, true, false, false, false, true]);
      expect(s.todayIndex, 6);
      expect(s.daysPracticedThisWeek, 3);
    });

    test('starts on Sunday when the locale says so', () {
      final s = stats(sessions, firstDay: 0);

      // The week of Sunday 25 October starts today.
      expect(s.weekDays, [true, false, false, false, false, false, false]);
      expect(s.todayIndex, 0);
    });

    test('week and month boundaries', () {
      final s = stats([
        done(DateTime(2026, 10, 30, 8)),
        done(DateTime(2026, 11, 1, 8)),
      ], at: DateTime(2026, 11, 1, 9));

      expect(s.weekDays, [false, false, false, false, true, false, true]);
    });
  });
}
