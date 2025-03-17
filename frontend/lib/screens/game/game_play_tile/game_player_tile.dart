import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:gogogame_frontend/core/types/game_type.dart';
import 'package:gogogame_frontend/core/types/user_type.dart';
import 'package:gogogame_frontend/screens/game/game_play_tile/tile_image.dart';
import 'package:gogogame_frontend/screens/game/game_play_tile/tile_label.dart';
import 'package:gogogame_frontend/screens/game/game_play_tile/tile_timer.dart';

class GamePlayerTile extends ConsumerStatefulWidget {
  final UserType? player;
  final DiskColor? color;
  final bool? isPlayerTurn;

  const GamePlayerTile({
    super.key,
    required this.player,
    required this.color,
    required this.isPlayerTurn,
  });

  @override
  ConsumerState<GamePlayerTile> createState() => _GamePlayerTileState();
}

class _GamePlayerTileState extends ConsumerState<GamePlayerTile> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: SizedBox(
        height: 50,
        child: Row(
          children: [
            TileImage(color: widget.color),
            Gap(16),
            TileLabel(user: widget.player, color: widget.color),
            const Spacer(),
            TileTimer(color: widget.color, isPlayerTurn: widget.isPlayerTurn),
          ],
        ),
      ),
    );
  }
}
