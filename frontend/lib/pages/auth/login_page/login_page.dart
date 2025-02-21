import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:gogogame_frontend/pages/auth/login_page/login_form.dart';
import 'package:gogogame_frontend/pages/auth/register_pages/register_page.dart';
import 'package:gogogame_frontend/widget/text_divider.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const RegisterPage()),
              );
            },
            child: Text('Sign Up'),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          children: [
            Flexible(flex: 1, child: Center(child: Text('logo'))),
            TextDivider(text: 'log in'),
            LoginForm(),
            Gap(56),
          ],
        ),
      ),
    );
  }
}
