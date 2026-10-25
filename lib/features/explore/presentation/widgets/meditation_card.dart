import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../shared/extensions/localized_text_x.dart';
import '../../../../shared/widgets/cover_art.dart';
import '../../../../shared/widgets/glass_surface.dart';
import '../../../../shared/widgets/premium_badge.dart';
import '../../../content/domain/models/meditation.dart';

/// Frosted list row for one meditation: cover, title, length, category and,
/// for premium content, a small gold lock in the corner.
///
/// Put a [BackdropGroup] above a list of these so the blur is shared.
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
      child: GlassSurface(
        child: Material(
          type: MaterialType.transparency,
          child: InkWell(
            onTap: onTap,
            splashFactory: NoSplash.splashFactory,
            highlightColor: AppColors.glassFillTop,
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                minHeight: AppSpacing.minTouchTarget,
              ),
              child: Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(AppSpacing.cardGap),
                    child: Row(
                      children: [
                        SizedBox.square(
                          dimension: coverSize,
                          child: CoverArt(
                            seed:
                                meditation.categoryIds.firstOrNull ??
                                meditation.id,
                            imageSource: meditation.coverImage,
                            borderRadius: BorderRadius.circular(
                              AppSpacing.radiusMd,
                            ),
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
                              const SizedBox(height: AppSpacing.xs + 2),
                              Row(
                                children: [
                                  const Icon(
                                    Icons.schedule_rounded,
                                    size: AppSpacing.md - 2,
                                    color: AppColors.textPastel,
                                  ),
                                  const SizedBox(width: AppSpacing.xs + 2),
                                  Flexible(
                                    child: Text(
                                      details,
                                      style: theme.textTheme.bodySmall
                                          ?.copyWith(
                                            color: AppColors.textPastel,
                                          ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        // Keeps text clear of the corner mark.
                        if (meditation.isPremium)
                          const SizedBox(width: PremiumCornerMark.size),
                      ],
                    ),
                  ),
                  if (meditation.isPremium)
                    const Positioned(
                      top: AppSpacing.cardGap,
                      right: AppSpacing.cardGap,
                      child: PremiumCornerMark(),
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
