import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../l10n/app_localizations.dart';

/// Icon used wherever premium content is marked as locked.
const IconData premiumLockIcon = Icons.lock_outline_rounded;

/// Marks premium content as locked: a thin gold pill with a label. The
/// paywall arrives in a later task.
class PremiumBadge extends StatelessWidget {
  const PremiumBadge({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);

    return Semantics(
      label: l10n.premiumLockedSemantics,
      excludeSemantics: true,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: AppColors.gold.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(AppSpacing.radiusPill),
          border: Border.all(
            color: AppColors.gold.withValues(alpha: 0.6),
            width: 0.75,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.sm + AppSpacing.xs,
            vertical: AppSpacing.xs,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                premiumLockIcon,
                size: AppSpacing.md - 2,
                color: AppColors.gold,
              ),
              const SizedBox(width: AppSpacing.xs + 2),
              Text(
                l10n.premiumLabel,
                style: theme.textTheme.labelMedium?.copyWith(
                  color: AppColors.gold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Small gold lock for the corner of a premium card.
///
/// A soft light sweeps across it once when it appears; with Reduce Motion
/// on it stays still.
class PremiumCornerMark extends StatefulWidget {
  const PremiumCornerMark({super.key});

  static const double size = 26;

  @override
  State<PremiumCornerMark> createState() => _PremiumCornerMarkState();
}

class _PremiumCornerMarkState extends State<PremiumCornerMark>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 2400),
  );

  // Waits a moment after the card appears, then sweeps.
  late final Animation<double> _sweep = CurvedAnimation(
    parent: _controller,
    curve: const Interval(0.35, 1, curve: Curves.easeInOut),
  );

  bool _reduceMotion = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _reduceMotion = MediaQuery.disableAnimationsOf(context);
    if (_reduceMotion) {
      _controller.stop();
    } else if (_controller.isDismissed) {
      _controller.forward();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mark = Container(
      width: PremiumCornerMark.size,
      height: PremiumCornerMark.size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.gold.withValues(alpha: 0.1),
        border: Border.all(
          color: AppColors.gold.withValues(alpha: 0.65),
          width: 0.75,
        ),
      ),
      child: const Icon(
        premiumLockIcon,
        size: AppSpacing.md - 2,
        color: AppColors.gold,
      ),
    );

    return Semantics(
      label: AppLocalizations.of(context).premiumLockedSemantics,
      excludeSemantics: true,
      child: AnimatedBuilder(
        animation: _controller,
        child: mark,
        builder: (context, child) {
          if (_reduceMotion || !_controller.isAnimating) return child!;
          // A narrow band of light travelling from top-left to bottom-right.
          final t = -0.3 + 1.6 * _sweep.value;
          return ShaderMask(
            blendMode: BlendMode.srcIn,
            shaderCallback: (bounds) => LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: const [
                AppColors.gold,
                AppColors.goldHighlight,
                AppColors.gold,
              ],
              stops: [
                (t - 0.2).clamp(0.0, 1.0),
                t.clamp(0.0, 1.0),
                (t + 0.2).clamp(0.0, 1.0),
              ],
            ).createShader(bounds),
            child: child,
          );
        },
      ),
    );
  }
}
