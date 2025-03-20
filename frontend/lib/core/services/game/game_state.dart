import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gogogame_frontend/core/services/game/timer_service.dart';
import 'package:gogogame_frontend/core/types/game_type.dart';
import 'package:gogogame_frontend/core/types/match_type.dart';

final gameStateProvider = StateNotifierProvider<GameStateNotifier, MatchType?>((
  ref,
) {
  return GameStateNotifier(timerService: ref.read(timerService.notifier));
});

class GameStateNotifier extends StateNotifier<MatchType?> {
  final TimerService timerService;

  GameStateNotifier({required this.timerService}) : super(null);

  void startMatch(MatchType match) {
    state = match;
    timerService.startTimer(match.format.initialTime * 60 * 1000, match.turn);
  }

  void resetMatch() {
    state = null;
  }

  MatchType? getMatch() {
    return state;
  }

  void applyMove(
    int x,
    int y,
    DiskColor color,
    DiskColor turn,
    Map<DiskColor, int> timeLeft,
    int timeStamp,
  ) {
    if (state == null) return;

    final match = state!.clone();
    match.applyMove(x, y, color, turn, timeStamp);
    timerService.updateTimer(
      timeLeft[DiskColor.black]!,
      timeLeft[DiskColor.white]!,
      timeStamp,
    );
    if (!match.isOver) timerService.setTurn(turn);

    state = match;
  }

  void applyResult(MatchResult result) {
    if (state == null) return;
    timerService.stopTimer();

    final match = state!.clone();
    match.isOver = true;

    state = match;
  }
}
