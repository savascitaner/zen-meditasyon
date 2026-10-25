import 'dart:async';

import 'package:zen_meditation/features/content/domain/content_repository.dart';
import 'package:zen_meditation/features/content/domain/models/category.dart';
import 'package:zen_meditation/features/content/domain/models/localized_text.dart';
import 'package:zen_meditation/features/content/domain/models/meditation.dart';
import 'package:zen_meditation/features/content/domain/models/program.dart';

/// In-memory [ContentRepository] for widget tests.
///
/// Set [gate] to hold every call until it completes, and [fail] to make
/// every call throw.
class FakeContentRepository implements ContentRepository {
  FakeContentRepository({
    List<Category>? categories,
    List<Meditation>? meditations,
    this.gate,
  }) : categories = categories ?? testCategories,
       meditations = meditations ?? testMeditations;

  final List<Category> categories;
  final List<Meditation> meditations;
  Completer<void>? gate;
  bool fail = false;

  /// Number of `getMeditations` calls, to check the catalog is not reloaded.
  int meditationCalls = 0;

  Future<void> _wait() async {
    await gate?.future;
    if (fail) throw StateError('content unavailable');
  }

  @override
  Future<List<Category>> getCategories() async {
    await _wait();
    return categories;
  }

  @override
  Future<List<Meditation>> getMeditations({
    String? categoryId,
    int? maxDuration,
    bool includePremium = true,
  }) async {
    meditationCalls++;
    await _wait();
    return [
      for (final m in meditations)
        if ((categoryId == null || m.categoryIds.contains(categoryId)) &&
            (maxDuration == null || m.durationMinutes <= maxDuration) &&
            (includePremium || !m.isPremium))
          m,
    ];
  }

  @override
  Future<Meditation?> getMeditationById(String id) async {
    await _wait();
    for (final m in meditations) {
      if (m.id == id) return m;
    }
    return null;
  }

  @override
  Future<List<Program>> getPrograms() async {
    await _wait();
    return const [];
  }

  @override
  Future<Program?> getProgramById(String id) async {
    await _wait();
    return null;
  }
}

const testCategories = [
  Category(
    id: 'sleep',
    title: LocalizedText(en: 'Sleep', tr: 'Uyku'),
    description: LocalizedText(en: 'Rest', tr: 'Dinlenme'),
  ),
  Category(
    id: 'focus',
    title: LocalizedText(en: 'Focus', tr: 'Odak'),
    description: LocalizedText(en: 'Attention', tr: 'Dikkat'),
  ),
];

const freeSleep = Meditation(
  id: 'free-sleep',
  title: LocalizedText(en: 'Winding down', tr: 'Gevşeme'),
  description: LocalizedText(
    en: 'A slow practice for the evening.',
    tr: 'Akşam için yavaş bir pratik.',
  ),
  categoryIds: ['sleep'],
  durationMinutes: 10,
  audioSource: 'assets/audio/sample.mp3',
  narrator: 'Maya',
);

const premiumSleep = Meditation(
  id: 'premium-sleep',
  title: LocalizedText(en: 'Long night breath', tr: 'Uzun gece nefesi'),
  description: LocalizedText(
    en: 'Breathing slowly into sleep.',
    tr: 'Uykuya yavaşça nefes alarak geçiş.',
  ),
  categoryIds: ['sleep'],
  durationMinutes: 30,
  audioSource: 'assets/audio/sample.mp3',
  narrator: 'Maya',
  isPremium: true,
);

const freeFocus = Meditation(
  id: 'free-focus',
  title: LocalizedText(en: 'One thing at a time', tr: 'Bir seferde bir şey'),
  description: LocalizedText(en: 'Settle attention.', tr: 'Dikkati yerleştir.'),
  categoryIds: ['focus'],
  durationMinutes: 5,
  audioSource: 'assets/audio/sample.mp3',
  narrator: 'Can',
);

const testMeditations = [freeSleep, premiumSleep, freeFocus];
