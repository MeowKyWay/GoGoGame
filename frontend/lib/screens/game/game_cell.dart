import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gogogame_frontend/core/constants/game_constant.dart';
import 'package:gogogame_frontend/core/services/config_service.dart';
import 'package:gogogame_frontend/core/types/game_type.dart';
import 'package:gogogame_frontend/screens/game/animated_disk.dart';
import 'package:gogogame_frontend/screens/game/hint_disk.dart';
import 'package:tuple/tuple.dart';

class GameCell extends ConsumerStatefulWidget {
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
  ConsumerState<GameCell> createState() => _GameCellState();
}

class _GameCellState extends ConsumerState<GameCell> {
  @override
  void didUpdateWidget(GameCell oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    final config = ref.watch(configService);
    final theme = config.gameTheme;

    Widget child;

    if (widget.disk.isDiskColor) {
      final int distance =
          widget.lastMove != null
              ? max(
                (widget.lastMove!.item1 - widget.x).abs(),
                (widget.lastMove!.item2 - widget.y).abs(),
              )
              : 0;
      final double delay = distance * 0.1; // Adjust timing for ripple effect

      child = AnimatedDisk(color: widget.disk.toDiskColor(), delay: delay);
    } else if (widget.userColor != null) {
      child = HintDisk(
        color: widget.userColor!,
        shouldShow: widget.isVaildMove,
      );
    } else {
      child = Container();
    }

    return GestureDetector(
      onTap: () => widget.onTap(widget.x, widget.y),
      child: Container(
        width: GameConstant.cellSize,
        height: GameConstant.cellSize,
        decoration: BoxDecoration(
          border: Border.all(color: theme.lineColor),
          color:
              widget.x % 2 == widget.y % 2
                  ? theme.boardColor.item1
                  : theme.boardColor.item2,
        ),
        child: child,
      ),
    );
  }
}
