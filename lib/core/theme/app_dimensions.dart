/// A static layout token repository defining the application's global spatial scale.
///
/// This class is marked `final` and `abstract` to prevent sub-classing or direct
/// instantiation, establishing a predictable, atomic 8-point layout grid system.
abstract final class AppDimensions {
  // ==========================================
  // Padding & Margin Spacing (8-Point Grid)
  // ==========================================

  /// Extra small spacing accent for tight visual relationships or minimal interior offsets.
  static const double xs = 4.0;

  /// Small layout spacing baseline used for minor layout grouping distributions.
  static const double sm = 8.0;

  /// Medium standard spacing layout token applied across typical component boundaries.
  static const double md = 16.0;

  /// Large separation spacing block for contrasting distinct structural page views.
  static const double lg = 24.0;

  /// Extra large structural separation token separating prominent component contexts.
  static const double xl = 32.0;

  /// Maximum standard scale padding block utilized for expansive layout gutters.
  static const double xxl = 48.0;

  // ==========================================
  // Components Layout
  // ==========================================

  /// Subtle corner smoothing profile for compact items like badges or small input indicators.
  static const double borderRadiusSm = 6.0;

  /// Standard structural corner smoothing profile recommended for cards, dialog frames, and buttons.
  static const double borderRadiusMd = 12.0;

  /// Pronounced corner smoothing profile tailored for large sheets, overlays, or modal layouts.
  static const double borderRadiusLg = 24.0;

  // ==========================================
  // Interactive Boundaries
  // ==========================================

  /// Enforces accessibility compliance to satisfy minimum cross-platform pointer collision dimensions.
  static const double minTouchTarget = 48.0;

  /// Explicit default vertical dimension constraint allocated for navigation app bars.
  static const double appBarHeight = 56.0;
}
