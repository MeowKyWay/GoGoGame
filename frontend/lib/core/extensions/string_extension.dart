extension StringExtension on String {
  /// Check if the string is a valid email
  bool isEmail() {
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    return emailRegex.hasMatch(this);
  }

  /// Check if the string is longer than the given length
  bool isLenght(int length, [int? maxLength]) {
    if (maxLength != null) {
      return this.length >= length && this.length <= maxLength;
    }
    return this.length >= length;
  }
}
