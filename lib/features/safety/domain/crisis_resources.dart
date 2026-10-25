// IMPORTANT: every number and link in this file is a placeholder from the
// product brief and has NOT been verified against official sources. Before a
// release, check each entry (number, operator, hours, free of charge) with
// the operator or the government's official page, and record the date and
// source next to the entry. This is the only file that holds help lines.

/// One help line the crisis screen can show.
class CrisisResource {
  const CrisisResource({
    required this.dialNumber,
    required this.displayNumber,
    required this.nameEn,
    required this.nameTr,
  });

  /// Digits only, used for the `tel:` link.
  final String dialNumber;

  /// How the number is written on screen.
  final String displayNumber;

  final String nameEn;
  final String nameTr;

  String name(String languageCode) => languageCode == 'tr' ? nameTr : nameEn;
}

/// The help lines for one region, plus the international directory.
class CrisisGuide {
  const CrisisGuide({required this.resources});

  /// Empty when the region is not known.
  final List<CrisisResource> resources;

  bool get isKnownRegion => resources.isNotEmpty;

  /// Directory of help lines worldwide; always offered.
  Uri get directory => crisisDirectoryUri;
}

final crisisDirectoryUri = Uri.parse('https://findahelpline.com');

const _emergency112 = CrisisResource(
  dialNumber: '112',
  displayNumber: '112',
  nameEn: 'Emergency services',
  nameTr: 'Acil çağrı merkezi',
);

const _us988 = CrisisResource(
  dialNumber: '988',
  displayNumber: '988',
  nameEn: '988 Suicide & Crisis Lifeline',
  nameTr: '988 İntihar ve Kriz Yardım Hattı',
);

const _samaritans = CrisisResource(
  dialNumber: '116123',
  displayNumber: '116 123',
  nameEn: 'Samaritans',
  nameTr: 'Samaritans (Birleşik Krallık)',
);

/// ISO 3166-1 alpha-2 codes of the European Union member states.
const _euCountries = {
  'AT', 'BE', 'BG', 'HR', 'CY', 'CZ', 'DK', 'EE', 'FI', 'FR', 'DE', 'GR', //
  'HU', 'IE', 'IT', 'LV', 'LT', 'LU', 'MT', 'NL', 'PL', 'PT', 'RO', 'SK',
  'SI', 'ES', 'SE',
};

/// The help lines for [countryCode] (ISO 3166-1 alpha-2, any case), or an
/// empty guide when the region is unknown or [countryCode] is null.
CrisisGuide crisisGuideFor(String? countryCode) {
  final code = countryCode?.toUpperCase();
  if (code == null) return const CrisisGuide(resources: []);
  if (code == 'TR') return const CrisisGuide(resources: [_emergency112]);
  if (code == 'US') return const CrisisGuide(resources: [_us988]);
  if (code == 'GB') return const CrisisGuide(resources: [_samaritans]);
  if (_euCountries.contains(code)) {
    return const CrisisGuide(resources: [_emergency112]);
  }
  return const CrisisGuide(resources: []);
}
