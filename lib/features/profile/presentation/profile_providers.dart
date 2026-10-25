import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/l10n/locale_controller.dart';
import '../../library/presentation/providers/library_providers.dart';
import '../../onboarding/presentation/onboarding_controller.dart';
import '../../player/presentation/player_providers.dart';
import '../../reminders/presentation/reminder_controller.dart';
import '../../safety/presentation/safety_providers.dart';
import '../data/user_data_service.dart';

final userDataServiceProvider = Provider<UserDataService>(
  (ref) => UserDataService(
    prefs: ref.watch(sharedPreferencesProvider),
    onboarding: ref.watch(onboardingRepositoryProvider),
    favorites: ref.watch(favoritesRepositoryProvider),
    practiceLog: ref.watch(practiceLogRepositoryProvider),
    reminders: ref.watch(reminderSettingsRepositoryProvider),
    scheduler: ref.watch(reminderSchedulerProvider),
  ),
);

/// Deletes all local data and resets every provider that cached it, so the
/// router sends the user back to the start of onboarding. The language
/// choice is kept.
final eraseUserDataProvider = Provider<Future<void> Function()>(
  (ref) => () async {
    await ref.read(userDataServiceProvider).deleteAll();
    ref
      ..invalidate(onboardingControllerProvider)
      ..invalidate(favoritesProvider)
      ..invalidate(practiceLogRepositoryProvider)
      ..invalidate(reminderControllerProvider)
      ..invalidate(reminderInviteDismissedProvider)
      ..invalidate(safetyNoticeSeenProvider);
  },
);
