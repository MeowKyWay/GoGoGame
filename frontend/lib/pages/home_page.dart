import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gogogame_frontend/core/services/auth/auth_service_provider.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text('Welcome to GoGoGame!'),
            ElevatedButton(
              onPressed: ref.read(authStateProvider.notifier).logout,
              child: const Text('Logout'),
            ),
          ],
        ),
      ),
    );
  }
}
