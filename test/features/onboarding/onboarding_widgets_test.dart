import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:zen_meditation/core/theme/app_theme.dart';
import 'package:zen_meditation/features/onboarding/presentation/widgets/option_card.dart';
import 'package:zen_meditation/features/onboarding/presentation/welcome_screen.dart';
import 'package:zen_meditation/l10n/app_localizations.dart';

void main() {
  testWidgets('option card can be activated by assistive technology', (
    tester,
  ) async {
    final semantics = tester.ensureSemantics();
    var taps = 0;
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: OptionCard(
            icon: Icons.spa,
            title: 'A',
            subtitle: 'B',
            selected: false,
            onTap: () => taps++,
          ),
        ),
      ),
    );

    final node = tester.getSemantics(find.bySemanticsLabel('A, B'));
    expect(node.getSemanticsData().hasAction(SemanticsAction.tap), isTrue);

    node.owner!.performAction(node.id, SemanticsAction.tap);
    expect(taps, 1);
    semantics.dispose();
  });

  testWidgets('welcome screen scrolls at large text on a small screen', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(320, 568);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.dark,
        locale: const Locale('en'),
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: AppLocalizations.supportedLocales,
        builder: (context, child) => MediaQuery(
          data: MediaQuery.of(context).copyWith(
            textScaler: const TextScaler.linear(2),
            disableAnimations: true,
          ),
          child: child!,
        ),
        home: const WelcomeScreen(),
      ),
    );
    await tester.pump();

    // An overflow would fail the test here.
    expect(find.byType(SingleChildScrollView), findsOneWidget);
    expect(find.text('Get started'), findsOneWidget);
  });
}
