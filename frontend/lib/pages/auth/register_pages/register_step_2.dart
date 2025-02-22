import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:gogogame_frontend/core/extensions/build_context_extension.dart';
import 'package:gogogame_frontend/pages/auth/register_pages/register_step_3.dart';

class RegisterStep2 extends ConsumerStatefulWidget {
  final String username;

  const RegisterStep2({super.key, required this.username});

  @override
  ConsumerState<RegisterStep2> createState() => _RegisterStep1State();
}

class _RegisterStep1State extends ConsumerState<RegisterStep2> {
  final TextEditingController _passwordController = TextEditingController();

  bool _isFilled = false;
  bool _isObscure = true;

  void _onChanged(String value) {
    if (_isFilled != value.isNotEmpty) {
      setState(() {
        _isFilled = value.isNotEmpty;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.transparent),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          children: [
            Text('Create a password', style: context.textTheme.headlineLarge),
            Gap(32),
            TextField(
              controller: _passwordController,
              onChanged: _onChanged,
              obscureText: _isObscure,
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.lock),
                suffixIcon: IconButton(
                  icon: Icon(
                    _isObscure ? Icons.visibility : Icons.visibility_off,
                  ),
                  onPressed: () {
                    setState(() {
                      _isObscure = !_isObscure;
                    });
                  },
                ),
                hintText: 'Password',
              ),
            ),
            Spacer(),
            FilledButton(
              style: ButtonStyle(
                minimumSize: WidgetStateProperty.all(Size(double.infinity, 56)),
              ),
              onPressed:
                  _isFilled
                      ? () {
                        context.push(
                          RegisterStep3(
                            email: widget.username,
                            password: _passwordController.text,
                          ),
                        );
                      }
                      : null,
              child: const Text('Continue'),
            ),
            Gap(24),
            SafeArea(child: Container()),
          ],
        ),
      ),
    );
  }
}
