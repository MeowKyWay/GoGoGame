import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gogogame_frontend/core/extensions/build_context_extension.dart';
import 'package:gogogame_frontend/core/services/config_service.dart';
import 'package:gogogame_frontend/screens/home/home_screen.dart';
import 'package:gogogame_frontend/screens/play/play_screen.dart';
import 'package:gogogame_frontend/widget/general/board_theme_modal/example_board.dart';
import 'package:gogogame_frontend/widget/input/text_divider.dart';

class HomePage extends ConsumerWidget implements AppHomePage {
  const HomePage({super.key});

  @override
  Widget get title => const Text('Gothello');

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ref.watch(configService).gameTheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Expanded(
            flex: 1,
            child: Padding(
              padding: EdgeInsets.all(16),
              child: FittedBox(child: ExampleBoard(theme: theme)),
            ),
          ),
          TextDivider(text: 'Play'),
          Flexible(
            flex: 1,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              spacing: 16,
              children: [
                SizedBox(
                  height: 56,
                  width: double.infinity,
                  child: Hero(
                    tag: 'play',
                    child: FilledButton(
                      onPressed: () {
                        context.push(PlayScreen());
                      },
                      child: Text('Play'),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
