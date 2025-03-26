import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:gogogame_frontend/core/extensions/build_context_extension.dart';
import 'package:gogogame_frontend/core/services/auth/auth_service_provider.dart';
import 'package:gogogame_frontend/core/services/config_service.dart';
import 'package:gogogame_frontend/screens/home/home_screen.dart';

class Store extends ConsumerWidget implements AppHomePage {
  const Store({super.key});

  @override
  Widget get title => const Text('More');

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final config = ref.watch(configService);
    final configNotifier = ref.watch(configService.notifier);

    return ListView(
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
