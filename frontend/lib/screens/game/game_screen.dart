import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gogogame_frontend/core/constants/time_control.dart';
import 'package:gogogame_frontend/core/extensions/build_context_extension.dart';
import 'package:gogogame_frontend/core/services/auth/auth_service_provider.dart';
import 'package:gogogame_frontend/core/services/game/game_service.dart';
import 'package:gogogame_frontend/core/services/game/game_state.dart';
import 'package:gogogame_frontend/core/types/match_type.dart';
import 'package:gogogame_frontend/core/types/user_type.dart';
import 'package:gogogame_frontend/screens/game/game_board.dart';
import 'package:gogogame_frontend/screens/game/game_play_tile/game_player_tile.dart';
import 'package:gogogame_frontend/screens/game/modal/queue_modal.dart';
import 'package:gogogame_frontend/screens/game/modal/result_modal.dart';

class GameScreen extends ConsumerStatefulWidget {
  final TimeControl timeControl;

  const GameScreen({super.key, required this.timeControl});

  @override
  ConsumerState<GameScreen> createState() => _GamePageState();
}

class _GamePageState extends ConsumerState<GameScreen> {
  late GameService game;

  void _onCellTap(int x, int y) {
    game.move(x, y);
  }

  @override
  Widget build(BuildContext context) {
    MatchType? match = ref.watch(gameStateProvider);
    UserType? user = ref.watch(authState);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (match?.result != null) {
        final modal = ResultModal(
          context,
          onClose: () {
            Navigator.of(context).pop();
          },
        );
        modal.show();
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Game'),
        automaticallyImplyLeading: match?.isOver ?? false,
      ),
      body: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          if (match != null)
            GamePlayerTile(
              player: match.opponent,
              color: match.color.opposite(),
              isPlayerTurn:
                  !match.isOver && match.turn == match.color.opposite(),
            ),
          GameBoard(onCellTap: _onCellTap, match: match),
          if (match != null)
            GamePlayerTile(
              player: user,
              color: match.color,
              isPlayerTurn: !match.isOver && match.turn == match.color,
            ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: context.colorScheme.outline,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.arrow_back),
            label: 'Resign',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    game = ref.read(gameService);

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final modal = QueueModal(
        context,
        onClose: () {
          Navigator.of(context).pop();
        },
      );
      modal.show();
      await game.connect();
      await game.joinQueue(
        widget.timeControl.initialTime,
        widget.timeControl.increment,
      );
      modal.hide();
    });
  }

  @override
  void dispose() {
    super.dispose();
    game.dispose();
  }
}
