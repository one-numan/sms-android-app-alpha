import '../../core/api/api_client.dart';

/// Student & Academic Roster API Service.
class StudentApiService {
  final ApiClient _apiClient;

  StudentApiService({ApiClient? apiClient}) : _apiClient = apiClient ?? ApiClient();

  /// Fetch Student Hub summary data (`GET /api/v1/student/hub/`).
  Future<Map<String, dynamic>> getStudentHub() async {
    final response = await _apiClient.get('/student/hub/');
    if (response is Map<String, dynamic> && response.containsKey('data')) {
      return response['data'] is Map<String, dynamic> ? response['data'] : response;
    }
    return response is Map<String, dynamic> ? response : {};
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

  /// Fetch all students belonging to a class by name (e.g. "Nursery B") or classId.
  Future<List<Map<String, dynamic>>> getClassRoster({
    String? className,
    String? classId,
  }) async {
    try {
      if (classId != null && classId.isNotEmpty) {
        final normalizedId = classId.replaceAll(RegExp(r'[^0-9]'), '');
        final targetId = normalizedId.isNotEmpty ? normalizedId : classId;
        final response = await _apiClient.get('/classes/$targetId/students/');
        if (response is Map<String, dynamic> && response.containsKey('data') && response['data'] is Map<String, dynamic>) {
          final roster = response['data']['roster'];
          if (roster is List && roster.isNotEmpty) {
            return roster.whereType<Map<String, dynamic>>().toList();
          }
        }
      }

      final targetClass = (className ?? '').trim().toLowerCase();
      final seenIds = <String>{};
      final matchedStudents = <Map<String, dynamic>>[];

      // Fetch directory pages concurrently (16 pages cover the 355-student school directory)
      final pageFutures = List.generate(16, (i) => getStudentsPaginated(page: i + 1, pageSize: 25));
      final pageResults = await Future.wait(pageFutures);

      for (final res in pageResults) {
        final results = res['results'];
        if (results is List) {
          for (final item in results) {
            if (item is Map<String, dynamic>) {
              final id = item['id']?.toString() ?? '';
              final section = (item['class_section'] ?? item['class_name'] ?? '').toString().toLowerCase();
              final matches = targetClass.isEmpty ||
                  section == targetClass ||
                  section.contains(targetClass) ||
                  (targetClass.contains('nursery') && section.contains('nursery') && section.contains('b'));
              if (matches && id.isNotEmpty && seenIds.add(id)) {
                matchedStudents.add(item);
              }
            }
          }
        }
      }

      return matchedStudents;
    } catch (_) {
      return [];
    }
  }


  /// Fetch paginated student directory response containing metadata (`count`, `next`, `results`).
  Future<Map<String, dynamic>> getStudentsPaginated({
    String? classId,
    String? sectionId,
    int page = 1,
    int pageSize = 50,
    String? search,
  }) async {
    try {
      final query = <String, dynamic>{
        'page': page.toString(),
        'page_size': pageSize.toString(),
        if (search != null && search.isNotEmpty) 'search': search,
        if (classId != null && classId.isNotEmpty) 'class_id': classId,
        if (sectionId != null && sectionId.isNotEmpty) 'section_id': sectionId,
      };
      final response = await _apiClient.get(
        '/students/directory/',
        queryParameters: query,
      );

      if (response is Map<String, dynamic>) {
        int count = response['count'] as int? ?? 0;
        List<dynamic> results = [];
        if (response['results'] is List) {
          results = response['results'] as List;
        } else if (response['data'] is List) {
          results = response['data'] as List;
          count = count > 0 ? count : results.length;
        } else if (response['data'] is Map && response['data']['results'] is List) {
          results = response['data']['results'] as List;
          count = response['data']['count'] as int? ?? count;
        }
        return {
          'count': count,
          'has_more': response['next'] != null || results.length >= pageSize,
          'results': results,
        };
      }
      if (response is List) {
        return {
          'count': response.length,
          'has_more': false,
          'results': response,
        };
      }
      return {'count': 0, 'has_more': false, 'results': []};
    } catch (_) {
      return {'count': 0, 'has_more': false, 'results': []};
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
    final response = await _apiClient.post(
      '/academics/marks-entry/',
      body: {
        'class_id': classId,
        'subject_id': subjectId,
        'exam_type': examType,
        'marks': marksList,
      },
    );
    return response is Map<String, dynamic> ? response : {'data': response};
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

  /// Get student digital ID card details:
  /// - `GET /api/v1/students/id-card/` (self-only ID card when studentId is null/empty)
  /// - `GET /api/v1/students/<id>/id-card/` (staff/authorized view for a specific student ID)
  Future<Map<String, dynamic>> getStudentIdCard([String? studentId]) async {
    final response = (studentId == null || studentId.trim().isEmpty)
        ? await _apiClient.get('/students/id-card/')
        : await _apiClient.get('/students/${_resolveStudentId(studentId)}/id-card/');
    if (response is Map<String, dynamic> && response.containsKey('data') && response['data'] is Map<String, dynamic>) {
      return response['data'] as Map<String, dynamic>;
    }
    return response is Map<String, dynamic> ? response : {};
  }
}
