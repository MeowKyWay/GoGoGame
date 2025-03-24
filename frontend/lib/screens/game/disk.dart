import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gogogame_frontend/core/types/game_type.dart';

class Disk extends ConsumerWidget {
  final DiskColor color;

  const Disk({super.key, required this.color});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Center(
      child: Image.asset(
        'assets/images/disk_${color.toString()}.png',
        width: 200,
        height: 200,
      ),
    );
  }
}
