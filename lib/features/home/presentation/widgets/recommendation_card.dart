import 'package:flutter/material.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../shared/extensions/localized_text_x.dart';
import '../../../../shared/widgets/cover_art.dart';
import '../../../content/domain/models/meditation.dart';

/// Today's suggested meditation. Tapping opens its detail page.
class RecommendationCard extends StatelessWidget {
  const RecommendationCard({
    required this.meditation,
    required this.onTap,
    this.categoryLabel,
    super.key,
  });

  static const double coverSize = 72;

  final Meditation meditation;
  final VoidCallback onTap;
  final String? categoryLabel;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);
    final title = meditation.title.of(context);
    final categoryLabel = this.categoryLabel;
    final details = [
      l10n.durationMinutes(meditation.durationMinutes),
      ?categoryLabel,
    ].join(' · ');

    return Semantics(
      button: true,
      label: '${l10n.recommendationLabel}, $title, $details',
      onTap: onTap,
      excludeSemantics: true,
      child: Card(
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
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
                        l10n.recommendationLabel,
                        style: theme.textTheme.labelMedium?.copyWith(
                          color: theme.colorScheme.primary,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      Text(title, style: theme.textTheme.titleMedium),
                      const SizedBox(height: AppSpacing.xs),
                      Text(
                        details,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
