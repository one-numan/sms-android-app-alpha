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

  /// Fetch moderation queue (`GET /api/v1/announcements/approval-desk/`).
  Future<Map<String, dynamic>> getApprovalDesk() async {
    final response = await _apiClient.get('/announcements/approval-desk/');
    if (response is Map<String, dynamic> && response.containsKey('data') && response['data'] is Map<String, dynamic>) {
      return response['data'] as Map<String, dynamic>;
    }
    return response is Map<String, dynamic> ? response : {};
  }

  /// Moderate circular (`POST /api/v1/announcements/approval-desk/`).
  Future<Map<String, dynamic>> moderateAnnouncement(String id, String action, {String? notes}) async {
    final response = await _apiClient.post(
      '/announcements/approval-desk/',
      body: {
        'id': id,
        'action': action, // 'APPROVE' or 'REJECT'
        if (notes != null) 'notes': notes,
      },
    );
    return response is Map<String, dynamic> ? response : {'status': 'success'};
  }
}
