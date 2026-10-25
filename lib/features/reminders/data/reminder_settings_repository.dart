import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../domain/reminder_settings.dart';
import '../domain/reminder_settings_repository.dart';

/// Keeps reminder settings in [SharedPreferences] as JSON. Unreadable or
/// out-of-range data reads as the defaults (off, 21:00).
class LocalReminderSettingsRepository implements ReminderSettingsRepository {
  LocalReminderSettingsRepository(this._prefs);

  static const storageKey = 'reminder_settings_v1';
  static const inviteDismissedKey = 'reminder_invite_dismissed_v1';

  final SharedPreferences _prefs;

  @override
  ReminderSettings load() {
    final raw = _prefs.getString(storageKey);
    if (raw == null) return const ReminderSettings();
    try {
      final settings = ReminderSettings.fromJson(
        jsonDecode(raw) as Map<String, dynamic>,
      );
      final valid =
          settings.hour >= 0 &&
          settings.hour < 24 &&
          settings.minute >= 0 &&
          settings.minute < 60;
      return valid ? settings : const ReminderSettings();
    } catch (_) {
      return const ReminderSettings();
    }
  }

  @override
  Future<void> save(ReminderSettings settings) =>
      _prefs.setString(storageKey, jsonEncode(settings.toJson()));

  @override
  bool loadInviteDismissed() => _prefs.getBool(inviteDismissedKey) ?? false;

  @override
  Future<void> saveInviteDismissed() =>
      _prefs.setBool(inviteDismissedKey, true);
}
