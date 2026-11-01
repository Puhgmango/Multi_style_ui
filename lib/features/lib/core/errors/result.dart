import 'package:multi_style_ui/core/errors/app_exception.dart';

/// Outcome of an operation that can fail without throwing to the UI.
sealed class Result<T> {
  const Result();
}

final class Success<T> extends Result<T> {
  const Success(this.value);

  final T value;
}

final class Failure<T> extends Result<T> {
  const Failure(this.exception);

  final AppException exception;
}
