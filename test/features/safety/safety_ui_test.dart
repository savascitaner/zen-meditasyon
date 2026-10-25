import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zen_meditation/app.dart';
import 'package:zen_meditation/core/l10n/locale_controller.dart';
import 'package:zen_meditation/core/platform/platform_providers.dart';
import 'package:zen_meditation/features/content/presentation/providers/content_providers.dart';
import 'package:zen_meditation/features/onboarding/data/local_onboarding_repository.dart';
import 'package:zen_meditation/features/onboarding/presentation/welcome_screen.dart';
import 'package:zen_meditation/features/player/presentation/player_providers.dart';
import 'package:zen_meditation/features/profile/presentation/about_screen.dart';
import 'package:zen_meditation/features/reminders/presentation/reminder_controller.dart';
import 'package:zen_meditation/features/safety/presentation/crisis_support_screen.dart';
import 'package:zen_meditation/features/safety/presentation/safety_providers.dart';

import '../../helpers/fake_audio_handler.dart';
import '../../helpers/fake_content_repository.dart';
import '../../helpers/fake_reminder_scheduler.dart';

const _noticeTitle = 'Before you begin';

class _Env {
  final launched = <Uri>[];
  var launchResult = true;
  final shared = <({String fileName, String json})>[];
  final scheduler = FakeReminderScheduler();
}

Future<void> _pump(
  WidgetTester tester,
  SharedPreferences prefs,
  _Env env, {
  Locale device = const Locale('en', 'US'),
}) async {
  tester.view.physicalSize = const Size(390, 844);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);
  // The welcome glow loops forever; reduce motion turns it off.
  tester.platformDispatcher.accessibilityFeaturesTestValue =
      const FakeAccessibilityFeatures(disableAnimations: true);
  addTearDown(tester.platformDispatcher.clearAccessibilityFeaturesTestValue);
  await tester.pumpWidget(
    ProviderScope(
      retry: (_, _) => null,
      overrides: [
        sharedPreferencesProvider.overrideWithValue(prefs),
        deviceLocaleProvider.overrideWithValue(device),
        contentRepositoryProvider.overrideWithValue(FakeContentRepository()),
        audioHandlerProvider.overrideWithValue(FakeAudioHandler()),
        reminderSchedulerProvider.overrideWithValue(env.scheduler),
        appVersionProvider.overrideWith((ref) => '1.2.3 (45)'),
        externalLauncherProvider.overrideWithValue((uri) async {
          env.launched.add(uri);
          return env.launchResult;
        }),
        fileSharerProvider.overrideWithValue(
          ({required fileName, required json, Rect? origin}) async =>
              env.shared.add((fileName: fileName, json: json)),
        ),
      ],
      child: const App(),
    ),
  );
  await tester.pumpAndSettle();
}

Future<SharedPreferences> _prefs([
  Map<String, Object> values = const {},
]) async {
  SharedPreferences.setMockInitialValues(values);
  return SharedPreferences.getInstance();
}

Future<void> _openProfile(WidgetTester tester, {String tab = 'Profile'}) async {
  await tester.tap(find.text(tab));
  await tester.pumpAndSettle();
}

void main() {
  group('safety note', () {
    testWidgets('appears once after onboarding and not on the next launch', (
      tester,
    ) async {
      final env = _Env();
      final prefs = await _prefs();
      await _pump(tester, prefs, env);
      expect(find.text(_noticeTitle), findsNothing);

      await tester.tap(find.text('Get started'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Skip for now'));
      await tester.pumpAndSettle();

      expect(find.text(_noticeTitle), findsOneWidget);
      expect(find.textContaining('not a health service'), findsOneWidget);
      expect(prefs.getBool(SafetyNoticeSeen.storageKey), true);

      await tester.tap(find.text('Got it'));
      await tester.pumpAndSettle();
      expect(find.text(_noticeTitle), findsNothing);

      // Second launch with the same stored data.
      await tester.pumpWidget(const SizedBox());
      await _pump(tester, prefs, env);
      expect(find.text(_noticeTitle), findsNothing);
      expect(find.byType(NavigationBar), findsOneWidget);
    });

    testWidgets('"Find support" opens the crisis screen', (tester) async {
      final env = _Env();
      final prefs = await _prefs({
        LocalOnboardingRepository.completedKey: true,
      });
      await _pump(tester, prefs, env);

      await tester.tap(find.text('Find support'));
      await tester.pumpAndSettle();

      expect(find.byType(CrisisSupportScreen), findsOneWidget);
    });

    testWidgets('can be read again from Profile > About', (tester) async {
      final env = _Env();
      final prefs = await _prefs({
        LocalOnboardingRepository.completedKey: true,
        SafetyNoticeSeen.storageKey: true,
      });
      await _pump(tester, prefs, env);
      await _openProfile(tester);

      await tester.tap(find.text('About'));
      await tester.pumpAndSettle();
      expect(find.byType(AboutScreen), findsOneWidget);
      expect(find.text('1.2.3 (45)'), findsOneWidget);

      await tester.tap(find.text('Read the safety note'));
      await tester.pumpAndSettle();
      expect(find.text(_noticeTitle), findsOneWidget);
    });
  });

  group('crisis screen', () {
    Future<_Env> open(
      WidgetTester tester, {
      Locale device = const Locale('en', 'US'),
    }) async {
      final env = _Env();
      final prefs = await _prefs({
        LocalOnboardingRepository.completedKey: true,
        SafetyNoticeSeen.storageKey: true,
      });
      await _pump(tester, prefs, env, device: device);
      await _openProfile(tester);
      await tester.tap(find.text('Having a hard time?'));
      await tester.pumpAndSettle();
      return env;
    }

    testWidgets('says to call emergency services first, then shows the '
        'regional line; tapping dials it', (tester) async {
      final env = await open(tester);

      expect(
        find.text(
          'If you are in immediate danger, call your local emergency number now.',
        ),
        findsOneWidget,
      );
      expect(find.text('988'), findsOneWidget);

      await tester.tap(find.text('988'));
      await tester.pumpAndSettle();
      expect(env.launched.single.toString(), 'tel:988');
    });

    testWidgets('an unknown region shows only the directory', (tester) async {
      final env = await open(tester, device: const Locale('ja', 'JP'));

      expect(find.textContaining("don't have a number"), findsOneWidget);
      expect(find.byIcon(Icons.call_outlined), findsNothing);

      await tester.tap(find.text('Find a helpline in your country'));
      await tester.pumpAndSettle();
      expect(env.launched.single.toString(), 'https://findahelpline.com');
    });

    testWidgets('a failed launch tells the user to dial by hand', (
      tester,
    ) async {
      final env = await open(tester, device: const Locale('en', 'GB'));
      env.launchResult = false;

      await tester.tap(find.text('116 123'));
      await tester.pump();
      expect(env.launched.single.toString(), 'tel:116123');
      expect(find.textContaining('dial the number yourself'), findsOneWidget);
    });

    testWidgets('is shown in Turkish on a Turkish device', (tester) async {
      final env = _Env();
      final prefs = await _prefs({
        LocalOnboardingRepository.completedKey: true,
        SafetyNoticeSeen.storageKey: true,
      });
      await _pump(tester, prefs, env, device: const Locale('tr', 'TR'));
      await _openProfile(tester, tab: 'Profil');
      await tester.tap(find.text('Zor bir an mı yaşıyorsun?'));
      await tester.pumpAndSettle();

      expect(find.textContaining('Hemen tehlikedeysen'), findsOneWidget);
      expect(find.text('Acil çağrı merkezi'), findsOneWidget);
      expect(find.text('112'), findsOneWidget);
    });
  });

  group('Profile data rights', () {
    testWidgets('export hands a JSON file to the share sheet', (tester) async {
      final env = _Env();
      final prefs = await _prefs({
        LocalOnboardingRepository.completedKey: true,
        SafetyNoticeSeen.storageKey: true,
        LocalOnboardingRepository.stressLevelKey: 'calm',
      });
      await _pump(tester, prefs, env);
      await _openProfile(tester);

      await tester.tap(find.text('Export my data'));
      await tester.pumpAndSettle();

      final file = env.shared.single;
      expect(
        file.fileName,
        matches(RegExp(r'^ensora-data-\d{4}-\d{2}-\d{2}\.json$')),
      );
      final data = jsonDecode(file.json) as Map<String, dynamic>;
      expect((data['onboarding'] as Map)['stressLevel'], 'calm');
    });

    testWidgets('delete asks first, and cancelling keeps everything', (
      tester,
    ) async {
      final env = _Env();
      final prefs = await _prefs({
        LocalOnboardingRepository.completedKey: true,
        SafetyNoticeSeen.storageKey: true,
      });
      await _pump(tester, prefs, env);
      await _openProfile(tester);

      await tester.tap(find.text('Delete my data'));
      await tester.pumpAndSettle();
      expect(find.text('Delete your data?'), findsOneWidget);

      await tester.tap(find.text('Cancel'));
      await tester.pumpAndSettle();
      expect(prefs.getBool(LocalOnboardingRepository.completedKey), true);
      expect(env.scheduler.cancelAllCalls, 0);
      expect(find.byType(NavigationBar), findsOneWidget);
    });

    testWidgets('confirming erases data, keeps the language and returns to '
        'onboarding', (tester) async {
      final env = _Env();
      final prefs = await _prefs({
        LocaleController.storageKey: 'en',
        LocalOnboardingRepository.completedKey: true,
        SafetyNoticeSeen.storageKey: true,
        'favorites_v1': '["a"]',
      });
      await _pump(tester, prefs, env);
      await _openProfile(tester);

      await tester.tap(find.text('Delete my data'));
      await tester.pumpAndSettle();
      await tester.tap(find.widgetWithText(TextButton, 'Delete'));
      await tester.pumpAndSettle();

      expect(prefs.getKeys(), {LocaleController.storageKey});
      expect(env.scheduler.cancelAllCalls, 1);
      expect(find.byType(WelcomeScreen), findsOneWidget);
    });
  });
}
