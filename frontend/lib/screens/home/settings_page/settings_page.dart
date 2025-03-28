import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:gogogame_frontend/core/extensions/build_context_extension.dart';
import 'package:gogogame_frontend/core/services/auth/auth_service_provider.dart';
import 'package:gogogame_frontend/core/services/config_service.dart';
import 'package:gogogame_frontend/screens/home/home_screen.dart';
import 'package:gogogame_frontend/widget/general/board_theme_modal/board_theme_modal.dart';
import 'package:gogogame_frontend/widget/general/board_theme_modal/disk_theme_modal.dart';

class Store extends ConsumerStatefulWidget implements AppHomePage {
  const Store({super.key});

  @override
  Widget get title => const Text('Settings');

  @override
  ConsumerState<Store> createState() => _StoreState();
}

class _StoreState extends ConsumerState<Store> with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    final config = ref.watch(configService);
    final configNotifier = ref.watch(configService.notifier);

    final user = ref.watch(authState);

    return ListView(
      children: [
        ListTile(
          title: Row(
            children: [
              Icon(Icons.person),
              Gap(8),
              Text(user?.username ?? 'Guest'),
            ],
          ),
        ),
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
        Padding(
          padding: EdgeInsets.all(8),
          child: FilledButton(
            onPressed: () {
              ref.read(authState.notifier).logout();
            },
            style: ButtonStyle(
              backgroundColor: WidgetStateProperty.all(
                context.colorScheme.error,
              ),
            ),
            child: const Text('Logout'),
          ),
        ),
      ],
    );
  }
}
