import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:gogogame_frontend/core/extensions/build_context_extension.dart';
import 'package:gogogame_frontend/core/extensions/string_extension.dart';
import 'package:gogogame_frontend/core/extensions/text_style_extension.dart';
import 'package:gogogame_frontend/core/services/auth/auth_service_provider.dart';
import 'package:gogogame_frontend/screens/auth/register_screens/register_step_2.dart';
import 'package:gogogame_frontend/widget/validating_text_form_field.dart';

class RegisterStep1 extends ConsumerStatefulWidget {
  const RegisterStep1({super.key});

  @override
  ConsumerState<RegisterStep1> createState() => _RegisterStep1State();
}

class _RegisterStep1State extends ConsumerState<RegisterStep1> {
  final TextEditingController _emailController = TextEditingController();

  bool _isFilled = false;
  bool? _isUnique;
  bool? _isEmail;
  Timer? _debounce;
  bool _isChecking = false;

  void _onChanged(String value) {
    _debounce?.cancel();
    if (!_isChecking || _isEmail != null) {
      setState(() {
        _isChecking = true;
        _isEmail = null;
      });
    }
    _debounce = Timer(const Duration(seconds: 2), () {
      if (value.isEmail()) {
        setState(() {
          _isEmail = true;
        });
      } else {
        setState(() {
          _isChecking = false;
          _isEmail = false;
        });
        return;
      }
      ref.read(authState.notifier).checkEmail(value).then((result) {
        setState(() {
          _isChecking = false;
          _isUnique = result;
        });
      });
    });
    if (_isFilled != value.isNotEmpty || _isUnique != null) {
      setState(() {
        _isUnique = null;
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
            Text('What is your email?', style: context.textTheme.headlineLarge),
            Gap(32),
            ValidatingTextFormField(
              controller: _emailController,
              onChanged: _onChanged,
              hintText: 'Email',
              prefixIcon: Icons.email,
              isLoading: _isChecking,
              isValid: _isUnique == true && _isEmail == true,
              isInvalid: _isUnique == false || _isEmail == false,
            ),
            if ((_isUnique != null && !_isUnique!) || _isEmail == false)
              SizedBox(
                width: double.infinity,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    _isUnique == false
                        ? 'Email is already taken'
                        : 'Invalid email',
                    style: context.textTheme.labelSmall?.withColor(
                      context.colorScheme.error,
                    ),
                  ),
                ),
              ),
            Spacer(),
            FilledButton(
              style: ButtonStyle(
                minimumSize: WidgetStateProperty.all(Size(double.infinity, 56)),
              ),
              onPressed:
                  _isFilled && _isUnique == true && _isEmail == true
                      ? () {
                        context.push(
                          RegisterStep2(username: _emailController.text),
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
