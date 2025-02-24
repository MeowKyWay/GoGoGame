import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gogogame_frontend/core/constants/config.dart';
import 'package:gogogame_frontend/core/services/auth/auth_service_provider.dart';
import 'package:http/http.dart' as http;
import '../auth/auth_service.dart'; // For JWT storage

final apiService = Provider(
  (ref) => ApiService(authService: ref.read(authService)),
);

class ApiService {
  final AuthService _authService; // Handles JWT storage

  ApiService({required AuthService authService}) : _authService = authService;

  Future<http.Response> postRequest(
    String endpoint,
    Map<String, dynamic> data,
  ) async {
    final url = Uri.parse("${Config.baseUrl}/$endpoint");
    final token = await _authService.getToken(); // Retrieve JWT token

    return http.post(
      url,
      headers: {
        "Content-Type": "application/json",
        if (token != null) "Authorization": "Bearer $token",
      },
      body: jsonEncode(data),
    );
  }

  Future<http.Response> getRequest(String endpoint) async {
    final url = Uri.parse("${Config.baseUrl}/$endpoint");
    final token = await _authService.getToken();

    return await http.get(
      url,
      headers: {
        "Content-Type": "application/json",
        if (token != null) "Authorization": "Bearer $token",
      },
    );
  }
}
