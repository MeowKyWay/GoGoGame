import 'package:flutter/material.dart';
import 'package:gogogame_frontend/core/extensions/build_context_extension.dart';
import 'package:gogogame_frontend/core/themes/game_theme/game_theme.dart';
import 'package:gogogame_frontend/core/types/game_type.dart';
import 'package:gogogame_frontend/core/types/user_type.dart';
import 'package:gogogame_frontend/widget/general/disk_image.dart';

class PlayerRow extends StatelessWidget {
  const PlayerRow({
    super.key,
    required this.userColor,
    required this.userPlayer,
    required this.context,
    required this.userScore,
    required this.opponentScore,
    required this.opponentColor,
    required this.opponentPlayer,

    required this.theme,
  });

  final DiskColor userColor;
  final UserType userPlayer;
  final BuildContext context;
  final int userScore;
  final int opponentScore;
  final DiskColor opponentColor;
  final UserType opponentPlayer;

  final GameTheme theme;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          spacing: 16,
          children: [
            SizedBox.square(
              dimension: 100,
              child: DiskImage(color: userColor, theme: theme),
            ),
            Text(userPlayer.username, style: context.textTheme.bodyMedium),
          ],
        ),
        SizedBox(
          width: 64,
          child: Center(
            child: Text(
              '$userScore',
              style: context.textTheme.displaySmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        Text(':', style: context.textTheme.displaySmall),
        SizedBox(
          width: 64,
          child: Center(
            child: Text(
              '$opponentScore',
              style: context.textTheme.displaySmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        Column(
          spacing: 16,
          children: [
            SizedBox.square(
              dimension: 100,
              child: DiskImage(color: opponentColor, theme: theme),
            ),
            Text(opponentPlayer.username, style: context.textTheme.bodyMedium),
          ],
        ),
      ],
    );
  }
}
