import 'package:flutter/material.dart';

extension AdaptiveContext on BuildContext {
  /// True when the current theme asks for the Cupertino look.
  bool get isCupertino {
    return switch (Theme.of(this).platform) {
      TargetPlatform.iOS || TargetPlatform.macOS => true,
      _ => false,
    };
  }
}
