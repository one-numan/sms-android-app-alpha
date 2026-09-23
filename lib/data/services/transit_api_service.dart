import '../../core/api/api_client.dart';

/// Bus Transit Tracking API Service.
class TransitApiService {
  final ApiClient _apiClient;

  TransitApiService({ApiClient? apiClient}) : _apiClient = apiClient ?? ApiClient();

  /// Fetch live bus route tracking data.
  Future<Map<String, dynamic>> getBusTransit({String? studentId}) async {
    final response = await _apiClient.get(
      '/transit/bus/',
      queryParameters: {
        if (studentId != null) 'student_id': studentId,
      },
    );
    if (response is Map<String, dynamic> && response.containsKey('data')) {
      final data = response['data'];
      if (data is Map<String, dynamic>) return data;
      if (data == null) return {};
      return response;
    }
    return response is Map<String, dynamic> ? response : {};
  }
}
