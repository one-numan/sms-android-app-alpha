import '../../core/api/api_client.dart';

/// Service for faculty timetables, staff directory, class summary, allocations, and class roster.
class FacultyApiService {
  final ApiClient _apiClient;

  FacultyApiService({ApiClient? apiClient}) : _apiClient = apiClient ?? ApiClient();

  /// GET /api/v1/faculty/timetable/teacher/
  Future<Map<String, dynamic>> getTeacherTimetable({String? teacherId, int? dayOfWeek}) async {
    final query = <String, dynamic>{};
    if (teacherId != null) query['teacher_id'] = teacherId;
    if (dayOfWeek != null) query['day_of_week'] = dayOfWeek.toString();

    final response = await _apiClient.get('/faculty/timetable/teacher/', queryParameters: query.isEmpty ? null : query);
    if (response is Map<String, dynamic> && response.containsKey('data') && response['data'] is Map<String, dynamic>) {
      return response['data'] as Map<String, dynamic>;
    }
    return response is Map<String, dynamic> ? response : {};
  }

  /// GET /api/v1/faculty/timetable/class/?class_id=...
  Future<Map<String, dynamic>> getClassTimetable(String classId, {int? dayOfWeek}) async {
    final query = <String, dynamic>{'class_id': classId};
    if (dayOfWeek != null) query['day_of_week'] = dayOfWeek.toString();

    final response = await _apiClient.get('/faculty/timetable/class/', queryParameters: query);
    if (response is Map<String, dynamic> && response.containsKey('data') && response['data'] is Map<String, dynamic>) {
      return response['data'] as Map<String, dynamic>;
    }
    return response is Map<String, dynamic> ? response : {};
  }

  /// GET /api/v1/faculty/allocations/
  Future<Map<String, dynamic>> getFacultyAllocations() async {
    final response = await _apiClient.get('/faculty/allocations/');
    if (response is Map<String, dynamic> && response.containsKey('data') && response['data'] is Map<String, dynamic>) {
      return response['data'] as Map<String, dynamic>;
    }
    return response is Map<String, dynamic> ? response : {};
  }

  /// GET /api/v1/faculty/staff/
  Future<Map<String, dynamic>> getStaffDirectory({
    int page = 1,
    int? pageSize,
    String? role,
    String? department,
    String? search,
  }) async {
    final query = <String, dynamic>{'page': page.toString()};
    if (pageSize != null) query['page_size'] = pageSize.toString();
    if (role != null && role.isNotEmpty) query['role'] = role;
    if (department != null && department.isNotEmpty) query['department'] = department;
    if (search != null && search.isNotEmpty) query['search'] = search;

    final response = await _apiClient.get('/faculty/staff/', queryParameters: query);
    return response is Map<String, dynamic> ? response : {};
  }

  /// GET /api/v1/classes/<id>/summary/
  Future<Map<String, dynamic>> getClassSummary(String classId) async {
    final normalizedId = classId.replaceAll(RegExp(r'[^0-9]'), '');
    final targetId = normalizedId.isNotEmpty ? normalizedId : classId;
    final response = await _apiClient.get('/classes/$targetId/summary/');
    if (response is Map<String, dynamic> && response.containsKey('data') && response['data'] is Map<String, dynamic>) {
      return response['data'] as Map<String, dynamic>;
    }
    return response is Map<String, dynamic> ? response : {};
  }

  /// GET /api/v1/classes/<id>/students/
  Future<Map<String, dynamic>> getClassStudents(String classId) async {
    final normalizedId = classId.replaceAll(RegExp(r'[^0-9]'), '');
    final targetId = normalizedId.isNotEmpty ? normalizedId : classId;
    final response = await _apiClient.get('/classes/$targetId/students/');
    if (response is Map<String, dynamic> && response.containsKey('data') && response['data'] is Map<String, dynamic>) {
      return response['data'] as Map<String, dynamic>;
    }
    return response is Map<String, dynamic> ? response : {};
  }
}
