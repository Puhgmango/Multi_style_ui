import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:multi_style_ui/core/constants/app_spacing.dart';
import 'package:multi_style_ui/core/widgets/adaptive_context.dart';

/// Inline success/error message. Uses icon + text (never color alone) and
/// a live region so screen readers announce it when it appears.
class StatusMessage extends StatelessWidget {
  const StatusMessage({
    required this.message,
    required this.isError,
    super.key,
  });

  final String message;
  final bool isError;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = isError ? theme.colorScheme.error : theme.colorScheme.primary;
    final icon = context.isCupertino
        ? (isError
            ? CupertinoIcons.exclamationmark_circle
            : CupertinoIcons.check_mark_circled)
        : (isError ? Icons.error_outline : Icons.check_circle_outline);

    return Semantics(
      liveRegion: true,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(
              message,
              style: theme.textTheme.bodyMedium?.copyWith(color: color),
            ),
          ),
        ],
      ),
    );
  }
}
