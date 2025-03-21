import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:gogogame_frontend/core/extensions/color_extension.dart';

class ModalBackground extends StatelessWidget {
  final Widget child;
  final Color? color;
  final ImageFilter? imageFilter;
  final Function()? onTap;

  const ModalBackground({
    super.key,
    required this.child,
    this.color,
    this.imageFilter,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: BackdropFilter(
        filter: imageFilter ?? ImageFilter.blur(sigmaX: 2.5, sigmaY: 2.5),
        enabled: imageFilter != null,
        child: Container(
          color: color ?? Colors.black.withOpa(0.5),
          child: child,
        ),
      ),
    );
  }
}
