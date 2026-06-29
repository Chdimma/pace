import 'dart:convert';
import 'package:http/http.dart' as http;

class MqttService {
  static const String baseUrl = 'http://10.0.2.2:3000/api/mqtt';

  static Future<bool> publish({required String topic, required dynamic payload}) async {
    final response = await http.post(
      Uri.parse('$baseUrl/publish'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'topic': topic, 'payload': payload}),
    );

    return response.statusCode >= 200 && response.statusCode < 300;
  }
}
