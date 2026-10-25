import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/route_names.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../l10n/app_localizations.dart';
import '../../../shared/extensions/localized_text_x.dart';
import '../../../shared/widgets/cover_art.dart';
import '../../../shared/widgets/empty_state.dart';
import '../../../shared/widgets/error_state.dart';
import '../../../shared/widgets/premium_badge.dart';
import '../../content/domain/models/meditation.dart';
import '../../content/presentation/providers/content_providers.dart';

/// Title, description and details of one meditation, with a start button.
class MeditationDetailScreen extends ConsumerWidget {
  const MeditationDetailScreen({required this.meditationId, super.key});

  final String meditationId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final meditation = ref.watch(meditationByIdProvider(meditationId));

    return Scaffold(
      appBar: AppBar(),
      body: meditation.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, _) => ErrorState(
          onRetry: () => ref.invalidate(meditationByIdProvider(meditationId)),
        ),
        data: (meditation) => meditation == null
            ? EmptyState(
                icon: Icons.search_off,
                title: l10n.detailNotFoundTitle,
                message: l10n.detailNotFoundMessage,
              )
            : _DetailBody(meditation: meditation),
      ),
    );
  }
}

class _DetailBody extends StatelessWidget {
  const _DetailBody({required this.meditation});

  static const double coverHeight = 200;
  static const double buttonHeight = 56;

  final Meditation meditation;

  void _onStart(BuildContext context) {
    if (meditation.isPremium) {
      // The paywall replaces this in a later task.
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context).detailPremiumComingSoon),
          ),
        );
      return;
    }
    context.push(RouteNames.playerLocation(meditation.id));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);
    final secondaryText = theme.textTheme.bodyMedium?.copyWith(
      color: theme.colorScheme.onSurfaceVariant,
    );

    return Column(
      children: [
        Expanded(
          child: ListView(
            padding: const EdgeInsets.all(AppSpacing.md),
            children: [
              SizedBox(
                height: coverHeight,
                child: CoverArt(
                  seed: meditation.categoryIds.firstOrNull ?? meditation.id,
                  imageSource: meditation.coverImage,
                  borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              Semantics(
                header: true,
                child: Text(
                  meditation.title.of(context),
                  style: theme.textTheme.headlineMedium,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              Wrap(
                spacing: AppSpacing.md,
                runSpacing: AppSpacing.sm,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  _InfoItem(
                    icon: Icons.schedule,
                    text: l10n.durationMinutes(meditation.durationMinutes),
                    style: secondaryText,
                  ),
                  _InfoItem(
                    icon: Icons.record_voice_over_outlined,
                    text: l10n.detailNarratedBy(meditation.narrator),
                    style: secondaryText,
                  ),
                  if (meditation.isPremium) const PremiumBadge(),
                ],
              ),
              const SizedBox(height: AppSpacing.lg),
              Text(
                meditation.description.of(context),
                style: theme.textTheme.bodyLarge,
              ),
            ],
          ),
        ),
        SafeArea(
          top: false,
          minimum: const EdgeInsets.all(AppSpacing.md),
          child: SizedBox(
            width: double.infinity,
            height: buttonHeight,
            child: FilledButton.icon(
              onPressed: () => _onStart(context),
              icon: Icon(meditation.isPremium ? Icons.lock : Icons.play_arrow),
              label: Text(
                meditation.isPremium
                    ? l10n.detailUnlockPremium
                    : l10n.detailStart,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _InfoItem extends StatelessWidget {
  const _InfoItem({required this.icon, required this.text, this.style});

  final IconData icon;
  final String text;
  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: AppSpacing.md + AppSpacing.xs, color: style?.color),
        const SizedBox(width: AppSpacing.xs),
        Text(text, style: style),
      ],
    );
  }
}
