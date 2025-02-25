import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final gameThemeProvider = StateNotifierProvider<GameThemeNotifier, GameTheme>(
  (ref) => GameThemeNotifier(),
);

class GameThemeNotifier extends StateNotifier<GameTheme> {
  GameThemeNotifier()
    : super(
        const GameTheme(
          boardColor: Color(0xFFD7A96B), // Light wood
          lineColor: Colors.black,
          starPointColor: Colors.black,
          blackStoneColor: Colors.black,
          whiteStoneColor: Colors.white,
          boardImage: null, // Default is no image
        ),
      );

  void updateTheme(GameTheme newTheme) {
    state = newTheme;
  }
}

class GameTheme {
  final Color? boardColor;
  final Color lineColor;
  final Color starPointColor;
  final Color blackStoneColor;
  final Color whiteStoneColor;
  final String? boardImage; // New field for image background

  const GameTheme({
    this.boardColor, // Can be null if using an image
    required this.lineColor,
    required this.starPointColor,
    required this.blackStoneColor,
    required this.whiteStoneColor,
    this.boardImage,
  });

  GameTheme copyWith({
    Color? boardColor,
    Color? lineColor,
    Color? starPointColor,
    Color? blackStoneColor,
    Color? whiteStoneColor,
    String? boardImage,
  }) {
    return GameTheme(
      boardColor: boardColor ?? this.boardColor,
      lineColor: lineColor ?? this.lineColor,
      starPointColor: starPointColor ?? this.starPointColor,
      blackStoneColor: blackStoneColor ?? this.blackStoneColor,
      whiteStoneColor: whiteStoneColor ?? this.whiteStoneColor,
      boardImage: boardImage ?? this.boardImage,
    );
  }
}
