import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zen_meditation/core/l10n/locale_controller.dart';
import 'package:zen_meditation/features/library/data/local_favorites_repository.dart';
import 'package:zen_meditation/features/library/presentation/providers/library_providers.dart';
import 'package:zen_meditation/features/onboarding/data/local_onboarding_repository.dart';
import 'package:zen_meditation/features/onboarding/domain/onboarding_profile.dart';
import 'package:zen_meditation/features/onboarding/presentation/onboarding_controller.dart';
import 'package:zen_meditation/features/player/data/local_practice_log_repository.dart';
import 'package:zen_meditation/features/player/domain/practice_session.dart';
import 'package:zen_meditation/features/profile/data/user_data_service.dart';
import 'package:zen_meditation/features/profile/presentation/profile_providers.dart';
import 'package:zen_meditation/features/reminders/data/reminder_settings_repository.dart';
import 'package:zen_meditation/features/reminders/presentation/reminder_controller.dart';
import 'package:zen_meditation/features/safety/presentation/safety_providers.dart';

import '../../helpers/fake_reminder_scheduler.dart';

final _session = PracticeSession(
  meditationId: 'calm-breath',
  startedAt: DateTime.utc(2026, 10, 20, 8, 30),
  listenedSeconds: 300,
  completed: true,
);

Future<SharedPreferences> _filledPrefs() async {
  SharedPreferences.setMockInitialValues({
    LocaleController.storageKey: 'tr',
    LocalOnboardingRepository.completedKey: true,
    LocalOnboardingRepository.stressLevelKey: 'stressed',
    LocalOnboardingRepository.experienceKey: 'newcomer',
    LocalFavoritesRepository.storageKey: jsonEncode(['a', 'b']),
    LocalPracticeLogRepository.storageKey: jsonEncode([_session.toJson()]),
    LocalReminderSettingsRepository.storageKey: jsonEncode({
      'enabled': true,
      'hour': 7,
      'minute': 45,
    }),
    LocalReminderSettingsRepository.inviteDismissedKey: true,
    SafetyNoticeSeen.storageKey: true,
    'some_future_key': 'x',
  });
  return SharedPreferences.getInstance();
}

ProviderContainer _container(
  SharedPreferences prefs,
  FakeReminderScheduler scheduler,
) {
  final container = ProviderContainer(
    overrides: [
      sharedPreferencesProvider.overrideWithValue(prefs),
      reminderSchedulerProvider.overrideWithValue(scheduler),
    ],
  );
  addTearDown(container.dispose);
  return container;
}

void main() {
  test('export contains every field, as readable JSON', () async {
    final prefs = await _filledPrefs();
    final container = _container(prefs, FakeReminderScheduler());

    final json = await container.read(userDataServiceProvider).exportJson();
    expect(json, contains('\n'), reason: 'indented, not one line');
    final data = jsonDecode(json) as Map<String, dynamic>;

    expect(data['app'], 'Ensora');
    expect(data['exportVersion'], UserDataService.exportVersion);
    expect(DateTime.tryParse(data['exportedAt'] as String), isNotNull);
    expect(data['onboarding'], {
      'completed': true,
      'stressLevel': 'stressed',
      'experience': 'newcomer',
    });
    expect(data['favorites'], ['a', 'b']);
    expect(data['practiceHistory'], [_session.toJson()]);
    expect(data['reminder'], {'enabled': true, 'hour': 7, 'minute': 45});
  });

  test('export of an empty install is valid and empty', () async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    final container = _container(prefs, FakeReminderScheduler());

    final data = await container.read(userDataServiceProvider).buildExport();
    expect(data['favorites'], isEmpty);
    expect(data['practiceHistory'], isEmpty);
    expect((data['onboarding']! as Map)['stressLevel'], isNull);
    expect((data['reminder']! as Map)['enabled'], false);
  });

  test(
    'delete clears every key but the language and cancels reminders',
    () async {
      final prefs = await _filledPrefs();
      final scheduler = FakeReminderScheduler();
      final container = _container(prefs, scheduler);

      await container.read(userDataServiceProvider).deleteAll();

      expect(prefs.getKeys(), {LocaleController.storageKey});
      expect(prefs.getString(LocaleController.storageKey), 'tr');
      expect(scheduler.cancelAllCalls, 1);
    },
  );

  test('erasing resets cached state so onboarding starts again', () async {
    final prefs = await _filledPrefs();
    final scheduler = FakeReminderScheduler();
    final container = _container(prefs, scheduler);
    // Fill the caches first.
    expect(container.read(onboardingCompletedProvider), true);
    expect(container.read(favoritesProvider), ['a', 'b']);
    expect(container.read(reminderControllerProvider).enabled, true);
    expect(container.read(reminderInviteDismissedProvider), true);
    expect(container.read(safetyNoticeSeenProvider), true);
    // Keep the stream provider alive, as a screen watching it would.
    container.listen(practiceHistoryProvider, (_, _) {});
    expect(await container.read(practiceHistoryProvider.future), hasLength(1));

    await container.read(eraseUserDataProvider)();

    expect(container.read(onboardingCompletedProvider), false);
    expect(
      container.read(onboardingControllerProvider),
      const OnboardingProfile(),
    );
    expect(container.read(favoritesProvider), isEmpty);
    expect(container.read(reminderControllerProvider).enabled, false);
    expect(container.read(reminderInviteDismissedProvider), false);
    expect(container.read(safetyNoticeSeenProvider), false);
    expect(await container.read(practiceHistoryProvider.future), isEmpty);
    expect(prefs.getKeys(), {LocaleController.storageKey});
    expect(container.read(localeControllerProvider).languageCode, 'tr');
  });
}
