import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gogogame_frontend/core/themes/game_theme.dart';
import 'package:gogogame_frontend/core/types/game_type.dart';

class Disk extends ConsumerWidget {
  final DiskColor color;

  const Disk({super.key, required this.color});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Center(
      child: Container(
        decoration: BoxDecoration(
          color: ref.watch(gameThemeProvider).getDiskColor(color),
          shape: BoxShape.circle,
          border: Border.all(color: Colors.black),
        ),
      ),
    );
  }
}
