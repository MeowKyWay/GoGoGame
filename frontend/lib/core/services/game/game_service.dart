import 'dart:async';
import 'dart:developer';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gogogame_frontend/core/services/websocket/web_socket_service.dart';
import 'package:gogogame_frontend/core/types/game_type.dart';

final gameService = Provider((ref) {
  return GameService(ref.read(webSocketService));
});

class GameService {
  final WebSocketService webSocket;

  MatchType? match;

  GameService(this.webSocket);

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

  Future<void> joinQueue(int boardSize, int initialTime, int increment) {
    webSocket.sendMessage('join_queue', {
      'boardSize': boardSize,
      'initialTime': initialTime,
      'increment': increment,
    });

    Completer<void> completer = Completer<void>();

    webSocket.listenOnce('match_found', (data) {
      log('[GameService] Game started: $data');
      webSocket.listen('move', (data) {
        log('[GameService] Move received: $data');
      });
      match = MatchType.fromJson(data);
      completer.complete();
    });

    return completer.future;
  }

  Future<void> move(int x, int y) {
    log('[GameService] Move: $x, $y');
    if (match == null) {
      throw Exception('No match found');
    }
    webSocket.sendMessage('move', {
      'matchId': match!.matchId,
      'color': match!.color,
      'x': x,
      'y': y,
    });
    return Future.value();
  }

  void dispose() {
    webSocket.dispose();
  }
}
