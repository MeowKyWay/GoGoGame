import 'dart:developer';

import 'package:gogogame_frontend/core/interfaces/clonable.dart';
import 'package:gogogame_frontend/core/interfaces/jsonable.dart';
import 'package:gogogame_frontend/core/types/game_type.dart';
import 'package:gogogame_frontend/core/types/user_type.dart';

class MatchType implements Jsonable, Clonable<MatchType> {
  final String matchId;
  final UserType opponent;
  final GameFormatType format;
  final DiskColor color;
  List<List<CellDisk>> board;
  DiskColor turn;

  MatchType({
    required this.matchId,
    required this.opponent,
    required this.format,
    required this.color,
    required this.board,
    required this.turn,
  });

  @override
  Map<String, dynamic> toJson() {
    return {
      'matchId': matchId,
      'opponent': opponent.toJson(),
      'format': format.toJson(),
      'color': color,
      'board': board,
      'turn': turn,
    };
  }

  factory MatchType.fromJson(Map<String, dynamic> json) {
    return MatchType(
      matchId: json['matchId'],
      opponent: UserType.fromJson(json['opponent']),
      format: GameFormatType.fromJson(json['format']),
      color: DiskColor.fromString(json['color']),
      board: List<List<CellDisk>>.from(
        json['board'].map(
          (row) => List<String>.from(row).map(CellDisk.fromString).toList(),
        ),
      ),
      turn: DiskColor.fromString(json['turn']),
    );
  }

  static const directions = [
    [-1, -1],
    [-1, 0],
    [-1, 1],
    [0, -1],
    [0, 1],
    [1, -1],
    [1, 0],
    [1, 1],
  ];

  List<List<int>> flipPieces(int x, int y, DiskColor color) {
    List<List<int>> allFlipped = [];

    for (var dir in directions) {
      int dx = dir[0], dy = dir[1];
      int nx = x + dx, ny = y + dy;
      List<List<int>> flipped = [];

      while (nx >= 0 &&
          nx < board.length &&
          ny >= 0 &&
          ny < board.length &&
          board[nx][ny] != CellDisk.empty &&
          !board[nx][ny].matches(color)) {
        flipped.add([nx, ny]);
        nx += dx;
        ny += dy;
      }

      if (flipped.isNotEmpty &&
          nx >= 0 &&
          nx < board.length &&
          ny >= 0 &&
          ny < board.length &&
          board[nx][ny].matches(color)) {
        allFlipped.addAll(flipped);
      }
    }

    for (var pos in allFlipped) {
      board[pos[0]][pos[1]] = color.toCellDisk(); // Flip pieces
    }

    return allFlipped;
  }

  bool hasLegalMove(DiskColor color) {
    for (int x = 0; x < board.length; x++) {
      for (int y = 0; y < board.length; y++) {
        if (board[x][y] == CellDisk.empty &&
            flipPieces(x, y, color).isNotEmpty) {
          return true;
        }
      }
    }
    return false;
  }

  void applyMove(int x, int y, DiskColor color) {
    if (board[x][y] != CellDisk.empty || color != turn) return;

    final flipped = flipPieces(x, y, color);
    if (flipped.isEmpty) return; // Invalid move

    board[x][y] = color.toCellDisk(); // Place piece
    for (final pos in flipped) {
      board[pos[0]][pos[1]] = color.toCellDisk(); // Flip pieces
    }
    turn = turn.opposite(); // Toggle turn

    // If next player has no move, switch back
    if (!hasLegalMove(turn)) {
      turn = turn.opposite();

      // If neither player has a move, game over
      if (!hasLegalMove(turn)) {
        log('[MatchType] Game Over: No legal moves left.');
      }
    }
  }

  @override
  MatchType clone() {
    return MatchType(
      matchId: matchId,
      opponent: opponent,
      format: format,
      color: color,
      board: board.map((row) => List.of(row)).toList(),
      turn: turn,
    );
  }
}
