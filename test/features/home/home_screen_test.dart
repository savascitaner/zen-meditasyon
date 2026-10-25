import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zen_meditation/app.dart';
import 'package:zen_meditation/core/l10n/locale_controller.dart';
import 'package:zen_meditation/features/content/presentation/providers/content_providers.dart';
import 'package:zen_meditation/features/home/presentation/widgets/recommendation_card.dart';
import 'package:zen_meditation/features/library/data/local_favorites_repository.dart';
import 'package:zen_meditation/features/meditation_detail/presentation/meditation_detail_screen.dart';
import 'package:zen_meditation/features/onboarding/data/local_onboarding_repository.dart';
import 'package:zen_meditation/features/player/domain/practice_session.dart';
import 'package:zen_meditation/features/player/presentation/player_providers.dart';

import '../../helpers/fake_audio_handler.dart';
import '../../helpers/fake_content_repository.dart';
import '../../helpers/in_memory_practice_log_repository.dart';

// Wednesday 21 October 2026.
final clock = DateTime(2026, 10, 21, 9);

PracticeSession done(String id, DateTime at) => PracticeSession(
  meditationId: id,
  startedAt: at,
  listenedSeconds: 600,
  completed: true,
);

Future<InMemoryPracticeLogRepository> pumpHome(
  WidgetTester tester, {
  List<PracticeSession> history = const [],
  Map<String, Object> stored = const {},
  Locale device = const Locale('en'),
  double textScale = 1,
}) async {
  SharedPreferences.setMockInitialValues({
    LocalOnboardingRepository.completedKey: true,
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
        deviceLocaleProvider.overrideWithValue(device),
        contentRepositoryProvider.overrideWithValue(FakeContentRepository()),
        audioHandlerProvider.overrideWithValue(FakeAudioHandler()),
        practiceLogRepositoryProvider.overrideWithValue(log),
        clockProvider.overrideWithValue(() => clock),
      ],
      child: MediaQuery(
        data: MediaQueryData(textScaler: TextScaler.linear(textScale)),
        child: const App(),
      ),
    ),
  );
  await tester.pumpAndSettle();
  return log;
}

void main() {
  testWidgets('empty history shows an inviting message and no strips', (
    tester,
  ) async {
    await pumpHome(tester);

    expect(find.text('Good morning'), findsOneWidget);
    expect(find.text('Your first session can start today.'), findsOneWidget);
    expect(find.textContaining('0 days'), findsNothing);
    expect(find.text('Continue where you left off'), findsNothing);
    expect(find.text('Your favorites'), findsNothing);
    expect(find.text('minutes of practice'), findsNothing);
    expect(find.byType(RecommendationCard), findsOneWidget);
  });

  testWidgets('Turkish greeting and invitation', (tester) async {
    await pumpHome(tester, device: const Locale('tr'));

    expect(find.text('Günaydın'), findsOneWidget);
    expect(find.text('İlk pratiğin bugün başlayabilir.'), findsOneWidget);
  });

  testWidgets('shows the streak, the week and the totals from history', (
    tester,
  ) async {
    final semantics = tester.ensureSemantics();
    await pumpHome(
      tester,
      history: [
        done('free-focus', DateTime(2026, 10, 20, 8)),
        done('free-focus', DateTime(2026, 10, 21, 7)),
      ],
    );

    expect(find.text('2 days in a row'), findsOneWidget);
    expect(find.text('20'), findsOneWidget);
    expect(find.text('minutes of practice'), findsOneWidget);
    expect(find.text('sessions completed'), findsOneWidget);
    // The card may merge the sentence with its title; the dots stay one phrase.
    expect(
      find.bySemanticsLabel(RegExp('This week you practised 2 days')),
      findsOneWidget,
    );
    semantics.dispose();

    // English weeks start on Sunday: Tuesday and Wednesday are slots 2 and 3.
    bool filled(int i) {
      final box = tester.widget<Container>(find.byKey(ValueKey('week-dot-$i')));
      return (box.decoration! as BoxDecoration).color != null;
    }

    expect(
      [for (var i = 0; i < 7; i++) filled(i)],
      [false, false, true, true, false, false, false],
    );
    // The reminder invitation sits above the strips, so scroll down to them.
    await tester.scrollUntilVisible(
      find.text('Continue where you left off'),
      200,
    );
    expect(find.text('Continue where you left off'), findsOneWidget);
  });

  testWidgets('a broken streak is met with kindness, not blame', (
    tester,
  ) async {
    await pumpHome(
      tester,
      history: [done('free-focus', DateTime(2026, 10, 15, 8))],
    );

    expect(find.text('A good day to begin again.'), findsOneWidget);
    expect(find.textContaining('0 days'), findsNothing);
  });

  testWidgets('favorites get their own strip', (tester) async {
    await pumpHome(
      tester,
      stored: {LocalFavoritesRepository.storageKey: '["free-sleep"]'},
    );

    expect(find.text('Your favorites'), findsOneWidget);
  });

  testWidgets('tapping the suggestion opens its detail page', (tester) async {
    // free-focus was the last one listened to, so free-sleep is suggested.
    await pumpHome(
      tester,
      history: [done('free-focus', DateTime(2026, 10, 20, 8))],
    );

    await tester.tap(find.byType(RecommendationCard));
    await tester.pumpAndSettle();

    expect(find.byType(MeditationDetailScreen), findsOneWidget);
    expect(find.text('Winding down'), findsWidgets);
  });

  testWidgets('streak and totals update when a session ends', (tester) async {
    final log = await pumpHome(tester);
    expect(find.text('Your first session can start today.'), findsOneWidget);

    await log.add(done('free-focus', DateTime(2026, 10, 21, 9)));
    await tester.pumpAndSettle();

    expect(find.text('1 day in a row'), findsOneWidget);
    expect(find.text('sessions completed'), findsOneWidget);
  });

  testWidgets('large text scrolls instead of overflowing', (tester) async {
    await pumpHome(
      tester,
      history: [
        done('free-focus', DateTime(2026, 10, 20, 8)),
        done('free-sleep', DateTime(2026, 10, 21, 8)),
      ],
      stored: {
        LocalFavoritesRepository.storageKey: '["free-sleep","free-focus"]',
      },
      textScale: 2.5,
    );

    expect(tester.takeException(), isNull);
    await tester.drag(find.byType(ListView).first, const Offset(0, -800));
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
  });
}
