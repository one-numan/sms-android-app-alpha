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
    required dynamic classId,
    required String sectionId,
    required String date,
    required List<Map<String, dynamic>> attendanceRecords,
  }) async {
    final rawClassStr = classId.toString();
    final classDigits = rawClassStr.replaceAll(RegExp(r'[^0-9]'), '');
    final intClassId = int.tryParse(classDigits) ?? int.tryParse(rawClassStr) ?? 0;

    final sanitizedRecords = attendanceRecords.map((r) {
      final rawSId = r['student_id']?.toString() ?? '';
      final lastToken = rawSId.contains('-') ? rawSId.split('-').last : rawSId;
      final sDigits = lastToken.replaceAll(RegExp(r'[^0-9]'), '');
      final intStudentId = int.tryParse(sDigits) ?? int.tryParse(lastToken) ?? 0;
      return {
        'student_id': intStudentId,
        'status': r['status'],
        if (r.containsKey('remark')) 'remark': r['remark'],
      };
    }).toList();

    final response = await _apiClient.post(
      '/attendance/roll-call/',
      body: {
        'class_id': intClassId,
        'section_id': sectionId,
        'date': date,
        'records': sanitizedRecords,
      },
    );
    return response is Map<String, dynamic> ? response : {'status': 'success'};
  }

  /// Fetch daily roll call attendance records for a class section (`GET /api/v1/attendance/roll-call/`).
  Future<Map<String, dynamic>> getClassAttendance({
    dynamic classId,
    String? date,
  }) async {
    final rawClassStr = classId?.toString();
    final classDigits = rawClassStr?.replaceAll(RegExp(r'[^0-9]'), '');
    final intClassId = classDigits != null && classDigits.isNotEmpty
        ? int.tryParse(classDigits)
        : int.tryParse(rawClassStr ?? '');

    try {
      final response = await _apiClient.get(
        '/attendance/roll-call/',
        queryParameters: {
          if (intClassId != null && intClassId > 0) 'class_id': intClassId.toString(),
          if (date != null) 'date': date,
        },
      );
      if (response is Map<String, dynamic> && response.containsKey('data') && response['data'] is Map<String, dynamic>) {
        return response['data'] as Map<String, dynamic>;
      }
      return response is Map<String, dynamic> ? response : {};
    } catch (_) {
      return {};
    }
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
