import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';

/// Night-blue to violet backdrop with two soft pools of light.
///
/// Wrap a [Scaffold] whose `backgroundColor` is [Colors.transparent]. The
/// backdrop is static and painted in its own layer, so scrolling the content
/// on top never repaints it.
class ZenBackground extends StatelessWidget {
  const ZenBackground({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        const Positioned.fill(
          child: IgnorePointer(child: RepaintBoundary(child: _Backdrop())),
        ),
        child,
      ],
    );
  }
}

class _Backdrop extends StatelessWidget {
  const _Backdrop();

  @override
  Widget build(BuildContext context) {
    return const DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          stops: [0, 0.45, 1],
          colors: [
            AppColors.backgroundTop,
            AppColors.backgroundMid,
            AppColors.backgroundBottom,
          ],
        ),
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          _Glow(
            center: Alignment(-0.9, -0.75),
            radius: 0.9,
            color: AppColors.glowViolet,
          ),
          _Glow(
            center: Alignment(1.1, 0.35),
            radius: 0.8,
            color: AppColors.glowBlue,
          ),
        ],
      ),
    );
  }
}

class _Glow extends StatelessWidget {
  const _Glow({
    required this.center,
    required this.radius,
    required this.color,
  });

  final Alignment center;
  final double radius;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: RadialGradient(
          center: center,
          radius: radius,
          colors: [color, color.withValues(alpha: 0)],
        ),
      ),
    );
  }
}
