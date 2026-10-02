import '../../core/api/api_client.dart';

/// Front Desk / Receptionist API Service.
class ReceptionistApiService {
  final ApiClient _apiClient;

  ReceptionistApiService({ApiClient? apiClient}) : _apiClient = apiClient ?? ApiClient();

  /// Fetch Front Desk dashboard: enquiry & application pipeline overview.
  Future<Map<String, dynamic>> getDashboard() async {
    final response = await _apiClient.get('/receptionist/dashboard/');
    if (response is Map<String, dynamic> && response.containsKey('data')) {
      return response['data'] is Map<String, dynamic> ? response['data'] : response;
    }
    return response is Map<String, dynamic> ? response : {};
  }
}
