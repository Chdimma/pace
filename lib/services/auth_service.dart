import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'api_config.dart';

class AuthService {
  static const int timeoutSeconds = 10;

  static String get baseUrl => '${ApiConfig.authBaseUrl}/auth';

  static Map<String, dynamic> buildLoginPayload({
    String? email,
    String? phoneNumber,
    required String password,
  }) {
    final payload = <String, dynamic>{'password': password};

    if (email != null && email.isNotEmpty) {
      payload['email'] = email;
    }

    if (phoneNumber != null && phoneNumber.isNotEmpty) {
      payload['phoneNumber'] = phoneNumber;
    }

    return payload;
  }

  static Future<Map<String, dynamic>> login({
    String? email,
    String? phoneNumber,
    required String password,
  }) async {
    try {
      final payload = buildLoginPayload(
        email: email,
        phoneNumber: phoneNumber,
        password: password,
      );

      final response = await http.post(
        Uri.parse('$baseUrl/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(payload),
      ).timeout(Duration(seconds: timeoutSeconds));

      if (response.body.isEmpty) {
        throw Exception('Empty response from backend at $baseUrl');
      }

      try {
        final body = jsonDecode(response.body);
        if (response.statusCode >= 200 && response.statusCode < 300) {
          return body is Map<String, dynamic>
              ? body
              : {'success': false, 'message': body.toString()};
        }

        if (body is Map<String, dynamic>) {
          final errorMessage = body['error'] ?? body['message'] ?? 'Login failed';
          throw Exception(errorMessage.toString());
        }

        throw Exception('Login failed');
      } catch (error) {
        if (error is Exception) {
          rethrow;
        }
        throw Exception('Invalid server response: ${response.body}');
      }
    } on TimeoutException {
      throw Exception('Request timeout. Backend may be offline.');
    } on http.ClientException catch (error) {
      throw Exception('Network error while contacting the backend: ${error.message}');
    } catch (error) {
      throw Exception('Backend error: $error');
    }
  }

  // Store token for authenticated requests
  static String? _authToken;

  static void setToken(String? token) {
    _authToken = token;
  }

  static String? get authToken => _authToken;

  static Future<Map<String, dynamic>> deleteAccount() async {
    try {
      if (_authToken == null) {
        throw Exception('You must be logged in to delete your account.');
      }

      final response = await http.delete(
        Uri.parse('$baseUrl/delete-account'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_authToken',
        },
      ).timeout(Duration(seconds: timeoutSeconds));

      if (response.body.isEmpty) {
        throw Exception('Empty response from backend');
      }

      final body = jsonDecode(response.body);
      if (response.statusCode >= 200 && response.statusCode < 300) {
        // Clear token on successful deletion
        _authToken = null;
        return body is Map<String, dynamic>
            ? body
            : {'success': false, 'message': body.toString()};
      }

      if (body is Map<String, dynamic>) {
        final errorMessage = body['error'] ?? body['message'] ?? 'Delete failed';
        throw Exception(errorMessage.toString());
      }

      throw Exception('Failed to delete account');
    } on TimeoutException {
      throw Exception('Request timeout. Backend may be offline.');
    } on http.ClientException catch (error) {
      throw Exception('Network error: ${error.message}');
    } catch (error) {
      if (error is Exception) rethrow;
      throw Exception('Failed to delete account: $error');
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
          return body is Map<String, dynamic>
              ? body
              : {'success': false, 'message': body.toString()};
        }

        if (body is Map<String, dynamic>) {
          final errorMessage = body['error'] ?? body['message'] ?? 'Signup failed';
          throw Exception(errorMessage.toString());
        }

        throw Exception('Signup failed');
      } catch (error) {
        if (error is Exception) {
          rethrow;
        }
        throw Exception('Invalid server response: ${response.body}');
      }
    } on TimeoutException {
      throw Exception('Request timeout. Backend may be offline.');
    } on http.ClientException catch (error) {
      throw Exception('Network error while contacting the backend: ${error.message}');
    } catch (error) {
      throw Exception('Backend error: $error');
    }
  }
}
