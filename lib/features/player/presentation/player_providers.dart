import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/audio_handler.dart';
import '../../../core/l10n/locale_controller.dart';
import '../data/local_practice_log_repository.dart';
import '../domain/practice_log_repository.dart';

/// Overridden in `main.dart` with the handler returned by `AudioService.init`
/// (and in tests with a fake).
final audioHandlerProvider = Provider<MeditationAudioHandler>(
  (ref) => throw UnimplementedError('audioHandlerProvider not overridden'),
);

/// The practice history, kept on the device.
final practiceLogRepositoryProvider = Provider<PracticeLogRepository>(
  (ref) => LocalPracticeLogRepository(ref.watch(sharedPreferencesProvider)),
);

/// Overridden in tests to make `startedAt` predictable.
final clockProvider = Provider<DateTime Function()>((ref) => DateTime.now);
