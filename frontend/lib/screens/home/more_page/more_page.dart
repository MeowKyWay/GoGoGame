import 'package:flutter/material.dart';
import 'package:gogogame_frontend/screens/home/home_screen.dart';

class MorePage extends StatelessWidget implements AppHomePage {
  const MorePage({Key? key});

  @override
  Widget get title => const Text('More');

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('More'));
  }
}
