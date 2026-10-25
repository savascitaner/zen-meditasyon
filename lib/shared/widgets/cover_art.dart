import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';

/// A meditation cover image, or a calm gradient when there is none or it
/// fails to load.
class CoverArt extends StatelessWidget {
  const CoverArt({
    required this.seed,
    this.imageSource,
    this.borderRadius = BorderRadius.zero,
    super.key,
  });

  /// An asset path (`assets/...`) or a URL.
  final String? imageSource;

  /// Picks the placeholder gradient, so the same item always looks the same.
  final String seed;
  final BorderRadius borderRadius;

  @override
  Widget build(BuildContext context) {
    final source = imageSource;
    return ClipRRect(
      borderRadius: borderRadius,
      child: source == null
          ? _GradientCover(seed: seed)
          : source.startsWith('http')
          ? Image.network(
              source,
              fit: BoxFit.cover,
              errorBuilder: (_, _, _) => _GradientCover(seed: seed),
            )
          : Image.asset(
              source,
              fit: BoxFit.cover,
              errorBuilder: (_, _, _) => _GradientCover(seed: seed),
            ),
    );
  }
}

class _GradientCover extends StatelessWidget {
  const _GradientCover({required this.seed});

  final String seed;

  @override
  Widget build(BuildContext context) {
    const gradients = AppColors.coverGradients;
    // String.hashCode is not stable across runs; sum the code units instead.
    final index = seed.codeUnits.fold(0, (a, b) => a + b) % gradients.length;
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: gradients[index],
        ),
      ),
      child: Center(
        child: Icon(
          Icons.self_improvement,
          color: AppColors.onAccentContainer.withValues(alpha: 0.5),
        ),
      ),
    );
  }
}
