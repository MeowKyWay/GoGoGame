import 'package:flutter/material.dart';
import 'package:gogogame_frontend/core/constants/font.dart';
import 'package:gogogame_frontend/core/extensions/build_context_extension.dart';
import 'package:gogogame_frontend/core/extensions/text_style_extension.dart';
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
    String left = format.initialTime.toString();
    String right = format.increment.toString();

    int maxLength = left.length > right.length ? left.length : right.length;

    // Make both sides equal in length by padding the shorter one
    left = left.padRight(maxLength, '\u2002');
    right = right.padLeft(maxLength, '\u2002');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(
          Icons.timer_outlined,
          color: context.colorScheme.secondary,
          size: iconSize,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(left, style: style?.withFontFamily(Font.sourceCode)),
            Text('|', style: style?.withFontFamily(Font.sourceCode)),
            Text(right, style: style?.withFontFamily(Font.sourceCode)),
          ],
        ),
      ],
    );
  }
}
