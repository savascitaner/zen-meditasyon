import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zen_meditation/app.dart';
import 'package:zen_meditation/core/l10n/locale_controller.dart';
import 'package:zen_meditation/core/router/app_router.dart';
import 'package:zen_meditation/features/content/presentation/providers/content_providers.dart';
import 'package:zen_meditation/features/player/presentation/player_providers.dart';
import 'package:zen_meditation/features/player/presentation/session_complete_sheet.dart';
import 'package:zen_meditation/features/player/presentation/widgets/breathing_circle.dart';

import '../../helpers/fake_audio_handler.dart';
import '../../helpers/fake_content_repository.dart';

Future<FakeAudioHandler> openPlayer(
  WidgetTester tester, {
  Object? loadError,
}) async {
  SharedPreferences.setMockInitialValues({});
  final prefs = await SharedPreferences.getInstance();
  final handler = FakeAudioHandler(length: const Duration(seconds: 100))
    ..loadError = loadError;
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(prefs),
        deviceLocaleProvider.overrideWithValue(const Locale('en')),
        contentRepositoryProvider.overrideWithValue(FakeContentRepository()),
        audioHandlerProvider.overrideWithValue(handler),
      ],
      child: const App(),
    ),
  );
  await tester.pumpAndSettle();
  final container = ProviderScope.containerOf(
    tester.element(find.byType(Scaffold).first),
  );
  container.read(appRouterProvider).push('/player/free-sleep');
  await tester.pumpAndSettle();
  return handler;
}

void main() {
  testWidgets('shows the title, remaining time and play button', (
    tester,
  ) async {
    await openPlayer(tester);

    expect(find.text('Winding down'), findsOneWidget);
    expect(find.text('Narrated by Maya'), findsOneWidget);
    expect(find.text('1:40 left'), findsOneWidget);
    expect(find.byTooltip('Play'), findsOneWidget);
    expect(find.byTooltip('Back 15 seconds'), findsOneWidget);
    expect(find.byTooltip('Forward 15 seconds'), findsOneWidget);
  });

  testWidgets('play switches to pause and starts the breathing circle', (
    tester,
  ) async {
    await openPlayer(tester);

    await tester.tap(find.byTooltip('Play'));
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));

    expect(find.byTooltip('Pause'), findsOneWidget);
    final circle = tester.widget<BreathingCircle>(find.byType(BreathingCircle));
    expect(circle.active, isTrue);

    await tester.tap(find.byTooltip('Pause'));
    await tester.pumpAndSettle();
    expect(find.byTooltip('Play'), findsOneWidget);
  });

  testWidgets('a missing audio file shows a friendly error', (tester) async {
    await openPlayer(tester, loadError: StateError('no such asset'));

    expect(find.text("This audio can't be played right now"), findsOneWidget);
    expect(find.text('Try again'), findsOneWidget);
    expect(find.byTooltip('Play'), findsNothing);
  });

  testWidgets('finishing the audio shows the completion sheet', (tester) async {
    final handler = await openPlayer(tester);

    await tester.tap(find.byTooltip('Play'));
    await tester.pump();
    handler
      ..listenFor(const Duration(seconds: 100))
      ..finish();
    await tester.pumpAndSettle();

    expect(find.byType(SessionCompleteSheet), findsOneWidget);
    expect(find.text('Session complete'), findsOneWidget);

    await tester.tap(find.text('Done'));
    await tester.pumpAndSettle();
    expect(find.byType(SessionCompleteSheet), findsNothing);
    expect(find.text('Winding down'), findsNothing);
    expect(handler.stopCalls, 1);
  });
}
