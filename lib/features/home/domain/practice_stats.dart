import '../../player/domain/practice_session.dart';

/// Streak and totals built from the practice history. Pure calculation: no
/// storage, no Flutter.
///
/// Days follow the device's local calendar and are compared as
/// `DateTime(y, m, d)`, never as sums of 24-hour durations, so daylight
/// saving changes cannot shift a session to the wrong day.
class PracticeStats {
  const PracticeStats({
    required this.currentStreak,
    required this.longestStreak,
    required this.totalMinutes,
    required this.completedSessions,
    required this.weekDays,
    required this.todayIndex,
    required this.hasHistory,
  });

  /// Days in a row with a completed session. Still alive when today has no
  /// practice yet, as long as yesterday had one.
  final int currentStreak;
  final int longestStreak;

  /// Everything listened to, completed or not.
  final int totalMinutes;
  final int completedSessions;

  /// Seven flags for the current week, starting on the locale's first day of
  /// the week. True when that day has a completed session.
  final List<bool> weekDays;

  /// Position of today in [weekDays].
  final int todayIndex;

  /// Whether any session was ever recorded.
  final bool hasHistory;

  int get daysPracticedThisWeek => weekDays.where((d) => d).length;

  /// [firstDayOfWeekIndex] is `MaterialLocalizations.firstDayOfWeekIndex`:
  /// 0 is Sunday, 1 is Monday and so on.
  factory PracticeStats.fromSessions(
    Iterable<PracticeSession> sessions,
    DateTime now, {
    int firstDayOfWeekIndex = 1,
  }) {
    final today = _dayOf(now);
    final practiced = <DateTime>{};
    var listenedSeconds = 0;
    var completed = 0;
    var count = 0;
    for (final session in sessions) {
      count++;
      listenedSeconds += session.listenedSeconds;
      if (session.completed) {
        completed++;
        practiced.add(_dayOf(session.startedAt));
      }
    }

    // Walk back from today, or from yesterday while today is still open.
    var current = 0;
    var day = practiced.contains(today) ? today : _previousDay(today);
    while (practiced.contains(day)) {
      current++;
      day = _previousDay(day);
    }

    final ordered = practiced.toList()..sort();
    var longest = 0;
    var run = 0;
    DateTime? previous;
    for (final d in ordered) {
      run = previous != null && _previousDay(d) == previous ? run + 1 : 1;
      if (run > longest) longest = run;
      previous = d;
    }

    // Day index 0 is Sunday; DateTime.weekday has Sunday at 7.
    final offset = (today.weekday % 7 - firstDayOfWeekIndex + 7) % 7;
    final weekStart = DateTime(today.year, today.month, today.day - offset);
    final week = [
      for (var i = 0; i < 7; i++)
        practiced.contains(
          DateTime(weekStart.year, weekStart.month, weekStart.day + i),
        ),
    ];

    return PracticeStats(
      currentStreak: current,
      longestStreak: longest,
      totalMinutes: (listenedSeconds / 60).round(),
      completedSessions: completed,
      weekDays: week,
      todayIndex: offset,
      hasHistory: count > 0,
    );
  }

  static DateTime _dayOf(DateTime t) => DateTime(t.year, t.month, t.day);

  static DateTime _previousDay(DateTime d) =>
      DateTime(d.year, d.month, d.day - 1);
}
