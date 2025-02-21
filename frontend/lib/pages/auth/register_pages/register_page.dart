import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:gogogame_frontend/pages/auth/register_pages/username_page.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return UsernamePage();
  }
}
