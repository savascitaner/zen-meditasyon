import 'dart:ui';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/data/latest_all.dart' as tz_data;
import 'package:timezone/timezone.dart' as tz;
import 'package:zen_meditation/core/l10n/locale_controller.dart';
import 'package:zen_meditation/features/reminders/data/local_notification_scheduler.dart';
import 'package:zen_meditation/features/reminders/data/reminder_settings_repository.dart';
import 'package:zen_meditation/features/reminders/domain/reminder_settings.dart';
import 'package:zen_meditation/features/reminders/presentation/reminder_content.dart';
import 'package:zen_meditation/features/reminders/presentation/reminder_controller.dart';
import 'package:zen_meditation/l10n/app_localizations.dart';

import '../../helpers/fake_reminder_scheduler.dart';

Future<(ProviderContainer, FakeReminderScheduler)> setUpContainer({
  Map<String, Object> stored = const {},
  bool permissionGranted = true,
}) async {
  SharedPreferences.setMockInitialValues(stored);
  final prefs = await SharedPreferences.getInstance();
  final scheduler = FakeReminderScheduler(permissionGranted: permissionGranted);
  final container = ProviderContainer(
    overrides: [
      sharedPreferencesProvider.overrideWithValue(prefs),
      deviceLocaleProvider.overrideWithValue(const Locale('en')),
      reminderSchedulerProvider.overrideWithValue(scheduler),
    ],
  );
  addTearDown(container.dispose);
  return (container, scheduler);
}

void main() {
  test('starts off at 21:00 and asks for nothing', () async {
    final (container, scheduler) = await setUpContainer();

    final settings = container.read(reminderControllerProvider);

    expect(settings, const ReminderSettings());
    expect(settings.enabled, isFalse);
    expect([settings.hour, settings.minute], [21, 0]);
    expect(scheduler.permissionRequests, 0);
    expect(scheduler.scheduled, isEmpty);
  });

  test('turning it on asks for permission, then schedules', () async {
    final (container, scheduler) = await setUpContainer();
    final controller = container.read(reminderControllerProvider.notifier);

    final ok = await controller.setEnabled(true);

    expect(ok, isTrue);
    expect(scheduler.permissionRequests, 1);
    expect(container.read(reminderControllerProvider).enabled, isTrue);
    expect(scheduler.scheduled, hasLength(1));
    expect([scheduler.last!.hour, scheduler.last!.minute], [21, 0]);
    expect(container.read(reminderPermissionDeniedProvider), isFalse);
  });

  test('refused permission keeps the switch off and flags it', () async {
    final (container, scheduler) = await setUpContainer(
      permissionGranted: false,
    );
    final controller = container.read(reminderControllerProvider.notifier);

    final ok = await controller.setEnabled(true);

    expect(ok, isFalse);
    expect(container.read(reminderControllerProvider).enabled, isFalse);
    expect(container.read(reminderPermissionDeniedProvider), isTrue);
    expect(scheduler.scheduled, isEmpty);
  });

  test('changing the time schedules again at the new time', () async {
    final (container, scheduler) = await setUpContainer();
    final controller = container.read(reminderControllerProvider.notifier);
    await controller.setEnabled(true);

    await controller.setTime(7, 30);

    expect(scheduler.scheduled, hasLength(2));
    expect([scheduler.last!.hour, scheduler.last!.minute], [7, 30]);
    expect(scheduler.last!.content.title, 'Morning breath');
  });

  test('changing the time while off only saves it', () async {
    final (container, scheduler) = await setUpContainer();
    final controller = container.read(reminderControllerProvider.notifier);

    await controller.setTime(8, 15);

    expect(scheduler.scheduled, isEmpty);
    final saved = LocalReminderSettingsRepository(
      container.read(sharedPreferencesProvider),
    ).load();
    expect([saved.hour, saved.minute, saved.enabled], [8, 15, false]);
  });

  test('turning it off cancels everything', () async {
    final (container, scheduler) = await setUpContainer();
    final controller = container.read(reminderControllerProvider.notifier);
    await controller.setEnabled(true);

    await controller.setEnabled(false);

    expect(scheduler.cancelAllCalls, 1);
    expect(container.read(reminderControllerProvider).enabled, isFalse);
  });

  test('a new app language schedules the reminder again in it', () async {
    final (container, scheduler) = await setUpContainer();
    final controller = container.read(reminderControllerProvider.notifier);
    await controller.setEnabled(true);
    expect(scheduler.last!.content.title, 'Evening calm');

    await container
        .read(localeControllerProvider.notifier)
        .setLocale(const Locale('tr'));

    expect(scheduler.scheduled, hasLength(2));
    expect(scheduler.last!.content.title, 'Akşam huzuru');
  });

  test('a new language does nothing while the reminder is off', () async {
    final (container, scheduler) = await setUpContainer();
    container.read(reminderControllerProvider);

    await container
        .read(localeControllerProvider.notifier)
        .setLocale(const Locale('tr'));

    expect(scheduler.scheduled, isEmpty);
  });

  test('settings survive a restart and are rescheduled', () async {
    final (container, scheduler) = await setUpContainer(
      stored: {
        LocalReminderSettingsRepository.storageKey:
            '{"enabled":true,"hour":6,"minute":45}',
      },
    );

    final settings = container.read(reminderControllerProvider);
    await Future<void>.delayed(Duration.zero);

    expect(
      settings,
      const ReminderSettings(enabled: true, hour: 6, minute: 45),
    );
    expect(scheduler.scheduled, hasLength(1));
    expect(scheduler.permissionRequests, 0);
  });

  test('turns itself off when iOS permission was withdrawn', () async {
    final (container, scheduler) = await setUpContainer(
      stored: {LocalReminderSettingsRepository.storageKey: '{"enabled":true}'},
      permissionGranted: false,
    );

    container.read(reminderControllerProvider);
    await Future<void>.delayed(Duration.zero);

    expect(container.read(reminderControllerProvider).enabled, isFalse);
    expect(scheduler.scheduled, isEmpty);
    expect(scheduler.permissionRequests, 0);
  });

  test('broken stored settings fall back to the defaults', () async {
    final (container, _) = await setUpContainer(
      stored: {LocalReminderSettingsRepository.storageKey: '{"hour":99}'},
    );

    expect(
      container.read(reminderControllerProvider),
      const ReminderSettings(),
    );
  });

  group('reminder text', () {
    test('has seven different gentle messages in each language', () async {
      for (final locale in AppLocalizations.supportedLocales) {
        final l10n = lookupAppLocalizations(locale);
        final bodies = reminderContentFor(l10n, 21).bodies;
        expect(bodies.toSet(), hasLength(7), reason: locale.languageCode);
        for (final body in bodies) {
          expect(body, isNotEmpty);
          expect(body.toLowerCase(), isNot(contains('streak')));
          expect(body.toLowerCase(), isNot(contains('seri')));
        }
      }
    });

    test('the title follows the time of day', () {
      final l10n = lookupAppLocalizations(const Locale('en'));
      expect(reminderContentFor(l10n, 7).title, 'Morning breath');
      expect(reminderContentFor(l10n, 14).title, 'A pause for you');
      expect(reminderContentFor(l10n, 21).title, 'Evening calm');
    });
  });

  group('next occurrence', () {
    setUpAll(() {
      tz_data.initializeTimeZones();
      tz.setLocalLocation(tz.getLocation('Europe/Istanbul'));
    });

    // Wednesday 21 October 2026, 20:00.
    tz.TZDateTime now() => tz.TZDateTime(tz.local, 2026, 10, 21, 20);

    test('later today when the time has not passed', () {
      final next = LocalNotificationScheduler.nextOccurrence(
        now(),
        DateTime.wednesday,
        21,
        0,
      );
      expect(next, tz.TZDateTime(tz.local, 2026, 10, 21, 21));
    });

    test('next week when today\'s time has passed', () {
      final next = LocalNotificationScheduler.nextOccurrence(
        now(),
        DateTime.wednesday,
        9,
        30,
      );
      expect(next, tz.TZDateTime(tz.local, 2026, 10, 28, 9, 30));
    });

    test('the coming Monday', () {
      final next = LocalNotificationScheduler.nextOccurrence(
        now(),
        DateTime.monday,
        21,
        0,
      );
      expect(next, tz.TZDateTime(tz.local, 2026, 10, 26, 21));
    });
  });
}
