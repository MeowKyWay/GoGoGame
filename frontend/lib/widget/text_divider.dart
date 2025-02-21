import 'package:flutter/material.dart';
import 'package:gogogame_frontend/core/extensions/build_context_extension.dart';

class TextDivider extends StatelessWidget {
  final String text;
  final TextStyle? textStyle;
  final Color? color;
  final double? thickness;
  final double? indent;
  final double? endIndent;
  final double? height;

  const TextDivider({
    super.key,
    required this.text,
    this.textStyle,
    this.color,
    this.thickness,
    this.indent,
    this.endIndent,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Divider(
            color: color ?? context.colorScheme.outlineVariant,
            thickness: thickness ?? 1,
            indent: indent ?? 0,
            height: height ?? 1,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            text,
            style:
                textStyle ??
                context.textTheme.labelSmall?.copyWith(color: color),
          ),
        ),
        Expanded(
          child: Divider(
            color: color ?? context.colorScheme.outlineVariant,
            thickness: thickness ?? 1,
            endIndent: endIndent ?? 0,
            height: height ?? 1,
          ),
        ),
      ],
    );
  }
}
