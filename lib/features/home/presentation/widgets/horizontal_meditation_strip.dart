import 'package:flutter/material.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../shared/extensions/localized_text_x.dart';
import '../../../../shared/widgets/cover_art.dart';
import '../../../content/domain/models/meditation.dart';

/// A titled, sideways-scrolling row of meditations.
///
/// Sized by its content rather than a fixed height, so larger text sizes
/// never overflow.
class HorizontalMeditationStrip extends StatelessWidget {
  const HorizontalMeditationStrip({
    required this.title,
    required this.meditations,
    required this.onTap,
    super.key,
  });

  static const double itemWidth = 140;

  final String title;
  final List<Meditation> meditations;
  final ValueChanged<Meditation> onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Semantics(
          header: true,
          child: Text(title, style: theme.textTheme.titleMedium),
        ),
        const SizedBox(height: AppSpacing.sm),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (final m in meditations)
                  Padding(
                    padding: const EdgeInsets.only(right: AppSpacing.sm),
                    child: SizedBox(
                      width: itemWidth,
                      child: Semantics(
                        button: true,
                        label:
                            '${m.title.of(context)}, '
                            '${l10n.durationMinutes(m.durationMinutes)}',
                        onTap: () => onTap(m),
                        excludeSemantics: true,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(
                            AppSpacing.radiusMd,
                          ),
                          onTap: () => onTap(m),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              AspectRatio(
                                aspectRatio: 1.4,
                                child: CoverArt(
                                  seed: m.categoryIds.firstOrNull ?? m.id,
                                  imageSource: m.coverImage,
                                  borderRadius: BorderRadius.circular(
                                    AppSpacing.radiusMd,
                                  ),
                                ),
                              ),
                              const SizedBox(height: AppSpacing.xs),
                              Text(
                                m.title.of(context),
                                style: theme.textTheme.bodyMedium,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(
                                l10n.durationMinutes(m.durationMinutes),
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: theme.colorScheme.onSurfaceVariant,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
