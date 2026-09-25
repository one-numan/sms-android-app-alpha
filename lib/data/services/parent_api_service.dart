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

  /// Fetch Parents Directory (`GET /api/v1/parents/directory/`).
  Future<Map<String, dynamic>> getParentsDirectory({String? search, String? classId, int page = 1}) async {
    final query = <String, dynamic>{'page': page.toString()};
    if (search != null && search.isNotEmpty) query['search'] = search;
    if (classId != null && classId.isNotEmpty) query['class_id'] = classId;

    try {
      final response = await _apiClient.get('/parents/directory/', queryParameters: query);
      return response is Map<String, dynamic> ? response : {};
    } catch (e) {
      return {'count': 0, 'results': []};
    }
  }
}
