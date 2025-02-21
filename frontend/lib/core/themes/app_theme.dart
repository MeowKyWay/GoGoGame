import 'package:flutter/material.dart';
import 'package:gogogame_frontend/core/themes/dark_color_scheme.dart';

class AppTheme {
  static ThemeData get darkTheme {
    return getTheme(colorScheme: darkColorScheme);
  }

  static ThemeData getTheme({required ColorScheme colorScheme}) {
    return ThemeData(
      brightness: colorScheme.brightness,
      primaryColor: colorScheme.primary,
      scaffoldBackgroundColor: colorScheme.surface,
      appBarTheme: AppBarTheme(
        backgroundColor: colorScheme.primary,
        titleTextStyle: TextStyle(
          color: colorScheme.onPrimary,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
        actionsIconTheme: IconThemeData(color: colorScheme.onPrimary, size: 20),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: colorScheme.primary,
        selectedItemColor: colorScheme.secondary,
        unselectedItemColor: colorScheme.onPrimary,
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.all(colorScheme.secondary),
          shape: WidgetStateProperty.all(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
          foregroundColor: WidgetStateProperty.all(colorScheme.onSecondary),
        ),
      ),
    );
  }
}
