import '../../core/api/api_client.dart';

/// Accounts & Finance API Service.
class AccountantApiService {
  final ApiClient _apiClient;

  AccountantApiService({ApiClient? apiClient}) : _apiClient = apiClient ?? ApiClient();

  /// Fetch Accounts Ledger & Fee Collection overview.
  Future<Map<String, dynamic>> getDashboard() async {
    final response = await _apiClient.get('/accounts/dashboard/');
    if (response is Map<String, dynamic> && response.containsKey('data')) {
      return response['data'] is Map<String, dynamic> ? response['data'] : response;
    }
    return response is Map<String, dynamic> ? response : {};
  }
}
