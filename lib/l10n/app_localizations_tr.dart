// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Turkish (`tr`).
class AppLocalizationsTr extends AppLocalizations {
  AppLocalizationsTr([String locale = 'tr']) : super(locale);

  @override
  String get appTitle => 'Zen';

  @override
  String get navToday => 'Bugün';

  @override
  String get navExplore => 'Keşfet';

  @override
  String get navPrograms => 'Programlar';

  @override
  String get navProfile => 'Profil';

  @override
  String get homePlaceholder => 'Günlük pratiğin burada görünecek.';

  @override
  String get programsPlaceholder => 'Rehberli programlar burada görünecek.';

  @override
  String get profilePlaceholder => 'Ayarların ve ilerlemen burada görünecek.';

  @override
  String get exploreAllCategories => 'Tümü';

  @override
  String get exploreAnyDuration => 'Her süre';

  @override
  String exploreDurationUpTo(int minutes) {
    return '$minutes dk\'ya kadar';
  }

  @override
  String get exploreCategoryFilterLabel => 'Kategoriler';

  @override
  String get exploreDurationFilterLabel => 'Süre';

  @override
  String exploreResultCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count meditasyon',
    );
    return '$_temp0';
  }

  @override
  String get exploreEmptyTitle => 'Eşleşen meditasyon yok';

  @override
  String get exploreEmptyMessage =>
      'Başka bir kategori ya da daha uzun bir süre dene.';

  @override
  String get exploreClearFilters => 'Filtreleri temizle';

  @override
  String get errorTitle => 'Bu içerik yüklenemedi';

  @override
  String get errorMessage => 'Bağlantını kontrol edip tekrar dene.';

  @override
  String get retry => 'Tekrar dene';

  @override
  String durationMinutes(int minutes) {
    return '$minutes dk';
  }

  @override
  String get premiumLabel => 'Premium';

  @override
  String get premiumLockedSemantics => 'Premium, kilitli';

  @override
  String detailNarratedBy(String name) {
    return 'Anlatan: $name';
  }

  @override
  String get detailStart => 'Başla';

  @override
  String get detailUnlockPremium => 'Premium ile aç';

  @override
  String get detailPremiumComingSoon => 'Premium planlar çok yakında.';

  @override
  String get detailNotFoundTitle => 'Bu meditasyon bulunamadı';

  @override
  String get detailNotFoundMessage => 'Taşınmış ya da kaldırılmış olabilir.';

  @override
  String get playerTitle => 'Oynatıcı';

  @override
  String get playerPlaceholder => 'Oynatıcı yakında burada olacak.';

  @override
  String get languageSectionTitle => 'Dil';

  @override
  String get languageEnglish => 'English';

  @override
  String get languageTurkish => 'Türkçe';
}
