import '../../core/api/api_client.dart';

/// Attendance & Roll Call API Service.
class AttendanceApiService {
  final ApiClient _apiClient;

  AttendanceApiService({ApiClient? apiClient}) : _apiClient = apiClient ?? ApiClient();

  /// Fetch Student Attendance matrix (`GET /api/v1/attendance/student/`).
  Future<Map<String, dynamic>> getStudentAttendance({
    String? studentId,
    String? month,
    String? year,
  }) async {
    final response = await _apiClient.get(
      '/attendance/student/',
      queryParameters: {
        if (studentId != null) 'student_id': studentId,
        if (month != null) 'month': month,
        if (year != null) 'year': year,
      },
    );
    if (response is Map<String, dynamic> && response.containsKey('data')) {
      return response['data'] is Map<String, dynamic> ? response['data'] : response;
    }
    return response is Map<String, dynamic> ? response : {};
  }

  /// Submit daily roll call register for a class section (`POST /api/v1/attendance/roll-call/`).
  Future<Map<String, dynamic>> submitRollCall({
    required String classId,
    required String sectionId,
    required String date,
    required List<Map<String, dynamic>> attendanceRecords,
  }) async {
    final response = await _apiClient.post(
      '/attendance/roll-call/',
      body: {
        'class_id': classId,
        'section_id': sectionId,
        'date': date,
        'records': attendanceRecords,
      },
    );
    return response is Map<String, dynamic> ? response : {'status': 'success'};
  }

  /// Fetch faculty leave balances and history (`GET /api/v1/attendance/faculty-leave/`).
  Future<Map<String, dynamic>> getFacultyLeave() async {
    final response = await _apiClient.get('/attendance/faculty-leave/');
    if (response is Map<String, dynamic> && response.containsKey('data') && response['data'] is Map<String, dynamic>) {
      return response['data'] as Map<String, dynamic>;
    }
    return response is Map<String, dynamic> ? response : {};
  }

  /// Apply for faculty leave (`POST /api/v1/attendance/faculty-leave/`).
  Future<Map<String, dynamic>> applyFacultyLeave(Map<String, dynamic> data) async {
    final response = await _apiClient.post('/attendance/faculty-leave/', body: data);
    return response is Map<String, dynamic> ? response : {'status': 'success'};
  }
}
