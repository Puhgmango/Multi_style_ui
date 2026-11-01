import 'package:flutter/material.dart';
import 'package:multi_style_ui/core/constants/app_spacing.dart';
import 'package:multi_style_ui/core/theme/app_colors.dart';
import 'package:multi_style_ui/core/widgets/adaptive_segmented_control.dart';
import 'package:multi_style_ui/core/widgets/status_message.dart';
import 'package:multi_style_ui/features/showcase/domain/app_settings.dart';
import 'package:multi_style_ui/features/showcase/presentation/settings_controller.dart';

/// Controls that change the design system live.
class SettingsPanel extends StatelessWidget {
  const SettingsPanel({required this.controller, super.key});

  final SettingsController controller;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: controller,
      builder: (context, _) {
        final settings = controller.settings;
        final error = controller.lastError;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const _FieldLabel('Phong cách giao diện'),
            AdaptiveSegmentedControl<DesignStyle>(
              semanticLabel: 'Chọn phong cách giao diện',
              options: const {
                DesignStyle.material: 'Material',
                DesignStyle.cupertino: 'Cupertino',
                DesignStyle.adaptive: 'Tự động',
              },
              selected: settings.style,
              onChanged: (value) =>
                  controller.update(settings.copyWith(style: value)),
            ),
            const SizedBox(height: AppSpacing.md),
            const _FieldLabel('Chế độ sáng / tối'),
            AdaptiveSegmentedControl<ThemeMode>(
              semanticLabel: 'Chọn chế độ sáng hoặc tối',
              options: const {
                ThemeMode.light: 'Sáng',
                ThemeMode.dark: 'Tối',
                ThemeMode.system: 'Hệ thống',
              },
              selected: settings.themeMode,
              onChanged: (value) =>
                  controller.update(settings.copyWith(themeMode: value)),
            ),
            const SizedBox(height: AppSpacing.md),
            const _FieldLabel('Màu chủ đạo'),
            _SwatchPicker(
              selected: settings.seedColor,
              onSelected: (color) =>
                  controller.update(settings.copyWith(seedColor: color)),
            ),
            const SizedBox(height: AppSpacing.md),
            _TextScaleSlider(
              value: settings.textScale,
              onChanged: (value) =>
                  controller.update(settings.copyWith(textScale: value)),
            ),
            if (error != null) ...[
              const SizedBox(height: AppSpacing.md),
              StatusMessage(message: error.message, isError: true),
            ],
          ],
        );
      },
    );
  }
}

class _FieldLabel extends StatelessWidget {
  const _FieldLabel(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Text(text, style: Theme.of(context).textTheme.labelLarge),
    );
  }
}

class _SwatchPicker extends StatelessWidget {
  const _SwatchPicker({required this.selected, required this.onSelected});

  final Color selected;
  final ValueChanged<Color> onSelected;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: AppSpacing.sm,
      runSpacing: AppSpacing.sm,
      children: [
        for (final option in AppColors.seedOptions)
          _Swatch(
            option: option,
            isSelected: option.color == selected,
            onTap: () => onSelected(option.color),
          ),
      ],
    );
  }
}

class _Swatch extends StatelessWidget {
  const _Swatch({
    required this.option,
    required this.isSelected,
    required this.onTap,
  });

  final SeedOption option;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final onColor = ThemeData.estimateBrightnessForColor(option.color) ==
            Brightness.dark
        ? Colors.white
        : Colors.black;

    return Semantics(
      button: true,
      selected: isSelected,
      label: 'Màu ${option.label}',
      onTap: onTap,
      excludeSemantics: true,
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: SizedBox.square(
          dimension: AppSpacing.minTapTarget,
          child: Center(
            child: Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: option.color,
                shape: BoxShape.circle,
              ),
              // Check icon: selection is not conveyed by color alone.
              child: isSelected
                  ? Icon(Icons.check, size: 20, color: onColor)
                  : null,
            ),
          ),
        ),
      ),
    );
  }
}

class _TextScaleSlider extends StatefulWidget {
  const _TextScaleSlider({required this.value, required this.onChanged});

  final double value;
  final ValueChanged<double> onChanged;

  @override
  State<_TextScaleSlider> createState() => _TextScaleSliderState();
}

class _TextScaleSliderState extends State<_TextScaleSlider> {
  late double _value = widget.value;

  @override
  void didUpdateWidget(covariant _TextScaleSlider oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value) {
      _value = widget.value;
    }
  }

  @override
  Widget build(BuildContext context) {
    final percent = '${(_value * 100).round()}%';
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _FieldLabel('Cỡ chữ: $percent'),
        Slider.adaptive(
          value: _value,
          min: AppSettings.minTextScale,
          max: AppSettings.maxTextScale,
          divisions: 8,
          label: percent,
          onChanged: (value) => setState(() => _value = value),
          // Persist once when the user lets go, not on every drag tick.
          onChangeEnd: widget.onChanged,
        ),
      ],
    );
  }
}
