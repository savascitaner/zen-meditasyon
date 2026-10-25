import 'package:flutter/material.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../shared/extensions/localized_text_x.dart';
import '../../../../shared/widgets/cover_art.dart';
import '../../../../shared/widgets/premium_badge.dart';
import '../../../content/domain/models/meditation.dart';

/// List row for one meditation: cover, title, length, category and, for
/// premium content, a lock badge.
class MeditationCard extends StatelessWidget {
  const MeditationCard({
    required this.meditation,
    required this.onTap,
    this.categoryLabel,
    super.key,
  });

  static const double coverSize = 72;

  final Meditation meditation;
  final VoidCallback onTap;

  /// Localized name of the category to show; omitted when null.
  final String? categoryLabel;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);
    final title = meditation.title.of(context);
    final duration = l10n.durationMinutes(meditation.durationMinutes);
    final categoryLabel = this.categoryLabel;
    final details = [duration, ?categoryLabel].join(' · ');
    final semanticsLabel = [
      title,
      duration,
      ?categoryLabel,
      if (meditation.isPremium) l10n.premiumLockedSemantics,
    ].join(', ');

    return Semantics(
      button: true,
      label: semanticsLabel,
      onTap: onTap,
      excludeSemantics: true,
      child: Card(
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              minHeight: AppSpacing.minTouchTarget,
            ),
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.sm + AppSpacing.xs),
              child: Row(
                children: [
                  SizedBox.square(
                    dimension: coverSize,
                    child: CoverArt(
                      seed: meditation.categoryIds.firstOrNull ?? meditation.id,
                      imageSource: meditation.coverImage,
                      borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: theme.textTheme.titleMedium,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: AppSpacing.xs),
                        Text(
                          details,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        if (meditation.isPremium) ...[
                          const SizedBox(height: AppSpacing.sm),
                          const PremiumBadge(),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
