import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gogogame_frontend/core/services/api/api_service.dart';
import 'package:gogogame_frontend/core/services/auth/auth_service.dart';
import 'package:gogogame_frontend/core/types/user_type.dart';

final authService = Provider((ref) => AuthService());

final authState = StateNotifierProvider<AuthNotifier, UserType?>((ref) {
  return AuthNotifier(
    authService: ref.read(authService),
    apiService: ref.read(apiService),
  );
});

class AuthNotifier extends StateNotifier<UserType?> {
  final AuthService _authService;
  final ApiService _apiService;

  AuthNotifier({
    required AuthService authService,
    required ApiService apiService,
  }) : _authService = authService,
       _apiService = apiService,
       super(null) {
    _checkAuth();
  }

  Future<void> _checkAuth() async {
    if (await _authService.isAuthenticated()) {
      state = await _authService.getUser();
    }
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
      _checkAuth();
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
      _checkAuth();
    } else {
      throw Exception(body['message']);
    }
  }

  Future<void> logout() async {
    await _authService.logout();
    state = null;
  }

  Future<bool> checkEmail(String email) async {
    final res = await _apiService.getRequest('users/check-email/$email');
    final body = jsonDecode(res.body);
    return body == false;
  }

  Future<bool> checkUsername(String username) async {
    final res = await _apiService.getRequest('users/check-username/$username');
    final body = jsonDecode(res.body);
    return body == false;
  }
}
