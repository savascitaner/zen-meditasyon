import 'reminder_settings.dart';

/// Stores the reminder choice and whether the Today invitation was dismissed.
abstract interface class ReminderSettingsRepository {
  ReminderSettings load();

  Future<void> save(ReminderSettings settings);

  bool loadInviteDismissed();

  Future<void> saveInviteDismissed();
}
