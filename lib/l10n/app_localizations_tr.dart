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

  @override
  String get favoritesTitle => 'Favorilerim';

  @override
  String get favoriteAdd => 'Favorilere ekle';

  @override
  String get favoriteRemove => 'Favorilerden çıkar';

  @override
  String get favoritesEmptyTitle => 'Henüz favorin yok';

  @override
  String get favoritesEmptyMessage =>
      'Tekrar dönmek istediğin bir meditasyonda kalbe dokun, burada seni beklesin.';

  @override
  String get favoritesEmptyAction => 'Meditasyonları keşfet';

  @override
  String get greetingMorning => 'Günaydın';

  @override
  String get greetingAfternoon => 'İyi günler';

  @override
  String get greetingEvening => 'İyi akşamlar';

  @override
  String get recommendationLabel => 'Bugün için önerimiz';

  @override
  String streakDays(int count) {
    return '$count gün üst üste';
  }

  @override
  String get streakRestart => 'Yeniden başlamak için güzel bir gün.';

  @override
  String get streakInvite => 'İlk pratiğin bugün başlayabilir.';

  @override
  String streakLongest(int count) {
    return 'En uzun serin: $count gün';
  }

  @override
  String weekDotsSemantics(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Bu hafta $count gün pratik yaptın',
      zero: 'Bu hafta henüz pratik yok',
    );
    return '$_temp0';
  }

  @override
  String get statsMinutes => 'dakika pratik';

  @override
  String get statsSessions => 'tamamlanan oturum';

  @override
  String get homeContinueTitle => 'Kaldığın yerden';

  @override
  String get homeFavoritesTitle => 'Favorilerin';

  @override
  String get reminderSectionTitle => 'Günlük hatırlatma';

  @override
  String get reminderSubtitle => 'Seçtiğin saatte günde bir nazik hatırlatma.';

  @override
  String get reminderTimeLabel => 'Hatırlatma saati';

  @override
  String get reminderTimeDone => 'Tamam';

  @override
  String get reminderPermissionDenied =>
      'Ensora için bildirimler kapalı. Bildirimlere Ayarlar\'dan izin verebilirsin.';

  @override
  String get reminderOpenSettings => 'Ayarlar\'ı aç';

  @override
  String get reminderTitleMorning => 'Sabah nefesi';

  @override
  String get reminderTitleAfternoon => 'Kendine bir mola';

  @override
  String get reminderTitleEvening => 'Akşam huzuru';

  @override
  String get reminderBody1 =>
      'Birkaç sakin dakika, hazır olduğunda seni bekliyor.';

  @override
  String get reminderBody2 =>
      'Yavaşça bir nefes al. Pratiğin istediğinde burada.';

  @override
  String get reminderBody3 =>
      'Bir dakikalık sessizlik bile günü yumuşatabilir.';

  @override
  String get reminderBody4 =>
      'Omuzlarını bırak. Kısa bir mola bir dokunuş uzağında.';

  @override
  String get reminderBody5 => 'Kendine ayırdığın bir an, kendi temponda.';

  @override
  String get reminderBody6 => 'Olduğun gibi gel. Nefes al, nefes ver.';

  @override
  String get reminderBody7 => 'Bir süre yavaşla. Bunu hak ettin.';

  @override
  String get reminderInviteTitle => 'Her gün bu saatte hatırlatayım mı?';

  @override
  String reminderInviteBody(String time) {
    return '$time saatinde nazik bir hatırlatma. Profil\'den değiştirebilir ya da kapatabilirsin.';
  }

  @override
  String get reminderInviteYes => 'Evet, hatırlat';

  @override
  String get reminderInviteNo => 'Şimdi değil';

  @override
  String get safetyNoticeTitle => 'Başlamadan önce';

  @override
  String get safetyNoticeBody =>
      'Ensora, günlük hayat için sakinleştirici pratikler sunar. Bir sağlık hizmeti değildir; terapinin ya da profesyonel desteğin yerine geçmez. Bir şey ağır geliyorsa, güvendiğin biriyle ya da bir uzmanla konuşmak iyi gelebilir.';

  @override
  String get safetyNoticeGotIt => 'Anladım';

  @override
  String get safetyNoticeSupport => 'Destek bul';

  @override
  String get crisisTitle => 'Zor bir an mı yaşıyorsun?';

  @override
  String get crisisImmediate => 'Hemen tehlikedeysen yerel acil numarayı ara.';

  @override
  String get crisisIntro =>
      'Bunu tek başına yaşamak zorunda değilsin. Bu hatlar bağımsız kuruluşlar tarafından işletilir. Ensora bu ekrandan hiçbir veri toplamaz.';

  @override
  String crisisCallSemantics(String name, String number) {
    return '$name hattını ara: $number';
  }

  @override
  String get crisisUnknownRegion =>
      'Bölgen için henüz listelenmiş bir numara yok. Aşağıdaki rehber bir tane bulmana yardımcı olabilir.';

  @override
  String get crisisDirectoryTitle => 'Ülkende bir yardım hattı bul';

  @override
  String get crisisDirectorySubtitle =>
      'findahelpline.com dünya genelindeki yardım hatlarını listeler.';

  @override
  String get crisisOpenFailed => 'Açılamadı. Lütfen numarayı kendin ara.';

  @override
  String get profileDataSection => 'Verilerin';

  @override
  String get profileAbout => 'Hakkında';

  @override
  String get profileExportData => 'Verilerimi dışa aktar';

  @override
  String get profileExportDataSubtitle =>
      'Geçmişinin, favorilerinin ve ayarlarının bir kopyasını JSON dosyası olarak kaydet.';

  @override
  String get profileDeleteData => 'Verilerimi sil';

  @override
  String get profileDeleteDataSubtitle =>
      'Ensora\'nın bu cihazda sakladığı her şeyi kaldır.';

  @override
  String get dataExportFailed =>
      'Verilerin dışa aktarılamadı. Lütfen tekrar dene.';

  @override
  String get dataDeleteConfirmTitle => 'Verilerin silinsin mi?';

  @override
  String get dataDeleteConfirmBody =>
      'Pratik geçmişin, favorilerin, cevapların ve hatırlatıcın bu cihazdan silinir; planlı hatırlatmalar iptal edilir. Dil tercihin korunur. Bu işlem geri alınamaz.';

  @override
  String get dataDeleteConfirm => 'Sil';

  @override
  String get dataDeleteCancel => 'Vazgeç';

  @override
  String get aboutTitle => 'Hakkında';

  @override
  String get aboutVersion => 'Sürüm';

  @override
  String get aboutDisclaimer =>
      'Ensora bir sağlık hizmeti değildir; terapinin ya da profesyonel desteğin yerine geçmez.';

  @override
  String get aboutPrivacyPolicy => 'Gizlilik politikası';

  @override
  String get aboutTerms => 'Kullanım koşulları';

  @override
  String get aboutSafetyNote => 'Güvenlik notunu oku';

  @override
  String get linkOpenFailed => 'Bağlantı açılamadı.';
}
