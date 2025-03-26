import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gogogame_frontend/core/extensions/build_context_extension.dart';
import 'package:gogogame_frontend/core/services/config_service.dart';
import 'package:gogogame_frontend/core/themes/game_theme.dart';
import 'package:gogogame_frontend/widget/general/game_theme_modal/game_theme_item.dart';
import 'package:gogogame_frontend/widget/modal/app_modal.dart';
import 'package:gogogame_frontend/widget/modal/cupertino_app_modal.dart';

/// usage: await ConfirmModal(context).show();
/// returns: true if right button is clicked, false if left button is clicked
/// returns: null if modal is dismissed
class GameThemeModal extends CupertinoAppModal {
  GameThemeModal(super.context, {required super.vsync});

  @override
  Widget buildModalContent(BuildContext context, AppModal modal) {
    return _GameThemeModal(context: context, modal: this);
  }
}

class _GameThemeModal extends ConsumerWidget {
  final BuildContext context;
  final GameThemeModal modal;

  const _GameThemeModal({required this.context, required this.modal});

  @override
  Widget build(BuildContext _, WidgetRef ref) {
    final config = ref.watch(configService);
    final configNotifier = ref.watch(configService.notifier);

    final selectedTheme = config.gameTheme;

    return Theme(
      data: context.theme,
      child: ClipRRect(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Game Theme'),
            actions: [
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => modal.hide(),
              ),
            ],
          ),
          body: ListView(
            children: [
              for (var theme in GameTheme.themes)
                GameThemeItem(
                  theme: theme,
                  isSelected: selectedTheme.name == theme.name,
                  onTap: () {
                    configNotifier.changeGameTheme(theme);
                    log(config.gameTheme.name);
                    modal.hide();
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }
}
