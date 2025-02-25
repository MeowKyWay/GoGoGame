import 'dart:developer';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gogogame_frontend/core/constants/config.dart';
import 'package:gogogame_frontend/core/services/auth/auth_service_provider.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

final webSocketService = Provider(
  (ref) => WebSocketService(Config.webSocketUrl, ref),
);

class WebSocketService {
  final String url;
  final Ref ref;

  WebSocketService(this.url, this.ref);

  late IO.Socket socket;

  Future<void> connect() async {
    String? token = await ref.read(authService).getToken();

    if (token == null) {
      throw Exception('Token is null');
    }

    socket = IO.io(
      url,
      IO.OptionBuilder()
          .setTransports(['websocket']) // Force WebSocket transport
          .disableAutoConnect() // Disable auto connect (connect manually)
          .setExtraHeaders({'Authorization': 'Bearer $token'}) // Send token
          .build(),
    );

    socket.connect();

    socket.onConnect((_) {
      log('Connected to WebSocket');
    });
    socket.onDisconnect((_) {
      log('Disconnected from WebSocket');
    });
    socket.onError((data) {
      log('WebSocket error: $data');
    });
  }

  void sendMessage(String event, dynamic data) {
    socket.emit(event, data);
  }

  void listen(String event, Function(dynamic) callback) {
    socket.on(event, callback);
  }

  void close() {
    socket.disconnect();
  }
}
