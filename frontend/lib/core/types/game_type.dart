import 'package:gogogame_frontend/core/interfaces/jsonable.dart';

class MatchType implements Jsonable {
  final String matchId;
  final UserType opponent;
  final GameFormatType format;
  final String color;

  MatchType({
    required this.matchId,
    required this.opponent,
    required this.format,
    required this.color,
  });

  @override
  Map<String, dynamic> toJson() {
    return {
      'matchId': matchId,
      'opponent': opponent.toJson(),
      'format': format.toJson(),
      'color': color,
    };
  }

  factory MatchType.fromJson(Map<String, dynamic> json) {
    return MatchType(
      matchId: json['matchId'],
      opponent: UserType.fromJson(json['opponent']),
      format: GameFormatType.fromJson(json['format']),
      color: json['color'],
    );
  }
}

class UserType implements Jsonable {
  final int id;
  final String username;

  UserType({required this.id, required this.username});

  @override
  Map<String, dynamic> toJson() {
    return {'id': id, 'username': username};
  }

  factory UserType.fromJson(Map<String, dynamic> json) {
    return UserType(id: json['id'], username: json['username']);
  }
}

class GameFormatType implements Jsonable {
  final int boardSize;
  final int initialTime;
  final int increment;

  GameFormatType({
    required this.boardSize,
    required this.initialTime,
    required this.increment,
  });

  @override
  Map<String, dynamic> toJson() {
    return {
      'boardSize': boardSize,
      'initialTime': initialTime,
      'increment': increment,
    };
  }

  factory GameFormatType.fromJson(Map<String, dynamic> json) {
    return GameFormatType(
      boardSize: json['boardSize'],
      initialTime: json['initialTime'],
      increment: json['increment'],
    );
  }
}
