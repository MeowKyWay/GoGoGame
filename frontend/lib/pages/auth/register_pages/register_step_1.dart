import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:gogogame_frontend/core/extensions/build_context_extension.dart';
import 'package:gogogame_frontend/core/extensions/text_style_extension.dart';
import 'package:gogogame_frontend/core/services/api/api_service.dart';
import 'package:gogogame_frontend/pages/auth/register_pages/register_step_2.dart';

class RegisterStep1 extends ConsumerStatefulWidget {
  const RegisterStep1({super.key});

  @override
  ConsumerState<RegisterStep1> createState() => _RegisterStep1State();
}

class _RegisterStep1State extends ConsumerState<RegisterStep1> {
  final TextEditingController _usernameController = TextEditingController();

  bool _isFilled = false;
  bool? _isUnique;
  Timer? _debounce;

  void _onChanged(String value) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(seconds: 1), () {
      ref
          .read(apiServiceProvider)
          .getRequest('users/check-username/$value')
          .then((res) {
            bool isUnique = res.body == 'false';
            if (_isUnique != isUnique) {
              setState(() {
                _isUnique = isUnique;
              });
            }
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
            Text(
              'What is your username?',
              style: context.textTheme.headlineLarge,
            ),
            Gap(32),
            TextField(
              controller: _usernameController,
              onChanged: _onChanged,
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.person),
                hintText: 'Username',
              ),
            ),
            if (_isUnique != null && !_isUnique!)
              SizedBox(
                width: double.infinity,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'This username is already taken',
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
                  _isFilled && _isUnique == true
                      ? () {
                        context.push(
                          RegisterStep2(username: _usernameController.text),
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
