// ==============================================================================
// Phase 6 Dynamic Faculty & Neutral Static Data Elimination Unit/Widget Tests
// ==============================================================================

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:sms_android_app_alpha/data/mock/auth_state.dart';
import 'package:sms_android_app_alpha/models/models.dart';
import 'package:sms_android_app_alpha/screens/dashboards/subject_teacher_dashboard_screen.dart';
import 'package:sms_android_app_alpha/screens/dashboards/subject_teacher_cohorts_screen.dart';
import 'package:sms_android_app_alpha/screens/faculty/subject_teacher_classes_screen.dart';
import 'package:sms_android_app_alpha/screens/faculty/subject_teacher_assignments_screen.dart';
import 'package:sms_android_app_alpha/screens/dashboards/class_teacher_dashboard_screen.dart';
import 'package:sms_android_app_alpha/screens/students/academic_report_card_screen.dart';

Widget createTestApp(Widget child, {AuthState? authState}) {
  return ChangeNotifierProvider<AuthState>.value(
    value: authState ?? AuthState(),
    child: MaterialApp(
      home: child,
    ),
  );
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Phase 6: Subject Teacher Dynamic Screens Tests', () {
    testWidgets('SubjectTeacherDashboardScreen mounts and displays live KPIs and cohorts', (tester) async {
      final auth = AuthState();
      auth.login(role: UserRole.subjectTeacher, username: 'washingtonsundar');

      await tester.pumpWidget(createTestApp(const SubjectTeacherDashboardScreen(), authState: auth));
      await tester.pumpAndSettle();

      expect(find.text('Students Taught'), findsOneWidget);
      expect(find.text('Grading Status'), findsOneWidget);
      expect(find.text('ASSIGNED TEACHING CLASSES'), findsOneWidget);
    });

    testWidgets('SubjectTeacherCohortsScreen mounts and shows dynamic cohorts and dynamic initials', (tester) async {
      final auth = AuthState();
      auth.login(role: UserRole.subjectTeacher, username: 'washingtonsundar');

      await tester.pumpWidget(createTestApp(const SubjectTeacherCohortsScreen(), authState: auth));
      await tester.pumpAndSettle();

      expect(find.text('My Classes'), findsWidgets);
      expect(find.text('ASSIGNED TEACHING CLASSES'), findsOneWidget);
      expect(find.text('5-A'), findsOneWidget);
      expect(find.text('2-B'), findsOneWidget);
    });

    testWidgets('SubjectTeacherClassesScreen mounts and shows dynamic assigned classes and summary', (tester) async {
      await tester.pumpWidget(createTestApp(const SubjectTeacherClassesScreen()));
      await tester.pumpAndSettle();

      expect(find.text('Subject Faculty Classes'), findsOneWidget);
      expect(find.text('Total Students'), findsOneWidget);
      expect(find.text('Weekly Load'), findsOneWidget);
      expect(find.text('ASSIGNED CLASSES & SECTIONS'), findsOneWidget);
      expect(find.text('Grade 5 • Section A'), findsOneWidget);
    });

    testWidgets('SubjectTeacherAssignmentsScreen mounts and shows curriculum specializations', (tester) async {
      await tester.pumpWidget(createTestApp(const SubjectTeacherAssignmentsScreen()));
      await tester.pumpAndSettle();

      expect(find.text('Curriculum & Subject Portfolio'), findsOneWidget);
      expect(find.text('Mathematics'), findsOneWidget);
      expect(find.text('MTH-01'), findsOneWidget);
    });
  });

  group('Phase 6: Static Persona Fallback Elimination Tests', () {
    testWidgets('ClassTeacherDashboardScreen renders neutral fallback when student name is null', (tester) async {
      final auth = AuthState();
      auth.login(role: UserRole.classTeacher, username: 'shubmangill');

      await tester.pumpWidget(createTestApp(const ClassTeacherDashboardScreen(), authState: auth));
      await tester.pumpAndSettle();

      // Ensure "Diya Sharma" is NOT present anywhere as hardcoded persona
      expect(find.text('Diya Sharma'), findsNothing);
      expect(find.text('Pending Student Leave'), findsOneWidget);
      expect(find.text('Leave request awaiting faculty review'), findsOneWidget);
    });

    testWidgets('AcademicReportCardScreen initializes dynamic day and eliminates hardcoded teacher personas', (tester) async {
      final auth = AuthState();
      auth.login(role: UserRole.parent, username: 'parent');

      await tester.pumpWidget(createTestApp(const AcademicReportCardScreen(studentId: 'ADM-2024-0412'), authState: auth));
      await tester.pumpAndSettle();

      // Ensure mock names Dr. Robert Chen, Mrs. Anita Desai are purged
      expect(find.text('Dr. Robert Chen'), findsNothing);
      expect(find.text('Mrs. Anita Desai'), findsNothing);
      expect(find.text('Mr. Vikram Malhotra'), findsNothing);

      // Verify academic report card loaded
      expect(find.text('ENROLLED SUBJECTS'), findsOneWidget);
      expect(find.text("TODAY'S TIMETABLE"), findsOneWidget);
    });
  });
}
