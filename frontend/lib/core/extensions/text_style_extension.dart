import 'package:flutter/material.dart';

extension TextStyleExtension on TextStyle {
  TextStyle withColor(Color color) => copyWith(color: color);
  TextStyle withFontSize(double fontSize) => copyWith(fontSize: fontSize);
  TextStyle withFontWeight(FontWeight fontWeight) =>
      copyWith(fontWeight: fontWeight);
  TextStyle withFontFamily(String fontFamily) =>
      copyWith(fontFamily: fontFamily);
}
