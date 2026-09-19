import '../../core/api/api_client.dart';

/// Student & Academic Roster API Service.
class StudentApiService {
  final ApiClient _apiClient;

  StudentApiService({ApiClient? apiClient}) : _apiClient = apiClient ?? ApiClient();

  /// Fetch list of students in class/section.
  Future<List<dynamic>> getStudents({String? classId, String? sectionId}) async {
    final response = await _apiClient.get(
      '/students',
      queryParameters: {
        if (classId != null) 'class_id': classId,
        if (sectionId != null) 'section_id': sectionId,
      },
    );

    if (response is List) return response;
    if (response is Map && response.containsKey('data') && response['data'] is List) {
      return response['data'];
    }
    return [];
  }

  /// Get student detailed profile dossier.
  Future<Map<String, dynamic>> getStudentDossier(String studentId) async {
    final response = await _apiClient.get('/students/$studentId/dossier');
    return response is Map<String, dynamic> ? response : {};
  }

  /// Submit or update student examination marks.
  Future<Map<String, dynamic>> submitMarks({
    required String classId,
    required String subjectId,
    required String examType,
    required List<Map<String, dynamic>> marksList,
  }) async {
    final response = await _apiClient.post(
      '/students/marks',
      body: {
        'class_id': classId,
        'subject_id': subjectId,
        'exam_type': examType,
        'marks': marksList,
      },
    );
    return response is Map<String, dynamic> ? response : {'status': 'success'};
  }
}
