import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:gogogame_frontend/core/extensions/build_context_extension.dart';
import 'package:gogogame_frontend/core/types/game_type.dart';
import 'package:gogogame_frontend/core/types/user_type.dart';
import 'package:gogogame_frontend/screens/game/disk.dart';

class TileLabel extends StatelessWidget {
  final UserType? user;
  final DiskColor? color;
  final int count;

  const TileLabel({super.key, this.user, this.color, required this.count});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(user?.username ?? '', style: context.textTheme.bodyLarge),
        if (color != null)
          Row(
            children: [
              SizedBox.square(
                dimension: context.textTheme.bodySmall!.fontSize! + 4,
                child: Disk(cellDisk: color!.toCellDisk()),
              ),
              Gap(4),
              Text(
                '${count >= 0 ? '+' : ''}$count',
                style: context.textTheme.bodySmall,
              ),
            ],
          ),
      ],
    );
  }
}
