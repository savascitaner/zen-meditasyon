import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zen_meditation/app.dart';
import 'package:zen_meditation/core/l10n/locale_controller.dart';
import 'package:zen_meditation/features/content/presentation/providers/content_providers.dart';
import 'package:zen_meditation/features/explore/presentation/widgets/meditation_card.dart';
import 'package:zen_meditation/features/meditation_detail/presentation/meditation_detail_screen.dart';
import 'package:zen_meditation/features/player/presentation/player_providers.dart';
import 'package:zen_meditation/features/player/presentation/player_screen.dart';

import '../../helpers/fake_audio_handler.dart';
import '../../helpers/fake_content_repository.dart';

/// Starts the app and opens the Explore tab.
///
/// With [settle] false the test pumps a few frames instead of settling, so a
/// pending [FakeContentRepository.gate] can be observed.
Future<void> openExplore(
  WidgetTester tester, {
  required FakeContentRepository repository,
  Locale device = const Locale('en'),
  bool settle = true,
}) async {
  SharedPreferences.setMockInitialValues({});
  final prefs = await SharedPreferences.getInstance();
  await tester.pumpWidget(
    ProviderScope(
      // Failures should surface immediately, not after automatic retries.
      retry: (_, _) => null,
      overrides: [
        sharedPreferencesProvider.overrideWithValue(prefs),
        deviceLocaleProvider.overrideWithValue(device),
        contentRepositoryProvider.overrideWithValue(repository),
        audioHandlerProvider.overrideWithValue(FakeAudioHandler()),
      ],
      child: const App(),
    ),
  );
  await tester.pumpAndSettle();

  final exploreLabel = device.languageCode == 'tr' ? 'Keşfet' : 'Explore';
  await tester.tap(
    find.descendant(
      of: find.byType(NavigationBar),
      matching: find.text(exploreLabel),
    ),
  );
  if (settle) {
    await tester.pumpAndSettle();
  } else {
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));
  }
}

Finder card(String title) => find.widgetWithText(MeditationCard, title);

Finder chip(String label) => find.widgetWithText(ChoiceChip, label);

void main() {
  testWidgets('shows a spinner while loading, then the list', (tester) async {
    final repository = FakeContentRepository(gate: Completer<void>());
    await openExplore(tester, repository: repository, settle: false);

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    expect(find.byType(MeditationCard), findsNothing);

    repository.gate!.complete();
    await tester.pumpAndSettle();

    expect(find.byType(CircularProgressIndicator), findsNothing);
    expect(find.text('3 meditations'), findsOneWidget);
    expect(find.byType(MeditationCard), findsNWidgets(3));
  });

  testWidgets('selecting a category changes the results', (tester) async {
    await openExplore(tester, repository: FakeContentRepository());
    expect(find.text('3 meditations'), findsOneWidget);

    await tester.tap(chip('Focus'));
    await tester.pumpAndSettle();

    expect(find.text('1 meditation'), findsOneWidget);
    expect(card('One thing at a time'), findsOneWidget);
    expect(card('Winding down'), findsNothing);

    await tester.tap(chip('All'));
    await tester.pumpAndSettle();
    expect(find.text('3 meditations'), findsOneWidget);
  });

  testWidgets('changing filters neither reloads nor shows a spinner', (
    tester,
  ) async {
    final repository = FakeContentRepository();
    await openExplore(tester, repository: repository);
    expect(repository.meditationCalls, 1);

    await tester.tap(chip('Focus'));
    // No settle: a reload would show a spinner right now.
    await tester.pump();
    expect(find.byType(CircularProgressIndicator), findsNothing);
    expect(find.text('1 meditation'), findsOneWidget);

    await tester.tap(chip('All'));
    await tester.pump();
    expect(find.text('3 meditations'), findsOneWidget);
    expect(repository.meditationCalls, 1);
  });

  testWidgets('duration filter keeps shorter meditations', (tester) async {
    await openExplore(tester, repository: FakeContentRepository());

    await tester.tap(chip('Up to 10 min'));
    await tester.pumpAndSettle();

    expect(find.text('2 meditations'), findsOneWidget);
    expect(card('Long night breath'), findsNothing);
  });

  testWidgets('premium card has a lock, free card does not', (tester) async {
    await openExplore(tester, repository: FakeContentRepository());

    expect(
      find.descendant(
        of: card('Long night breath'),
        matching: find.byIcon(Icons.lock),
      ),
      findsOneWidget,
    );
    expect(
      find.descendant(
        of: card('Winding down'),
        matching: find.byIcon(Icons.lock),
      ),
      findsNothing,
    );
  });

  testWidgets('cards have a screen reader label and 48dp targets', (
    tester,
  ) async {
    final semantics = tester.ensureSemantics();
    await openExplore(tester, repository: FakeContentRepository());

    expect(
      find.bySemanticsLabel(
        'Long night breath, 30 min, Sleep, Premium, locked',
      ),
      findsOneWidget,
    );
    expect(
      tester.getSize(card('Winding down')).height,
      greaterThanOrEqualTo(48),
    );
    for (final element in chip('Focus').evaluate()) {
      final size = tester.getSize(find.byWidget(element.widget));
      expect(size.height, greaterThanOrEqualTo(48));
      expect(size.width, greaterThanOrEqualTo(48));
    }
    semantics.dispose();
  });

  testWidgets('tapping a free card opens its detail page and player', (
    tester,
  ) async {
    await openExplore(tester, repository: FakeContentRepository());

    await tester.tap(card('Winding down'));
    await tester.pumpAndSettle();

    expect(find.byType(MeditationDetailScreen), findsOneWidget);
    expect(find.text('Winding down'), findsOneWidget);
    expect(find.text('A slow practice for the evening.'), findsOneWidget);
    expect(find.text('10 min'), findsOneWidget);
    expect(find.text('Narrated by Maya'), findsOneWidget);

    await tester.tap(find.text('Start'));
    await tester.pumpAndSettle();

    expect(find.byType(PlayerScreen), findsOneWidget);
  });

  testWidgets('premium detail page shows unlock and a snack bar', (
    tester,
  ) async {
    await openExplore(tester, repository: FakeContentRepository());

    await tester.tap(card('Long night breath'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Unlock with Premium'));
    await tester.pump();

    expect(find.text('Premium plans are coming soon.'), findsOneWidget);
    expect(find.byType(PlayerScreen), findsNothing);
  });

  testWidgets('shows an empty state and clears filters', (tester) async {
    await openExplore(tester, repository: FakeContentRepository());

    await tester.tap(chip('Focus'));
    await tester.pumpAndSettle();
    await tester.tap(chip('Up to 3 min'));
    await tester.pumpAndSettle();

    expect(find.text('No meditations match'), findsOneWidget);

    await tester.tap(find.text('Clear filters'));
    await tester.pumpAndSettle();
    expect(find.text('3 meditations'), findsOneWidget);
  });

  testWidgets('shows an error state and recovers on retry', (tester) async {
    final repository = FakeContentRepository()..fail = true;
    await openExplore(tester, repository: repository);

    expect(find.text("This couldn't load"), findsOneWidget);

    repository.fail = false;
    await tester.tap(find.text('Try again'));
    await tester.pumpAndSettle();

    expect(find.text('3 meditations'), findsOneWidget);
  });

  testWidgets('shows content in Turkish on a Turkish device', (tester) async {
    await openExplore(
      tester,
      repository: FakeContentRepository(),
      device: const Locale('tr'),
    );

    expect(find.text('3 meditasyon'), findsOneWidget);
    expect(chip('Uyku'), findsOneWidget);
    expect(card('Uzun gece nefesi'), findsOneWidget);

    await tester.tap(card('Uzun gece nefesi'));
    await tester.pumpAndSettle();
    expect(find.text('Premium ile aç'), findsOneWidget);
    expect(find.text('30 dk'), findsOneWidget);
  });
}
