import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gogogame_frontend/core/constants/time_control.dart';
import 'package:gogogame_frontend/core/services/auth/auth_service_provider.dart';
import 'package:gogogame_frontend/core/services/game/game_service.dart';
import 'package:gogogame_frontend/core/services/game/game_state.dart';
import 'package:gogogame_frontend/core/types/match_type.dart';
import 'package:gogogame_frontend/core/types/user_type.dart';
import 'package:gogogame_frontend/screens/game/game_board.dart';
import 'package:gogogame_frontend/screens/game/game_play_tile/game_player_tile.dart';
import 'package:gogogame_frontend/screens/game/modal/queue_modal.dart';
import 'package:gogogame_frontend/screens/game/modal/result_modal.dart';
import 'package:gogogame_frontend/widget/modal/app_modal.dart';
import 'package:gogogame_frontend/widget/modal/confirm_modal.dart';

class GameScreen extends ConsumerStatefulWidget {
  final TimeControl timeControl;

  const GameScreen({super.key, required this.timeControl});

  @override
  ConsumerState<GameScreen> createState() => _GamePageState();
}

class _GamePageState extends ConsumerState<GameScreen>
    with TickerProviderStateMixin {
  late GameService game;

  void _onCellTap(int x, int y) {
    game.move(x, y);
  }

  void showResultModal() async {
    final modal = ResultModal(
      context,
      vsync: this,
      onClose: () {
        Navigator.of(context).pop();
      },
    );
    await Future.delayed(Duration(milliseconds: 500));
    modal.show();
  }

  @override
  Widget build(BuildContext context) {
    MatchType? match = ref.watch(gameStateProvider);
    UserType? user = ref.watch(authState);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (match?.result != null) {
        showResultModal();
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Game'),
        automaticallyImplyLeading: match?.isOver ?? false,
        leading:
            match?.isOver == false
                ? IconButton(
                  icon: const Icon(Icons.exit_to_app_rounded),
                  onPressed: () async {
                    await _resignModal().show();
                  },
                )
                : null,
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
    );
  }

  AppModal _resignModal() {
    return ConfirmModal(
      context,
      vsync: this,
      title: 'Resign',
      message: 'Are you sure you want to resign?',
      leftButtonText: 'Cancel',
      rightButtonText: 'Resign',
      onRightButton: () {
        game.resign();
      },
    );
  }

  @override
  void initState() {
    super.initState();
    game = ref.read(gameService);

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final modal = QueueModal(
        context,
        vsync: this,
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
