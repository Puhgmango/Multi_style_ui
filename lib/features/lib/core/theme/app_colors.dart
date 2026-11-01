import 'package:flutter/material.dart';

/// A selectable seed color with a human readable name.
@immutable
class SeedOption {
  const SeedOption({required this.label, required this.color});

  final String label;
  final Color color;
}

/// Brand colors. Full light/dark palettes are generated from a seed
/// (Material 3 tonal palette) so contrast stays consistent.
abstract final class AppColors {
  static const Color defaultSeed = Color(0xFF3F51B5);

  static const List<SeedOption> seedOptions = [
    SeedOption(label: 'Chàm', color: defaultSeed),
    SeedOption(label: 'Xanh lá', color: Color(0xFF2E7D32)),
    SeedOption(label: 'Cam', color: Color(0xFFE65100)),
    SeedOption(label: 'Hồng', color: Color(0xFFC2185B)),
  ];
}
