/// Spacing and radius tokens. Screens use these instead of raw numbers.
abstract final class AppSpacing {
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 16;
  static const double lg = 24;
  static const double xl = 32;
  static const double xxl = 48;

  /// Side margin of top-level screens, as on iOS.
  static const double gutter = 20;

  /// Gap between list cards.
  static const double cardGap = 12;

  static const double radiusSm = 8;
  static const double radiusMd = 16;
  static const double radiusLg = 24;

  /// Fully rounded ends (chips, pills).
  static const double radiusPill = 999;

  /// Blur behind glass surfaces.
  static const double glassBlur = 18;

  /// Minimum size of anything tappable (Material / WCAG guidance).
  static const double minTouchTarget = 48;
}
