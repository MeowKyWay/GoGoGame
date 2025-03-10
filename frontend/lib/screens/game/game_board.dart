import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gogogame_frontend/core/constants/game_constant.dart';
import 'package:gogogame_frontend/core/themes/game_theme.dart';

class GameBoard extends ConsumerWidget {
  final int size = 8;
  final Function(int, int) onCellTap;

  const GameBoard({super.key, required this.onCellTap});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final boardTheme = ref.watch(gameThemeProvider);

    const cellSize = GameConstant.cellSize;
    const padding = cellSize / 2;

    return Center(
      child: SizedBox.square(
        dimension: double.infinity,
        child: FittedBox(
          // Ensures board scales down if needed
          child: InteractiveViewer(
            child: Container(
              decoration: BoxDecoration(
                color:
                    boardTheme.boardImage == null
                        ? boardTheme.boardColor
                        : null,
                image:
                    boardTheme.boardImage != null
                        ? DecorationImage(
                          image: AssetImage(boardTheme.boardImage!),
                          fit: BoxFit.cover,
                        )
                        : null,
              ),
              child: Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(padding),
                    child: SizedBox(
                      width: (size - 1) * cellSize,
                      height: (size - 1) * GameConstant.cellSize,
                      child: CustomPaint(
                        painter: GoBoardPainter(size, boardTheme),
                      ),
                    ),
                  ),
                  Positioned.fill(
                    child: GestureDetector(
                      onTapUp: (details) {
                        final localPos = details.localPosition;
                        int x = ((localPos.dx - padding) / cellSize).round();
                        int y = ((localPos.dy - padding) / cellSize).round();
                        onCellTap(x, y);
                      },
                      child: Container(color: Colors.transparent),
                    ),
                  ),
                ],
              ),
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
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
