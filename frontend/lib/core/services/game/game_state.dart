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
  }

  void endMatch() {
    state = null;
  }

  MatchType? getMatch() {
    return state;
  }

  void applyMove(int x, int y, DiskColor color, Map<DiskColor, int> timeLeft) {
    if (state == null) return;

    final match = state!.clone();
    match.applyMove(x, y, color);
    match.updateTimer(timeLeft);

    state = match;
  }
}
