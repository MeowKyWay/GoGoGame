extension StringExtension on String {
  /// Check if the string is a valid email
  bool isEmail() {
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    return emailRegex.hasMatch(this);
  }

  bool isUsername() {
    final usernameRegex = RegExp(r'^[a-zA-Z0-9_]{3,20}$');
    return usernameRegex.hasMatch(this);
  }

  /// Check if the string is longer than the given length
  bool isLenght({int? minLength, int? maxLength}) {
    if (minLength != null && length < minLength) {
      return false;
    }
    if (maxLength != null && length > maxLength) {
      return false;
    }
    return true;
  }
}
