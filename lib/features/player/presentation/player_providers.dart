import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/audio_handler.dart';
import '../data/in_memory_practice_log_repository.dart';
import '../domain/practice_log_repository.dart';

/// Overridden in `main.dart` with the handler returned by `AudioService.init`
/// (and in tests with a fake).
final audioHandlerProvider = Provider<MeditationAudioHandler>(
  (ref) => throw UnimplementedError('audioHandlerProvider not overridden'),
);

/// Görev 7 swaps this for a persistent repository.
final practiceLogRepositoryProvider = Provider<PracticeLogRepository>(
  (ref) => InMemoryPracticeLogRepository(),
);

/// Overridden in tests to make `startedAt` predictable.
final clockProvider = Provider<DateTime Function()>((ref) => DateTime.now);
