import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zen_meditation/app.dart';
import 'package:zen_meditation/core/l10n/locale_controller.dart';

Future<void> pumpApp(
  WidgetTester tester, {
  Map<String, Object> stored = const {},
  Locale device = const Locale('en'),
}) async {
  SharedPreferences.setMockInitialValues(stored);
  final prefs = await SharedPreferences.getInstance();
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(prefs),
        deviceLocaleProvider.overrideWithValue(device),
      ],
      child: const App(),
    ),
  );
  await tester.pumpAndSettle();
}

Finder navLabel(String text) =>
    find.descendant(of: find.byType(NavigationBar), matching: find.text(text));

void main() {
  testWidgets('shows four tabs in English by default', (tester) async {
    await pumpApp(tester);

    for (final label in ['Today', 'Explore', 'Programs', 'Profile']) {
      expect(navLabel(label), findsOneWidget);
    }
  });

  testWidgets('opens in Turkish on a Turkish device', (tester) async {
    await pumpApp(tester, device: const Locale('tr', 'TR'));

    expect(navLabel('Bugün'), findsOneWidget);
  });

  testWidgets('switching to Turkish updates tabs and persists', (tester) async {
    await pumpApp(tester);

    await tester.tap(navLabel('Profile'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Türkçe'));
    await tester.pumpAndSettle();

    expect(navLabel('Bugün'), findsOneWidget);
    expect(navLabel('Keşfet'), findsOneWidget);
    expect(navLabel('Programlar'), findsOneWidget);
    expect(navLabel('Profil'), findsOneWidget);

    final prefs = await SharedPreferences.getInstance();
    expect(prefs.getString(LocaleController.storageKey), 'tr');
  });

  testWidgets('saved language wins over device language', (tester) async {
    await pumpApp(
      tester,
      stored: {LocaleController.storageKey: 'en'},
      device: const Locale('tr'),
    );

    expect(navLabel('Today'), findsOneWidget);
  });

  testWidgets('tab state is kept when switching tabs', (tester) async {
    await pumpApp(tester);

    await tester.tap(navLabel('Profile'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Türkçe'));
    await tester.pumpAndSettle();
    await tester.tap(navLabel('Bugün'));
    await tester.pumpAndSettle();
    await tester.tap(navLabel('Profil'));
    await tester.pumpAndSettle();

    final selected = tester
        .widget<SegmentedButton<String>>(find.byType(SegmentedButton<String>))
        .selected;
    expect(selected, {'tr'});
  });
}
