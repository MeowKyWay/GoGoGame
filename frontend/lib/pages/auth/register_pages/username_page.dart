import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:gogogame_frontend/core/extensions/build_context_extension.dart';

class UsernamePage extends StatelessWidget {
  const UsernamePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.transparent),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          children: [
            Text(
              'What is your username?',
              style: context.textTheme.headlineLarge,
            ),
            TextField(
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.person),
                hintText: 'Username',
              ),
            ),
            Spacer(),
            FilledButton(
              onPressed: () {
                throw UnimplementedError();
              },
              child: const Text('Continue'),
            ),
            Gap(56),
          ],
        ),
      ),
    );
  }
}
