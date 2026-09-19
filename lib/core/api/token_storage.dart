import 'package:shared_preferences/shared_preferences.dart';

/// Service for storing and retrieving JWT authentication tokens & user session metadata.
class TokenStorage {
  static const String _tokenKey = 'auth_bearer_token';
  static const String _refreshTokenKey = 'auth_refresh_token';
  static const String _userRoleKey = 'auth_active_user_role';

  /// Save access token.
  static Future<void> saveToken(String token) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_tokenKey, token);
    } catch (_) {}
  }

  /// Get current saved access token.
  static Future<String?> getToken() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString(_tokenKey);
    } catch (_) {
      return null;
    }
  }

  /// Save refresh token.
  static Future<void> saveRefreshToken(String refreshToken) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_refreshTokenKey, refreshToken);
    } catch (_) {}
  }

  /// Get saved refresh token.
  static Future<String?> getRefreshToken() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString(_refreshTokenKey);
    } catch (_) {
      return null;
    }
  }

  /// Save active user role string.
  static Future<void> saveActiveRole(String role) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_userRoleKey, role);
    } catch (_) {}
  }

  /// Get active user role.
  static Future<String?> getActiveRole() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString(_userRoleKey);
    } catch (_) {
      return null;
    }
  }

  /// Clear session credentials on logout.
  static Future<void> clearSession() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_tokenKey);
      await prefs.remove(_refreshTokenKey);
      await prefs.remove(_userRoleKey);
    } catch (_) {}
  }
}
