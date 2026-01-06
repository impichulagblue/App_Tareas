import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  // 👇 REVISA TU IP
  static const String baseUrl = 'http://192.168.1.88:3000/auth';

  static Future<bool> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', data['token']);

        // 👇 GUARDAMOS LO QUE VIENE DE LA BD
        await prefs.setString('userName', data['user']['name']);
        await prefs.setInt('avatarColor', data['user']['color'] ?? 0xFF4A00E0);
        return true;
      }
      return false;
    } catch (e) { return false; }
  }

  static Future<bool> register(String name, String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/register'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'name': name, 'email': email, 'password': password}),
      );
      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e) { return false; }
  }

  // 👇 FUNCIÓN NUEVA PARA GUARDAR PERFIL
  static Future<bool> updateProfile(String name, int color) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    if (token == null) return false;

    try {
      final response = await http.put(
        Uri.parse('$baseUrl/update'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({'name': name, 'color': color}),
      );

      if (response.statusCode == 200) {
        // Actualizamos también en el celular
        await prefs.setString('userName', name);
        await prefs.setInt('avatarColor', color);
        return true;
      }
      return false;
    } catch (e) { return false; }
  }

  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
