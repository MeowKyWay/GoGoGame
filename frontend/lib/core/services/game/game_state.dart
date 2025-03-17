import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gogogame_frontend/core/types/game_type.dart';
import 'package:gogogame_frontend/core/types/match_type.dart';

final gameStateProvider = StateNotifierProvider<GameStateNotifier, MatchType?>((
  ref,
) {
  return GameStateNotifier();
});

class GameStateNotifier extends StateNotifier<MatchType?> {
  GameStateNotifier() : super(null);

  void startMatch(MatchType match) {
    state = match;
    match.startTimer();
  }

  void endMatch() {
    state = null;
  }

  MatchType? getMatch() {
    return state;
  }

  void applyMove(
    int x,
    int y,
    DiskColor color,
    Map<DiskColor, int> timeLeft,
    int timeStamp,
  ) {
    if (state == null) return;

    final match = state!.clone();
    match.applyMove(x, y, color, timeStamp);
    match.timerService.updateTimer(
      timeLeft[DiskColor.black]!,
      timeLeft[DiskColor.white]!,
      timeStamp,
    );

    state = match;
  }
}
