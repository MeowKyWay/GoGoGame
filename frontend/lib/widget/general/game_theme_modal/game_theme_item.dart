import 'package:flutter/material.dart';
import 'package:gogogame_frontend/core/extensions/build_context_extension.dart';
import 'package:gogogame_frontend/core/extensions/text_style_extension.dart';
import 'package:gogogame_frontend/core/themes/game_theme.dart';
import 'package:gogogame_frontend/widget/general/game_theme_modal/example_board.dart';

class GameThemeItem extends StatelessWidget {
  final GameTheme theme;
  final bool isSelected;
  final Function() onTap;

  const GameThemeItem({
    super.key,
    required this.theme,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      padding: const EdgeInsets.all(16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            theme.name,
            style: context.textTheme.labelMedium?.withFontWeight(
              isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          if (isSelected) const Icon(Icons.check, size: 24),
          const Spacer(),
          ExampleBoard(theme: theme),
        ],
      ),
    );
  }
}
