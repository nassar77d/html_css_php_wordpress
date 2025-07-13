import 'package:http/http.dart' as http;
import 'dart:convert';

class AuthService {
  static const String _baseUrl = "http://10.0.2.2:80/api.php";

  static Future<Map<String, dynamic>> login(String username, String password) async {
    final response = await http.post(
      Uri.parse(_baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'action': 'login',
        'username': username,
        'password': password,
      }),
    );
    return json.decode(response.body);
  }

  static Future<Map<String, dynamic>> register(String username, String password) async {
    final response = await http.post(
      Uri.parse(_baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'action': 'register',
        'username': username,
        'password': password,
      }),
    );
    return json.decode(response.body);
  }
}