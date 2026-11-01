import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:multi_style_ui/core/constants/app_spacing.dart';
import 'package:multi_style_ui/core/theme/app_typography.dart';

/// Builds the Material theme and the matching Cupertino theme from the
/// same [ColorScheme], so both styles share one visual identity.
abstract final class AppTheme {
  static ThemeData build({
    required Color seedColor,
    required Brightness brightness,
    required bool useCupertino,
  }) {
    final scheme = ColorScheme.fromSeed(
      seedColor: seedColor,
      brightness: brightness,
    );
    final base = ThemeData(useMaterial3: true, colorScheme: scheme);
    final shape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(AppSpacing.radius),
    );

    return base.copyWith(
      // Drives Switch.adaptive, Slider.adaptive, scroll physics, transitions.
      platform: useCupertino ? TargetPlatform.iOS : TargetPlatform.android,
      textTheme: AppTypography.textTheme(base.textTheme),
      appBarTheme: AppBarTheme(
        centerTitle: useCupertino,
        backgroundColor: scheme.surface,
        foregroundColor: scheme.onSurface,
        scrolledUnderElevation: 1,
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radius),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: const Size(
            AppSpacing.minTapTarget,
            AppSpacing.minTapTarget,
          ),
          shape: shape,
        ),
      ),
      cupertinoOverrideTheme: CupertinoThemeData(
        brightness: brightness,
        primaryColor: scheme.primary,
        scaffoldBackgroundColor: scheme.surface,
        barBackgroundColor: scheme.surfaceContainer,
      ),
    );
  }
}
