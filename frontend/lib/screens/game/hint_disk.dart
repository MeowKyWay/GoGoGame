import 'package:flutter/widgets.dart';
import 'package:gogogame_frontend/core/constants/game_constant.dart';
import 'package:gogogame_frontend/core/types/game_type.dart';
import 'package:gogogame_frontend/screens/game/animated_disk.dart';

class HintDisk extends StatelessWidget {
  final DiskColor color;

  const HintDisk({super.key, required this.color});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox.square(
        dimension: GameConstant.cellSize * 0.4,
        child: AnimatedDisk(color: color),
      ),
    );
  }
}
