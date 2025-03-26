import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gogogame_frontend/core/constants/game_constant.dart';
import 'package:gogogame_frontend/core/services/game/game_sound_effect_service.dart';
import 'package:gogogame_frontend/core/themes/game_theme.dart';
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

    if (oldWidget.disk != widget.disk && widget.disk.isDiskColor) {
      final int distance =
          widget.lastMove != null
              ? max(
                (widget.lastMove!.item1 - widget.x).abs(),
                (widget.lastMove!.item2 - widget.y).abs(),
              )
              : 0;
      double delay = distance * 0.1; // Adjust timing for ripple effect

      if (delay != 0) {
        delay = delay + 0.15;
      }

      Future.delayed(Duration(milliseconds: (delay * 1000).toInt()), () {
        ref.read(gameSoundEffectService).playDiskSound();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = ref.watch(gameTheme);

    Widget child;

    if (widget.disk.isDiskColor) {
      final int distance =
          widget.lastMove != null
              ? (widget.lastMove!.item1 - widget.x).abs() +
                  (widget.lastMove!.item2 - widget.y).abs()
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
        decoration: BoxDecoration(border: Border.all(color: theme.lineColor)),
        child: child,
      ),
    );
  }
}
