import 'package:flutter/material.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../../l10n/app_localizations.dart';
import '../../domain/practice_stats.dart';
import 'week_dots.dart';

/// A gentle streak message and this week's dots. No scores or badges, and a
/// broken streak is never blamed on the user.
class StreakCard extends StatelessWidget {
  const StreakCard({
    required this.stats,
    required this.firstDayOfWeekIndex,
    super.key,
  });

  final PracticeStats stats;
  final int firstDayOfWeekIndex;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);
    final streak = stats.currentStreak;
    final title = streak > 0
        ? l10n.streakDays(streak)
        : stats.longestStreak > 0
        ? l10n.streakRestart
        : l10n.streakInvite;
    final subtitle = streak > 0 && stats.longestStreak > streak
        ? l10n.streakLongest(stats.longestStreak)
        : null;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: theme.textTheme.titleMedium),
            if (subtitle != null) ...[
              const SizedBox(height: AppSpacing.xs),
              Text(
                subtitle,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
            const SizedBox(height: AppSpacing.md),
            WeekDots(
              days: stats.weekDays,
              todayIndex: stats.todayIndex,
              firstDayOfWeekIndex: firstDayOfWeekIndex,
            ),
          ],
        ),
      ),
    );
  }
}
