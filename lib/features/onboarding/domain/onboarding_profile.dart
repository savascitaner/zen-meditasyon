import 'package:freezed_annotation/freezed_annotation.dart';

part 'onboarding_profile.freezed.dart';

/// How the user has been feeling lately, in their own everyday words.
///
/// This is a self-description used to personalise the app, never a clinical
/// measurement.
enum StressLevel { calm, slightlyTense, stressed, overwhelmed }

/// How familiar the user is with meditation.
enum MeditationExperience { newcomer, someExperience, regular }

/// The answers from the welcome survey and whether onboarding is finished.
///
/// Both answers stay null when the user skips the survey.
@freezed
abstract class OnboardingProfile with _$OnboardingProfile {
  const factory OnboardingProfile({
    StressLevel? stressLevel,
    MeditationExperience? experience,
    @Default(false) bool completed,
  }) = _OnboardingProfile;
}
