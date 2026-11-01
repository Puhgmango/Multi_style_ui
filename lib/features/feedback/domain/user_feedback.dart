import 'package:flutter/foundation.dart';

@immutable
class UserFeedback {
  const UserFeedback({required this.email, required this.message});

  final String email;
  final String message;
}
