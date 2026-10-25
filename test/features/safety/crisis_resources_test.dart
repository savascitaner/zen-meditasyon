import 'package:flutter_test/flutter_test.dart';
import 'package:zen_meditation/features/safety/domain/crisis_resources.dart';

void main() {
  group('crisisGuideFor', () {
    test('Turkey gets 112', () {
      final guide = crisisGuideFor('TR');
      expect(guide.isKnownRegion, true);
      expect(guide.resources.map((r) => r.dialNumber), ['112']);
    });

    test('United States gets 988', () {
      final guide = crisisGuideFor('US');
      expect(guide.resources.map((r) => r.dialNumber), ['988']);
    });

    test('United Kingdom gets Samaritans 116 123', () {
      final resource = crisisGuideFor('GB').resources.single;
      expect(resource.dialNumber, '116123');
      expect(resource.displayNumber, '116 123');
      expect(resource.name('en'), 'Samaritans');
    });

    test('EU member states get 112', () {
      for (final code in ['DE', 'FR', 'ES', 'IE', 'SE']) {
        expect(crisisGuideFor(code).resources.map((r) => r.dialNumber), [
          '112',
        ], reason: code);
      }
    });

    test('the country code is not case sensitive', () {
      expect(crisisGuideFor('tr').resources.single.dialNumber, '112');
    });

    test('an unknown or missing region has no numbers, only the directory', () {
      for (final code in [null, '', 'JP', 'ZZ']) {
        final guide = crisisGuideFor(code);
        expect(guide.isKnownRegion, false, reason: '$code');
        expect(guide.resources, isEmpty);
        expect(guide.directory.toString(), 'https://findahelpline.com');
      }
    });

    test('every dial number is digits only, so tel: links work', () {
      for (final code in ['TR', 'US', 'GB', 'DE']) {
        for (final r in crisisGuideFor(code).resources) {
          expect(r.dialNumber, matches(RegExp(r'^\d+$')));
        }
      }
    });

    test('names switch with the language', () {
      final resource = crisisGuideFor('TR').resources.single;
      expect(resource.name('tr'), 'Acil çağrı merkezi');
      expect(resource.name('en'), 'Emergency services');
    });
  });
}
