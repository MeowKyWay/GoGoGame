import 'package:flutter/material.dart';
import 'package:gogogame_frontend/core/extensions/build_context_extension.dart';
import 'package:gogogame_frontend/core/types/game_type.dart';

class FormatIcon extends StatelessWidget {
  final GameFormatType format;
  final TextStyle? style;
  final double iconSize;

  const FormatIcon({
    super.key,
    required this.format,
    this.style,
    this.iconSize = 64,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(
          Icons.timer_outlined,
          color: context.colorScheme.secondary,
          size: iconSize,
        ),
        Text(format.toString(), style: style ?? context.textTheme.bodyMedium),
      ],
    );
  }
}
