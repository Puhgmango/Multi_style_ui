import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:multi_style_ui/core/constants/app_spacing.dart';
import 'package:multi_style_ui/core/widgets/adaptive_context.dart';

/// Primary action button with a built-in loading state.
class AdaptiveButton extends StatelessWidget {
  const AdaptiveButton({
    required this.label,
    required this.onPressed,
    this.isLoading = false,
    super.key,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    // Disabled while loading to prevent double submission.
    final callback = isLoading ? null : onPressed;
    final content = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (isLoading) ...[
          const SizedBox.square(
            dimension: 18,
            child: CircularProgressIndicator.adaptive(strokeWidth: 2),
          ),
          const SizedBox(width: AppSpacing.sm),
        ],
        Text(isLoading ? 'Đang gửi...' : label),
      ],
    );

    if (context.isCupertino) {
      return CupertinoButton.filled(onPressed: callback, child: content);
    }
    return FilledButton(onPressed: callback, child: content);
  }
}
