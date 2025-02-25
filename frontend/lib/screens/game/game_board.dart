import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gogogame_frontend/core/constants/game_constant.dart';
import 'package:gogogame_frontend/core/themes/game_theme.dart';

class GameBoard extends ConsumerWidget {
  final int size; // 9, 13, or 19

  const GameBoard({super.key, required this.size});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final boardTheme = ref.watch(gameThemeProvider);

    return Center(
      child: SizedBox.square(
        dimension: double.infinity,
        child: FittedBox(
          // Ensures board scales down if needed
          child: Container(
            padding: const EdgeInsets.all(GameConstant.cellSize),
            decoration: BoxDecoration(
              color:
                  boardTheme.boardImage == null ? boardTheme.boardColor : null,
              image:
                  boardTheme.boardImage != null
                      ? DecorationImage(
                        image: AssetImage(boardTheme.boardImage!),
                        fit: BoxFit.cover,
                      )
                      : null,
            ),
            child: SizedBox(
              width: (size - 1) * GameConstant.cellSize,
              height: (size - 1) * GameConstant.cellSize,
              child: CustomPaint(painter: GoBoardPainter(size, boardTheme)),
            ),
          ),
        ),
      ),
    );
  }
}

class GoBoardPainter extends CustomPainter {
  final int size;
  final GameTheme theme;
  static const double cellSize = GameConstant.cellSize; // Fixed cell size

  GoBoardPainter(this.size, this.theme);

  @override
  void paint(Canvas canvas, Size boardSize) {
    final paint =
        Paint()
          ..color = theme.lineColor
          ..strokeWidth = 2
          ..style = PaintingStyle.stroke;

    // Draw Grid
    for (int i = 0; i < size; i++) {
      double offset = i * cellSize;
      canvas.drawLine(
        Offset(0, offset),
        Offset((size - 1) * cellSize, offset),
        paint,
      ); // Horizontal
      canvas.drawLine(
        Offset(offset, 0),
        Offset(offset, (size - 1) * cellSize),
        paint,
      ); // Vertical
    }

    final starPaint = Paint()..color = theme.starPointColor;
    List<Offset> starPoints;
    switch (size) {
      case 9:
        starPoints = GameConstant.b9x9StarPoints;
        break;
      case 13:
        starPoints = GameConstant.b13x13StarPoints;
        break;
      case 19:
        starPoints = GameConstant.b19x19StarPoints;
        break;
      default:
        starPoints = [];
    }
    for (var point in starPoints) {
      canvas.drawCircle(
        Offset(point.dx * cellSize, point.dy * cellSize),
        4,
        starPaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
