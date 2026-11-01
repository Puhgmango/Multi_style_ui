import 'package:multi_style_ui/features/showcase/domain/app_settings.dart';

abstract interface class SettingsRepository {
  Future<AppSettings> load();

  Future<void> save(AppSettings settings);
}

/// Memory-only implementation. Swap for shared_preferences/Hive later
/// without touching the controller.
class InMemorySettingsRepository implements SettingsRepository {
  static const Duration _latency = Duration(milliseconds: 150);

  AppSettings _stored = const AppSettings();

  @override
  Future<AppSettings> load() async {
    await Future<void>.delayed(_latency);
    return _stored;
  }

  @override
  Future<void> save(AppSettings settings) async {
    await Future<void>.delayed(_latency);
    _stored = settings;
  }
}
