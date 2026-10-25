import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_spacing.dart';
import '../../../l10n/app_localizations.dart';
import 'reminder_controller.dart';

/// The Profile section for the daily reminder: a switch, the time, and, when
/// iOS has refused notifications, a way to the Settings app.
class ReminderSettingsTile extends ConsumerWidget {
  const ReminderSettingsTile({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final settings = ref.watch(reminderControllerProvider);
    final denied = ref.watch(reminderPermissionDeniedProvider);
    final time = TimeOfDay(hour: settings.hour, minute: settings.minute);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SwitchListTile(
          contentPadding: EdgeInsets.zero,
          secondary: const Icon(Icons.notifications_none),
          title: Text(l10n.reminderSectionTitle),
          subtitle: Text(l10n.reminderSubtitle),
          value: settings.enabled,
          onChanged: (value) =>
              ref.read(reminderControllerProvider.notifier).setEnabled(value),
        ),
        if (settings.enabled)
          ListTile(
            contentPadding: EdgeInsets.zero,
            minTileHeight: AppSpacing.minTouchTarget,
            leading: const Icon(Icons.schedule),
            title: Text(l10n.reminderTimeLabel),
            trailing: Text(
              MaterialLocalizations.of(context).formatTimeOfDay(
                time,
                alwaysUse24HourFormat: MediaQuery.alwaysUse24HourFormatOf(
                  context,
                ),
              ),
              style: theme.textTheme.titleMedium,
            ),
            onTap: () => _pickTime(context, ref, time),
          ),
        if (denied) ...[
          Text(
            l10n.reminderPermissionDenied,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          Align(
            alignment: AlignmentDirectional.centerStart,
            child: TextButton(
              onPressed: () => ref.read(openAppSettingsProvider)(),
              child: Text(l10n.reminderOpenSettings),
            ),
          ),
        ],
      ],
    );
  }

  Future<void> _pickTime(
    BuildContext context,
    WidgetRef ref,
    TimeOfDay current,
  ) async {
    var picked = current;
    final use24h = MediaQuery.alwaysUse24HourFormatOf(context);
    final l10n = AppLocalizations.of(context);
    await showModalBottomSheet<void>(
      context: context,
      builder: (sheetContext) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Align(
              alignment: AlignmentDirectional.centerEnd,
              child: TextButton(
                onPressed: () => Navigator.of(sheetContext).pop(),
                child: Text(l10n.reminderTimeDone),
              ),
            ),
            SizedBox(
              height: _pickerHeight,
              child: CupertinoTheme(
                data: const CupertinoThemeData(brightness: Brightness.dark),
                child: CupertinoDatePicker(
                  mode: CupertinoDatePickerMode.time,
                  use24hFormat: use24h,
                  initialDateTime: DateTime(
                    2000,
                    1,
                    1,
                    current.hour,
                    current.minute,
                  ),
                  onDateTimeChanged: (value) => picked = TimeOfDay(
                    hour: value.hour,
                    minute: value.minute,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
    await ref
        .read(reminderControllerProvider.notifier)
        .setTime(picked.hour, picked.minute);
  }

  static const double _pickerHeight = 216;
}
