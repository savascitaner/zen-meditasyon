import 'package:flutter/material.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../../l10n/app_localizations.dart';

/// The seven days of this week, filled where the user practised.
///
/// VoiceOver reads one sentence instead of seven dots.
class WeekDots extends StatelessWidget {
  const WeekDots({
    required this.days,
    required this.todayIndex,
    required this.firstDayOfWeekIndex,
    super.key,
  });

  static const double dotSize = 20;

  final List<bool> days;
  final int todayIndex;

  /// 0 is Sunday, as in `MaterialLocalizations.firstDayOfWeekIndex`.
  final int firstDayOfWeekIndex;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);
    final weekdays = MaterialLocalizations.of(context).narrowWeekdays;
    final count = days.where((d) => d).length;

    return Semantics(
      label: l10n.weekDotsSemantics(count),
      excludeSemantics: true,
      child: Row(
        children: [
          for (var i = 0; i < days.length; i++)
            Expanded(
              child: Column(
                children: [
                  Container(
                    key: ValueKey('week-dot-$i'),
                    width: dotSize,
                    height: dotSize,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: days[i] ? theme.colorScheme.primary : null,
                      border: Border.all(
                        color: days[i] || i == todayIndex
                            ? theme.colorScheme.primary
                            : theme.colorScheme.outline,
                        width: i == todayIndex ? 2 : 1,
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    weekdays[(firstDayOfWeekIndex + i) % 7],
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
