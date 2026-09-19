import '../../core/api/api_client.dart';
import '../../core/api/token_storage.dart';

/// Authentication API Service.
class AuthApiService {
  final ApiClient _apiClient;

  AuthApiService({ApiClient? apiClient}) : _apiClient = apiClient ?? ApiClient();

  /// Login with username/email and password.
  Future<Map<String, dynamic>> login({
    required String identity,
    required String password,
    String? role,
  }) async {
    final response = await _apiClient.post(
      '/auth/login',
      body: {
        'identity': identity,
        'password': password,
        if (role != null) 'role': role,
      },
    );

    if (response is Map<String, dynamic>) {
      final token = response['token'] ?? response['access_token'];
      if (token != null && token is String) {
        await TokenStorage.saveToken(token);
      }
      if (response.containsKey('refresh_token') && response['refresh_token'] is String) {
        await TokenStorage.saveRefreshToken(response['refresh_token']);
      }
      if (role != null) {
        await TokenStorage.saveActiveRole(role);
      }
      return response;
    }
    return {'status': 'success', 'data': response};
  }

  /// Send OTP code to 2FA phone/email.
  Future<Map<String, dynamic>> requestOtp(String identity) async {
    final response = await _apiClient.post(
      '/auth/otp/request',
      body: {'identity': identity},
    );
    return response is Map<String, dynamic> ? response : {'status': 'success'};
  }

  /// Verify 2FA OTP code.
  Future<Map<String, dynamic>> verifyOtp({
    required String identity,
    required String otpCode,
  }) async {
    final response = await _apiClient.post(
      '/auth/otp/verify',
      body: {
        'identity': identity,
        'otp': otpCode,
      },
    );
    return response is Map<String, dynamic> ? response : {'status': 'verified'};
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
    return response is Map<String, dynamic> ? response : {'status': 'success'};
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
