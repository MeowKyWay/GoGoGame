import 'package:flutter/material.dart';

final lightColorScheme = ColorScheme(
  brightness: Brightness.light,

  primary: Color(0xFFc7c6c5), //Appbar Navbar etc
  onPrimary: Colors.black, //primary text color
  secondary: Color.fromARGB(255, 139, 168, 89), //Buttons etc
  onSecondary: Color(0xFF8b8987), //secondary text color
  tertiary: Color(0xFFedeceb), //Textinput fill etc
  onTertiary: Color(0xFFb3b2b2), //Textfield hint color

  primaryContainer: Color(0xFFF3F3F3),
  onPrimaryContainer: Colors.black,

  outline: Colors.black,
  outlineVariant: Color(0xFFdad8d6),

  error: Color.fromARGB(255, 223, 75, 75),
  onError: Colors.white,

  surface: Colors.white,
  onSurface: Colors.black,
);

const Color primaryColor = Color.fromARGB(255, 39, 37, 34);
