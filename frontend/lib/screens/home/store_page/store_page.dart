import 'package:flutter/material.dart';
import 'package:gogogame_frontend/screens/home/home_screen.dart';

class StorePage extends StatelessWidget implements AppHomePage {
  const StorePage({super.key});

  @override
  Widget get title => const Text('Store');

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('Store'));
  }
}
