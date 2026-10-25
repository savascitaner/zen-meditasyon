import 'onboarding_profile.dart';

/// Stores the onboarding answers on the device.
///
/// Reads are synchronous so the router can decide where to send the user
/// before the first frame.
abstract interface class OnboardingRepository {
  OnboardingProfile load();

  Future<void> save(OnboardingProfile profile);

  /// Forgets every answer, so onboarding shows again on the next launch.
  Future<void> clear();
}
