// ==============================================================================
// One Numan Public School (ONPS) — Android ERP Mobile Application
// Needs Attention API Service (Role-Scoped Universal Feed)
// Connected to Django REST API: GET /api/v1/attention/
// ==============================================================================

import '../../core/api/api_client.dart';

/// Universal Needs Attention Feed API Service.
/// Serves all 7 authenticated roles from a single backend endpoint:
/// `GET /api/v1/attention/`
class AttentionApiService {
  final ApiClient _apiClient;

  AttentionApiService({ApiClient? apiClient}) : _apiClient = apiClient ?? ApiClient();

  /// Fetch Needs Attention feed for the currently authenticated user.
  /// Response envelope:
  /// {
  ///   "success": true,
  ///   "data": {
  ///     "items": [ ... ],
  ///     "summary": { ... },
  ///     "total_count": int
  ///   }
  /// }
  Future<Map<String, dynamic>> getAttentionFeed() async {
    try {
      final response = await _apiClient.get('/attention/');
      if (response is Map<String, dynamic>) {
        if (response.containsKey('data') && response['data'] is Map<String, dynamic>) {
          final data = response['data'] as Map<String, dynamic>;
          return {
            'total_count': data['total_count'] as int? ?? (data['items'] as List?)?.length ?? 0,
            'summary': data['summary'] is Map<String, dynamic> ? data['summary'] : <String, dynamic>{},
            'items': data['items'] is List ? data['items'] : <dynamic>[],
          };
        }
        return {
          'total_count': response['total_count'] as int? ?? (response['items'] as List?)?.length ?? 0,
          'summary': response['summary'] is Map<String, dynamic> ? response['summary'] : <String, dynamic>{},
          'items': response['items'] is List ? response['items'] : <dynamic>[],
        };
      }
      return {'total_count': 0, 'summary': <String, dynamic>{}, 'items': <dynamic>[]};
    } catch (_) {
      return {'total_count': 0, 'summary': <String, dynamic>{}, 'items': <dynamic>[]};
    }
  }
}
