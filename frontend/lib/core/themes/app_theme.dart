import 'package:flutter/material.dart';
import 'package:gogogame_frontend/core/extensions/color_extension.dart';
import 'package:gogogame_frontend/core/themes/dark_color_scheme.dart';
import 'package:gogogame_frontend/core/themes/light_color_scheme.dart';

class AppTheme {
  static ThemeData get darkTheme {
    return getTheme(colorScheme: darkColorScheme);
  }

  static ThemeData get lightTheme {
    return getTheme(colorScheme: lightColorScheme);
  }

  static ThemeData getTheme({required ColorScheme colorScheme}) {
    return ThemeData(
      brightness: colorScheme.brightness,
      primaryColor: colorScheme.primary,
      textSelectionTheme: TextSelectionThemeData(
        cursorColor: Colors.white,
        selectionColor: Colors.white30,
      ),
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
          backgroundColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.disabled)) {
              return colorScheme.secondary.dimmed;
            }
            return colorScheme.secondary;
          }),
          shape: WidgetStateProperty.all(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
          foregroundColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.disabled)) {
              return colorScheme.onPrimary.dimmed;
            }
            return colorScheme.onPrimary;
          }),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: ButtonStyle(
          textStyle: WidgetStateProperty.all(textTheme.labelSmall),
          foregroundColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.disabled)) {
              return colorScheme.onPrimary.dimmed;
            }
            return colorScheme.onPrimary;
          }),
          backgroundColor: WidgetStateProperty.all(Colors.transparent),
          splashFactory: NoSplash.splashFactory,
          overlayColor: WidgetStateProperty.all(Colors.transparent),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: colorScheme.tertiary,
        hoverColor: Colors.transparent,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: colorScheme.outline),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: colorScheme.error),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: colorScheme.error),
        ),
        hintStyle: TextStyle(color: colorScheme.onTertiary),
        prefixIconColor: colorScheme.onTertiary,
      ),
      colorScheme: colorScheme,
      textTheme: textTheme,
    );
  }

  static TextTheme textTheme = TextTheme(
    headlineLarge: TextStyle(fontSize: 24, fontWeight: FontWeight.w700),

    labelLarge: TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
    labelMedium: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
    labelSmall: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),

    bodyLarge: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
    bodyMedium: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
    bodySmall: TextStyle(fontSize: 12, fontWeight: FontWeight.w400),
  );
}
