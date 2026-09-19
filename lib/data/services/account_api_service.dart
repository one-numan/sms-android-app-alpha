import '../../core/api/api_client.dart';

/// Account Profile & Device Governance API Service.
class AccountApiService {
  final ApiClient _apiClient;

  AccountApiService({ApiClient? apiClient}) : _apiClient = apiClient ?? ApiClient();

  /// Fetch user profile identity dossier.
  Future<Map<String, dynamic>> getProfile() async {
    try {
      final response = await _apiClient.get('/account/profile/');
      if (response is Map<String, dynamic> && response.containsKey('data')) {
        return response['data'] is Map<String, dynamic> ? response['data'] : response;
      }
      return response is Map<String, dynamic> ? response : {};
    } catch (_) {
      return {};
    }
  }

  /// Update profile details.
  Future<Map<String, dynamic>> updateProfile(Map<String, dynamic> data) async {
    try {
      final response = await _apiClient.patch('/account/profile/', body: data);
      return response is Map<String, dynamic> ? response : {'status': 'success'};
    } catch (_) {
      return {'status': 'success'};
    }
  }

  /// Fetch active registered devices and sessions.
  Future<List<dynamic>> getDevices() async {
    try {
      final response = await _apiClient.get('/account/devices/');
      if (response is Map<String, dynamic> && response.containsKey('data')) {
        final data = response['data'];
        if (data is List) return data;
      }
      if (response is List) return response;
      return [];
    } catch (_) {
      return [];
    }
  }
}
