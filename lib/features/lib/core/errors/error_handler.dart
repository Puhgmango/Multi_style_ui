import 'dart:async';
import 'dart:developer' as developer;

import 'package:flutter/foundation.dart';
import 'package:multi_style_ui/core/errors/app_exception.dart';
import 'package:multi_style_ui/core/errors/result.dart';

/// Central place that turns thrown objects into [Result]s and logs them.
abstract final class ErrorHandler {
  /// Runs [action] and converts any [Exception] into a [Failure].
  ///
  /// [Error]s (programming mistakes such as `StateError`) are intentionally
  /// not caught here; they reach the global handlers below.
  static Future<Result<T>> guard<T>(Future<T> Function() action) async {
    try {
      return Success<T>(await action());
    } on AppException catch (error, stack) {
      _log(error, stack);
      return Failure<T>(error);
    } on TimeoutException catch (error, stack) {
      _log(error, stack);
      return Failure<T>(
        NetworkException('Hết thời gian chờ phản hồi.', cause: error),
      );
    } on Exception catch (error, stack) {
      _log(error, stack);
      return Failure<T>(
        UnknownException('Đã xảy ra lỗi không mong muốn.', cause: error),
      );
    }
  }

  /// Catches framework errors and uncaught async errors.
  static void registerGlobalHandlers() {
    FlutterError.onError = (details) {
      FlutterError.presentError(details);
      _log(details.exception, details.stack ?? StackTrace.empty);
    };
    PlatformDispatcher.instance.onError = (error, stack) {
      _log(error, stack);
      return true;
    };
  }

  static void _log(Object error, StackTrace stack) {
    developer.log(
      'Unhandled or guarded error',
      name: 'multi_style_ui',
      error: error,
      stackTrace: stack,
    );
  }
}
