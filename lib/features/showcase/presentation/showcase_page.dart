import 'package:flutter/material.dart';
import 'package:multi_style_ui/core/constants/app_spacing.dart';
import 'package:multi_style_ui/core/widgets/adaptive_scaffold.dart';
import 'package:multi_style_ui/features/feedback/data/feedback_repository.dart';
import 'package:multi_style_ui/features/feedback/presentation/feedback_form.dart';
import 'package:multi_style_ui/features/showcase/presentation/settings_controller.dart';
import 'package:multi_style_ui/features/showcase/presentation/widgets/settings_panel.dart';
import 'package:multi_style_ui/features/showcase/presentation/widgets/typography_preview.dart';

class ShowcasePage extends StatelessWidget {
  const ShowcasePage({
    required this.settingsController,
    required this.feedbackRepository,
    super.key,
  });

  final SettingsController settingsController;
  final FeedbackRepository feedbackRepository;

  @override
  Widget build(BuildContext context) {
    return AdaptiveScaffold(
      title: 'Giao diện đa phong cách',
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.md),
        children: [
          _Section(
            title: '1. Hệ thống thiết kế',
            child: SettingsPanel(controller: settingsController),
          ),
          const _Section(
            title: '2. Typography & độ tương phản',
            child: TypographyPreview(),
          ),
          _Section(
            title: '3. Phản hồi tương tác & xử lý lỗi',
            child: FeedbackForm(repository: feedbackRepository),
          ),
        ],
      ),
    );
  }
}

class _Section extends StatelessWidget {
  const _Section({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Semantics(
              header: true,
              child: Text(title, style: Theme.of(context).textTheme.titleLarge),
            ),
            const SizedBox(height: AppSpacing.md),
            child,
          ],
        ),
      ),
    );
  }
}
