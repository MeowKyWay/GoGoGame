import 'package:flutter/material.dart';
import 'package:gogogame_frontend/core/extensions/build_context_extension.dart';
import 'package:gogogame_frontend/core/extensions/text_style_extension.dart';
import 'package:gogogame_frontend/core/themes/game_theme/game_theme.dart';
import 'package:gogogame_frontend/widget/general/board_theme_modal/example_board.dart';

class GameThemeItem extends StatelessWidget {
  final GameTheme theme;
  final GameThemeType type;
  final bool isSelected;
  final Function() onTap;

  const GameThemeItem({
    super.key,
    required this.theme,
    required this.type,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        color: Colors.transparent,
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 3,
              child: Row(
                children: [
                  Text(
                    theme.themeName(type),
                    style: context.textTheme.labelMedium?.withFontWeight(
                      isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                  if (isSelected) const Icon(Icons.check, size: 24),
                ],
              ),
            ),
            Expanded(
              flex: 2,
              child: FittedBox(child: ExampleBoard(theme: theme)),
            ),
          ],
        ),
      ),
    );
  }
}
