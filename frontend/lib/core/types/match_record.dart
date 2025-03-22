import 'dart:developer';

import 'package:gogogame_frontend/core/interfaces/jsonable.dart';
import 'package:gogogame_frontend/core/types/game_type.dart';
import 'package:gogogame_frontend/core/types/user_type.dart';

class MatchRecord implements Jsonable {
  final int id;

  final GameFormatType format;

  final UserType? blackPlayer;
  final UserType? whitePlayer;

  final Winner winner;

  final String endReason;

  final int blackScore;
  final int whiteScore;

  final int timeLeftBlack;
  final int timeLeftWhite;

  final DateTime createdAt;

  MatchRecord({
    required this.id,
    required this.format,
    required this.blackPlayer,
    required this.whitePlayer,
    required this.winner,
    required this.endReason,
    required this.blackScore,
    required this.whiteScore,
    required this.timeLeftBlack,
    required this.timeLeftWhite,
    required this.createdAt,
  });

  factory MatchRecord.fromJson(Map<String, dynamic> json) {
    log(json.toString());
    return MatchRecord(
      id: json['id'],
      format: GameFormatType(
        initialTime: json['initialTime'],
        increment: json['incrementTime'],
      ),
      blackPlayer: UserType.fromJson(json['blackPlayer']),
      whitePlayer: UserType.fromJson(json['whitePlayer']),
      winner: Winner.fromString(json['winner']),
      endReason: json['endReason'],
      blackScore: json['blackScore'],
      whiteScore: json['whiteScore'],
      timeLeftBlack: json['timeLeftBlack'],
      timeLeftWhite: json['timeLeftWhite'],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'initialTime': format.initialTime,
      'incrementTime': format.increment,
      'blackPlayer': blackPlayer?.toJson(),
      'whitePlayer': whitePlayer?.toJson(),
      'winner': winner.toString(),
      'endReason': endReason,
      'blackScore': blackScore,
      'whiteScore': whiteScore,
      'timeLeftBlack': timeLeftBlack,
      'timeLeftWhite': timeLeftWhite,
      'createAt': createdAt.toIso8601String(),
    };
  }
}
