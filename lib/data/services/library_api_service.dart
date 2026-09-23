import '../../core/api/api_client.dart';

/// Service for librarian dashboard, catalog metrics, and book circulation.
class LibraryApiService {
  final ApiClient _apiClient;

  LibraryApiService({ApiClient? apiClient}) : _apiClient = apiClient ?? ApiClient();

  /// GET /api/v1/library/dashboard/
  Future<Map<String, dynamic>> getLibrarianDashboard() async {
    final response = await _apiClient.get('/library/dashboard/');
    if (response is Map<String, dynamic> && response.containsKey('data') && response['data'] is Map<String, dynamic>) {
      return response['data'] as Map<String, dynamic>;
    }
    return response is Map<String, dynamic> ? response : {};
  }

  /// POST /api/v1/library/dashboard/
  Future<Map<String, dynamic>> issueBook(Map<String, dynamic> data) async {
    final response = await _apiClient.post('/library/dashboard/', body: data);
    return response is Map<String, dynamic> ? response : {};
  }
}
