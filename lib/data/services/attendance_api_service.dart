import '../../core/api/api_client.dart';

/// Attendance & Roll Call API Service.
class AttendanceApiService {
  final ApiClient _apiClient;

  AttendanceApiService({ApiClient? apiClient}) : _apiClient = apiClient ?? ApiClient();

  /// Submit daily roll call register for a class section.
  Future<Map<String, dynamic>> submitRollCall({
    required String classId,
    required String sectionId,
    required String date,
    required List<Map<String, dynamic>> attendanceRecords,
  }) async {
    final response = await _apiClient.post(
      '/attendance/roll-call',
      body: {
        'class_id': classId,
        'section_id': sectionId,
        'date': date,
        'records': attendanceRecords,
      },
    );
    return response is Map<String, dynamic> ? response : {'status': 'success'};
  }

  /// Get attendance matrix monthly report.
  Future<Map<String, dynamic>> getAttendanceMatrix({
    required String classId,
    required String month,
    required String year,
  }) async {
    final response = await _apiClient.get(
      '/attendance/matrix',
      queryParameters: {
        'class_id': classId,
        'month': month,
        'year': year,
      },
    );
    return response is Map<String, dynamic> ? response : {};
  }
}
