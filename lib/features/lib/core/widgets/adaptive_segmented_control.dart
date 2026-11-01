import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:multi_style_ui/core/constants/app_spacing.dart';
import 'package:multi_style_ui/core/widgets/adaptive_context.dart';

/// Single-choice selector: `SegmentedButton` or
/// `CupertinoSlidingSegmentedControl`.
class AdaptiveSegmentedControl<T extends Object> extends StatelessWidget {
  const AdaptiveSegmentedControl({
    required this.options,
    required this.selected,
    required this.onChanged,
    required this.semanticLabel,
    super.key,
  });

  final Map<T, String> options;
  final T selected;
  final ValueChanged<T> onChanged;
  final String semanticLabel;

  @override
  Widget build(BuildContext context) {
    final Widget control;
    if (context.isCupertino) {
      control = CupertinoSlidingSegmentedControl<T>(
        groupValue: selected,
        children: {
          for (final entry in options.entries)
            entry.key: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.sm,
                vertical: AppSpacing.sm,
              ),
              child: Text(entry.value),
            ),
        },
        onValueChanged: (value) {
          if (value != null) {
            onChanged(value);
          }
        },
      );
    } else {
      control = SegmentedButton<T>(
        showSelectedIcon: false,
        segments: [
          for (final entry in options.entries)
            ButtonSegment<T>(value: entry.key, label: Text(entry.value)),
        ],
        selected: {selected},
        onSelectionChanged: (values) => onChanged(values.first),
      );
    }
    return Semantics(label: semanticLabel, container: true, child: control);
  }
}
