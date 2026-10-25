import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart' show Override;
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zen_meditation/app.dart';
import 'package:zen_meditation/core/l10n/locale_controller.dart';
import 'package:zen_meditation/features/content/presentation/providers/content_providers.dart';
import 'package:zen_meditation/features/onboarding/data/local_onboarding_repository.dart';
import 'package:zen_meditation/features/safety/presentation/safety_providers.dart';
import 'package:zen_meditation/features/player/domain/practice_session.dart';
import 'package:zen_meditation/features/player/presentation/player_providers.dart';
import 'package:zen_meditation/features/reminders/data/reminder_settings_repository.dart';
import 'package:zen_meditation/features/reminders/presentation/reminder_controller.dart';

import '../../helpers/fake_audio_handler.dart';
import '../../helpers/fake_content_repository.dart';
import '../../helpers/fake_reminder_scheduler.dart';
import '../../helpers/in_memory_practice_log_repository.dart';

final clock = DateTime(2026, 10, 21, 9);

final completed = PracticeSession(
  meditationId: 'free-focus',
  startedAt: DateTime(2026, 10, 21, 7),
  listenedSeconds: 600,
  completed: true,
);

const inviteTitle = 'Remind you every day at this time?';

Future<void> pumpApp(
  WidgetTester tester, {
  required FakeReminderScheduler scheduler,
  List<PracticeSession> history = const [],
  Map<String, Object> stored = const {},
  List<Override> overrides = const [],
}) async {
  SharedPreferences.setMockInitialValues({
    LocalOnboardingRepository.completedKey: true,
    SafetyNoticeSeen.storageKey: true,
    ...stored,
  });
  final prefs = await SharedPreferences.getInstance();
  final log = InMemoryPracticeLogRepository();
  for (final session in history) {
    await log.add(session);
  }
  tester.view.physicalSize = const Size(390, 844);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);
  await tester.pumpWidget(
    ProviderScope(
      retry: (_, _) => null,
      overrides: [
        sharedPreferencesProvider.overrideWithValue(prefs),
        deviceLocaleProvider.overrideWithValue(const Locale('en')),
        contentRepositoryProvider.overrideWithValue(FakeContentRepository()),
        audioHandlerProvider.overrideWithValue(FakeAudioHandler()),
        practiceLogRepositoryProvider.overrideWithValue(log),
        clockProvider.overrideWithValue(() => clock),
        reminderSchedulerProvider.overrideWithValue(scheduler),
        ...overrides,
      ],
      child: const App(),
    ),
  );
  await tester.pumpAndSettle();
}

Future<void> openProfile(WidgetTester tester) async {
  await tester.tap(find.text('Profile'));
  await tester.pumpAndSettle();
}

void main() {
  group('invitation card on Today', () {
    testWidgets('is not shown before a first completed session', (
      tester,
    ) async {
      await pumpApp(tester, scheduler: FakeReminderScheduler());

      expect(find.text(inviteTitle), findsNothing);
    });

    testWidgets('is shown after a completed session', (tester) async {
      await pumpApp(
        tester,
        scheduler: FakeReminderScheduler(),
        history: [completed],
      );

      expect(find.text(inviteTitle), findsOneWidget);
      expect(find.textContaining('9:00 PM'), findsOneWidget);
    });

    testWidgets('is not shown when the reminder is already on', (tester) async {
      await pumpApp(
        tester,
        scheduler: FakeReminderScheduler(),
        history: [completed],
        stored: {
          LocalReminderSettingsRepository.storageKey: '{"enabled":true}',
        },
      );

      expect(find.text(inviteTitle), findsNothing);
    });

    testWidgets('never comes back once dismissed', (tester) async {
      final scheduler = FakeReminderScheduler();
      await pumpApp(tester, scheduler: scheduler, history: [completed]);

      await tester.tap(find.text('Not now'));
      await tester.pumpAndSettle();
      expect(find.text(inviteTitle), findsNothing);

      // A fresh start with the same saved data.
      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getBool('reminder_invite_dismissed_v1'), isTrue);
      await tester.pumpWidget(const SizedBox());
      await pumpApp(
        tester,
        scheduler: scheduler,
        history: [completed],
        stored: {'reminder_invite_dismissed_v1': true},
      );
      expect(find.text(inviteTitle), findsNothing);
      expect(scheduler.permissionRequests, 0);
    });

    testWidgets('saying yes asks for permission and schedules', (tester) async {
      final scheduler = FakeReminderScheduler();
      await pumpApp(tester, scheduler: scheduler, history: [completed]);

      await tester.tap(find.text('Yes, remind me'));
      await tester.pumpAndSettle();

      expect(scheduler.permissionRequests, 1);
      expect(scheduler.scheduled, hasLength(1));
      expect(find.text(inviteTitle), findsNothing);
    });

    testWidgets('a refusal closes the card and explains', (tester) async {
      final scheduler = FakeReminderScheduler(permissionGranted: false);
      await pumpApp(tester, scheduler: scheduler, history: [completed]);

      await tester.tap(find.text('Yes, remind me'));
      await tester.pumpAndSettle();

      expect(scheduler.scheduled, isEmpty);
      expect(find.text(inviteTitle), findsNothing);
      expect(find.textContaining('allow them in Settings'), findsOneWidget);
    });
  });

  group('Profile', () {
    testWidgets('opening the app or the Profile asks for nothing', (
      tester,
    ) async {
      final scheduler = FakeReminderScheduler();
      await pumpApp(tester, scheduler: scheduler);
      await openProfile(tester);

      expect(find.text('Daily reminder'), findsOneWidget);
      expect(scheduler.permissionRequests, 0);
      expect(find.text('Reminder time'), findsNothing);
    });

    testWidgets('the switch turns the reminder on and shows the time', (
      tester,
    ) async {
      final scheduler = FakeReminderScheduler();
      await pumpApp(tester, scheduler: scheduler);
      await openProfile(tester);

      await tester.tap(find.byType(Switch));
      await tester.pumpAndSettle();

      expect(scheduler.permissionRequests, 1);
      expect(scheduler.last, isNotNull);
      expect(find.text('Reminder time'), findsOneWidget);
      expect(find.text('9:00 PM'), findsOneWidget);
    });

    testWidgets('a refusal leaves the switch off and offers Settings', (
      tester,
    ) async {
      final scheduler = FakeReminderScheduler(permissionGranted: false);
      var settingsOpened = 0;
      await pumpApp(
        tester,
        scheduler: scheduler,
        overrides: [
          openAppSettingsProvider.overrideWithValue(
            () async => settingsOpened++,
          ),
        ],
      );
      await openProfile(tester);

      await tester.tap(find.byType(Switch));
      await tester.pumpAndSettle();

      expect(tester.widget<Switch>(find.byType(Switch)).value, isFalse);
      expect(find.textContaining('allow them in Settings'), findsOneWidget);
      await tester.tap(find.text('Open Settings'));
      expect(settingsOpened, 1);
    });

    testWidgets('turning it off cancels the reminder', (tester) async {
      final scheduler = FakeReminderScheduler();
      await pumpApp(
        tester,
        scheduler: scheduler,
        stored: {
          LocalReminderSettingsRepository.storageKey: '{"enabled":true}',
        },
      );
      await openProfile(tester);

      await tester.tap(find.byType(Switch));
      await tester.pumpAndSettle();

      expect(scheduler.cancelAllCalls, 1);
      expect(find.text('Reminder time'), findsNothing);
    });

    testWidgets('picking a time reschedules', (tester) async {
      final scheduler = FakeReminderScheduler();
      await pumpApp(
        tester,
        scheduler: scheduler,
        stored: {
          LocalReminderSettingsRepository.storageKey: '{"enabled":true}',
        },
      );
      await openProfile(tester);
      final before = scheduler.scheduled.length;

      await tester.tap(find.text('Reminder time'));
      await tester.pumpAndSettle();
      // Scroll the hour wheel one step: 9 PM becomes 10 PM.
      await tester.drag(
        find.byType(CupertinoPicker).first,
        const Offset(0, -40),
      );
      await tester.pumpAndSettle();
      await tester.tap(find.text('Done'));
      await tester.pumpAndSettle();

      expect(scheduler.scheduled.length, before + 1);
      expect(scheduler.last!.hour, isNot(21));
    });
  });

  testWidgets('tapping a reminder shows the Today tab', (tester) async {
    final scheduler = FakeReminderScheduler();
    await pumpApp(tester, scheduler: scheduler);
    await openProfile(tester);
    expect(find.text('Daily reminder'), findsOneWidget);

    scheduler.tap();
    await tester.pumpAndSettle();

    expect(find.text('Good morning'), findsOneWidget);
    expect(find.text('Daily reminder'), findsNothing);
  });
}
