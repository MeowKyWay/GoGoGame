import 'dart:async';
import 'dart:developer';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gogogame_frontend/core/constants/config.dart';
import 'package:gogogame_frontend/core/services/auth/auth_service_provider.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

final webSocketService = Provider((ref) {
  final service = WebSocketService(Config.webSocketUrl, ref);
  ref.onDispose(() => service.dispose()); // Cleanup on provider disposal
  return service;
});

class WebSocketService {
  final String url;
  final Ref ref;
  IO.Socket? _socket; // Nullable to check connection status

  WebSocketService(this.url, this.ref);

  Future<void> connect() async {
    if (_socket?.connected == true) {
      log('[WebSocket] Already connected');
      return;
    }

    final token = await ref.read(authService).getToken();
    if (token == null) {
      log('[WebSocket] Token is null, cannot connect');
      return;
    }

    _socket = IO.io(
      url,
      IO.OptionBuilder()
          .setTransports(['websocket'])
          .setExtraHeaders({'Authorization': 'Bearer $token'})
          .setReconnectionAttempts(10) // Retry 10 times
          .setReconnectionDelay(2000) // Wait 2s between retries
          .build(),
    );

    final completer = Completer<void>();

    Future.delayed(const Duration(seconds: 10), () {
      if (!completer.isCompleted) {
        log('[WebSocket] Authentication timed out');
        disconnect();
        completer.completeError(Exception('Authentication timed out'));
      }
    });

    _socket!.onConnect((_) => log('[WebSocket] Connected'));
    _socket!.on('authenticated', (_) {
      log('[WebSocket] Authenticated');
      completer.complete(); // Resolve when authenticated
    });

    _socket!.connect();

    return await completer.future;
  }

  void sendMessage(String event, dynamic data) {
    if (_socket?.connected == true) {
      _socket!.emit(event, data);
    } else {
      log('[WebSocket] Cannot send message, socket is not connected');
    }
  }

  void listen(String event, Function(dynamic) callback) {
    _socket?.on(event, callback);
  }

  void disconnect() {
    _socket?.disconnect();
  }

  void dispose() {
    _socket?.dispose();
    log('[WebSocket] Disposed');
  }
}
