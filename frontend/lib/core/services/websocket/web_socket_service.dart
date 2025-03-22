import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gogogame_frontend/core/constants/config.dart';
import 'package:gogogame_frontend/core/services/auth/auth_service_provider.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;

final webSocketService = Provider((ref) {
  final service = WebSocketService(Config.webSocketUrl, ref);
  ref.onDispose(() => service.dispose()); // Cleanup on provider disposal
  return service;
});

class WebSocketService {
  final String url;
  final Ref ref;
  io.Socket? _socket; // Nullable to check connection status

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

    _socket?.disconnect(); // Ensure previous connection is closed
    _socket?.dispose(); // Free resources before reconnecting
    _socket = null; // Reset the socket

    _socket = io.io(
      url,
      io.OptionBuilder()
          .setTransports(['websocket'])
          .setReconnectionAttempts(10) // Retry 10 times
          .setReconnectionDelay(2000) // Wait 2s between retries
          .disableAutoConnect() // Do not connect immediately
          .build(),
    );

    _socket!.auth = {'token': token};

    final completer = Completer<void>();

    Future.delayed(const Duration(seconds: 10), () {
      if (!completer.isCompleted) {
        log('[WebSocket] Authentication timed out');
        disconnect();
        completer.completeError(Exception('Authentication timed out'));
      }
    });

    listen('message', (data) {
      log('[WebSocket] Message: ${data['message']}');
    });

    _socket!.onConnect((_) => log('[WebSocket] Connected'));
    listenOnce('authenticated', (_) {
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

  void listenOnce(String event, Function(dynamic) callback) {
    _socket?.once(event, (data) {
      // log('[WebSocket] Event received: $event - Data: $data');
      if (data is List) {
        if (data.last is Function) {
          (data.last as Function)(true);
          log('[WebSocket] Acknowledgment sent for event: $event');
        }
        data = data.first;
      }

      // Call the provided callback with data
      try {
        callback(jsonDecode(data));
      } catch (e) {
        callback(data);
      }
    });
  }

  void listen(String event, Function(dynamic) callback) {
    _socket?.on(event, (data) {
      // log('[WebSocket] Event received: $event - Data: $data');
      if (data is List) {
        if (data.last is Function) {
          (data.last as Function)(true);
          log('[WebSocket] Acknowledgment sent for event: $event');
        }
        data = data.first;
      }

      // Call the provided callback with data
      try {
        callback(jsonDecode(data));
      } catch (e) {
        callback(data);
      }
    });
  }

  void disconnect() {
    _socket?.disconnect();
  }

  void dispose() {
    _socket?.dispose();
    log('[WebSocket] Disposed');
  }
}
