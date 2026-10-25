import 'package:flutter/material.dart';

/// Calm night palette: deep blue fading into dark violet.
///
/// Every text colour is checked against [background], [surface] and the
/// lightest point of the glass surfaces for WCAG AA contrast (4.5:1) in
/// `test/core/theme/app_colors_test.dart`.
abstract final class AppColors {
  static const Color background = Color(0xFF10142A);
  static const Color surface = Color(0xFF1A1D36);
  static const Color surfaceHigh = Color(0xFF252946);
  static const Color outline = Color(0xFF3A3F5E);

  /// Stops of the screen background gradient, top to bottom.
  static const Color backgroundTop = Color(0xFF0C1227);
  static const Color backgroundMid = Color(0xFF12152F);
  static const Color backgroundBottom = Color(0xFF1C1534);

  /// Soft light pools drawn over the background gradient. They also give the
  /// frosted cards something to blur.
  static const Color glowViolet = Color(0x2E7B5CE6);
  static const Color glowBlue = Color(0x242F5FD6);

  /// Translucent "glass" surfaces, drawn over the background gradient.
  static const Color glassFillTop = Color(0x1AFFFFFF);
  static const Color glassFillBottom = Color(0x0AFFFFFF);
  static const Color glassBorder = Color(0x1FFFFFFF);

  /// Worst case behind text on glass: the brightest glow under the most
  /// opaque glass fill. Only used to check contrast.
  static final Color glassOverGlow = Color.alphaBlend(
    glassFillTop,
    Color.alphaBlend(glowViolet, backgroundBottom),
  );

  static const Color textPrimary = Color(0xFFE6E8F2);
  static const Color textSecondary = Color(0xFFA6ACC4);

  /// Pastel lavender for small details on glass (length, category, icons).
  static const Color textPastel = Color(0xFFC9CBEA);

  /// Soft sage accent used for primary actions.
  static const Color accent = Color(0xFF8DB9A6);
  static const Color onAccent = Color(0xFF0F1A16);
  static const Color accentContainer = Color(0xFF2C3F38);
  static const Color onAccentContainer = Color(0xFFCFE5DA);

  /// Muted lavender, for secondary highlights.
  static const Color secondary = Color(0xFFB4ADD6);
  static const Color onSecondary = Color(0xFF1B1830);

  /// Selected filter chip: violet pill with a soft glow around it.
  static const Color chipSelected = Color(0xFF5A47C2);
  static const Color onChipSelected = Color(0xFFFFFFFF);
  static const Color chipGlow = Color(0x738A6CFF);
  static const Color chipIdleFill = Color(0x0FFFFFFF);
  static const Color chipIdleBorder = Color(0x14FFFFFF);

  /// Selected tab pill in the navigation bar.
  static const Color navIndicator = Color(0xFF332C66);

  /// Thin gold for premium marks.
  static const Color gold = Color(0xFFE9C985);
  static const Color goldHighlight = Color(0xFFFFF4D6);

  static const Color error = Color(0xFFE8A39B);
  static const Color onError = Color(0xFF3B1310);

  /// Placeholder cover gradients for content without artwork. Decorative
  /// only; text is never drawn on them.
  static const List<List<Color>> coverGradients = [
    [Color(0xFF3D3576), Color(0xFF1A1D36)],
    [Color(0xFF26446E), Color(0xFF151A33)],
    [Color(0xFF4B3067), Color(0xFF1A1533)],
    [Color(0xFF2B4B5C), Color(0xFF141A30)],
  ];
}
