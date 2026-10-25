import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/l10n/locale_controller.dart';
import '../data/local_onboarding_repository.dart';
import '../domain/onboarding_profile.dart';
import '../domain/onboarding_repository.dart';

final onboardingRepositoryProvider = Provider<OnboardingRepository>(
  (ref) => LocalOnboardingRepository(ref.watch(sharedPreferencesProvider)),
);

final onboardingControllerProvider =
    NotifierProvider<OnboardingController, OnboardingProfile>(
      OnboardingController.new,
    );

/// Whether the user has finished (or skipped) onboarding. The router listens
/// to this to choose between the welcome flow and the app.
final onboardingCompletedProvider = Provider<bool>(
  (ref) => ref.watch(onboardingControllerProvider.select((p) => p.completed)),
);

/// Holds the survey answers and saves every change right away, so a user who
/// leaves halfway finds their answers again.
///
/// State changes before the write finishes: the screen and router react at
/// once, and the write follows in the background.
class OnboardingController extends Notifier<OnboardingProfile> {
  @override
  OnboardingProfile build() => ref.watch(onboardingRepositoryProvider).load();

  Future<void> selectStressLevel(StressLevel level) =>
      _update(state.copyWith(stressLevel: level));

  Future<void> selectExperience(MeditationExperience experience) =>
      _update(state.copyWith(experience: experience));

  /// Finishes onboarding with whatever was answered; skipping the survey
  /// calls this too.
  Future<void> complete() => _update(state.copyWith(completed: true));

  /// Clears every answer and shows onboarding again.
  Future<void> reset() async {
    state = const OnboardingProfile();
    await ref.read(onboardingRepositoryProvider).clear();
  }

  Future<void> _update(OnboardingProfile next) async {
    if (next == state) return;
    state = next;
    await ref.read(onboardingRepositoryProvider).save(next);
  }
}
