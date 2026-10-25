import 'package:flutter_test/flutter_test.dart';
import 'package:zen_meditation/features/content/domain/models/meditation_filter.dart';

import '../../helpers/fake_content_repository.dart';

void main() {
  const all = testMeditations;

  test('an empty filter keeps everything', () {
    expect(const MeditationFilter().apply(all), all);
  });

  test('a category keeps only meditations that have it', () {
    expect(const MeditationFilter(categoryId: 'focus').apply(all), [freeFocus]);
  });

  test('a maximum duration keeps shorter meditations', () {
    expect(const MeditationFilter(maxDuration: 10).apply(all), [
      freeSleep,
      freeFocus,
    ]);
  });

  test('premium content is dropped when not included', () {
    expect(const MeditationFilter(includePremium: false).apply(all), [
      freeSleep,
      freeFocus,
    ]);
  });
}
