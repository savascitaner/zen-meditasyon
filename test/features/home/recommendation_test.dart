import 'package:flutter_test/flutter_test.dart';
import 'package:zen_meditation/features/content/domain/models/localized_text.dart';
import 'package:zen_meditation/features/content/domain/models/meditation.dart';
import 'package:zen_meditation/features/home/domain/recommendation.dart';
import 'package:zen_meditation/features/home/presentation/providers/home_providers.dart';
import 'package:zen_meditation/features/onboarding/domain/onboarding_profile.dart';
import 'package:zen_meditation/features/player/domain/practice_session.dart';

Meditation med(
  String id,
  List<String> categories,
  int minutes, {
  bool premium = false,
}) => Meditation(
  id: id,
  title: LocalizedText(en: id, tr: id),
  description: const LocalizedText(en: '', tr: ''),
  categoryIds: categories,
  durationMinutes: minutes,
  audioSource: 'assets/audio/sample.mp3',
  narrator: 'Maya',
  isPremium: premium,
);

final catalog = [
  med('breath-3', ['breath', 'anxiety'], 3),
  med('breath-5', ['breath', 'focus'], 5),
  med('breath-premium-5', ['breath'], 5, premium: true),
  med('sleep-10', ['sleep'], 10),
  med('sleep-premium', ['sleep'], 30, premium: true),
  med('calm-5', ['stress'], 5),
  med('anxiety-10', ['anxiety'], 10),
  med('zen-10', ['zen'], 10),
  med('focus-10', ['focus'], 10),
  med('walk-10', ['walking'], 10),
];

final noon = DateTime(2026, 10, 21, 12);
final evening = DateTime(2026, 10, 21, 21);

const regularCalm = OnboardingProfile(
  stressLevel: StressLevel.calm,
  experience: MeditationExperience.regular,
  completed: true,
);

String? pick(
  OnboardingProfile profile,
  DateTime now, {
  String? last,
  List<Meditation>? from,
}) => recommendMeditation(
  catalog: from ?? catalog,
  profile: profile,
  now: now,
  lastListenedId: last,
)?.id;

void main() {
  group('rules', () {
    test('newcomers get a 3 to 5 minute breathing session', () {
      final id = pick(
        regularCalm.copyWith(experience: MeditationExperience.newcomer),
        noon,
      );

      expect(id, anyOf('breath-3', 'breath-5'));
    });

    test('a skipped survey is treated like a newcomer', () {
      final id = pick(const OnboardingProfile(completed: true), noon);

      expect(id, anyOf('breath-3', 'breath-5'));
    });

    for (final level in [StressLevel.stressed, StressLevel.overwhelmed]) {
      test('$level gets short breathing or anxiety content', () {
        final id = pick(regularCalm.copyWith(stressLevel: level), noon);

        expect(id, anyOf('breath-3', 'breath-5', 'anxiety-10'));
      });
    }

    test('evenings prefer sleep, over every other rule', () {
      for (final profile in [
        regularCalm,
        regularCalm.copyWith(stressLevel: StressLevel.overwhelmed),
        const OnboardingProfile(completed: true),
      ]) {
        expect(pick(profile, evening), 'sleep-10');
      }
    });

    test('20:00 is the first evening hour', () {
      expect(
        pick(regularCalm, DateTime(2026, 10, 21, 19, 59)),
        isNot('sleep-10'),
      );
      expect(pick(regularCalm, DateTime(2026, 10, 21, 20)), 'sleep-10');
    });

    test('everyone else gets a 10 minute zen or focus session', () {
      expect(pick(regularCalm, noon), anyOf('zen-10', 'focus-10'));
    });

    test('never suggests premium content', () {
      for (var day = 1; day <= 28; day++) {
        for (final profile in [
          regularCalm,
          const OnboardingProfile(completed: true),
        ]) {
          for (final hour in [9, 22]) {
            final id = pick(profile, DateTime(2026, 10, day, hour));
            expect(id, isNot(contains('premium')));
          }
        }
      }
    });

    test('falls back to any free meditation when no rule fits', () {
      final id = pick(
        regularCalm,
        noon,
        from: [
          med('only-walk', ['walking'], 20),
        ],
      );

      expect(id, 'only-walk');
    });

    test('an empty or premium-only catalog gives null', () {
      expect(pick(regularCalm, noon, from: []), isNull);
      expect(
        pick(
          regularCalm,
          noon,
          from: [
            med('p', ['zen'], 10, premium: true),
          ],
        ),
        isNull,
      );
    });
  });

  group('stability', () {
    test('the same day always gives the same suggestion', () {
      final first = pick(regularCalm, DateTime(2026, 10, 21, 8));

      for (final hour in [9, 12, 15, 18, 19]) {
        expect(pick(regularCalm, DateTime(2026, 10, 21, hour)), first);
      }
    });

    test('the order of the catalog does not matter', () {
      expect(
        pick(regularCalm, noon, from: catalog.reversed.toList()),
        pick(regularCalm, noon),
      );
    });

    test('the suggestion rotates over the days', () {
      final seen = {
        for (var day = 1; day <= 14; day++)
          pick(regularCalm, DateTime(2026, 10, day, 9)),
      };

      expect(seen, {'zen-10', 'focus-10'});
    });
  });

  group('last listened', () {
    test('is not suggested again', () {
      for (var day = 1; day <= 14; day++) {
        final now = DateTime(2026, 10, day, 9);
        final normal = pick(regularCalm, now)!;

        expect(pick(regularCalm, now, last: normal), isNot(normal));
      }
    });

    test('is still suggested when it is the only free option', () {
      final only = med('only', ['zen'], 10);

      expect(pick(regularCalm, noon, from: [only], last: 'only'), 'only');
    });

    test('lastListenedBefore ignores today so the pick stays put', () {
      PracticeSession at(String id, DateTime t) => PracticeSession(
        meditationId: id,
        startedAt: t,
        listenedSeconds: 300,
        completed: true,
      );
      final sessions = [
        at('old', DateTime(2026, 10, 19, 9)),
        at('yesterday', DateTime(2026, 10, 20, 23, 59)),
        at('today', DateTime(2026, 10, 21, 8)),
      ];

      expect(lastListenedBefore(sessions, noon), 'yesterday');
      expect(lastListenedBefore([], noon), isNull);
      expect(
        lastListenedBefore([at('today', DateTime(2026, 10, 21, 8))], noon),
        isNull,
      );
    });
  });
}
