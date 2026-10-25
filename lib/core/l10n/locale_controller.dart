import 'dart:ui';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Overridden in `main.dart` (and in tests) with a loaded instance.
final sharedPreferencesProvider = Provider<SharedPreferences>(
  (ref) => throw UnimplementedError('sharedPreferencesProvider not overridden'),
);

/// The device locale, read when no language has been saved yet.
final deviceLocaleProvider = Provider<Locale>(
  (ref) => PlatformDispatcher.instance.locale,
);

final localeControllerProvider = NotifierProvider<LocaleController, Locale>(
  LocaleController.new,
);

/// Holds the app language and persists the user's choice.
///
/// With no saved choice, Turkish devices get Turkish and all others English.
class LocaleController extends Notifier<Locale> {
  static const storageKey = 'app_locale';
  static const supportedLanguageCodes = ['en', 'tr'];

  @override
  Locale build() {
    final saved = ref.watch(sharedPreferencesProvider).getString(storageKey);
    if (saved != null && supportedLanguageCodes.contains(saved)) {
      return Locale(saved);
    }
    final device = ref.watch(deviceLocaleProvider);
    return Locale(device.languageCode == 'tr' ? 'tr' : 'en');
  }

  Future<void> setLocale(Locale locale) async {
    if (!supportedLanguageCodes.contains(locale.languageCode)) return;
    state = Locale(locale.languageCode);
    await ref
        .read(sharedPreferencesProvider)
        .setString(storageKey, locale.languageCode);
  }
}
