import '../../core/api/api_client.dart';

/// Principal & Executive Operations API Service.
class PrincipalApiService {
  final ApiClient _apiClient;

  PrincipalApiService({ApiClient? apiClient}) : _apiClient = apiClient ?? ApiClient();

  /// Fetch Principal Hub Executive KPIs.
  Future<Map<String, dynamic>> getDashboard() async {
    final response = await _apiClient.get('/principal/dashboard/');
    if (response is Map<String, dynamic> && response.containsKey('data')) {
      return response['data'] is Map<String, dynamic> ? response['data'] : response;
    }
    return response is Map<String, dynamic> ? response : {};
  }
}
