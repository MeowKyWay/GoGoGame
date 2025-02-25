import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gogogame_frontend/core/constants/board_size_type.dart';
import 'package:gogogame_frontend/core/constants/time_control.dart';
import 'package:gogogame_frontend/core/extensions/build_context_extension.dart';
import 'package:gogogame_frontend/core/services/game/game_service.dart';
import 'package:gogogame_frontend/screens/game/game_board.dart';
import 'package:loader_overlay/loader_overlay.dart';

class GameScreen extends ConsumerStatefulWidget {
  final BoardSize boardSize;
  final TimeControl timeControl;

  const GameScreen({
    super.key,
    required this.boardSize,
    required this.timeControl,
  });

  @override
  ConsumerState<GameScreen> createState() => _GamePageState();
}

class _GamePageState extends ConsumerState<GameScreen> {
  late GameService game;

  @override
  void initState() {
    super.initState();

    game = ref.read(gameService);

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      context.loaderOverlay.show();
      await game.connect();
      await game.joinQueue(
        widget.boardSize.value,
        widget.timeControl.initialTime,
        widget.timeControl.increment,
      );
      if (mounted) context.loaderOverlay.hide();
    });
  }

  @override
  void dispose() {
    super.dispose();
    game.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Game')),
      body: Center(child: GameBoard(size: widget.boardSize.value)),
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
}
