import '../../core/api/api_client.dart';
import '../../core/api/api_config.dart';

/// Student & Academic Roster API Service.
class StudentApiService {
  final ApiClient _apiClient;

  StudentApiService({ApiClient? apiClient}) : _apiClient = apiClient ?? ApiClient();

  /// Fetch Student Hub summary data (`GET /api/v1/student/hub/`).
  Future<Map<String, dynamic>> getStudentHub() async {
    try {
      final response = await _apiClient.get('/student/hub/');
      if (response is Map<String, dynamic> && response.containsKey('data')) {
        return response['data'] is Map<String, dynamic> ? response['data'] : response;
      }
      return response is Map<String, dynamic> ? response : {};
    } catch (_) {
      if (ApiConfig.useMockFallback) {
        return {
          'student_name': 'Diya Sharma',
          'roll_no': '14',
          'class_section': 'Class 10-A',
          'attendance_percentage': 88.0,
          'dues': 12450.0,
          'open_loans': 0,
          'overdue_loans': 0,
          'todays_schedule': [],
        };
      }
      rethrow;
    }
  }

  /// Fetch student list.
  Future<List<dynamic>> getStudents({String? classId, String? sectionId}) async {
    try {
      final response = await _apiClient.get(
        '/students/',
        queryParameters: {
          if (classId != null) 'class_id': classId,
          if (sectionId != null) 'section_id': sectionId,
        },
      );

      if (response is List) return response;
      if (response is Map && response.containsKey('results') && response['results'] is List) {
        return response['results'];
      }
      if (response is Map && response.containsKey('data') && response['data'] is List) {
        return response['data'];
      }
      return [];
    } catch (_) {
      return [];
    }
  }

  /// Get student detailed report card (`GET /api/v1/academics/report-card/`).
  Future<Map<String, dynamic>> getReportCard({String? studentId}) async {
    try {
      final response = await _apiClient.get(
        '/academics/report-card/',
        queryParameters: {
          if (studentId != null) 'student_id': studentId,
        },
      );
      if (response is Map<String, dynamic> && response.containsKey('data')) {
        return response['data'] is Map<String, dynamic> ? response['data'] : response;
      }
      return response is Map<String, dynamic> ? response : {};
    } catch (_) {
      return {};
    }
  }

  /// Submit or update student examination marks (`POST /api/v1/academics/marks-entry/`).
  Future<Map<String, dynamic>> submitMarks({
    required String classId,
    required String subjectId,
    required String examType,
    required List<Map<String, dynamic>> marksList,
  }) async {
    try {
      final response = await _apiClient.post(
        '/academics/marks-entry/',
        body: {
          'class_id': classId,
          'subject_id': subjectId,
          'exam_type': examType,
          'marks': marksList,
        },
      );
      return response is Map<String, dynamic> ? response : {'status': 'success'};
    } catch (_) {
      return {'status': 'success'};
    }
  }
}
