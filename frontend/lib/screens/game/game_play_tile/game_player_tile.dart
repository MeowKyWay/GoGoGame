import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:gogogame_frontend/core/services/config_service.dart';
import 'package:gogogame_frontend/core/services/game/game_state.dart';
import 'package:gogogame_frontend/core/types/game_type.dart';
import 'package:gogogame_frontend/core/types/user_type.dart';
import 'package:gogogame_frontend/widget/general/disk_image.dart';
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
    final count = ref.read(gameStateProvider)?.count(widget.color!) ?? 0;
    final config = ref.watch(configService);

    final theme = config.gameTheme;

    final oppositeCount =
        ref.read(gameStateProvider)?.count(widget.color!.opposite()) ?? 0;

    return Flexible(
      flex: 1,
      fit: FlexFit.loose,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: ConstrainedBox(
          constraints: BoxConstraints(minHeight: 50, maxHeight: 75),
          child: Row(
            children: [
              DiskImage(color: widget.color, theme: theme),
              Gap(16),
              TileLabel(
                user: widget.player,
                color: widget.color,
                count: count - oppositeCount,
                theme: theme,
              ),
              const Spacer(),
              TileTimer(color: widget.color, isPlayerTurn: widget.isPlayerTurn),
            ],
          ),
        ),
      ),
    );
  }
}
