import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_spacing.dart';
import '../../../l10n/app_localizations.dart';
import 'reminder_controller.dart';

/// Shown once on Today after the first completed session, while the reminder
/// is off. Either answer, or closing it, retires the card for good.
class ReminderInviteCard extends ConsumerWidget {
  const ReminderInviteCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (!ref.watch(showReminderInviteProvider)) return const SizedBox.shrink();

    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final settings = ref.watch(reminderControllerProvider);
    final time = MaterialLocalizations.of(context).formatTimeOfDay(
      TimeOfDay(hour: settings.hour, minute: settings.minute),
      alwaysUse24HourFormat: MediaQuery.alwaysUse24HourFormatOf(context),
    );

    Future<void> accept() async {
      final messenger = ScaffoldMessenger.of(context);
      final granted = await ref
          .read(reminderControllerProvider.notifier)
          .setEnabled(true);
      await ref.read(reminderInviteDismissedProvider.notifier).dismiss();
      if (!granted) {
        messenger.showSnackBar(
          SnackBar(content: Text(l10n.reminderPermissionDenied)),
        );
      }
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l10n.reminderInviteTitle, style: theme.textTheme.titleMedium),
            const SizedBox(height: AppSpacing.xs),
            Text(
              l10n.reminderInviteBody(time),
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            Align(
              alignment: AlignmentDirectional.centerEnd,
              child: Wrap(
                spacing: AppSpacing.sm,
                children: [
                  TextButton(
                    onPressed: () => ref
                        .read(reminderInviteDismissedProvider.notifier)
                        .dismiss(),
                    child: Text(l10n.reminderInviteNo),
                  ),
                  FilledButton(
                    onPressed: accept,
                    child: Text(l10n.reminderInviteYes),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
