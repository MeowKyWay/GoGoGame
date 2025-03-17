import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gogogame_frontend/core/types/game_type.dart';

final gameTheme = StateNotifierProvider<GameThemeNotifier, GameTheme>(
  (ref) => GameThemeNotifier(),
);

class GameThemeNotifier extends StateNotifier<GameTheme> {
  GameThemeNotifier()
    : super(
        const GameTheme(
          boardColor: Color(0xFFD7A96B), // Light wood
          lineColor: Colors.black,
          blackDiskColor: Colors.black,
          whiteDiskColor: Colors.white,
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
  final Color blackDiskColor;
  final Color whiteDiskColor;
  final String? boardImage; // New field for image background

  const GameTheme({
    this.boardColor, // Can be null if using an image
    required this.lineColor,
    required this.blackDiskColor,
    required this.whiteDiskColor,
    this.boardImage,
  });

  Color getDiskColor(DiskColor color) {
    return color == DiskColor.black ? blackDiskColor : whiteDiskColor;
  }

  GameTheme copyWith({
    Color? boardColor,
    Color? lineColor,
    Color? blackDiskColor,
    Color? whiteDiskColor,
    String? boardImage,
  }) {
    return GameTheme(
      boardColor: boardColor ?? this.boardColor,
      lineColor: lineColor ?? this.lineColor,
      blackDiskColor: blackDiskColor ?? this.blackDiskColor,
      whiteDiskColor: whiteDiskColor ?? this.whiteDiskColor,
      boardImage: boardImage ?? this.boardImage,
    );
  }
}
