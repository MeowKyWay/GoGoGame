import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gogogame_frontend/core/constants/game_constant.dart';
import 'package:gogogame_frontend/core/themes/game_theme.dart';
import 'package:gogogame_frontend/core/types/game_type.dart';
import 'package:gogogame_frontend/screens/game/animated_disk.dart';
import 'package:gogogame_frontend/screens/game/hint_disk.dart';
import 'package:tuple/tuple.dart';

class GameCell extends ConsumerWidget {
  final int x;
  final int y;
  final Function(int, int) onTap;
  final CellDisk disk;
  final DiskColor? userColor;
  final Tuple2<int, int>? lastMove;
  final bool isVaildMove;

  const GameCell({
    super.key,
    required this.x,
    required this.y,
    required this.onTap,
    required this.disk,
    required this.userColor,
    this.lastMove,
    this.isVaildMove = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ref.watch(gameTheme);

    Widget child;

    if (disk.isDiskColor) {
      final int distance =
          lastMove != null
              ? (lastMove!.item1 - x).abs() + (lastMove!.item2 - y).abs()
              : 0;
      final double delay = distance * 0.1; // Adjust timing for ripple effect

      child = AnimatedDisk(color: disk.toDiskColor(), delay: delay);
    } else if (userColor != null) {
      child = HintDisk(color: userColor!, shouldShow: isVaildMove);
    } else {
      child = Container();
    }

    return GestureDetector(
      onTap: () => onTap(x, y),
      child: Container(
        width: GameConstant.cellSize,
        height: GameConstant.cellSize,
        decoration: BoxDecoration(border: Border.all(color: theme.lineColor)),
        child: child,
      ),
    );
  }
}
