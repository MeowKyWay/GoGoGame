import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gogogame_frontend/core/constants/board_size_type.dart';
import 'package:gogogame_frontend/core/constants/time_control.dart';
import 'package:gogogame_frontend/core/services/websocket/web_socket_service.dart';

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
  late WebSocketService service;

  @override
  void initState() {
    super.initState();

    service = ref.read(webSocketService);

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await service.connect();
      service.listen('message', (data) {
        log('Message: $data');
      });
      service.listen('validationError', (data) {
        log('Validation error: $data');
      });
      service.listen('matchFound', (data) {
        log('Game started: $data');
      });
      service.listen('error', (data) {
        log('Error: $data');
      });
      service.sendMessage('joinQueue', {
        'boardSize': widget.boardSize.value,
        'initialTime': widget.timeControl.initialTime,
        'increment': widget.timeControl.increment,
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    service.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Game')),
      body: Center(child: Text('Game')),
    );
  }
}
