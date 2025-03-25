import 'dart:math';

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
  final List<List<CellDisk>> _board;
  final DiskColor turn;

  final Tuple2<int, int>? lastMove;

  final MatchResult? result;

  MatchType({
    required this.matchId,
    required this.opponent,
    required this.format,
    required this.color,
    required List<List<CellDisk>> board,
    required this.turn,
    this.lastMove,
    this.result,
  }) : _board = List<List<CellDisk>>.unmodifiable(
         board.map((row) => List<CellDisk>.unmodifiable(row)),
       ); // Ensuring deep immutability

  List<List<CellDisk>> get board => _board;

  int count(DiskColor color) {
    return board
        .expand((row) => row)
        .where((cell) => cell.matches(color))
        .length;
  }

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

  /// Apply match result
  /// Returns a new MatchType with the result applied
  MatchType applyResult(MatchResult result) {
    return copyWith(result: result);
  }

  /// Apply a move to the board
  /// Returns a new MatchType with the move applied
  MatchType applyMove(
    int x,
    int y,
    DiskColor color,
    DiskColor turn,
    int timeStamp,
  ) {
    if (board[x][y] != CellDisk.empty) throw InvalidMoveException();
    if (this.turn != color) throw NotYourTurnException();

    final flipped = flipPieces(x, y, color);
    if (flipped.isEmpty) throw IllegalMoveException(); // Invalid move

    // Create a new board while maintaining immutability
    final newBoard = board.map((row) => row.toList()).toList();
    newBoard[x][y] = color.toCellDisk();
    for (final pos in flipped) {
      newBoard[pos.item1][pos.item2] = color.toCellDisk();
    }

    return copyWith(
      board: List<List<CellDisk>>.unmodifiable(
        newBoard.map(List<CellDisk>.unmodifiable),
      ),
      lastMove: Tuple2(x, y),
      turn: turn,
    );
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

  MatchType removeRandomPair() {
    Tuple2<int, int>? black = getRandomDiskPosition(DiskColor.black);
    Tuple2<int, int>? white = getRandomDiskPosition(DiskColor.white);

    if (black == null || white == null) {
      throw Exception('No pair found');
    }

    final newBoard = board.map((row) => row.toList()).toList();
    newBoard[black.item1][black.item2] = CellDisk.empty;
    newBoard[white.item1][white.item2] = CellDisk.empty;

    return copyWith(
      board: List<List<CellDisk>>.unmodifiable(
        newBoard.map(List<CellDisk>.unmodifiable),
      ),
    );
  }

  Tuple2<int, int>? getRandomDiskPosition(DiskColor color) {
    List<Tuple2<int, int>> positions = [];

    for (int x = 0; x < board.length; x++) {
      for (int y = 0; y < board[x].length; y++) {
        if (board[x][y].matches(color)) {
          positions.add(Tuple2(x, y));
        }
      }
    }

    if (positions.isEmpty) return null; // No disks of the given color found

    return positions[Random().nextInt(positions.length)];
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
      result: result,
    );
  }

  copyWith({
    List<List<CellDisk>>? board,
    DiskColor? turn,
    Tuple2<int, int>? lastMove,
    MatchResult? result,
  }) {
    return MatchType(
      matchId: matchId,
      opponent: opponent,
      format: format,
      color: color,
      board: board ?? this.board,
      turn: turn ?? this.turn,
      lastMove: lastMove ?? this.lastMove,
      result: result ?? this.result,
    );
  }

  bool get isOver => result != null;
}

class MatchResult {
  final Winner winner;
  final String reasonString;

  MatchResult({required this.winner, required this.reasonString});

  factory MatchResult.fromJson(Map<String, dynamic> json) {
    return MatchResult(
      winner: Winner.fromString(json['winner']),
      reasonString: json['endReason'],
    );
  }
}
