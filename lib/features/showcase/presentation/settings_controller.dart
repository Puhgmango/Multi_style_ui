import 'package:flutter/foundation.dart';
import 'package:multi_style_ui/core/errors/app_exception.dart';
import 'package:multi_style_ui/core/errors/error_handler.dart';
import 'package:multi_style_ui/core/errors/result.dart';
import 'package:multi_style_ui/features/showcase/data/settings_repository.dart';
import 'package:multi_style_ui/features/showcase/domain/app_settings.dart';

/// Holds [AppSettings]; applies changes optimistically and rolls back when
/// persisting fails.
class SettingsController extends ChangeNotifier {
  SettingsController(this._repository);

  final SettingsRepository _repository;

  AppSettings _settings = const AppSettings();
  AppException? _lastError;

  AppSettings get settings => _settings;

  AppException? get lastError => _lastError;

  Future<void> load() async {
    final result = await ErrorHandler.guard(_repository.load);
    switch (result) {
      case Success(:final value):
        _settings = value;
      case Failure(:final exception):
        _lastError = exception;
    }
    notifyListeners();
  }

  Future<void> update(AppSettings next) async {
    final previous = _settings;
    _settings = next;
    _lastError = null;
    notifyListeners();

    final result = await ErrorHandler.guard(() => _repository.save(next));
    if (result case Failure(:final exception)) {
      _settings = previous;
      _lastError = exception;
    }
    notifyListeners();
  }
}
