import 'dart:async';
import 'dart:developer';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gogogame_frontend/core/services/game/game_state.dart';
import 'package:gogogame_frontend/core/services/websocket/web_socket_service.dart';
import 'package:gogogame_frontend/core/types/game_type.dart';
import 'package:gogogame_frontend/core/types/match_type.dart';

final gameService = Provider((ref) {
  return GameService(
    ref.read(webSocketService),
    ref.read(gameStateProvider.notifier),
  );
});

class GameService {
  final WebSocketService webSocket;
  final GameStateNotifier gameState;

  GameService(this.webSocket, this.gameState);

  Future<void> connect() async {
    await webSocket.connect();

    webSocket.listen('validation_error', (data) {
      log('[GameService] Validation error: $data');
      throw Exception('Validation error: $data');
    });

    webSocket.listen('error', (data) {
      log('[GameService] Error: $data');
      throw Exception('Error: $data');
    });
  }

  Future<void> joinQueue(int initialTime, int increment) {
    webSocket.sendMessage('join_queue', {
      'initialTime': initialTime,
      'increment': increment,
    });

    Completer<void> completer = Completer<void>();

    webSocket.listenOnce('match_found', (data) {
      log('[GameService] Game started: $data');
      webSocket.listen('move', (data) {
        log('[GameService] Move received: $data');
        gameState.applyMove(
          data['x'],
          data['y'],
          DiskColor.fromString(data['color']),
          {
            DiskColor.black: data['timeLeft']['black'],
            DiskColor.white: data['timeLeft']['white'],
          },
        );
      });
      gameState.startMatch(MatchType.fromJson(data));
      completer.complete();
    });

    return completer.future;
  }

  Future<void> move(int x, int y) {
    final match = gameState.getMatch();
    if (match == null) {
      throw Exception('No match found');
    }
    webSocket.sendMessage('move', {
      'matchId': match.matchId,
      'color': match.color.toString(),
      'x': x,
      'y': y,
    });
    return Future.value();
  }

  void dispose() {
    webSocket.dispose();
  }
}
