import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthService {
  // Update this to your deployed backend URL
  static const String baseUrl = 'https://pace-fawn.vercel.app/api/auth';
  static const int timeoutSeconds = 10;

  static Future<Map<String, dynamic>> login({required String email, required String password}) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      ).timeout(Duration(seconds: timeoutSeconds));

      if (response.body.isEmpty) {
        throw Exception('Empty response from backend at $baseUrl');
      }

      try {
        final body = jsonDecode(response.body);
        if (response.statusCode >= 200 && response.statusCode < 300) {
          return body is Map<String, dynamic> ? body : {'success': false, 'message': body.toString()};
        }
        throw Exception(body['error'] ?? 'Login failed');
      } catch (error) {
        throw Exception('Invalid server response: ${response.body}');
      }
    } on TimeoutException {
      throw Exception('Request timeout. Backend may be offline.');
    } catch (error) {
      throw Exception('Backend error: $error');
    }
  }

  static Future<Map<String, dynamic>> signup({
    required String name,
    required String email,
    required String password,
    required String username,
    String? phoneNumber,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/signup'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'name': name,
          'email': email,
          'password': password,
          'username': username,
          'phoneNumber': phoneNumber,
        }),
      ).timeout(Duration(seconds: timeoutSeconds));

      if (response.body.isEmpty) {
        throw Exception('Empty response from backend at $baseUrl');
      }

      try {
        final body = jsonDecode(response.body);
        if (response.statusCode >= 200 && response.statusCode < 300) {
          return body is Map<String, dynamic> ? body : {'success': false, 'message': body.toString()};
        }
        throw Exception(body['error'] ?? 'Signup failed');
      } catch (error) {
        throw Exception('Invalid server response: ${response.body}');
      }
    } on TimeoutException {
      throw Exception('Request timeout. Backend may be offline.');
    } catch (error) {
      throw Exception('Backend error: $error');
    }
  }
}
