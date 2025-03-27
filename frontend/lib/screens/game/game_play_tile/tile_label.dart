import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:gogogame_frontend/core/extensions/build_context_extension.dart';
import 'package:gogogame_frontend/core/themes/game_theme/game_theme.dart';
import 'package:gogogame_frontend/core/types/game_type.dart';
import 'package:gogogame_frontend/core/types/user_type.dart';
import 'package:gogogame_frontend/widget/general/disk.dart';

class TileLabel extends StatelessWidget {
  final UserType? user;
  final DiskColor? color;
  final int count;
  final GameTheme theme;

  const TileLabel({
    super.key,
    this.user,
    this.color,
    required this.count,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60,
      child: FittedBox(
        fit: BoxFit.fitHeight,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 16,
          children: [
            Text(user?.username ?? '', style: context.textTheme.bodyLarge),
            if (color != null)
              Row(
                children: [
                  SizedBox.square(
                    dimension: context.textTheme.bodySmall!.fontSize! + 4,
                    child: Disk(color: color!, theme: theme),
                  ),
                  Gap(4),
                  Text(
                    '${count >= 0 ? '+' : ''}$count',
                    style: context.textTheme.bodySmall,
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
