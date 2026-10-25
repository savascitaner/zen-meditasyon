import 'package:freezed_annotation/freezed_annotation.dart';

part 'reminder_settings.freezed.dart';
part 'reminder_settings.g.dart';

/// The daily reminder the user has chosen. Off until they turn it on, and
/// 21:00 until they pick another time.
@freezed
abstract class ReminderSettings with _$ReminderSettings {
  const factory ReminderSettings({
    @Default(false) bool enabled,
    @Default(21) int hour,
    @Default(0) int minute,
  }) = _ReminderSettings;

  const ReminderSettings._();

  factory ReminderSettings.fromJson(Map<String, dynamic> json) =>
      _$ReminderSettingsFromJson(json);
}
