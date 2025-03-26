import 'package:flutter/material.dart';
import 'package:gogogame_frontend/core/interfaces/jsonable.dart';
import 'package:tuple/tuple.dart';

class GameTheme extends Jsonable {
  final String name;
  final Tuple2<Color, Color> boardColor;
  final Color lineColor;

  GameTheme({
    required this.name,
    required this.boardColor, // Can be null if using an image
    required this.lineColor,
  });

  GameTheme copyWith({Tuple2<Color, Color>? boardColor, Color? lineColor}) {
    return GameTheme(
      name: name,
      boardColor: boardColor ?? this.boardColor,
      lineColor: lineColor ?? this.lineColor,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "boardColor": {
        "item1": boardColor.item1.toARGB32(),
        "item2": boardColor.item2.toARGB32(),
      },
      "lineColor": lineColor.toARGB32(),
    };
  }

  factory GameTheme.fromJson(Map<String, dynamic> data) {
    return GameTheme(
      name: data["name"],
      boardColor: Tuple2(
        Color(data["boardColor"]["item1"]),
        Color(data["boardColor"]["item2"]),
      ),
      lineColor: Color(data["lineColor"]),
    );
  }

  static List<GameTheme> themes = [
    defaultGameTheme,
    lightWoodGameTheme,
    darkWoodGameTheme,
    pinkTheme,
    purpleTheme,
  ];
}

GameTheme defaultGameTheme = GameTheme(
  name: "Default",
  boardColor: Tuple2(Color(0xFF006800), Color(0xFF008001)), // Green
  lineColor: Colors.transparent,
);

GameTheme lightWoodGameTheme = GameTheme(
  name: "Light Wood",
  boardColor: Tuple2(Color(0xFFB58A5B), Color(0xFFCDA578)), // Light Wood
  lineColor: Colors.transparent,
);

GameTheme darkWoodGameTheme = GameTheme(
  name: "Dark Wood",
  boardColor: Tuple2(Color(0xFF91663E), Color(0xFFA0764A)), // Dark Wood
  lineColor: Colors.transparent,
);

GameTheme pinkTheme = GameTheme(
  name: "Pink",
  boardColor: Tuple2(Color(0xFFFB6F91), Color(0xFFFEB3C6)), // Pink
  lineColor: Colors.transparent,
);

GameTheme purpleTheme = GameTheme(
  name: "Purple",
  boardColor: Tuple2(Color(0xFF8c72eb), Color(0xFFaa99e8)), // Purple
  lineColor: Colors.transparent,
);
