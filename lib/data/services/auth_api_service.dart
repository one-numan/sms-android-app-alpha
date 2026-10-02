import '../../core/api/api_client.dart';
import '../../core/api/api_exception.dart';
import '../../core/api/token_storage.dart';

/// Authentication API Service.
class AuthApiService {
  final ApiClient _apiClient;

  AuthApiService({ApiClient? apiClient}) : _apiClient = apiClient ?? ApiClient();

  /// Login with username/email and password.
  Future<Map<String, dynamic>> login({
    required String username,
    required String password,
    String? role,
  }) async {
    final response = await _apiClient.post(
      '/auth/login/',
      body: {
        'username': username,
        'password': password,
      },
    );

    if (response is Map<String, dynamic>) {
      final token = response['access'] ?? response['token'] ?? response['access_token'];
      if (token != null && token is String) {
        await TokenStorage.saveToken(token);
      }
      if (response.containsKey('refresh') && response['refresh'] is String) {
        await TokenStorage.saveRefreshToken(response['refresh']);
      }
      if (role != null) {
        await TokenStorage.saveActiveRole(role);
      }
      return response;
    }
    return {'status': 'success', 'data': response};
  }

  /// Verify 2FA OTP code.
  Future<Map<String, dynamic>> verifyOtp({
    required String loginToken,
    required String code,
  }) async {
    final response = await _apiClient.post(
      '/auth/otp/verify/',
      body: {
        'login_token': loginToken,
        'code': code,
      },
    );

    if (response is Map<String, dynamic>) {
      final token = response['access'] ?? response['token'];
      if (token != null && token is String) {
        await TokenStorage.saveToken(token);
      }
      if (response.containsKey('refresh') && response['refresh'] is String) {
        await TokenStorage.saveRefreshToken(response['refresh']);
      }
      return response;
    }
    return {'data': response};
  }

  /// Reset Password.
  Future<Map<String, dynamic>> resetPassword({
    required String identity,
    required String newPassword,
  }) async {
    final response = await _apiClient.post(
      '/auth/password/reset',
      body: {
        'identity': identity,
        'new_password': newPassword,
      },
    );
    return response is Map<String, dynamic> ? response : {'data': response};
  }

  /// Refresh active JWT token using refresh token (`POST /api/v1/auth/token/refresh/`).
  Future<Map<String, dynamic>> refreshToken({String? refreshToken}) async {
    final token = refreshToken ?? await TokenStorage.getRefreshToken();
    if (token == null || token.trim().isEmpty) {
      throw const UnauthorizedException('No refresh token available');
    }
    final response = await _apiClient.post(
      '/auth/token/refresh/',
      body: {'refresh': token},
    );
    if (response is Map<String, dynamic>) {
      final newAccess = response['access'] ?? response['token'] ?? response['access_token'];
      if (newAccess != null && newAccess is String) {
        await TokenStorage.saveToken(newAccess);
      }
      final newRefresh = response['refresh'] ?? response['refresh_token'];
      if (newRefresh != null && newRefresh is String) {
        await TokenStorage.saveRefreshToken(newRefresh);
      }
      return response;
    }
    return {'status': 'success', 'data': response};
  }

  /// Logout and revoke active session token.
  Future<void> logout() async {
    try {
      await _apiClient.post('/auth/logout');
    } catch (_) {
      // Clear token locally regardless of server status
    } finally {
      await TokenStorage.clearSession();
    }
  }
}
