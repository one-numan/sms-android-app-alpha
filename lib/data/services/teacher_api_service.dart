import '../../core/api/api_client.dart';

/// Teacher Portals & Marks/Roll Call API Service.
class TeacherApiService {
  final ApiClient _apiClient;

  TeacherApiService({ApiClient? apiClient}) : _apiClient = apiClient ?? ApiClient();

  /// Fetch Class Teacher Hub summary.
  Future<Map<String, dynamic>> getClassDashboard() async {
    final response = await _apiClient.get('/teacher/class-dashboard/');
    if (response is Map<String, dynamic> && response.containsKey('data')) {
      return response['data'] is Map<String, dynamic> ? response['data'] : response;
    }
    return response is Map<String, dynamic> ? response : {};
  }

  /// Fetch Subject Teacher Cohorts summary.
  Future<Map<String, dynamic>> getSubjectDashboard() async {
    final response = await _apiClient.get('/teacher/subject-dashboard/');
    if (response is Map<String, dynamic> && response.containsKey('data')) {
      return response['data'] is Map<String, dynamic> ? response['data'] : response;
    }
    return response is Map<String, dynamic> ? response : {};
  }
}
