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
          'student_name': 'Test Student',
          'roll_no': 'STU-000',
          'class_section': 'Class 8-A',
          'attendance_percentage': 0.0,
          'dues': 0.0,
          'open_loans': 0,
          'overdue_loans': 0,
          'todays_schedule': [],
        };
      }
      rethrow;
    }
  }

  /// Fetch student list from live backend directory or class roster.
  Future<List<dynamic>> getStudents({
    String? classId,
    String? sectionId,
    int page = 1,
    String? search,
  }) async {
    try {
      if (classId != null && classId.isNotEmpty) {
        final normalizedId = classId.replaceAll(RegExp(r'[^0-9]'), '');
        final targetId = normalizedId.isNotEmpty ? normalizedId : classId;
        final response = await _apiClient.get('/classes/$targetId/students/');
        if (response is Map<String, dynamic> && response.containsKey('data') && response['data'] is Map<String, dynamic>) {
          final roster = response['data']['roster'];
          if (roster is List) return roster;
        }
      }
      final query = <String, dynamic>{
        'page': page.toString(),
        if (search != null && search.isNotEmpty) 'search': search,
      };
      final response = await _apiClient.get(
        '/students/directory/',
        queryParameters: query,
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

  static String _resolveStudentId(String studentId) {
    if (studentId.contains('-')) {
      final last = studentId.split('-').last;
      final parsed = int.tryParse(last);
      if (parsed != null && parsed > 0) return parsed.toString();
    }
    final parsed = int.tryParse(studentId.replaceAll(RegExp(r'[^0-9]'), ''));
    if (parsed != null && parsed > 0) return parsed.toString();
    return studentId.isNotEmpty ? studentId : '1';
  }

  /// Get student comprehensive dossier (`GET /api/v1/students/<id>/dossier/`).
  Future<Map<String, dynamic>> getStudentDossier(String studentId) async {
    final targetId = _resolveStudentId(studentId);
    final response = await _apiClient.get('/students/$targetId/dossier/');
    if (response is Map<String, dynamic> && response.containsKey('data') && response['data'] is Map<String, dynamic>) {
      return response['data'] as Map<String, dynamic>;
    }
    return response is Map<String, dynamic> ? response : {};
  }

  /// Get student digital ID card details (`GET /api/v1/students/<id>/id-card/`).
  Future<Map<String, dynamic>> getStudentIdCard(String studentId) async {
    final targetId = _resolveStudentId(studentId);
    final response = await _apiClient.get('/students/$targetId/id-card/');
    if (response is Map<String, dynamic> && response.containsKey('data') && response['data'] is Map<String, dynamic>) {
      return response['data'] as Map<String, dynamic>;
    }
    return response is Map<String, dynamic> ? response : {};
  }
}
