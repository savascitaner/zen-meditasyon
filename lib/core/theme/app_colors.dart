import 'package:flutter/material.dart';

/// Calm, low-contrast dark palette.
///
/// Every text colour is checked against [background] and [surface] for
/// WCAG AA contrast (4.5:1) in `test/core/theme/app_colors_test.dart`.
abstract final class AppColors {
  static const Color background = Color(0xFF11151B);
  static const Color surface = Color(0xFF1A2029);
  static const Color surfaceHigh = Color(0xFF232B36);
  static const Color outline = Color(0xFF3A4452);

  static const Color textPrimary = Color(0xFFE4E8EE);
  static const Color textSecondary = Color(0xFFA3ADBA);

  /// Soft sage accent used for selected states and primary actions.
  static const Color accent = Color(0xFF8DB9A6);
  static const Color onAccent = Color(0xFF0F1A16);
  static const Color accentContainer = Color(0xFF2C3F38);
  static const Color onAccentContainer = Color(0xFFCFE5DA);

  /// Muted lavender, for secondary highlights.
  static const Color secondary = Color(0xFFB4ADD6);
  static const Color onSecondary = Color(0xFF1B1830);

  static const Color error = Color(0xFFE8A39B);
  static const Color onError = Color(0xFF3B1310);
}
