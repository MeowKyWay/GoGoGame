import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gogogame_frontend/core/constants/game_constant.dart';
import 'package:gogogame_frontend/core/themes/game_theme.dart';

class GameCell extends ConsumerWidget {
  final int x;
  final int y;
  final Function(int, int) onTap;

  const GameCell({
    super.key,
    required this.x,
    required this.y,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ref.watch(gameThemeProvider);

    return GestureDetector(
      onTap: () => onTap(x, y),
      child: Container(
        width: GameConstant.cellSize,
        height: GameConstant.cellSize,
        decoration: BoxDecoration(border: Border.all(color: theme.lineColor)),
      ),
    );
  }
}
