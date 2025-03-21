import 'package:flutter/material.dart';
import 'package:gogogame_frontend/core/constants/game_constant.dart';
import 'package:gogogame_frontend/core/types/game_type.dart';
import 'package:gogogame_frontend/screens/game/disk.dart';

class DiskImage extends StatelessWidget {
  final DiskColor? color;

  const DiskImage({super.key, required this.color});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraint) {
        return SizedBox.square(
          dimension: constraint.maxHeight,
          child: Container(
            padding: EdgeInsets.all(5),
            decoration: BoxDecoration(
              color: GameConstant.imageBackgroundColor,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Center(
              child: color != null ? Disk(cellDisk: color!.toCellDisk()) : null,
            ),
          ),
        );
      },
    );
  }
}
