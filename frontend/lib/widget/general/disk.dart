import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gogogame_frontend/core/themes/game_theme/game_theme.dart';
import 'package:gogogame_frontend/core/types/game_type.dart';

class Disk extends ConsumerWidget {
  final DiskColor color;
  final GameTheme theme;

  const Disk({super.key, required this.color, required this.theme});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    String path;

    switch (color) {
      case DiskColor.black:
        path = theme.diskTheme.blackPath;
        break;
      case DiskColor.white:
        path = theme.diskTheme.whitePath;
        break;
    }

    return Center(child: Image.asset(path));
  }
}
