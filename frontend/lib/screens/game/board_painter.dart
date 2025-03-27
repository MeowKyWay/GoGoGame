import 'package:flutter/material.dart';
import 'package:gogogame_frontend/core/constants/game_constant.dart';
import 'package:gogogame_frontend/core/themes/game_theme/board_theme.dart';

class BoardPainter extends CustomPainter {
  final int size;
  final BoardTheme theme;
  static const double cellSize = GameConstant.cellSize; // Fixed cell size

  BoardPainter(this.size, this.theme);

  @override
  void paint(Canvas canvas, Size boardSize) {
    final paint =
        Paint()
          ..color = theme.lineColor
          ..strokeWidth = 2
          ..style = PaintingStyle.stroke;

    // Draw Grid
    for (int i = 0; i <= size; i++) {
      double offset = i * cellSize;
      canvas.drawLine(
        Offset(0, offset),
        Offset((size) * cellSize, offset),
        paint,
      ); // Horizontal
      canvas.drawLine(
        Offset(offset, 0),
        Offset(offset, (size) * cellSize),
        paint,
      ); // Vertical
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
