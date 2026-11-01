import 'package:flutter/material.dart';
import 'package:multi_style_ui/core/constants/app_spacing.dart';
import 'package:multi_style_ui/core/utils/contrast.dart';

/// Shows the type scale and checks color contrast against WCAG AA.
class TypographyPreview extends StatelessWidget {
  const TypographyPreview({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final text = theme.textTheme;
    final scheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Phần này chỉ để xem: thử đổi màu, chế độ sáng/tối hoặc cỡ chữ '
          'ở mục 1, chữ và tỷ lệ tương phản bên dưới sẽ cập nhật theo.',
          style: text.bodyMedium?.copyWith(color: scheme.onSurfaceVariant),
        ),
        const SizedBox(height: AppSpacing.md),
        Text('Headline', style: text.headlineMedium),
        Text('Title', style: text.titleLarge),
        Text(
          'Nội dung chính nên có cỡ chữ 14–16 và giãn dòng khoảng 1.5 '
          'để dễ đọc.',
          style: text.bodyLarge,
        ),
        Text('Label', style: text.labelLarge),
        const SizedBox(height: AppSpacing.md),
        _ContrastRow(
          label: 'onSurface / surface',
          foreground: scheme.onSurface,
          background: scheme.surface,
        ),
        const SizedBox(height: AppSpacing.sm),
        _ContrastRow(
          label: 'onPrimary / primary',
          foreground: scheme.onPrimary,
          background: scheme.primary,
        ),
      ],
    );
  }
}

class _ContrastRow extends StatelessWidget {
  const _ContrastRow({
    required this.label,
    required this.foreground,
    required this.background,
  });

  final String label;
  final Color foreground;
  final Color background;

  @override
  Widget build(BuildContext context) {
    final ratio = Contrast.ratio(foreground, background);
    final verdict = ratio >= Contrast.minAa ? 'Đạt AA' : 'Chưa đạt AA';

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(AppSpacing.radius),
        border: Border.all(color: Theme.of(context).colorScheme.outline),
      ),
      child: Text(
        '$label: ${ratio.toStringAsFixed(1)}:1 – $verdict',
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: foreground,
            ),
      ),
    );
  }
}
