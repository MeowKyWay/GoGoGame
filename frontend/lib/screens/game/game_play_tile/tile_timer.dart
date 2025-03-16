import 'dart:developer';

import 'package:flutter/widgets.dart';
import 'package:gogogame_frontend/core/extensions/build_context_extension.dart';
import 'package:gogogame_frontend/core/extensions/text_style_extension.dart';

class TileTimer extends StatelessWidget {
  final int? timeLeft;

  const TileTimer({super.key, required this.timeLeft});

  @override
  Widget build(BuildContext context) {
    log(timeLeft.toString());
    return Container(
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: context.colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(8),
      ),
      child:
          timeLeft != null
              ? Text(
                (timeLeft! / 1000).round().toString(),
                style: context.textTheme.labelMedium?.withColor(
                  context.colorScheme.onPrimaryContainer,
                ),
              )
              : null,
    );
  }
}
