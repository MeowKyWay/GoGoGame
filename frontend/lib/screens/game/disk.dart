import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gogogame_frontend/core/extensions/color_extension.dart';
import 'package:gogogame_frontend/core/types/game_type.dart';

class Disk extends ConsumerWidget {
  final CellDisk cellDisk;
  final bool isHint;

  const Disk({super.key, required this.cellDisk, this.isHint = false});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Center(
      child: Container(
        decoration: BoxDecoration(
          color:
              cellDisk.isDiskColor
                  ? cellDisk.toColor()
                  : isHint
                  ? Colors.black.withOpa(0.3)
                  : Colors.transparent,
          shape: BoxShape.circle,
          border: Border.all(
            color:
                cellDisk == CellDisk.empty ? Colors.transparent : Colors.black,
          ),
        ),
      ),
    );
  }
}
