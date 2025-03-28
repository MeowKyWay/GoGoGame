import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:gogogame_frontend/core/extensions/build_context_extension.dart';
import 'package:gogogame_frontend/core/services/config_service.dart';
import 'package:gogogame_frontend/widget/general/board_theme_modal/board_theme_modal.dart';
import 'package:gogogame_frontend/widget/general/board_theme_modal/disk_theme_modal.dart';
import 'package:gogogame_frontend/widget/modal/app_modal.dart';
import 'package:gogogame_frontend/widget/modal/cupertino_app_modal.dart';

class SettingsModal extends CupertinoAppModal {
  SettingsModal(
    super.context, {
    required super.vsync,
    super.onDismiss,
    super.isDismissible,
  });

  @override
  Widget buildModalContent(BuildContext context, AppModal modal) {
    return _SettingsModal(context: context, modal: this);
  }
}

class _SettingsModal extends ConsumerStatefulWidget {
  final BuildContext context;
  final SettingsModal modal;

  const _SettingsModal({required this.context, required this.modal});

  @override
  ConsumerState<_SettingsModal> createState() => _SettingsModalState();
}

class _SettingsModalState extends ConsumerState<_SettingsModal>
    with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    final config = ref.watch(configService);
    final configNotifier = ref.watch(configService.notifier);

    return Theme(
      data: context.theme,
      child: ClipRRect(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Settings'),
            actions: [
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => widget.modal.hide(),
              ),
            ],
          ),
          body: ListView(
            padding: const EdgeInsets.only(top: 16),
            children: [
              SwitchListTile(
                value: config.isMuted,
                onChanged: (value) => configNotifier.toggleMute(),
                title: Row(
                  children: [
                    Icon(config.isMuted ? Icons.volume_off : Icons.volume_up),
                    Gap(8),
                    Text(config.isMuted ? 'Sound Muted' : 'Sound On'),
                  ],
                ),
              ),
              ListTile(
                title: Row(
                  children: [
                    Icon(Icons.grid_3x3_rounded),
                    Gap(8),
                    const Text('Customize Board'),
                  ],
                ),
                onTap: () {
                  BoardThemeModal(context, vsync: this).show();
                },
              ),
              ListTile(
                title: Row(
                  children: [
                    Icon(Icons.circle),
                    Gap(8),
                    const Text('Customize Disk'),
                  ],
                ),
                onTap: () {
                  DiskThemeModal(context, vsync: this).show();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
