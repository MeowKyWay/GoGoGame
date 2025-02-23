import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gogogame_frontend/core/extensions/build_context_extension.dart';
import 'package:gogogame_frontend/core/extensions/text_extension.dart';
import 'package:gogogame_frontend/core/extensions/text_style_extension.dart';
import 'package:gogogame_frontend/core/services/auth/auth_service_provider.dart';
import 'package:loader_overlay/loader_overlay.dart';

class LoginForm extends ConsumerStatefulWidget {
  final bool isTyping;
  final Function(bool) onTyping;

  const LoginForm({super.key, required this.isTyping, required this.onTyping});

  @override
  ConsumerState<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends ConsumerState<LoginForm> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final FocusNode _usernameFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();

  bool _isObscure = true;
  bool _isFilled = false;

  String errorMessages = '';

  void _onSubmit(BuildContext context) async {
    final username = _usernameController.text;
    final password = _passwordController.text;
    try {
      context.loaderOverlay.show();
      await ref
          .read(authStateProvider.notifier)
          .login(username: username, password: password);
      if (!context.mounted) return;
    } on Exception catch (e) {
      setState(() {
        errorMessages = e.toString();
      });
    }
    context.loaderOverlay.hide();
  }

  @override
  void initState() {
    super.initState();
    _usernameFocus.addListener(_onFocusChange);
    _passwordFocus.addListener(_onFocusChange);
  }

  @override
  void dispose() {
    _usernameFocus.dispose();
    _passwordFocus.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _onFocusChange() {
    if (_usernameFocus.hasFocus || _passwordFocus.hasFocus) {
      if (!widget.isTyping) {
        widget.onTyping(true);
      }
      return;
    }
    if (widget.isTyping) {
      widget.onTyping(false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Flexible(
      flex: 1,
      child: Form(
        onChanged: () {
          if (_usernameController.text.isNotEmpty &&
              _passwordController.text.isNotEmpty) {
            setState(() {
              _isFilled = true;
            });
            return;
          }
          if (_isFilled) {
            setState(() {
              _isFilled = false;
            });
          }
        },
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: 16,
          children: [
            TextFormField(
              focusNode: _usernameFocus,
              controller: _usernameController,
              decoration: const InputDecoration(
                hintText: 'Email or Username',
                prefixIcon: Icon(Icons.person),
              ),
            ),
            TextFormField(
              focusNode: _passwordFocus,
              controller: _passwordController,
              decoration: InputDecoration(
                hintText: 'Password',
                prefixIcon: Icon(Icons.lock),
                suffixIcon: IconButton(
                  onPressed: () {
                    setState(() {
                      _isObscure = !_isObscure;
                    });
                  },
                  icon: Icon(
                    _isObscure ? Icons.visibility : Icons.visibility_off,
                  ),
                ),
              ),
              obscureText: _isObscure,
            ),
            TextButton(
              onPressed: () {
                throw UnimplementedError();
              },
              child: Text(
                'Forgot Password?',
              ).withColor(context.colorScheme.onSecondary),
            ),
            AnimatedContainer(
              height: _isFilled ? 56 : 0,
              duration: const Duration(milliseconds: 100),
              child: AnimatedOpacity(
                duration: const Duration(milliseconds: 300),
                opacity: _isFilled ? 1 : 0,
                child: FilledButton(
                  onPressed: () => _onSubmit(context),
                  style: ButtonStyle(
                    minimumSize: WidgetStateProperty.all(
                      Size(double.infinity, 56),
                    ),
                  ),
                  child: Text('Login', style: context.textTheme.labelLarge),
                ),
              ),
            ),
            if (errorMessages.isNotEmpty)
              Text(
                errorMessages,
                style: context.textTheme.labelSmall?.withColor(
                  context.colorScheme.error,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
