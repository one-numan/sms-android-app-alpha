import '../../core/api/api_client.dart';

/// Parent Portal API Service.
class ParentApiService {
  final ApiClient _apiClient;

  ParentApiService({ApiClient? apiClient}) : _apiClient = apiClient ?? ApiClient();

  /// Fetch Parent Dashboard overview.
  Future<Map<String, dynamic>> getDashboard() async {
    final response = await _apiClient.get('/parent/dashboard/');
    if (response is Map<String, dynamic> && response.containsKey('data')) {
      return response['data'] is Map<String, dynamic> ? response['data'] : response;
    }
    return response is Map<String, dynamic> ? response : {};
  }
}
