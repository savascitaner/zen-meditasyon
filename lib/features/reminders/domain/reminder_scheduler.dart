/// What the reminder says. [bodies] holds one message per weekday, indexed by
/// `DateTime.weekday - 1` (Monday first), so the text changes from day to day.
class ReminderContent {
  const ReminderContent({required this.title, required this.bodies})
    : assert(bodies.length == 7);

  final String title;
  final List<String> bodies;
}

/// Schedules the daily reminder. The only place that knows about the
/// notification plugin, so the rest of the app and its tests do not.
abstract interface class ReminderScheduler {
  /// Emits when the user taps a reminder.
  Stream<void> get taps;

  /// Asks iOS for notification permission and returns whether it was granted.
  /// This is what shows the system dialog, so call it only when the user turns
  /// the reminder on, never at launch.
  Future<bool> requestPermission();

  /// Whether notifications are currently allowed, without asking.
  Future<bool> isPermissionGranted();

  /// Replaces any scheduled reminder with one every day at [hour]:[minute]
  /// device-local time.
  Future<void> scheduleDaily({
    required int hour,
    required int minute,
    required ReminderContent content,
  });

  Future<void> cancelAll();
}

/// Used where notifications are not available (and in tests that do not care
/// about them): permission is never granted and nothing is scheduled.
class UnavailableReminderScheduler implements ReminderScheduler {
  const UnavailableReminderScheduler();

  @override
  Stream<void> get taps => const Stream.empty();

  @override
  Future<bool> requestPermission() async => false;

  @override
  Future<bool> isPermissionGranted() async => false;

  @override
  Future<void> scheduleDaily({
    required int hour,
    required int minute,
    required ReminderContent content,
  }) async {}

  @override
  Future<void> cancelAll() async {}
}
