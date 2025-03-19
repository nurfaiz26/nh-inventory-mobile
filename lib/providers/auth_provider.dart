import 'package:flutter/material.dart';
import 'package:nh_manajemen_inventory/services/auth_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

  Future<bool> isUserLoggedOut() async {
    final prefs = await SharedPreferences.getInstance();
    String? lastLoginString = prefs.getString('log_date');

    if (lastLoginString != null) {
      DateTime lastLogin = DateTime.parse(lastLoginString);
      DateTime now = DateTime.now();

      // Check if more than 24 hours have passed
      if (now.difference(lastLogin).inDays >= 2) {
        return true; // User should be logged out
      }
    }
    return false; // User is still logged in
  }

  Future<bool> isUserRefetch() async {
    final prefs = await SharedPreferences.getInstance();
    String? lastLoginTelepon = prefs.getString('telepon');

    if (lastLoginTelepon != null) {
      final loginAgain =  await login(lastLoginTelepon);

      if (loginAgain) {
        return true;
      }
    }
    return false;
  }

  Future<void> checkLoginStatus() async {
    bool shouldLogout = await isUserLoggedOut();

    if (shouldLogout) {
      logout();
    } else {
      bool relogin = await isUserRefetch();

      if(relogin) {
        _userData = await _authService.getUserData();
      } else {
        logout();
      }
    }

    notifyListeners();
  }
}
