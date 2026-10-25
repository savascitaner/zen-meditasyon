// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Turkish (`tr`).
class AppLocalizationsTr extends AppLocalizations {
  AppLocalizationsTr([String locale = 'tr']) : super(locale);

  @override
  String get appTitle => 'Ensora';

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
  String get playerPlay => 'Oynat';

  @override
  String get playerPause => 'Duraklat';

  @override
  String get playerBack15 => '15 saniye geri';

  @override
  String get playerForward15 => '15 saniye ileri';

  @override
  String playerRemaining(String time) {
    return '$time kaldı';
  }

  @override
  String get playerClose => 'Oynatıcıyı kapat';

  @override
  String get playerReplay => 'Tekrar dinle';

  @override
  String get playerUnavailableTitle => 'Bu ses şu anda çalınamıyor';

  @override
  String get playerUnavailableMessage => 'Biraz sonra tekrar deneyebilirsin.';

  @override
  String get sessionCompleteTitle => 'Oturum tamamlandı';

  @override
  String get sessionCompleteMessage =>
      'Kendine bu zamanı ayırdığın için teşekkürler. Bu sakinliği iyi geldiği sürece yanında taşıyabilirsin.';

  @override
  String get sessionCompleteDone => 'Tamam';

  @override
  String get languageSectionTitle => 'Dil';

  @override
  String get languageEnglish => 'English';

  @override
  String get languageTurkish => 'Türkçe';

  @override
  String get welcomeTagline =>
      'Nefes al, yavaşla ve her gün biraz daha sakinlik bul.';

  @override
  String get welcomeGetStarted => 'Başlayalım';

  @override
  String get welcomeDisclaimer =>
      'Ensora gündelik iyi oluşuna destek olur; profesyonel desteğin yerini tutmaz.';

  @override
  String surveyStepOf(int step, int total) {
    return 'Adım $step / $total';
  }

  @override
  String get surveyBack => 'Geri';

  @override
  String get surveySkip => 'Şimdilik geç';

  @override
  String get surveyContinue => 'Devam et';

  @override
  String get surveyFinish => 'Keşfetmeye başla';

  @override
  String get surveyStressTitle => 'Son zamanlarda kendini nasıl hissediyorsun?';

  @override
  String get surveyStressSubtitle =>
      'Doğru ya da yanlış cevap yok. Bu yalnızca sana nazik bir başlangıç hazırlamamıza yardımcı olur.';

  @override
  String get stressCalmTitle => 'Çoğunlukla sakin';

  @override
  String get stressCalmSubtitle => 'Her şey oldukça dengeli.';

  @override
  String get stressSlightlyTenseTitle => 'Biraz gergin';

  @override
  String get stressSlightlyTenseSubtitle =>
      'Bazı günler diğerlerinden daha yoğun geçiyor.';

  @override
  String get stressStressedTitle => 'Sık sık stresli';

  @override
  String get stressStressedSubtitle =>
      'Zihnim çoğu zaman meşgul ya da huzursuz.';

  @override
  String get stressOverwhelmedTitle => 'Bunalmış';

  @override
  String get stressOverwhelmedSubtitle =>
      'Son zamanlarda her şey biraz fazla geldi.';

  @override
  String get surveyExperienceTitle => 'Meditasyona ne kadar aşinasın?';

  @override
  String get surveyExperienceSubtitle => 'Her başlangıç noktası güzeldir.';

  @override
  String get experienceNewcomerTitle => 'Yeni başlıyorum';

  @override
  String get experienceNewcomerSubtitle =>
      'Kısa ve sade seanslar iyi bir başlangıç.';

  @override
  String get experienceSomeTitle => 'Birkaç kez denedim';

  @override
  String get experienceSomeSubtitle =>
      'Temelleri biliyorum ve devam etmek istiyorum.';

  @override
  String get experienceRegularTitle => 'Düzenli pratik yapıyorum';

  @override
  String get experienceRegularSubtitle =>
      'Meditasyon zaten rutinimin bir parçası.';
}
