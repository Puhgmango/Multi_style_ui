import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:multi_style_ui/core/constants/app_spacing.dart';
import 'package:multi_style_ui/core/errors/error_handler.dart';
import 'package:multi_style_ui/core/errors/result.dart';
import 'package:multi_style_ui/core/utils/validators.dart';
import 'package:multi_style_ui/core/widgets/adaptive_button.dart';
import 'package:multi_style_ui/core/widgets/adaptive_context.dart';
import 'package:multi_style_ui/core/widgets/status_message.dart';
import 'package:multi_style_ui/features/feedback/data/feedback_repository.dart';
import 'package:multi_style_ui/features/feedback/domain/user_feedback.dart';

typedef _Status = ({String message, bool isError});

/// Form with validation, loading state and success/error feedback.
class FeedbackForm extends StatefulWidget {
  const FeedbackForm({required this.repository, super.key});

  final FeedbackRepository repository;

  @override
  State<FeedbackForm> createState() => _FeedbackFormState();
}

class _FeedbackFormState extends State<FeedbackForm> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _messageController = TextEditingController();

  bool _simulateFailure = false;
  bool _isSubmitting = false;
  _Status? _status;

  @override
  void dispose() {
    _emailController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final form = _formKey.currentState;
    if (form == null || !form.validate()) {
      setState(() {
        _status = (
          message: 'Vui lòng sửa các trường báo lỗi.',
          isError: true,
        );
      });
      return;
    }

    FocusScope.of(context).unfocus();
    setState(() {
      _isSubmitting = true;
      _status = null;
    });

    final feedback = UserFeedback(
      email: _emailController.text.trim(),
      message: _messageController.text.trim(),
    );
    final result = await ErrorHandler.guard(
      () => widget.repository.submit(
        feedback,
        simulateFailure: _simulateFailure,
      ),
    );
    if (!mounted) {
      return;
    }

    setState(() {
      _isSubmitting = false;
      _status = switch (result) {
        Success() => (message: 'Đã gửi phản hồi. Cảm ơn bạn!', isError: false),
        Failure(:final exception) => (
            message: exception.message,
            isError: true,
          ),
      };
    });
    if (result is Success<void>) {
      form.reset();
    }
  }

  @override
  Widget build(BuildContext context) {
    final status = _status;

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _AdaptiveTextField(
            label: 'Email',
            controller: _emailController,
            validator: Validators.email,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            autofillHints: const [AutofillHints.email],
          ),
          const SizedBox(height: AppSpacing.md),
          _AdaptiveTextField(
            label: 'Nội dung',
            controller: _messageController,
            validator: Validators.message,
            keyboardType: TextInputType.multiline,
            minLines: 3,
            maxLines: 5,
          ),
          const SizedBox(height: AppSpacing.md),
          MergeSemantics(
            child: Row(
              children: [
                const Expanded(child: Text('Mô phỏng lỗi mạng')),
                Switch.adaptive(
                  value: _simulateFailure,
                  onChanged: _isSubmitting
                      ? null
                      : (value) => setState(() => _simulateFailure = value),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          AdaptiveButton(
            label: 'Gửi phản hồi',
            onPressed: _submit,
            isLoading: _isSubmitting,
          ),
          if (status != null) ...[
            const SizedBox(height: AppSpacing.md),
            StatusMessage(message: status.message, isError: status.isError),
          ],
        ],
      ),
    );
  }
}

class _AdaptiveTextField extends StatelessWidget {
  const _AdaptiveTextField({
    required this.label,
    required this.controller,
    required this.validator,
    required this.keyboardType,
    this.textInputAction,
    this.autofillHints,
    this.minLines,
    this.maxLines = 1,
  });

  final String label;
  final TextEditingController controller;
  final FormFieldValidator<String> validator;
  final TextInputType keyboardType;
  final TextInputAction? textInputAction;
  final Iterable<String>? autofillHints;
  final int? minLines;
  final int? maxLines;

  @override
  Widget build(BuildContext context) {
    if (context.isCupertino) {
      final theme = Theme.of(context);
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Label above the field: a side prefix breaks on multi-line input.
          Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.xs),
            child: Text(label, style: theme.textTheme.labelLarge),
          ),
          DecoratedBox(
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(AppSpacing.radius),
            ),
            child: CupertinoTextFormFieldRow(
              controller: controller,
              placeholder: label,
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.md,
                vertical: AppSpacing.sm,
              ),
              validator: validator,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              keyboardType: keyboardType,
              textInputAction: textInputAction,
              autofillHints: autofillHints,
              minLines: minLines,
              maxLines: maxLines,
            ),
          ),
        ],
      );
    }
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(labelText: label),
      validator: validator,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      autofillHints: autofillHints,
      minLines: minLines,
      maxLines: maxLines,
    );
  }
}
