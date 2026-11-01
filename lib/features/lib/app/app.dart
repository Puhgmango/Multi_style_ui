import 'package:flutter/material.dart';
import 'package:multi_style_ui/core/theme/app_theme.dart';
import 'package:multi_style_ui/features/feedback/data/feedback_repository.dart';
import 'package:multi_style_ui/features/showcase/presentation/settings_controller.dart';
import 'package:multi_style_ui/features/showcase/presentation/showcase_page.dart';

class App extends StatelessWidget {
  const App({
    required this.settingsController,
    required this.feedbackRepository,
    super.key,
  });

  final SettingsController settingsController;
  final FeedbackRepository feedbackRepository;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: settingsController,
      builder: (context, _) {
        final settings = settingsController.settings;
        final useCupertino = settings.usesCupertino;

        return MaterialApp(
          title: 'Multi-style UI',
          debugShowCheckedModeBanner: false,
          themeMode: settings.themeMode,
          theme: AppTheme.build(
            seedColor: settings.seedColor,
            brightness: Brightness.light,
            useCupertino: useCupertino,
          ),
          darkTheme: AppTheme.build(
            seedColor: settings.seedColor,
            brightness: Brightness.dark,
            useCupertino: useCupertino,
          ),
          builder: (context, child) {
            // Respect the OS text size and multiply by the in-app setting.
            final mediaQuery = MediaQuery.of(context);
            final scale = mediaQuery.textScaler.scale(1) * settings.textScale;
            return MediaQuery(
              data: mediaQuery.copyWith(
                textScaler: TextScaler.linear(scale.clamp(0.8, 2.0)),
              ),
              child: child ?? const SizedBox.shrink(),
            );
          },
          home: ShowcasePage(
            settingsController: settingsController,
            feedbackRepository: feedbackRepository,
          ),
        );
      },
    );
  }
}
