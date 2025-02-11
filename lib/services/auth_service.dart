import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  final String _baseUrl =
      'https://assets.itnh.systems/api'; // Replace with your API URL

  Future<bool> login(String telepon) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'telepon': telepon}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setInt('id', data['data']['id']);
      await prefs.setString('nama', data['data']['nama']);
      await prefs.setString('telepon', data['data']['telepon']);
      await prefs.setInt('status', data['data']['status']);
      await prefs.setString('level', data['data']['level']);
      await prefs.setInt('gudang_id', data['data']['gudang_id']);
      return true;
    } else {
      return false;
    }
  }

  Future<void> logout() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('id');
    await prefs.remove('nama');
    await prefs.remove('telepon');
    await prefs.remove('status');
    await prefs.remove('level');
    await prefs.remove('gudang_id');
  }

  Future<Map<String, dynamic>?> getUserData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final id = prefs.getInt('id');
    final nama = prefs.getString('nama');
    final telepon = prefs.getString('telepon');
    final status = prefs.getInt('status');
    final level = prefs.getString('level');
    final gudangId = prefs.getInt('gudang_id');

    if (id != null &&
        nama != null &&
        telepon != null &&
        status != null &&
        level != null &&
        gudangId != null) {
      return {
        'id': id,
        'nama': nama,
        'telepon': telepon,
        'status': status,
        'level': level,
        'gudangId': gudangId
      };
    }
    return null;
  }
}
