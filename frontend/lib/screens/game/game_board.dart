import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gogogame_frontend/core/constants/game_constant.dart';
import 'package:gogogame_frontend/core/themes/game_theme.dart';
import 'package:gogogame_frontend/screens/game/game_cell.dart';

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
              padding: EdgeInsets.all(padding),
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
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: boardTheme.lineColor),
                ),
                child: SizedBox(
                  width: (size) * cellSize,
                  height: (size) * cellSize,
                  child: Wrap(
                    children: [
                      // Padding(
                      //   padding: const EdgeInsets.all(padding),
                      //   child: SizedBox(
                      //     width: (size) * cellSize,
                      //     height: (size) * GameConstant.cellSize,
                      //     child: CustomPaint(
                      //       painter: BoardPainter(size, boardTheme),
                      //     ),
                      //   ),
                      // ),
                      for (int x = 0; x < size; x++)
                        for (int y = 0; y < size; y++)
                          GameCell(x: x, y: y, onTap: onCellTap),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
