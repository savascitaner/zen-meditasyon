import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zen_meditation/core/l10n/locale_controller.dart';
import 'package:zen_meditation/features/content/presentation/providers/content_providers.dart';
import 'package:zen_meditation/features/library/data/local_favorites_repository.dart';
import 'package:zen_meditation/features/library/presentation/providers/library_providers.dart';
import 'package:zen_meditation/features/library/presentation/widgets/favorite_button.dart';
import 'package:zen_meditation/l10n/app_localizations.dart';

import '../../helpers/fake_content_repository.dart';

Future<ProviderContainer> containerWith(Map<String, Object> stored) async {
  SharedPreferences.setMockInitialValues(stored);
  final prefs = await SharedPreferences.getInstance();
  final container = ProviderContainer(
    overrides: [
      sharedPreferencesProvider.overrideWithValue(prefs),
      contentRepositoryProvider.overrideWithValue(FakeContentRepository()),
    ],
  );
  addTearDown(container.dispose);
  return container;
}

void main() {
  group('favoritesProvider', () {
    test('toggle adds in order and removes', () async {
      final c = await containerWith({});
      final notifier = c.read(favoritesProvider.notifier);

      notifier.toggle('b');
      notifier.toggle('a');
      notifier.toggle('c');
      expect(c.read(favoritesProvider), ['b', 'a', 'c']);

      notifier.toggle('a');
      expect(c.read(favoritesProvider), ['b', 'c']);

      notifier.toggle('a');
      expect(c.read(favoritesProvider), ['b', 'c', 'a']);
    });

    test('updates the state at once and persists across a restart', () async {
      final c = await containerWith({});
      c.read(favoritesProvider.notifier).toggle('x');
      expect(c.read(favoritesProvider), ['x']);
      await pumpEventQueue();

      final prefs = c.read(sharedPreferencesProvider);
      expect(LocalFavoritesRepository(prefs).load(), ['x']);

      final restarted = ProviderContainer(
        overrides: [sharedPreferencesProvider.overrideWithValue(prefs)],
      );
      addTearDown(restarted.dispose);
      expect(restarted.read(favoritesProvider), ['x']);
    });

    for (final broken in ['{oops', '{"a":1}', '']) {
      test('unreadable data "$broken" reads as no favorites', () async {
        final c = await containerWith({
          LocalFavoritesRepository.storageKey: broken,
        });
        expect(c.read(favoritesProvider), isEmpty);
      });
    }

    test('ids that are not strings are ignored', () async {
      final c = await containerWith({
        LocalFavoritesRepository.storageKey: '["a", 3, null, "b"]',
      });
      expect(c.read(favoritesProvider), ['a', 'b']);
    });

    test('favorites missing from the catalog are skipped', () async {
      final c = await containerWith({
        LocalFavoritesRepository.storageKey:
            '["free-focus", "removed", "free-sleep"]',
      });

      final meditations = await c.read(favoriteMeditationsProvider.future);

      expect(meditations, [freeFocus, freeSleep]);
    });
  });

  group('FavoriteButton', () {
    Future<void> pumpButton(WidgetTester tester) async {
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();
      await tester.pumpWidget(
        ProviderScope(
          overrides: [sharedPreferencesProvider.overrideWithValue(prefs)],
          child: const MaterialApp(
            locale: Locale('en'),
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: Scaffold(body: FavoriteButton(meditationId: 'free-sleep')),
          ),
        ),
      );
    }

    testWidgets('tapping swaps the icon and the spoken label', (tester) async {
      final semantics = tester.ensureSemantics();
      await pumpButton(tester);

      expect(find.byIcon(Icons.favorite_border), findsOneWidget);
      expect(find.bySemanticsLabel('Add to favorites'), findsOneWidget);
      expect(tester.getSize(find.byType(IconButton)).width, 48);
      expect(tester.getSize(find.byType(IconButton)).height, 48);

      await tester.tap(find.byType(FavoriteButton));
      await tester.pump();

      expect(find.byIcon(Icons.favorite), findsOneWidget);
      expect(find.byIcon(Icons.favorite_border), findsNothing);
      expect(find.bySemanticsLabel('Remove from favorites'), findsOneWidget);
      expect(find.bySemanticsLabel('Add to favorites'), findsNothing);

      await tester.tap(find.byType(FavoriteButton));
      await tester.pump();
      expect(find.byIcon(Icons.favorite_border), findsOneWidget);
      semantics.dispose();
    });
  });
}
