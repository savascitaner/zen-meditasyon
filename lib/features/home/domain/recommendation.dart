import '../../content/domain/models/category.dart';
import '../../content/domain/models/meditation.dart';
import '../../onboarding/domain/onboarding_profile.dart';

/// First hour of the day that counts as evening.
const eveningStartHour = 20;

/// Picks today's free meditation from the [catalog].
///
/// The first rule that leaves candidates wins:
/// 1. evening (from 20:00): sleep
/// 2. new to meditation, or survey skipped: 3 to 5 minute breathing
/// 3. stressed or overwhelmed: short breathing or anxiety
/// 4. otherwise: 10 minute zen or mindfulness
///
/// The choice is seeded by the calendar day, so it stays the same all day.
/// [lastListenedId] is never suggested; pass the meditation listened to
/// before today, or the pick would change as soon as a session ends.
/// Returns null only when the catalog has no free content.
Meditation? recommendMeditation({
  required List<Meditation> catalog,
  required OnboardingProfile profile,
  required DateTime now,
  String? lastListenedId,
}) {
  final free = [
    for (final m in catalog)
      if (!m.isPremium) m,
  ]..sort((a, b) => a.id.compareTo(b.id));
  final fresh = [
    for (final m in free)
      if (m.id != lastListenedId) m,
  ];

  bool inAny(Meditation m, List<String> ids) => m.categoryIds.any(ids.contains);

  final stressed =
      profile.stressLevel == StressLevel.stressed ||
      profile.stressLevel == StressLevel.overwhelmed;
  final newcomer =
      profile.experience == null ||
      profile.experience == MeditationExperience.newcomer;

  final rules = <bool Function(Meditation)>[
    if (now.hour >= eveningStartHour) (m) => inAny(m, [CategoryIds.sleep]),
    if (newcomer)
      (m) =>
          inAny(m, [CategoryIds.breath]) &&
          m.durationMinutes >= 3 &&
          m.durationMinutes <= 5,
    if (stressed)
      (m) =>
          (inAny(m, [CategoryIds.breath]) && m.durationMinutes <= 5) ||
          inAny(m, [CategoryIds.anxiety]),
    (m) =>
        m.durationMinutes == 10 &&
        inAny(m, [CategoryIds.zen, CategoryIds.focus, CategoryIds.bodyScan]),
  ];

  final seed = now.year * 10000 + now.month * 100 + now.day;
  for (final pool in [fresh, free]) {
    for (final rule in rules) {
      final candidates = pool.where(rule).toList();
      if (candidates.isNotEmpty) {
        return candidates[seed % candidates.length];
      }
    }
    if (pool.isNotEmpty) return pool[seed % pool.length];
  }
  return null;
}
