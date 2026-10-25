import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

/// A soft circle that slowly grows and shrinks behind [child], as a gentle
/// pace for breathing. It only moves while [active], and stays still when the
/// system asks to reduce motion.
class BreathingCircle extends StatefulWidget {
  const BreathingCircle({
    required this.active,
    required this.size,
    required this.child,
    super.key,
  });

  /// One full breath: in and back out.
  static const cycle = Duration(seconds: 4);
  static const double _smallestScale = 0.82;

  final bool active;
  final double size;
  final Widget child;

  @override
  State<BreathingCircle> createState() => _BreathingCircleState();
}

class _BreathingCircleState extends State<BreathingCircle>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: BreathingCircle.cycle ~/ 2,
  );
  late final Animation<double> _scale = Tween(
    begin: BreathingCircle._smallestScale,
    end: 1.0,
  ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

  bool _reduceMotion = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _reduceMotion = MediaQuery.disableAnimationsOf(context);
    _sync();
  }

  @override
  void didUpdateWidget(BreathingCircle oldWidget) {
    super.didUpdateWidget(oldWidget);
    _sync();
  }

  void _sync() {
    final shouldMove = widget.active && !_reduceMotion;
    if (shouldMove && !_controller.isAnimating) {
      _controller.repeat(reverse: true);
    } else if (!shouldMove && _controller.isAnimating) {
      _controller.stop();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: widget.size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          ScaleTransition(
            scale: _scale,
            child: DecoratedBox(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.accentContainer.withValues(alpha: 0.7),
              ),
              child: const SizedBox.expand(),
            ),
          ),
          widget.child,
        ],
      ),
    );
  }
}
