import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthService {
  final _storage = const FlutterSecureStorage();
  final String _tokenKey = 'jwt_token';

  Future<void> saveToken(String token) async {
    await _storage.write(key: _tokenKey, value: token);
  }

  Future<String?> getToken() async {
    return await _storage.read(key: _tokenKey);
  }

  Future<void> logout() async {
    await _storage.delete(key: _tokenKey);
  }

  Future<bool> isAuthenticated() async {
    final token = await getToken();

    if (token == null) return false;

    try {
      final jwt = JWT.decode(token);
      final exp = jwt.payload['exp']; // Expiration timestamp (UNIX time)

      if (exp == null) return false; // No expiration time in token

      final now = DateTime.now().millisecondsSinceEpoch ~/ 1000;
      return exp > now; // Token is valid if expiration time is in the future
    } catch (e) {
      return false; // Token is invalid
    }
  }
}
