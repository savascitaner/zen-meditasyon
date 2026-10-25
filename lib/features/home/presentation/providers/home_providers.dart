import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../content/domain/models/meditation.dart';
import '../../../content/presentation/providers/content_providers.dart';
import '../../../library/presentation/providers/library_providers.dart';
import '../../../onboarding/presentation/onboarding_controller.dart';
import '../../../player/domain/practice_session.dart';
import '../../../player/presentation/player_providers.dart';
import '../../domain/practice_stats.dart';
import '../../domain/recommendation.dart';

/// Streak and totals from the practice history, kept up to date as sessions
/// end. The argument is `MaterialLocalizations.firstDayOfWeekIndex`.
final practiceStatsProvider = Provider.family<AsyncValue<PracticeStats>, int>((
  ref,
  firstDayOfWeekIndex,
) {
  final now = ref.watch(clockProvider)();
  return ref
      .watch(practiceHistoryProvider)
      .whenData(
        (sessions) => PracticeStats.fromSessions(
          sessions,
          now,
          firstDayOfWeekIndex: firstDayOfWeekIndex,
        ),
      );
});

/// Today's suggested meditation; null when the catalog has no free content.
final todayRecommendationProvider = FutureProvider<Meditation?>((ref) async {
  final now = ref.watch(clockProvider)();
  final profile = ref.watch(onboardingControllerProvider);
  final catalog = await ref.watch(allMeditationsProvider.future);
  final sessions = await ref.watch(practiceHistoryProvider.future);
  return recommendMeditation(
    catalog: catalog,
    profile: profile,
    now: now,
    lastListenedId: lastListenedBefore(sessions, now),
  );
});

/// The meditation most recently listened to before today. Today's sessions
/// are left out so the suggestion does not change once one is played.
String? lastListenedBefore(List<PracticeSession> sessions, DateTime now) {
  final startOfToday = DateTime(now.year, now.month, now.day);
  PracticeSession? last;
  for (final session in sessions) {
    if (session.startedAt.isBefore(startOfToday) &&
        (last == null || session.startedAt.isAfter(last.startedAt))) {
      last = session;
    }
  }
  return last?.meditationId;
}
