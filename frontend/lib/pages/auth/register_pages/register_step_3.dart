import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:gogogame_frontend/core/extensions/build_context_extension.dart';
import 'package:gogogame_frontend/core/extensions/string_extension.dart';
import 'package:gogogame_frontend/core/extensions/text_extension.dart';
import 'package:gogogame_frontend/core/services/api/api_service.dart';
import 'package:gogogame_frontend/core/services/auth/auth_service_provider.dart';
import 'package:gogogame_frontend/widget/validating_text_form_field.dart';
import 'package:loader_overlay/loader_overlay.dart';

class RegisterStep3 extends ConsumerStatefulWidget {
  final String email;
  final String password;

  const RegisterStep3({super.key, required this.email, required this.password});

  @override
  ConsumerState<RegisterStep3> createState() => _RegisterStep3State();
}

class _RegisterStep3State extends ConsumerState<RegisterStep3> {
  final TextEditingController _usernameController = TextEditingController();

  bool _isChecking = false;
  Timer? _debounce;
  String? _errorMessage;

  void _onChanged(String value) {
    _debounce?.cancel();
    if (!_isChecking || (_errorMessage != null && _errorMessage!.isNotEmpty)) {
      setState(() {
        _isChecking = true;
        _errorMessage = '';
      });
    }
    _debounce = Timer(const Duration(seconds: 2), () {
      if (!value.isLenght(minLength: 3)) {
        _errorMessage = 'Too short';
      } else if (!value.isLenght(maxLength: 20)) {
        _errorMessage = 'Too long';
      } else if (value.isUsername()) {
        ref
            .read(apiServiceProvider)
            .getRequest('users/check-username/$value')
            .then((res) {
              log(res.body);
              bool isUnique = res.body != 'true';
              _errorMessage = isUnique ? '' : 'Username is already taken';
            });
      } else {
        _errorMessage = 'Only letters, numbers and underscores are allowed';
      }

      setState(() {
        _isChecking = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.transparent),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          children: [
            Text('Choose a username', style: context.textTheme.headlineLarge),
            Gap(16),
            Text(
              'This is what your friends and other players will see when you play.',
              textAlign: TextAlign.center,
              style: context.textTheme.bodyLarge,
            ).withColor(context.colorScheme.onSecondary),
            Gap(32),
            ValidatingTextFormField(
              controller: _usernameController,
              onChanged: _onChanged,
              hintText: 'Username',
              isLoading: _isChecking,
              isValid: !_isChecking && _errorMessage == '',
              isInvalid:
                  !_isChecking &&
                  _errorMessage != null &&
                  _errorMessage!.isNotEmpty,
            ),
            if (_errorMessage != null && _errorMessage!.isNotEmpty)
              SizedBox(
                width: double.infinity,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    _errorMessage!,
                    style: context.textTheme.bodyMedium,
                  ).withColor(context.colorScheme.error),
                ),
              ),

            Spacer(),
            FilledButton(
              style: ButtonStyle(
                minimumSize: WidgetStateProperty.all(Size(double.infinity, 56)),
              ),
              onPressed:
                  _errorMessage == '' && _isChecking == false
                      ? () async {
                        context.loaderOverlay.show();
                        ref
                            .read(authStateProvider.notifier)
                            .register(
                              email: widget.email,
                              username: _usernameController.text,
                              password: widget.password,
                            )
                            .then((value) {
                              if (context.mounted) {
                                context.loaderOverlay.hide();
                              }
                            });
                      }
                      : null,
              child: const Text('Create Account'),
            ),
            Gap(24),
            SafeArea(child: Container()),
          ],
        ),
      ),
    );
  }
}
