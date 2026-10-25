import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../../l10n/app_localizations.dart';
import '../providers/library_providers.dart';

/// Heart button that adds or removes one meditation from the favorites.
class FavoriteButton extends ConsumerWidget {
  const FavoriteButton({required this.meditationId, super.key});

  final String meditationId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final isFavorite = ref.watch(
      favoritesProvider.select((ids) => ids.contains(meditationId)),
    );

    final label = isFavorite ? l10n.favoriteRemove : l10n.favoriteAdd;

    return Semantics(
      button: true,
      label: label,
      excludeSemantics: true,
      child: IconButton(
        constraints: const BoxConstraints.tightFor(
          width: AppSpacing.minTouchTarget,
          height: AppSpacing.minTouchTarget,
        ),
        tooltip: label,
        icon: Icon(isFavorite ? Icons.favorite : Icons.favorite_border),
        onPressed: () {
          HapticFeedback.selectionClick();
          ref.read(favoritesProvider.notifier).toggle(meditationId);
        },
      ),
    );
  }
}
