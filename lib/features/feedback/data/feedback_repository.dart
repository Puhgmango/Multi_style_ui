import 'package:multi_style_ui/core/errors/app_exception.dart';
import 'package:multi_style_ui/features/feedback/domain/user_feedback.dart';

abstract interface class FeedbackRepository {
  /// [simulateFailure] exists only so the demo can show the error path.
  Future<void> submit(UserFeedback feedback, {bool simulateFailure = false});
}

/// Pretends to call a server.
class FakeFeedbackRepository implements FeedbackRepository {
  static const Duration _latency = Duration(seconds: 1);

  @override
  Future<void> submit(
    UserFeedback feedback, {
    bool simulateFailure = false,
  }) async {
    if (feedback.message.trim().isEmpty) {
      throw const ValidationException('Nội dung phản hồi trống.');
    }
    await Future<void>.delayed(_latency);
    if (simulateFailure) {
      throw const NetworkException(
        'Không thể kết nối máy chủ. Vui lòng thử lại.',
      );
    }
  }
}
