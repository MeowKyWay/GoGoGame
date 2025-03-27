import 'package:gogogame_frontend/core/interfaces/jsonable.dart';
import 'package:gogogame_frontend/core/themes/game_theme/board_theme.dart';
import 'package:gogogame_frontend/core/themes/game_theme/disk_theme.dart';

class GameTheme extends Jsonable {
  final BoardTheme boardTheme;
  final DiskTheme diskTheme;

  GameTheme({required this.boardTheme, required this.diskTheme});

  @override
  Map<String, dynamic> toJson() {
    return {"boardTheme": boardTheme.toJson(), "diskTheme": diskTheme.toJson()};
  }

  GameTheme copyWith({BoardTheme? boardTheme, DiskTheme? diskTheme}) {
    return GameTheme(
      boardTheme: boardTheme ?? this.boardTheme,
      diskTheme: diskTheme ?? this.diskTheme,
    );
  }

  String themeName(GameThemeType type) {
    switch (type) {
      case GameThemeType.board:
        return boardTheme.name;
      case GameThemeType.disk:
        return diskTheme.name;
    }
  }

  factory GameTheme.fromJson(Map<String, dynamic> data) {
    return GameTheme(
      boardTheme: BoardTheme.fromJson(data["boardTheme"]),
      diskTheme: DiskTheme.fromJson(data["diskTheme"]),
    );
  }

  static GameTheme get defaultTheme {
    return GameTheme(
      boardTheme: BoardTheme.defaultTheme,
      diskTheme: DiskTheme.glossy,
    );
  }
}

enum GameThemeType { board, disk }
