import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

/// Soft, slowly breathing rings of light for the welcome screen.
///
/// Each ring follows the same slow breath with a small delay, so the glow
/// seems to ripple outward. With reduce motion turned on it is drawn still.
class CalmOrb extends StatefulWidget {
  const CalmOrb({required this.size, super.key});

  /// One full breath, in and out. Slower than the player's pace on purpose:
  /// this is a backdrop, not a guide.
  static const cycle = Duration(seconds: 8);

  final double size;

  @override
  State<CalmOrb> createState() => _CalmOrbState();
}

class _CalmOrbState extends State<CalmOrb> with SingleTickerProviderStateMixin {
  static const _rings = 3;

  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: CalmOrb.cycle,
  );

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (MediaQuery.disableAnimationsOf(context)) {
      _controller
        ..stop()
        ..value = 0.25;
    } else if (!_controller.isAnimating) {
      _controller.repeat();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ExcludeSemantics(
      child: SizedBox.square(
        dimension: widget.size,
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, _) => Stack(
            alignment: Alignment.center,
            children: [
              for (var ring = _rings - 1; ring >= 0; ring--)
                _Ring(
                  breath: _breath(_controller.value - ring * 0.08),
                  baseScale: 0.55 + ring * 0.2,
                  opacity: 0.55 - ring * 0.15,
                ),
            ],
          ),
        ),
      ),
    );
  }

  /// 0 at the bottom of a breath, 1 at the top, eased like a sine wave.
  static double _breath(double t) => (1 - math.cos(2 * math.pi * t)) / 2;
}

class _Ring extends StatelessWidget {
  const _Ring({
    required this.breath,
    required this.baseScale,
    required this.opacity,
  });

  final double breath;
  final double baseScale;
  final double opacity;

  @override
  Widget build(BuildContext context) {
    return Transform.scale(
      scale: baseScale + breath * 0.08,
      child: DecoratedBox(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(
            colors: [
              AppColors.accent.withValues(
                alpha: opacity * (0.6 + breath * 0.4),
              ),
              AppColors.secondary.withValues(alpha: opacity * 0.35),
              AppColors.background.withValues(alpha: 0),
            ],
            stops: const [0, 0.55, 1],
          ),
        ),
        child: const SizedBox.expand(),
      ),
    );
  }
}
