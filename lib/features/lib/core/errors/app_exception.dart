/// Base type for every error the app raises on purpose.
sealed class AppException implements Exception {
  const AppException(this.message, {this.cause});

  /// Message that is safe to show to the user.
  final String message;

  /// Original error, kept for logging only.
  final Object? cause;

  @override
  String toString() => '$runtimeType: $message';
}

/// Input did not satisfy a business rule.
final class ValidationException extends AppException {
  const ValidationException(super.message);
}

/// Remote call failed or timed out.
final class NetworkException extends AppException {
  const NetworkException(super.message, {super.cause});
}

/// Local persistence failed.
final class StorageException extends AppException {
  const StorageException(super.message, {super.cause});
}

/// Anything we did not anticipate.
final class UnknownException extends AppException {
  const UnknownException(super.message, {super.cause});
}
