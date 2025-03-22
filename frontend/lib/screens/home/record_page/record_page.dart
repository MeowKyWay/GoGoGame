import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gogogame_frontend/core/services/record/record_provider.dart';
import 'package:gogogame_frontend/screens/home/home_screen.dart';

class Record extends ConsumerWidget implements AppHomePage {
  const Record({super.key});

  @override
  Widget get title => const Text('Store');

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(recordProvider);
    return const Center(child: Text('History'));
  }
}
