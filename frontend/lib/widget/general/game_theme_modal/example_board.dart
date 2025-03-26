import 'package:flutter/widgets.dart';
import 'package:gogogame_frontend/core/constants/game_constant.dart';
import 'package:gogogame_frontend/core/themes/game_theme.dart';
import 'package:gogogame_frontend/core/types/game_type.dart';
import 'package:gogogame_frontend/widget/general/disk.dart';

class ExampleBoard extends StatelessWidget {
  final GameTheme theme;

  const ExampleBoard({super.key, required this.theme});

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: GameConstant.cellSize * 2,
      child: Wrap(
        children: List.generate(4, (index) {
          final x = index % 2;
          final y = index ~/ 2;
          final isBlack = (x + y) % 2 == 1;
          return Container(
            padding: const EdgeInsets.all(8),
            width: GameConstant.cellSize,
            height: GameConstant.cellSize,
            color: isBlack ? theme.boardColor.item1 : theme.boardColor.item2,
            child: Disk(color: isBlack ? DiskColor.black : DiskColor.white),
          );
        }),
      ),
    );
  }
}
