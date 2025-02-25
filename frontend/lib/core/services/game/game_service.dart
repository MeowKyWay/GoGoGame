import 'dart:async';
import 'dart:developer';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gogogame_frontend/core/services/websocket/web_socket_service.dart';

final gameService = Provider((ref) {
  return GameService(ref.read(webSocketService));
});

class GameService {
  final WebSocketService webSocket;

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

    webSocket.listen('match_found', (data) {
      log('[GameService] Game started: $data');
      completer.complete();
    });

    return completer.future;
  }

  void dispose() {
    webSocket.dispose();
  }
}
