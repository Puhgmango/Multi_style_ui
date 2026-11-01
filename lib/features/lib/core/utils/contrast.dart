import 'dart:math' as math;
import 'dart:ui';

/// WCAG 2.x contrast helpers.
abstract final class Contrast {
  /// Minimum ratio for normal text at level AA.
  static const double minAa = 4.5;

  static double ratio(Color a, Color b) {
    final la = a.computeLuminance();
    final lb = b.computeLuminance();
    final lighter = math.max(la, lb);
    final darker = math.min(la, lb);
    return (lighter + 0.05) / (darker + 0.05);
  }
}
