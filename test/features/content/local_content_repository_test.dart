import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:zen_meditation/features/content/data/local_content_repository.dart';
import 'package:zen_meditation/features/content/domain/models/category.dart';
import 'package:zen_meditation/features/content/domain/models/localized_text.dart';
import 'package:zen_meditation/features/content/domain/models/meditation.dart';
import 'package:zen_meditation/features/content/domain/models/meditation_filter.dart';
import 'package:zen_meditation/features/content/presentation/providers/content_providers.dart';

/// Serves a fixed string for any key, to test parsing without the real asset.
class _StringBundle extends CachingAssetBundle {
  _StringBundle(this.contents);

  final String contents;

  @override
  Future<ByteData> load(String key) async =>
      ByteData.sublistView(Uint8List.fromList(utf8.encode(contents)));
}

const _smallCatalog = '''
{
  "categories": [
    {"id": "sleep", "title": {"en": "Sleep", "tr": "Uyku"},
     "description": {"en": "Rest", "tr": "Dinlenme"}}
  ],
  "meditations": [
    {"id": "m1", "title": {"en": "Night", "tr": "Gece"},
     "description": {"en": "Wind down", "tr": "Gevşe"},
     "categoryIds": ["sleep"], "durationMinutes": 10,
     "audioSource": "assets/audio/sample.mp3", "coverImage": null,
     "narrator": "Maya", "isPremium": true, "tags": ["night"]},
    {"id": "m2", "title": {"en": "Short", "tr": "Kısa"},
     "description": {"en": "Quick", "tr": "Hızlı"},
     "categoryIds": ["sleep"], "durationMinutes": 3,
     "audioSource": "https://example.com/a.mp3", "narrator": "Can"}
  ],
  "programs": [
    {"id": "p1", "title": {"en": "Sleep routine", "tr": "Uyku düzeni"},
     "description": {"en": "Thirty nights", "tr": "Otuz gece"},
     "totalDays": 30, "isPremium": true,
     "days": [{"dayNumber": 1, "meditationId": "m1",
               "note": {"en": "Begin", "tr": "Başla"}}]}
  ]
}
''';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('parsing', () {
    test('reads every field and applies defaults', () async {
      final repo = LocalContentRepository(bundle: _StringBundle(_smallCatalog));

      final m1 = await repo.getMeditationById('m1');
      expect(m1, isNotNull);
      expect(m1!.title, const LocalizedText(en: 'Night', tr: 'Gece'));
      expect(m1.title.resolve('tr'), 'Gece');
      expect(m1.title.resolve('de'), 'Night');
      expect(m1.categoryIds, ['sleep']);
      expect(m1.durationMinutes, 10);
      expect(m1.audioSource, 'assets/audio/sample.mp3');
      expect(m1.coverImage, isNull);
      expect(m1.narrator, 'Maya');
      expect(m1.isPremium, isTrue);
      expect(m1.tags, ['night']);

      final m2 = (await repo.getMeditationById('m2'))!;
      expect(m2.isPremium, isFalse);
      expect(m2.tags, isEmpty);

      final program = (await repo.getProgramById('p1'))!;
      expect(program.totalDays, 30);
      expect(program.isPremium, isTrue);
      expect(program.days.single.dayNumber, 1);
      expect(program.days.single.meditationId, 'm1');
      expect(program.days.single.note.tr, 'Başla');

      expect((await repo.getCategories()).single.title.en, 'Sleep');
    });

    test('round-trips through toJson', () async {
      final repo = LocalContentRepository(bundle: _StringBundle(_smallCatalog));
      final program = (await repo.getProgramById('p1'))!;
      final json = jsonDecode(jsonEncode(program.toJson()));

      expect(
        json,
        containsPair('days', [
          {
            'dayNumber': 1,
            'meditationId': 'm1',
            'note': {'en': 'Begin', 'tr': 'Başla'},
          },
        ]),
      );
    });
  });

  group('bundled catalog', () {
    late LocalContentRepository repo;

    setUp(() => repo = LocalContentRepository());

    test('has the nine report categories', () async {
      final ids = (await repo.getCategories()).map((c) => c.id);
      expect(ids, CategoryIds.all);
    });

    test('has at least 12 meditations covering every category', () async {
      final meditations = await repo.getMeditations();
      expect(meditations.length, greaterThanOrEqualTo(12));
      for (final id in CategoryIds.all) {
        expect(
          meditations.where((m) => m.categoryIds.contains(id)),
          isNotEmpty,
          reason: 'no meditation in $id',
        );
      }
      expect(meditations.where((m) => m.isPremium), isNotEmpty);
      expect(meditations.where((m) => !m.isPremium), isNotEmpty);
    });

    test('meditations use known categories and filter durations', () async {
      for (final m in await repo.getMeditations()) {
        expect(CategoryIds.all, containsAll(m.categoryIds), reason: m.id);
        expect(meditationDurationOptions, contains(m.durationMinutes));
        expect(m.audioSource, 'assets/audio/sample.mp3');
        expect(m.title.en, isNotEmpty);
        expect(m.title.tr, isNotEmpty);
      }
    });

    test('has three 30-day programs pointing at real meditations', () async {
      final programs = await repo.getPrograms();
      expect(programs.map((p) => p.id), [
        'intro-to-zen',
        'sleep-routine',
        'stress-and-work',
      ]);
      for (final program in programs) {
        expect(program.totalDays, 30);
        expect(program.days.map((d) => d.dayNumber), [
          for (var i = 1; i <= 30; i++) i,
        ]);
        for (final day in program.days) {
          expect(
            await repo.getMeditationById(day.meditationId),
            isNotNull,
            reason: '${program.id} day ${day.dayNumber}',
          );
        }
      }
    });

    test('filters by category', () async {
      final sleep = await repo.getMeditations(categoryId: CategoryIds.sleep);
      expect(sleep, isNotEmpty);
      expect(sleep.every((m) => m.categoryIds.contains('sleep')), isTrue);
      expect(sleep.length, lessThan((await repo.getMeditations()).length));
    });

    test('filters by maximum duration', () async {
      for (final max in meditationDurationOptions) {
        final result = await repo.getMeditations(maxDuration: max);
        expect(result.every((m) => m.durationMinutes <= max), isTrue);
      }
      final short = await repo.getMeditations(maxDuration: 3);
      expect(short.map((m) => m.durationMinutes).toSet(), {3});
      expect(
        await repo.getMeditations(maxDuration: 30),
        await repo.getMeditations(),
      );
    });

    test('includePremium: false removes premium content', () async {
      final free = await repo.getMeditations(includePremium: false);
      expect(free, isNotEmpty);
      expect(free.any((m) => m.isPremium), isFalse);
    });

    test('combines filters', () async {
      final result = await repo.getMeditations(
        categoryId: CategoryIds.zen,
        maxDuration: 10,
        includePremium: false,
      );
      expect(result.map((m) => m.id), ['zen-sitting-5', 'zen-counting-10']);
    });

    test('returns null for unknown ids', () async {
      expect(await repo.getMeditationById('does-not-exist'), isNull);
      expect(await repo.getProgramById('does-not-exist'), isNull);
    });
  });

  group('providers', () {
    test('meditationsProvider passes the filter to the repository', () async {
      final container = ProviderContainer(
        overrides: [
          contentRepositoryProvider.overrideWithValue(
            LocalContentRepository(bundle: _StringBundle(_smallCatalog)),
          ),
        ],
      );
      addTearDown(container.dispose);

      final free = await container.read(
        meditationsProvider(const MeditationFilter(includePremium: false))
            .future,
      );
      expect(free.map((m) => m.id), ['m2']);

      final categories = await container.read(categoriesProvider.future);
      expect(categories.single.id, 'sleep');

      final programs = await container.read(programsProvider.future);
      expect(programs.single.id, 'p1');
    });
  });
}
