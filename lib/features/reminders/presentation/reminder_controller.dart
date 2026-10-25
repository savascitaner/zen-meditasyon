import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/l10n/locale_controller.dart';
import '../../../l10n/app_localizations.dart';
import '../../library/presentation/providers/library_providers.dart';
import '../data/reminder_settings_repository.dart';
import '../domain/reminder_scheduler.dart';
import '../domain/reminder_settings.dart';
import '../domain/reminder_settings_repository.dart';
import 'reminder_content.dart';

/// Overridden in `main.dart` with the real scheduler, and in reminder tests
/// with a fake.
final reminderSchedulerProvider = Provider<ReminderScheduler>(
  (ref) => const UnavailableReminderScheduler(),
);

final reminderSettingsRepositoryProvider = Provider<ReminderSettingsRepository>(
  (ref) =>
      LocalReminderSettingsRepository(ref.watch(sharedPreferencesProvider)),
);

/// Opens this app's page in the iOS Settings app. Overridden in tests.
final openAppSettingsProvider = Provider<Future<void> Function()>(
  (ref) => () async {
    await launchUrl(Uri.parse('app-settings:'));
  },
);

/// True after iOS refused notifications, until the user tries again or turns
/// the reminder off. Drives the "allow it in Settings" hint.
final reminderPermissionDeniedProvider =
    NotifierProvider<ReminderPermissionDenied, bool>(
      ReminderPermissionDenied.new,
    );

class ReminderPermissionDenied extends Notifier<bool> {
  @override
  bool build() => false;

  void set(bool denied) => state = denied;
}

final reminderControllerProvider =
    NotifierProvider<ReminderController, ReminderSettings>(
      ReminderController.new,
    );

/// Holds the reminder settings and keeps the scheduled notification in step
/// with them. Permission is requested here, and only when the user turns the
/// reminder on.
class ReminderController extends Notifier<ReminderSettings> {
  ReminderScheduler get _scheduler => ref.read(reminderSchedulerProvider);
  ReminderSettingsRepository get _repository =>
      ref.read(reminderSettingsRepositoryProvider);

  @override
  ReminderSettings build() {
    // New language: the scheduled text is in the old one, so schedule again.
    ref.listen(localeControllerProvider, (_, _) {
      if (state.enabled) unawaited(_schedule());
    });
    final settings = ref.watch(reminderSettingsRepositoryProvider).load();
    if (settings.enabled) unawaited(Future.microtask(sync));
    return settings;
  }

  /// Turns the reminder on or off. Returns false when the user turns it on and
  /// iOS does not allow notifications; the reminder then stays off.
  Future<bool> setEnabled(bool enabled) async {
    final denied = ref.read(reminderPermissionDeniedProvider.notifier);
    if (!enabled) {
      denied.set(false);
      await _apply(state.copyWith(enabled: false));
      await _scheduler.cancelAll();
      return true;
    }
    final granted = await _scheduler.requestPermission();
    denied.set(!granted);
    if (!granted) {
      await _apply(state.copyWith(enabled: false));
      return false;
    }
    await _apply(state.copyWith(enabled: true));
    await _schedule();
    return true;
  }

  Future<void> setTime(int hour, int minute) async {
    if (hour == state.hour && minute == state.minute) return;
    await _apply(state.copyWith(hour: hour, minute: minute));
    if (state.enabled) await _schedule();
  }

  /// Schedules again with the current time zone and language, and turns the
  /// reminder off if the user has since withdrawn permission in iOS Settings.
  /// Does nothing while the reminder is off.
  Future<void> sync() async {
    if (!state.enabled) return;
    if (!await _scheduler.isPermissionGranted()) {
      await _apply(state.copyWith(enabled: false));
      return;
    }
    await _schedule();
  }

  Future<void> _apply(ReminderSettings settings) async {
    state = settings;
    await _repository.save(settings);
  }

  Future<void> _schedule() {
    final l10n = lookupAppLocalizations(ref.read(localeControllerProvider));
    return _scheduler.scheduleDaily(
      hour: state.hour,
      minute: state.minute,
      content: reminderContentFor(l10n, state.hour),
    );
  }
}

final reminderInviteDismissedProvider =
    NotifierProvider<ReminderInviteDismissed, bool>(
      ReminderInviteDismissed.new,
    );

class ReminderInviteDismissed extends Notifier<bool> {
  @override
  bool build() =>
      ref.watch(reminderSettingsRepositoryProvider).loadInviteDismissed();

  Future<void> dismiss() async {
    state = true;
    await ref.read(reminderSettingsRepositoryProvider).saveInviteDismissed();
  }
}

/// Whether Today should invite the user to set up the reminder: once they
/// have completed a session, while the reminder is off, and never again after
/// the card has been answered or dismissed.
final showReminderInviteProvider = Provider<bool>((ref) {
  if (ref.watch(reminderInviteDismissedProvider)) return false;
  if (ref.watch(reminderControllerProvider).enabled) return false;
  final sessions = ref.watch(practiceHistoryProvider).value ?? const [];
  return sessions.any((s) => s.completed);
});
