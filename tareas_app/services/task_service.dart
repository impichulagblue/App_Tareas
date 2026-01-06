import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/task_model.dart';

class TaskService {
  // 👇 Asegúrate que esta IP sea la correcta
  static const String baseUrl = 'http://192.168.1.88:3000/tasks';

  static Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  // 1. OBTENER
  static Future<List<Task>> getTasks() async {
    final token = await _getToken();
    if (token == null) return [];
    try {
      final response = await http.get(Uri.parse(baseUrl), headers: {
        'Content-Type': 'application/json', 'Authorization': 'Bearer $token',
      });
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => Task.fromJson(json)).toList();
      }
      return [];
    } catch (e) { return []; }
  }

  // 2. CREAR
  static Future<bool> createTask(String title, String desc, String priority, String date) async {
    final token = await _getToken();
    if (token == null) return false;
    try {
      final response = await http.post(Uri.parse(baseUrl), headers: {
        'Content-Type': 'application/json', 'Authorization': 'Bearer $token',
      }, body: jsonEncode({
        'title': title, 'description': desc, 'priority': priority, 'deadline': date
      }));
      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e) { return false; }
  }

  // 3. ACTUALIZAR (¡NUEVO!) 👇
  static Future<bool> updateTask(int id, String title, String desc, String priority, String date) async {
    final token = await _getToken();
    if (token == null) return false;
    try {
      final response = await http.put(Uri.parse('$baseUrl/$id'), headers: {
        'Content-Type': 'application/json', 'Authorization': 'Bearer $token',
      }, body: jsonEncode({
        'title': title, 'description': desc, 'priority': priority, 'deadline': date
      }));
      return response.statusCode == 200;
    } catch (e) { return false; }
  }

  // 4. BORRAR
  static Future<bool> deleteTask(int id) async {
    final token = await _getToken();
    if (token == null) return false;
    try {
      final response = await http.delete(Uri.parse('$baseUrl/$id'), headers: {
        'Authorization': 'Bearer $token',
      });
      return response.statusCode == 200;
    } catch (e) { return false; }
  }
}
