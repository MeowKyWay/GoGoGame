import 'package:flutter/animation.dart';

extension OffsetExtension on Offset {
  Offset get ceil {
    return Offset(dx.ceilToDouble(), dy.ceilToDouble());
  }
}
