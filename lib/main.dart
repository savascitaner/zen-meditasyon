import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app.dart';
import 'core/l10n/locale_controller.dart';
import 'features/player/data/audio_handler.dart';
import 'features/player/presentation/player_providers.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  // Starts the background audio service. Must run once, before the first
  // frame, so the player screen can use the handler right away.
  final audioHandler = await AudioService.init<MeditationAudioHandler>(
    builder: JustAudioMeditationHandler.new,
    config: const AudioServiceConfig(
      androidNotificationChannelId: 'com.zenmeditation.zen_meditation.audio',
      androidNotificationChannelName: 'Meditation playback',
      androidNotificationOngoing: true,
      rewindInterval: playerSkipInterval,
      fastForwardInterval: playerSkipInterval,
    ),
  );

  runApp(
    ProviderScope(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(prefs),
        audioHandlerProvider.overrideWithValue(audioHandler),
      ],
      child: const App(),
    ),
  );
}
