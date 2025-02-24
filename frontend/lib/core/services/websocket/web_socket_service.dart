import 'dart:convert';
import 'dart:developer';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gogogame_frontend/core/constants/config.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/status.dart' as status;

final webSocketService = Provider(
  (ref) => WebSocketService(Config.webSocketUrl),
);

class WebSocketService {
  final String url;
  late WebSocketChannel _channel;

  WebSocketService(this.url);

  void connect() {
    _channel = WebSocketChannel.connect(Uri.parse(url));
    log('Connected to WebSocket at $url');
  }

  void sendMessage(String event, dynamic data) {
    final message = jsonEncode({'event': event, 'data': data});
    _channel.sink.add(message);
  }

  void subscribe(String event, Function(dynamic) callback) {
    _channel.stream.listen((message) {
      final data = jsonDecode(message);
      if (data['event'] == event) {
        callback(data['data']);
      }
    });
  }

  Stream get messages => _channel.stream;

  void close() {
    _channel.sink.close(status.normalClosure);
    log('WebSocket connection closed');
  }
}
