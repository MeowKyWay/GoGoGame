import 'package:flutter/material.dart';
import 'package:gogogame_frontend/core/constants/board_size_type.dart';
import 'package:gogogame_frontend/core/constants/time_control.dart';

class PlayScreen extends StatefulWidget {
  const PlayScreen({super.key});

  @override
  State<PlayScreen> createState() => _PlayScreenState();
}

class _PlayScreenState extends State<PlayScreen> {
  BoardSize _boardSize = BoardSize.b9x9;
  TimeControl _timeControl = TimeControl.defaultTimeControl;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Play')),
      body: Column(
        children: [
          DropdownButton<BoardSize>(
            items:
                BoardSize.boardSizes
                    .map(
                      (e) => DropdownMenuItem<BoardSize>(
                        value: e,
                        child: Text(e.toString()),
                      ),
                    )
                    .toList(),
            onChanged: (value) {
              setState(() {
                _boardSize = value!;
              });
            },
            value: _boardSize,
          ),
          DropdownButton<TimeControl>(
            items:
                TimeControl.timeControls
                    .map(
                      (e) => DropdownMenuItem<TimeControl>(
                        value: e,
                        child: Text(e.toString()),
                      ),
                    )
                    .toList(),
            onChanged: (value) {
              setState(() {
                _timeControl = value!;
              });
            },
            value: _timeControl,
          ),
        ],
      ),
    );
  }
}
