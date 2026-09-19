import '../../core/api/api_client.dart';
import '../../core/api/api_config.dart';

/// Parent Portal API Service.
class ParentApiService {
  final ApiClient _apiClient;

  ParentApiService({ApiClient? apiClient}) : _apiClient = apiClient ?? ApiClient();

  /// Fetch Parent Dashboard overview.
  Future<Map<String, dynamic>> getDashboard() async {
    try {
      final response = await _apiClient.get('/parent/dashboard/');
      if (response is Map<String, dynamic> && response.containsKey('data')) {
        return response['data'] is Map<String, dynamic> ? response['data'] : response;
      }
      return response is Map<String, dynamic> ? response : {};
    } catch (_) {
      if (ApiConfig.useMockFallback) {
        return {
          'children_count': 2,
          'children': [
            {'id': 'ADM-2024-0412', 'full_name': 'Diya Sharma', 'class_section': '5-A', 'attendance_percentage': 96.5, 'dues': 12450.0},
            {'id': 'ADM-2024-0890', 'full_name': 'Aarav Sharma', 'class_section': '2-B', 'attendance_percentage': 94.2, 'dues': 8950.0},
          ],
          'total_dues': 21400.0,
        };
      }
      rethrow;
    }
  }
}
