import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/l10n/locale_controller.dart';
import '../../library/domain/favorites_repository.dart';
import '../../onboarding/domain/onboarding_repository.dart';
import '../../player/domain/practice_log_repository.dart';
import '../../reminders/domain/reminder_scheduler.dart';
import '../../reminders/domain/reminder_settings_repository.dart';

/// Exports and erases what Ensora keeps on this device (KVKK / GDPR).
///
/// Everything is local; nothing is sent anywhere. Exporting only reads, and
/// the file leaves the app only if the user picks a place in the share sheet.
class UserDataService {
  UserDataService({
    required this.prefs,
    required this.onboarding,
    required this.favorites,
    required this.practiceLog,
    required this.reminders,
    required this.scheduler,
    DateTime Function()? clock,
  }) : _clock = clock ?? DateTime.now;

  /// Bumped when the shape of the export changes.
  static const exportVersion = 1;

  /// The only key that survives [deleteAll]: the chosen app language.
  static const preservedKeys = {LocaleController.storageKey};

  final SharedPreferences prefs;
  final OnboardingRepository onboarding;
  final FavoritesRepository favorites;
  final PracticeLogRepository practiceLog;
  final ReminderSettingsRepository reminders;
  final ReminderScheduler scheduler;
  final DateTime Function() _clock;

  /// Practice history, favorites, onboarding answers and the reminder
  /// setting as a JSON-encodable map.
  Future<Map<String, Object?>> buildExport() async {
    final profile = onboarding.load();
    final sessions = await practiceLog.getAll();
    return {
      'app': 'Ensora',
      'exportVersion': exportVersion,
      'exportedAt': _clock().toUtc().toIso8601String(),
      'onboarding': {
        'completed': profile.completed,
        'stressLevel': profile.stressLevel?.name,
        'experience': profile.experience?.name,
      },
      'favorites': favorites.load(),
      'practiceHistory': [for (final s in sessions) s.toJson()],
      'reminder': reminders.load().toJson(),
    };
  }

  /// The export as readable, indented JSON.
  Future<String> exportJson() async =>
      const JsonEncoder.withIndent('  ').convert(await buildExport());

  /// Cancels scheduled notifications, then removes every stored key except
  /// the language choice.
  ///
  /// Providers that cache stored data must be invalidated afterwards (see
  /// `eraseUserDataProvider`).
  Future<void> deleteAll() async {
    await scheduler.cancelAll();
    for (final key in prefs.getKeys().toList()) {
      if (preservedKeys.contains(key)) continue;
      await prefs.remove(key);
    }
  }
}
