import '../../core/api/api_client.dart';

/// Super Admin System Telemetry API Service.
class TelemetryApiService {
  final ApiClient _apiClient;

  TelemetryApiService({ApiClient? apiClient}) : _apiClient = apiClient ?? ApiClient();

  /// Fetch system telemetry (error rates, top categories/features, recent errors)
  /// for the given trailing window in days (7, 30, or 90).
  Future<Map<String, dynamic>> getDashboard({int days = 7}) async {
    final response = await _apiClient.get('/telemetry/dashboard/', queryParameters: {'days': days});
    if (response is Map<String, dynamic> && response.containsKey('data')) {
      return response['data'] is Map<String, dynamic> ? response['data'] : response;
    }
    return response is Map<String, dynamic> ? response : {};
  }
}
