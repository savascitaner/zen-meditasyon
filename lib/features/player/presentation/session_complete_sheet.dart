import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../l10n/app_localizations.dart';

enum SessionCompleteAction { done, replay }

/// A calm thank-you after a finished session. Null when dismissed.
Future<SessionCompleteAction?> showSessionCompleteSheet(BuildContext context) {
  return showModalBottomSheet<SessionCompleteAction>(
    context: context,
    builder: (_) => const SessionCompleteSheet(),
  );
}

class SessionCompleteSheet extends StatelessWidget {
  const SessionCompleteSheet({super.key});

  static const double iconSize = 56;
  static const double buttonHeight = 56;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);

    // Scrolls on short screens, where a bottom sheet gets little height.
    return SafeArea(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const ExcludeSemantics(
                child: Icon(
                  Icons.spa_outlined,
                  size: iconSize,
                  color: AppColors.accent,
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              Text(
                l10n.sessionCompleteTitle,
                style: theme.textTheme.headlineSmall,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                l10n.sessionCompleteMessage,
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.lg),
              SizedBox(
                width: double.infinity,
                height: buttonHeight,
                child: FilledButton(
                  onPressed: () =>
                      Navigator.of(context).pop(SessionCompleteAction.done),
                  child: Text(l10n.sessionCompleteDone),
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              TextButton(
                onPressed: () =>
                    Navigator.of(context).pop(SessionCompleteAction.replay),
                child: Text(l10n.playerReplay),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
