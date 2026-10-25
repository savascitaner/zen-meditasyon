import 'dart:ui' as ui;

import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';

/// Frosted, translucent panel with soft corners and a hairline edge.
///
/// In a long list, put a [BackdropGroup] above the items so the engine blurs
/// the backdrop once for all of them. With Increase Contrast on, the panel is
/// solid and unblurred instead.
class GlassSurface extends StatelessWidget {
  const GlassSurface({
    required this.child,
    this.borderRadius = AppSpacing.radiusLg,
    super.key,
  });

  final Widget child;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    final solid = MediaQuery.highContrastOf(context);
    final radius = BorderRadius.circular(borderRadius);

    return RepaintBoundary(
      child: ClipRRect(
        borderRadius: radius,
        child: BackdropFilter.grouped(
          enabled: !solid,
          filter: ui.ImageFilter.blur(
            sigmaX: AppSpacing.glassBlur,
            sigmaY: AppSpacing.glassBlur,
          ),
          child: DecoratedBox(
            decoration: BoxDecoration(
              borderRadius: radius,
              color: solid ? AppColors.surface : null,
              gradient: solid
                  ? null
                  : const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        AppColors.glassFillTop,
                        AppColors.glassFillBottom,
                      ],
                    ),
              border: Border.all(
                color: solid ? AppColors.outline : AppColors.glassBorder,
                width: solid ? 1 : 0.5,
              ),
            ),
            child: child,
          ),
        ),
      ),
    );
  }
}
