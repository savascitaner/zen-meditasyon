import '../../../l10n/app_localizations.dart';
import '../domain/reminder_scheduler.dart';

/// The reminder text in the app language. The title follows the time of day
/// (morning breath, afternoon pause, evening calm) and the body changes with
/// the weekday. Nothing medical, and nothing about streaks or guilt.
ReminderContent reminderContentFor(AppLocalizations l10n, int hour) {
  final title = hour < 12
      ? l10n.reminderTitleMorning
      : hour < 18
      ? l10n.reminderTitleAfternoon
      : l10n.reminderTitleEvening;
  return ReminderContent(
    title: title,
    bodies: [
      l10n.reminderBody1,
      l10n.reminderBody2,
      l10n.reminderBody3,
      l10n.reminderBody4,
      l10n.reminderBody5,
      l10n.reminderBody6,
      l10n.reminderBody7,
    ],
  );
}
