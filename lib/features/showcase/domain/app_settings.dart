import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:multi_style_ui/core/theme/app_colors.dart';

enum DesignStyle { material, cupertino, adaptive }

/// Immutable user preferences that drive the design system.
@immutable
class AppSettings {
  const AppSettings({
    this.style = DesignStyle.adaptive,
    this.themeMode = ThemeMode.system,
    this.seedColor = AppColors.defaultSeed,
    this.textScale = 1.0,
  });

  static const double minTextScale = 0.8;
  static const double maxTextScale = 1.6;

  final DesignStyle style;
  final ThemeMode themeMode;
  final Color seedColor;
  final double textScale;

  /// `adaptive` follows the host platform.
  bool get usesCupertino {
    return switch (style) {
      DesignStyle.material => false,
      DesignStyle.cupertino => true,
      DesignStyle.adaptive => defaultTargetPlatform == TargetPlatform.iOS ||
          defaultTargetPlatform == TargetPlatform.macOS,
    };
  }

  AppSettings copyWith({
    DesignStyle? style,
    ThemeMode? themeMode,
    Color? seedColor,
    double? textScale,
  }) {
    return AppSettings(
      style: style ?? this.style,
      themeMode: themeMode ?? this.themeMode,
      seedColor: seedColor ?? this.seedColor,
      textScale: textScale ?? this.textScale,
    );
  }
}
