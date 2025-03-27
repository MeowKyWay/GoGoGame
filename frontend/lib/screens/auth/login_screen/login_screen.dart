import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gogogame_frontend/core/extensions/build_context_extension.dart';
import 'package:gogogame_frontend/core/services/config_service.dart';
import 'package:gogogame_frontend/screens/auth/login_screen/login_form.dart';
import 'package:gogogame_frontend/screens/auth/register_screens/register_step_1.dart';
import 'package:gogogame_frontend/widget/general/board_theme_modal/example_board.dart';
import 'package:gogogame_frontend/widget/input/text_divider.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  bool _isTyping = false;

  @override
  Widget build(BuildContext context) {
    final theme = ref.watch(configService).gameTheme;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        actions: [
          TextButton(
            onPressed: () {
              context.push(RegisterStep1());
            },
            child: Text('Sign Up'),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            if (!_isTyping) ...[
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 32),
                  child: FittedBox(child: ExampleBoard(theme: theme)),
                ),
              ),
              TextDivider(text: 'log in'),
            ],
            LoginForm(
              isTyping: _isTyping,
              onTyping: (isTyping) {
                setState(() {
                  _isTyping = isTyping;
                });
              },
            ),
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              height: _isTyping ? 0 : 56,
            ),
          ],
        ),
      ),
    );
  }
}
