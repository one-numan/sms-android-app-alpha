import '../../core/api/api_client.dart';

/// Announcement & Circulars API Service.
class AnnouncementApiService {
  final ApiClient _apiClient;

  AnnouncementApiService({ApiClient? apiClient}) : _apiClient = apiClient ?? ApiClient();

  /// Fetch published circulars & notices.
  Future<List<dynamic>> getAnnouncements() async {
    final response = await _apiClient.get('/announcements/');
    if (response is Map<String, dynamic> && response.containsKey('results')) {
      final results = response['results'];
      if (results is List) return results;
    }
    if (response is Map<String, dynamic> && response.containsKey('data')) {
      final data = response['data'];
      if (data is List) return data;
    }
    if (response is List) return response;
    return [];
  }
}
