import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gogogame_frontend/core/services/api/api_service.dart';
import 'package:gogogame_frontend/core/services/auth/auth_service.dart';

final authServiceProvider = Provider((ref) => AuthService());

final authStateProvider = StateNotifierProvider<AuthNotifier, bool>((ref) {
  return AuthNotifier(
    authService: ref.read(authServiceProvider),
    apiService: ref.read(apiServiceProvider),
  );
});

class AuthNotifier extends StateNotifier<bool> {
  final AuthService _authService;
  final ApiService _apiService;

  AuthNotifier({
    required AuthService authService,
    required ApiService apiService,
  }) : _authService = authService,
       _apiService = apiService,
       super(false) {
    _checkAuth();
  }

  Future<void> _checkAuth() async {
    state = await _authService.isAuthenticated();
  }

  Future<void> login({
    required String username,
    required String password,
  }) async {
    final res = await _apiService.postRequest('auth/signin', {
      'username': username,
      'password': password,
    });

    final body = jsonDecode(res.body);
    if (body['access_token'] != null) {
      await _authService.saveToken(body['access_token']);
      state = true;
    } else {
      throw Exception(body['message']);
    }
  }

  Future<void> register({
    required String email,
    required String username,
    required String password,
  }) async {
    final res = await _apiService.postRequest('auth/signup', {
      'email': email,
      'username': username,
      'password': password,
    });

    final body = jsonDecode(res.body);
    if (body['access_token'] != null) {
      await _authService.saveToken(body['access_token']);
      state = true;
    } else {
      throw Exception(body['message']);
    }
  }

  Future<void> logout() async {
    await _authService.logout();
    state = false;
  }
}
