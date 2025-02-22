import 'package:flutter/material.dart';

extension ColorExtension on Color {
  Color get dimmed =>
      Color.alphaBlend(Colors.black.withAlpha((0.25 * 255).toInt()), this);

  Color withOpa(double opacity) => withAlpha((opacity * 255).toInt());
}
