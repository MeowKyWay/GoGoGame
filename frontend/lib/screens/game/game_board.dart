import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gogogame_frontend/core/constants/game_constant.dart';
import 'package:gogogame_frontend/core/services/config_service.dart';
import 'package:gogogame_frontend/core/types/game_type.dart';
import 'package:gogogame_frontend/core/types/match_type.dart';
import 'package:gogogame_frontend/screens/game/game_cell.dart';
import 'package:tuple/tuple.dart';

class GameBoard extends ConsumerWidget {
  final int size = 8;
  final Function(int, int) onCellTap;

  final MatchType? match;

  const GameBoard({super.key, required this.onCellTap, required this.match});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final config = ref.watch(configService);
    final gameTheme = config.gameTheme;

    const cellSize = GameConstant.cellSize;
    const padding = 0.0;

    final validMoves = match?.getValidMoves() ?? [];

    return LayoutBuilder(
      builder: (context, constraints) {
        return Center(
          child: SizedBox.square(
            dimension: constraints.maxWidth,
            child: FittedBox(
              // Ensures board scales down if needed
              child: Container(
                padding: EdgeInsets.all(padding),
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: gameTheme.boardTheme.lineColor),
                  ),
                  child: SizedBox(
                    width: (size) * cellSize,
                    height: (size) * cellSize,
                    child: Wrap(
                      children: [
                        for (int x = 0; x < size; x++)
                          for (int y = 0; y < size; y++)
                            GameCell(
                              x: x,
                              y: y,
                              onTap: onCellTap,
                              disk: match?.board[x][y] ?? CellDisk.empty,
                              userColor: match?.color,
                              lastMove: match?.lastMove,
                              isVaildMove:
                                  validMoves.contains(Tuple2(x, y)) &&
                                  match?.turn == match?.color &&
                                  match?.isOver == false,
                            ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
