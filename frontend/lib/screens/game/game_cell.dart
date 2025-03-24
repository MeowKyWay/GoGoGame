import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gogogame_frontend/core/constants/game_constant.dart';
import 'package:gogogame_frontend/core/themes/game_theme.dart';
import 'package:gogogame_frontend/core/types/game_type.dart';
import 'package:gogogame_frontend/screens/game/disk.dart';

class GameCell extends ConsumerWidget {
  final int x;
  final int y;
  final Function(int, int) onTap;
  final CellDisk disk;
  final DiskColor? userColor;
  final bool isVaildMove;

  const GameCell({
    super.key,
    required this.x,
    required this.y,
    required this.onTap,
    required this.disk,
    required this.userColor,
    this.isVaildMove = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ref.watch(gameTheme);

    Widget child;

    if (disk.isDiskColor) {
      child = Disk(color: disk.toDiskColor());
    } else if (isVaildMove && userColor != null) {
      child = Center(
        child: SizedBox.square(
          dimension: GameConstant.cellSize * 0.4,
          child: Disk(color: userColor!),
        ),
      );
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
