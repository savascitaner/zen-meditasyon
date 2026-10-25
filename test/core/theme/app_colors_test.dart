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
    const pairs = <(Color, Color)>[
      (AppColors.textPrimary, AppColors.background),
      (AppColors.textPrimary, AppColors.surface),
      (AppColors.textSecondary, AppColors.background),
      (AppColors.textSecondary, AppColors.surface),
      (AppColors.onAccent, AppColors.accent),
      (AppColors.onAccentContainer, AppColors.accentContainer),
      (AppColors.onSecondary, AppColors.secondary),
      (AppColors.onError, AppColors.error),
      (AppColors.accent, AppColors.background),
    ];
    for (final (fg, bg) in pairs) {
      expect(contrast(fg, bg), greaterThanOrEqualTo(4.5), reason: '$fg on $bg');
    }
  });
}
