/// Form validators. Return `null` when valid, otherwise a user message.
abstract final class Validators {
  static final RegExp _emailPattern = RegExp(r'^[\w.+-]+@[\w-]+(\.[\w-]+)+$');

  static String? email(String? value) {
    final text = value?.trim() ?? '';
    if (text.isEmpty) {
      return 'Vui lòng nhập email.';
    }
    if (!_emailPattern.hasMatch(text)) {
      return 'Email không hợp lệ.';
    }
    return null;
  }

  static String? message(String? value, {int minLength = 10}) {
    final text = value?.trim() ?? '';
    if (text.isEmpty) {
      return 'Vui lòng nhập nội dung.';
    }
    if (text.length < minLength) {
      return 'Nội dung cần tối thiểu $minLength ký tự.';
    }
    return null;
  }
}
