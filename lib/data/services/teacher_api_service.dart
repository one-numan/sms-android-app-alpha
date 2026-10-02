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

  /// Fetch Teacher Attention items.
  /// GET /api/v1/attention/
  Future<Map<String, dynamic>> getDashboardAttention() async {
    try {
      final response = await _apiClient.get('/attention/');
      if (response is Map<String, dynamic> && response.containsKey('data')) {
        return response['data'] is Map<String, dynamic> ? response['data'] : response;
      }
      return response is Map<String, dynamic> ? response : {};
    } catch (_) {
      return {'total_count': 0, 'items': []};
    }
  }

  /// Fetch Teacher Today Status (Consolidated schedule, day type, attendance status).
  /// GET /teacher/today-status/
  Future<Map<String, dynamic>> getTodayStatus() async {
    try {
      final response = await _apiClient.get('/teacher/today-status/');
      if (response is Map<String, dynamic> && response.containsKey('data')) {
        return response['data'] is Map<String, dynamic> ? response['data'] : response;
      }
      return response is Map<String, dynamic> ? response : {};
    } catch (_) {
      return {};
    }
  }

  /// Authoritatively resolve assigned class and class ID for a Class Teacher.
  Future<Map<String, dynamic>> resolveClassTeacherAssignment({String? email, String? username}) async {
    try {
      final classDash = await getClassDashboard();
      final assignedClass = classDash['assigned_class']?.toString();
      if (assignedClass == null || assignedClass.isEmpty || assignedClass.toLowerCase() == 'none') {
        return {};
      }

      String? classId = classDash['class_id']?.toString() ?? classDash['assigned_class_id']?.toString();
      Map<String, dynamic> classSummary = {};

      if (classId == null || classId.isEmpty) {
        try {
          final query = <String, dynamic>{};
          if (email != null && email.isNotEmpty) {
            query['search'] = email;
          } else if (username != null && username.isNotEmpty) {
            query['search'] = username;
          }
          final staffResp = await _apiClient.get('/faculty/staff/', queryParameters: query.isEmpty ? null : query);
          final staffResults = (staffResp is Map<String, dynamic>)
              ? (staffResp['results'] as List<dynamic>?)
              : null;
          if (staffResults != null && staffResults.isNotEmpty) {
            final match = staffResults.firstWhere(
              (r) => (r is Map &&
                  ((email != null && r['email'] == email) ||
                   (username != null && (r['email']?.toString().contains(username) ?? false)))),
              orElse: () => staffResults.first,
            );
            if (match is Map) {
              final staffId = match['id']?.toString() ?? '';
              final numMatch = RegExp(r'(\d+)$').firstMatch(staffId);
              if (numMatch != null) {
                classId = 'CLS-${numMatch.group(1)}';
              }
            }
          }
        } catch (_) {}
      }

      if (classId != null && classId.isNotEmpty) {
        try {
          final normalizedId = classId.replaceAll(RegExp(r'[^0-9]'), '');
          final targetId = normalizedId.isNotEmpty ? normalizedId : classId;
          final sumResp = await _apiClient.get('/classes/$targetId/summary/');
          if (sumResp is Map<String, dynamic> && sumResp.containsKey('data') && sumResp['data'] is Map<String, dynamic>) {
            classSummary = sumResp['data'] as Map<String, dynamic>;
          }
        } catch (_) {}
      }

      return {
        'assigned_class': assignedClass,
        'class_id': classSummary['class_id']?.toString() ?? classId,
        'class_name': classSummary['class_name']?.toString() ?? assignedClass,
        'grade': classSummary['grade']?.toString(),
        'section': classSummary['section']?.toString(),
        'total_students': classSummary['total_students'] ?? classDash['total_students'],
        'class_summary': classSummary,
        'class_dashboard': classDash,
      };
    } catch (_) {
      return {};
    }
  }
}

