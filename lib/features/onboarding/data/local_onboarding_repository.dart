import 'package:shared_preferences/shared_preferences.dart';

import '../domain/onboarding_profile.dart';
import '../domain/onboarding_repository.dart';

/// Keeps the onboarding answers in [SharedPreferences] (NSUserDefaults on
/// iOS). Nothing leaves the device.
///
/// Enums are stored by name, so reordering them never changes saved answers;
/// an unknown name (from an older or newer build) reads as no answer.
class LocalOnboardingRepository implements OnboardingRepository {
  LocalOnboardingRepository(this._prefs);

  static const completedKey = 'onboarding_completed';
  static const stressLevelKey = 'onboarding_stress_level';
  static const experienceKey = 'onboarding_experience';

  final SharedPreferences _prefs;

  @override
  OnboardingProfile load() => OnboardingProfile(
    stressLevel: _byName(StressLevel.values, _prefs.getString(stressLevelKey)),
    experience: _byName(
      MeditationExperience.values,
      _prefs.getString(experienceKey),
    ),
    completed: _prefs.getBool(completedKey) ?? false,
  );

  @override
  Future<void> save(OnboardingProfile profile) async {
    await Future.wait([
      _setOrRemove(stressLevelKey, profile.stressLevel?.name),
      _setOrRemove(experienceKey, profile.experience?.name),
      _prefs.setBool(completedKey, profile.completed),
    ]);
  }

  @override
  Future<void> clear() async {
    await Future.wait([
      _prefs.remove(stressLevelKey),
      _prefs.remove(experienceKey),
      _prefs.remove(completedKey),
    ]);
  }

  Future<bool> _setOrRemove(String key, String? value) =>
      value == null ? _prefs.remove(key) : _prefs.setString(key, value);

  static T? _byName<T extends Enum>(List<T> values, String? name) {
    for (final value in values) {
      if (value.name == name) return value;
    }
    return null;
  }
}
