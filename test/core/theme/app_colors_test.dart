import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:zen_meditation/core/theme/app_colors.dart';

double contrast(Color a, Color b) {
  final la = a.computeLuminance();
  final lb = b.computeLuminance();
  final hi = la > lb ? la : lb;
  final lo = la > lb ? lb : la;
  return (hi + 0.05) / (lo + 0.05);
}

void main() {
  test('text colours meet WCAG AA (4.5:1) on their backgrounds', () {
    final pairs = <(Color, Color)>[
      (AppColors.textPrimary, AppColors.background),
      (AppColors.textPrimary, AppColors.surface),
      (AppColors.textSecondary, AppColors.background),
      (AppColors.textSecondary, AppColors.surface),
      (AppColors.onAccent, AppColors.accent),
      (AppColors.onAccentContainer, AppColors.accentContainer),
      (AppColors.onSecondary, AppColors.secondary),
      (AppColors.onError, AppColors.error),
      (AppColors.accent, AppColors.background),
      // Gradient stops behind screen text.
      (AppColors.textPrimary, AppColors.backgroundTop),
      (AppColors.textSecondary, AppColors.backgroundTop),
      (AppColors.textPrimary, AppColors.backgroundBottom),
      (AppColors.textSecondary, AppColors.backgroundBottom),
      // Text on glass cards and chips, over the brightest glow.
      (AppColors.textPrimary, AppColors.glassOverGlow),
      (AppColors.textSecondary, AppColors.glassOverGlow),
      (AppColors.textPastel, AppColors.glassOverGlow),
      (AppColors.onChipSelected, AppColors.chipSelected),
      (AppColors.gold, AppColors.glassOverGlow),
      (AppColors.gold, AppColors.surface),
      // Navy text on gold (colour scheme tertiary).
      (AppColors.backgroundTop, AppColors.gold),
    ];
    for (final (fg, bg) in pairs) {
      expect(contrast(fg, bg), greaterThanOrEqualTo(4.5), reason: '$fg on $bg');
    }
  });
}
