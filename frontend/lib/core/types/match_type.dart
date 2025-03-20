import 'dart:developer';

import 'package:gogogame_frontend/core/exceptions/game_exception.dart';
import 'package:gogogame_frontend/core/interfaces/clonable.dart';
import 'package:gogogame_frontend/core/interfaces/jsonable.dart';
import 'package:gogogame_frontend/core/services/game/timer_service.dart';
import 'package:gogogame_frontend/core/types/game_type.dart';
import 'package:gogogame_frontend/core/types/user_type.dart';
import 'package:tuple/tuple.dart';

class MatchType implements Jsonable, Clonable<MatchType> {
  final String matchId;
  final UserType opponent;
  final GameFormatType format;
  final DiskColor color;
  final List<List<CellDisk>> board;
  bool isOver;

  DiskColor turn;

  MatchType({
    required this.matchId,
    required this.opponent,
    required this.format,
    required this.color,
    required this.board,
    required this.turn,
    required this.isOver,
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

  factory MatchType.fromJson(
    Map<String, dynamic> json,
    TimerService timerService,
  ) {
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
      isOver: false,
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

  List<Tuple2<int, int>> flipPieces(int x, int y, DiskColor color) {
    List<Tuple2<int, int>> allFlipped = [];

    for (var dir in directions) {
      int dx = dir[0], dy = dir[1];
      int nx = x + dx, ny = y + dy;
      List<Tuple2<int, int>> flipped = [];

      while (nx >= 0 &&
          nx < board.length &&
          ny >= 0 &&
          ny < board.length &&
          board[nx][ny] != CellDisk.empty &&
          !board[nx][ny].matches(color)) {
        flipped.add(Tuple2(nx, ny));
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

  void applyMove(int x, int y, DiskColor color, DiskColor turn, int timeStamp) {
    if (board[x][y] != CellDisk.empty) throw InvalidMoveException();

    if (this.turn != color) throw NotYourTurnException();

    final flipped = flipPieces(x, y, color);
    if (flipped.isEmpty) throw IllegalMoveException(); // Invalid move

    List<List<CellDisk>> newBoard = board.map((row) => List.of(row)).toList();
    newBoard[x][y] = color.toCellDisk();

    for (final pos in flipped) {
      newBoard[pos.item1][pos.item2] = color.toCellDisk();
    }

    this.turn = turn;

    // Update state
    board.clear();
    board.addAll(newBoard);
    return;
  }

  List<Tuple2<int, int>> getValidMoves() {
    List<Tuple2<int, int>> validMoves = [];

    for (int x = 0; x < board.length; x++) {
      for (int y = 0; y < board.length; y++) {
        if (board[x][y] == CellDisk.empty &&
            flipPieces(x, y, turn).isNotEmpty) {
          validMoves.add(Tuple2(x, y));
        }
      }
    }

    return validMoves;
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
      isOver: isOver,
    );
  }

  void printBoard() {
    String boardString = board
        .asMap()
        .entries
        .map((entry) {
          int rowIndex = entry.key;
          String row = entry.value
              .map((cell) {
                return cell == CellDisk.black
                    ? '⚫'
                    : cell == CellDisk.white
                    ? '⚪'
                    : '⬜';
              })
              .join(' ');
          return '$rowIndex: $row';
        })
        .join('\n');

    log('\n$boardString');
  }
}

class MatchResult {
  final DiskColor winner;
  final String reason;

  MatchResult({required this.winner, required this.reason});

  factory MatchResult.fromJson(Map<String, dynamic> json) {
    return MatchResult(
      winner: DiskColor.fromString(json['winner']),
      reason: json['message'],
    );
  }
}
