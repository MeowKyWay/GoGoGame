import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gogogame_frontend/core/services/auth/auth_service_provider.dart';
import 'package:gogogame_frontend/screens/home/home_screen.dart';

class MorePage extends ConsumerWidget implements AppHomePage {
  const MorePage({Key? key});

  @override
  Widget get title => const Text('More');

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Center(
      child: FilledButton(
        onPressed: () {
          ref.read(authState.notifier).logout();
        },
        child: Text('Logout'),
      ),
    );
  }
}
