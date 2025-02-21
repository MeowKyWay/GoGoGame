import 'package:flutter/material.dart';

final darkColorScheme = ColorScheme(
  brightness: Brightness.dark,

  primary: Color.fromARGB(255, 39, 37, 34), //Appbar Navbar etc
  onPrimary: Colors.white, //Text on Appbar Navbar etc
  secondary: Color.fromARGB(255, 139, 168, 89), //Buttons etc
  onSecondary: Colors.white, //Text on Buttons etc
  tertiary: Color.fromARGB(255, 66, 62, 59), //Textinput fill etc
  onTertiary: Color.fromARGB(255, 140, 139, 137), //Textfield hint color

  outline: Colors.white,

  error: Color.fromARGB(255, 223, 75, 75),
  onError: Colors.white,

  surface: Color.fromARGB(255, 50, 46, 43),
  onSurface: Colors.white,
);

const Color primaryColor = Color.fromARGB(255, 39, 37, 34);
