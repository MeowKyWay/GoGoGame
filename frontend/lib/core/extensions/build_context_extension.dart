import 'package:flutter/material.dart';

extension BuildContextExtension on BuildContext {
  ThemeData get theme => Theme.of(this);
  TextTheme get textTheme => theme.textTheme;
  ColorScheme get colorScheme => theme.colorScheme;

  void push(Widget page) {
    Navigator.of(this).push(MaterialPageRoute(builder: (_) => page));
  }
}
