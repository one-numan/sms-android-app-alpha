import 'package:flutter_test/flutter_test.dart';
import 'package:sms_android_app_alpha/data/mock/auth_state.dart';
import 'package:sms_android_app_alpha/models/models.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Teacher Role Resolution Tests', () {
    test('resolves to Class Teacher when assigned_class is present', () {
      final profile = {
        'id': 4,
        'user': {'username': 'democlassteacher', 'user_type': 'faculty'},
        'assigned_class': {'id': 1, 'name': 'Nursery B', 'section': 'B'},
        'teaching_assignments': [
          {'subject': 'English', 'grade': 'Nursery B'},
        ],
      };

      final role = AuthState.resolveRoleFromProfile(profile);
      expect(role, UserRole.classTeacher);
    });

    test('resolves to Subject Teacher when assigned_class is null', () {
      final profile = {
        'id': 5,
        'user': {'username': 'demosubjectteacher', 'user_type': 'faculty'},
        'assigned_class': null,
        'teaching_assignments': [
          {'subject': 'Mathematics', 'grade': 'Grade 5-A'},
          {'subject': 'Science', 'grade': 'Grade 6-B'},
        ],
      };

      final role = AuthState.resolveRoleFromProfile(profile);
      expect(role, UserRole.subjectTeacher);
    });

    test('resolves to Subject Teacher when assigned_class is empty map', () {
      final profile = {
        'id': 6,
        'user': {'username': 'demosubjectteacher2', 'user_type': 'faculty'},
        'assigned_class': <String, dynamic>{},
        'teaching_assignments': [],
      };

      final role = AuthState.resolveRoleFromProfile(profile);
      expect(role, UserRole.subjectTeacher);
    });

    test('resolves explicit role strings correctly', () {
      expect(AuthState.resolveRoleFromProfile({'role': 'class_teacher'}), UserRole.classTeacher);
      expect(AuthState.resolveRoleFromProfile({'role': 'subject_teacher'}), UserRole.subjectTeacher);
      expect(AuthState.resolveRoleFromProfile({'role': 'principal'}), UserRole.principal);
      expect(AuthState.resolveRoleFromProfile({'role': 'parent'}), UserRole.parent);
      expect(AuthState.resolveRoleFromProfile({'role': 'student'}), UserRole.student);
      expect(AuthState.resolveRoleFromProfile({'role': 'accountant'}), UserRole.accountant);
      expect(AuthState.resolveRoleFromProfile({'role': 'librarian'}), UserRole.librarian);
      expect(AuthState.resolveRoleFromProfile({'role': 'superadmin'}), UserRole.superAdmin);
    });
  });
}
