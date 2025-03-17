import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gogogame_frontend/core/types/game_type.dart'; // Ensure this contains DiskColor

final timerService = StateNotifierProvider<TimerService, Map<DiskColor, int>>((
  ref,
) {
  return TimerService();
});

class TimerService extends StateNotifier<Map<DiskColor, int>> {
  Timer? _timer;
  DiskColor _currentTurn;

  TimerService()
    : _currentTurn = DiskColor.black, // Black starts first
      super({DiskColor.black: 0, DiskColor.white: 0});

  void startTimer(int initialTime, DiskColor startingTurn) {
    state = {DiskColor.black: initialTime, DiskColor.white: initialTime};
    _currentTurn = startingTurn;

    _startPeriodicTimer();
  }

  void _startPeriodicTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (state[_currentTurn]! > 0) {
        state = {
          ...state,
          _currentTurn: (state[_currentTurn]! - 1000).clamp(
            0,
            double.maxFinite.toInt(),
          ), // Prevent negative time
        };
      }

      // Stop the timer if time runs out
      if (state[_currentTurn] == 0) {
        stopTimer();
        // Handle game over logic here if needed
      }
    });
  }

  void switchTurn() {
    _currentTurn = _currentTurn.opposite();
    _startPeriodicTimer(); // Restart the timer for the next turn
  }

  void stopTimer() {
    _timer?.cancel();
  }

  void updateTimer(int blackTime, int whiteTime, int timeStamp) {
    final timeElapsed = DateTime.now().millisecondsSinceEpoch - timeStamp;

    state = {
      DiskColor.black: (blackTime - timeElapsed).clamp(
        0,
        double.maxFinite.toInt(),
      ),
      DiskColor.white: (whiteTime - timeElapsed).clamp(
        0,
        double.maxFinite.toInt(),
      ),
    };
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
