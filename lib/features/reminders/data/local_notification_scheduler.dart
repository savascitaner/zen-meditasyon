import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest_all.dart' as tz_data;
import 'package:timezone/timezone.dart' as tz;

import '../domain/reminder_scheduler.dart';

/// [ReminderScheduler] on top of flutter_local_notifications (iOS).
///
/// Seven weekly notifications are scheduled, one per weekday, each with its
/// own message. Together they fire every day at the chosen time and the text
/// rotates through the week.
class LocalNotificationScheduler implements ReminderScheduler {
  LocalNotificationScheduler([FlutterLocalNotificationsPlugin? plugin])
    : _plugin = plugin ?? FlutterLocalNotificationsPlugin();

  /// Ids are `idBase + weekday` (1 to 7).
  static const idBase = 7100;

  final FlutterLocalNotificationsPlugin _plugin;
  final _taps = StreamController<void>.broadcast();

  @override
  Stream<void> get taps => _taps.stream;

  /// Sets up the plugin and the device time zone. Does NOT ask for permission:
  /// every `request*Permission` flag is off, because the plugin would
  /// otherwise show the system dialog right here, at launch.
  Future<void> init() async {
    tz_data.initializeTimeZones();
    try {
      final info = await FlutterTimezone.getLocalTimezone();
      tz.setLocalLocation(tz.getLocation(info.identifier));
    } catch (e) {
      debugPrint('Could not read the device time zone, using UTC: $e');
    }
    await _plugin.initialize(
      settings: const InitializationSettings(
        iOS: DarwinInitializationSettings(
          requestAlertPermission: false,
          requestSoundPermission: false,
          requestBadgePermission: false,
        ),
      ),
      onDidReceiveNotificationResponse: (_) => _taps.add(null),
    );
  }

  IOSFlutterLocalNotificationsPlugin? get _ios => _plugin
      .resolvePlatformSpecificImplementation<
        IOSFlutterLocalNotificationsPlugin
      >();

  @override
  Future<bool> requestPermission() async =>
      await _ios?.requestPermissions(alert: true, sound: true) ?? false;

  @override
  Future<bool> isPermissionGranted() async =>
      (await _ios?.checkPermissions())?.isEnabled ?? false;

  @override
  Future<void> scheduleDaily({
    required int hour,
    required int minute,
    required ReminderContent content,
  }) async {
    await _plugin.cancelAll();
    for (var weekday = DateTime.monday; weekday <= DateTime.sunday; weekday++) {
      await _plugin.zonedSchedule(
        id: idBase + weekday,
        title: content.title,
        body: content.bodies[weekday - 1],
        scheduledDate: nextOccurrence(
          tz.TZDateTime.now(tz.local),
          weekday,
          hour,
          minute,
        ),
        notificationDetails: const NotificationDetails(
          iOS: DarwinNotificationDetails(),
        ),
        androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
        matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime,
      );
    }
  }

  @override
  Future<void> cancelAll() => _plugin.cancelAll();

  /// The first moment after [now] that falls on [weekday] at [hour]:[minute].
  @visibleForTesting
  static tz.TZDateTime nextOccurrence(
    tz.TZDateTime now,
    int weekday,
    int hour,
    int minute,
  ) {
    var date = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      hour,
      minute,
    );
    while (date.weekday != weekday || !date.isAfter(now)) {
      date = tz.TZDateTime(
        tz.local,
        date.year,
        date.month,
        date.day + 1,
        hour,
        minute,
      );
    }
    return date;
  }
}
