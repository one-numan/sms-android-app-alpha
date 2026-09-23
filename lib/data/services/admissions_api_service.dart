import '../../core/api/api_client.dart';

/// Service for admissions enquiries and applications.
class AdmissionsApiService {
  final ApiClient _apiClient;

  AdmissionsApiService({ApiClient? apiClient}) : _apiClient = apiClient ?? ApiClient();

  /// GET /api/v1/admissions/enquiries/
  Future<Map<String, dynamic>> getEnquiries({int page = 1, String? status, String? search}) async {
    final query = <String, dynamic>{'page': page.toString()};
    if (status != null && status.isNotEmpty) query['status'] = status;
    if (search != null && search.isNotEmpty) query['search'] = search;

    final response = await _apiClient.get('/admissions/enquiries/', queryParameters: query);
    return response is Map<String, dynamic> ? response : {};
  }

  /// POST /api/v1/admissions/enquiries/
  Future<Map<String, dynamic>> createEnquiry(Map<String, dynamic> data) async {
    final response = await _apiClient.post('/admissions/enquiries/', body: data);
    return response is Map<String, dynamic> ? response : {};
  }

  /// GET /api/v1/admissions/applications/
  Future<Map<String, dynamic>> getApplications({int page = 1, String? status, String? search}) async {
    final query = <String, dynamic>{'page': page.toString()};
    if (status != null && status.isNotEmpty) query['status'] = status;
    if (search != null && search.isNotEmpty) query['search'] = search;

    final response = await _apiClient.get('/admissions/applications/', queryParameters: query);
    if (response is Map<String, dynamic> && response.containsKey('data') && response['data'] is Map<String, dynamic>) {
      return response['data'] as Map<String, dynamic>;
    }
    return response is Map<String, dynamic> ? response : {};
  }
}
