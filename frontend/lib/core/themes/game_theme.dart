import 'package:flutter/material.dart';
import 'package:gogogame_frontend/core/interfaces/jsonable.dart';

class GameTheme extends Jsonable {
  final Color boardColor;
  final Color lineColor;

  GameTheme({
    required this.boardColor, // Can be null if using an image
    required this.lineColor,
  });

  GameTheme copyWith({Color? boardColor, Color? lineColor}) {
    return GameTheme(
      boardColor: boardColor ?? this.boardColor,
      lineColor: lineColor ?? this.lineColor,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      "boardColor": boardColor.toARGB32(),
      "lineColor": lineColor.toARGB32(),
    };
  }

  factory GameTheme.fromJson(Map<String, dynamic> data) {
    return GameTheme(
      boardColor: Color(data["boardColor"]),
      lineColor: Color(data["lineColor"]),
    );
  }
}

GameTheme defaultGameTheme = GameTheme(
  boardColor: Color(0xFFD7A96B), // Light wood
  lineColor: Colors.black,
);

GameTheme darkGameTheme = GameTheme(
  boardColor: Color(0xFF8B4513), // Dark wood
  lineColor: Colors.white,
);
