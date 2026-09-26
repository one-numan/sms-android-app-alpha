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
  Future<Map<String, dynamic>> getParentsDirectory({
    String? search,
    String? classId,
    int page = 1,
    int pageSize = 20,
  }) async {
    final query = <String, dynamic>{
      'page': page.toString(),
      'page_size': pageSize.toString(),
    };
    if (search != null && search.isNotEmpty) query['search'] = search;
    if (classId != null && classId.isNotEmpty) query['class_id'] = classId;

    try {
      final response = await _apiClient.get('/parents/directory/', queryParameters: query);
      if (response is Map<String, dynamic>) {
        int count = response['count'] as int? ?? 0;
        List<dynamic> results = [];
        if (response['results'] is List) {
          results = response['results'] as List;
        } else if (response['data'] is List) {
          results = response['data'] as List;
          count = count > 0 ? count : results.length;
        } else if (response['data'] is Map && response['data']['results'] is List) {
          results = response['data']['results'] as List;
          count = response['data']['count'] as int? ?? count;
        }
        return {
          'count': count > 0 ? count : results.length,
          'has_more': response['next'] != null || results.length >= pageSize,
          'results': results,
        };
      }
      if (response is List) {
        return {'count': response.length, 'has_more': false, 'results': response};
      }
      return {'count': 0, 'has_more': false, 'results': []};
    } catch (e) {
      return {'count': 0, 'has_more': false, 'results': []};
    }
  }
}
