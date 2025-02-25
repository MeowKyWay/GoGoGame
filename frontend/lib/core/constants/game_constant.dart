import 'package:flutter/widgets.dart';

class GameConstant {
  static const double cellSize = 40;

  static const double stoneSize = 0.9 * cellSize;

  static const List<Offset> b9x9StarPoints = [
    Offset(2, 2),
    Offset(6, 2),
    Offset(2, 6),
    Offset(6, 6),
  ];

  static const List<Offset> b13x13StarPoints = [
    Offset(3, 3),
    Offset(9, 3),
    Offset(3, 9),
    Offset(9, 9),
  ];

  static const List<Offset> b19x19StarPoints = [
    Offset(3, 3),
    Offset(9, 3),
    Offset(15, 3),
    Offset(3, 9),
    Offset(9, 9),
    Offset(15, 9),
    Offset(3, 15),
    Offset(9, 15),
    Offset(15, 15),
  ];
}
