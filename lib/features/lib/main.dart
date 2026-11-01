import 'dart:async';

import 'package:flutter/material.dart';
import 'package:multi_style_ui/app/app.dart';
import 'package:multi_style_ui/core/errors/error_handler.dart';
import 'package:multi_style_ui/features/feedback/data/feedback_repository.dart';
import 'package:multi_style_ui/features/showcase/data/settings_repository.dart';
import 'package:multi_style_ui/features/showcase/presentation/settings_controller.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  ErrorHandler.registerGlobalHandlers();

  // Manual dependency injection: easy to read and to replace in tests.
  final settingsController = SettingsController(InMemorySettingsRepository());
  final feedbackRepository = FakeFeedbackRepository();

  runApp(
    App(
      settingsController: settingsController,
      feedbackRepository: feedbackRepository,
    ),
  );
  unawaited(settingsController.load());
}
