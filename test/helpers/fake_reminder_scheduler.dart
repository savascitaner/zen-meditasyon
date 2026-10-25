import 'dart:async';

import 'package:zen_meditation/features/reminders/domain/reminder_scheduler.dart';

/// Records what the app asks of the scheduler. [permissionGranted] decides how
/// the permission request is answered.
class FakeReminderScheduler implements ReminderScheduler {
  FakeReminderScheduler({this.permissionGranted = true});

  bool permissionGranted;
  int permissionRequests = 0;
  int cancelAllCalls = 0;
  final List<ScheduledReminder> scheduled = [];
  final _taps = StreamController<void>.broadcast();

  ScheduledReminder? get last => scheduled.lastOrNull;

  void tap() => _taps.add(null);

  @override
  Stream<void> get taps => _taps.stream;

  @override
  Future<bool> requestPermission() async {
    permissionRequests++;
    return permissionGranted;
  }

  @override
  Future<bool> isPermissionGranted() async => permissionGranted;

  @override
  Future<void> scheduleDaily({
    required int hour,
    required int minute,
    required ReminderContent content,
  }) async => scheduled.add(ScheduledReminder(hour, minute, content));

  @override
  Future<void> cancelAll() async => cancelAllCalls++;
}

class ScheduledReminder {
  const ScheduledReminder(this.hour, this.minute, this.content);

  final int hour;
  final int minute;
  final ReminderContent content;
}
