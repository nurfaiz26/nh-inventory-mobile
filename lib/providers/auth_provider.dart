import 'package:flutter/material.dart';
import 'package:nh_manajemen_inventory/services/auth_service.dart';

class AuthProvider with ChangeNotifier {
  final AuthService _authService = AuthService();
  Map<String, dynamic>? _userData;

  Map<String, dynamic>? get userData => _userData;

  Future<bool> login(String telepon) async {
    final success = await _authService.login(telepon);
    if (success) {
      _userData = await _authService.getUserData();
      notifyListeners();
    }
    return success;
  }

  Future<void> logout() async {
    await _authService.logout();
    _userData = null;
    notifyListeners();
  }

  Future<void> checkLoginStatus() async {
    _userData = await _authService.getUserData();
    notifyListeners();
  }
}
