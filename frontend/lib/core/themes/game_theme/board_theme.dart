import 'package:flutter/material.dart';
import 'package:gogogame_frontend/core/interfaces/jsonable.dart';
import 'package:tuple/tuple.dart';

class BoardTheme extends Jsonable {
  final String name;
  final Tuple2<Color, Color> color;
  final Color lineColor;

  BoardTheme({
    required this.name,
    required this.color, // Can be null if using an image
    required this.lineColor,
  });

  BoardTheme copyWith({Tuple2<Color, Color>? boardColor, Color? lineColor}) {
    return BoardTheme(
      name: name,
      color: boardColor ?? this.color,
      lineColor: lineColor ?? this.lineColor,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "boardColor": {
        "item1": color.item1.toARGB32(),
        "item2": color.item2.toARGB32(),
      },
      "lineColor": lineColor.toARGB32(),
    };
  }

  factory BoardTheme.fromJson(Map<String, dynamic> data) {
    return BoardTheme(
      name: data["name"],
      color: Tuple2(
        Color(data["boardColor"]["item1"]),
        Color(data["boardColor"]["item2"]),
      ),
      lineColor: Color(data["lineColor"]),
    );
  }

  static List<BoardTheme> themes = [
    defaultTheme,
    lightWoodTheme,
    darkWoodTheme,
    pinkTheme,
    purpleTheme,
  ];

  static BoardTheme get defaultTheme {
    return BoardTheme(
      name: "Default",
      color: Tuple2(Color(0xFF006800), Color(0xFF008001)), // Green
      lineColor: Colors.transparent,
    );
  }

  static BoardTheme get lightWoodTheme {
    return BoardTheme(
      name: "Light Wood",
      color: Tuple2(Color(0xFFB58A5B), Color(0xFFCDA578)), // Light Wood
      lineColor: Colors.transparent,
    );
  }

  static BoardTheme get darkWoodTheme {
    return BoardTheme(
      name: "Dark Wood",
      color: Tuple2(Color(0xFF91663E), Color(0xFFA0764A)), // Dark Wood
      lineColor: Colors.transparent,
    );
  }

  static BoardTheme get pinkTheme {
    return BoardTheme(
      name: "Pink",
      color: Tuple2(Color(0xFFFB6F91), Color(0xFFFEB3C6)), // Pink
      lineColor: Colors.transparent,
    );
  }

  static BoardTheme get purpleTheme {
    return BoardTheme(
      name: "Purple",
      color: Tuple2(Color(0xFF8c72eb), Color(0xFFaa99e8)), // Purple
      lineColor: Colors.transparent,
    );
  }
}
