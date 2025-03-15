import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:gogogame_frontend/core/extensions/build_context_extension.dart';
import 'package:gogogame_frontend/core/types/game_type.dart';
import 'package:gogogame_frontend/core/types/user_type.dart';
import 'package:gogogame_frontend/screens/game/disk.dart';

class TileLabel extends StatelessWidget {
  final UserType? user;
  final DiskColor? color;

  const TileLabel({super.key, this.user, this.color});

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
                child: Disk(color: color!),
              ),
              Gap(4),
              Text('+10', style: context.textTheme.bodySmall),
            ],
          ),
      ],
    );
  }
}
