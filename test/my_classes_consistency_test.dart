import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:sms_android_app_alpha/core/utils/class_section_formatter.dart';
import 'package:sms_android_app_alpha/data/mock/auth_state.dart';
import 'package:sms_android_app_alpha/models/models.dart';
import 'package:sms_android_app_alpha/screens/dashboards/subject_teacher_cohorts_screen.dart';

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

  group('ClassSectionFormatter Tests', () {
    test('formats all standard academic grade and section variations', () {
      expect(ClassSectionFormatter.formatCompact('Grade 2 F'), '2 - F');
      expect(ClassSectionFormatter.formatFull('Grade 2 F'), 'Class 2 - F');

      expect(ClassSectionFormatter.formatCompact('Nursery A'), 'N - A');
      expect(ClassSectionFormatter.formatFull('Nursery A'), 'Class N - A');

      expect(ClassSectionFormatter.formatCompact('LKG B'), 'L - B');
      expect(ClassSectionFormatter.formatFull('LKG B'), 'Class L - B');

      expect(ClassSectionFormatter.formatCompact('UKG C'), 'U - C');
      expect(ClassSectionFormatter.formatFull('UKG C'), 'Class U - C');

      expect(ClassSectionFormatter.formatCompact('Grade 10 E'), '10 - E');
      expect(ClassSectionFormatter.formatFull('Grade 10 E'), 'Class 10 - E');

      expect(ClassSectionFormatter.extractSection('Grade 2 F'), 'F');
      expect(ClassSectionFormatter.extractSection('Nursery A'), 'A');
    });
  });

  group('My Classes Screen Specification Tests', () {
    testWidgets('Subject Teacher My Classes UI conforms to all requirements', (tester) async {
      final auth = AuthState();
      auth.login(role: UserRole.subjectTeacher, username: 'shubmangill');

      await tester.pumpWidget(createTestApp(const SubjectTeacherCohortsScreen(), authState: auth));
      await tester.pumpAndSettle();

      expect(find.text('My Classes'), findsWidgets);
      expect(find.text('Assigned Classes'), findsWidgets);
      expect(find.text('Total Students'), findsWidgets);
      expect(find.text('Periods / Week'), findsWidgets);
      expect(find.text('ASSIGNED TEACHING CLASSES'), findsWidgets);
      expect(find.text('Academic Year 2026–27'), findsNothing);
    });

    testWidgets('Class Teacher My Classes UI works consistently', (tester) async {
      final auth = AuthState();
      auth.login(role: UserRole.classTeacher, username: 'shubmangill');

      await tester.pumpWidget(createTestApp(const SubjectTeacherCohortsScreen(), authState: auth));
      await tester.pumpAndSettle();

      expect(find.text('My Classes'), findsWidgets);
      expect(find.text('Assigned Classes'), findsWidgets);
      expect(find.text('ASSIGNED TEACHING CLASSES'), findsWidgets);
    });

    testWidgets('Principal isolation: Principal cannot view teacher cohort roster', (tester) async {
      final auth = AuthState();
      auth.login(role: UserRole.principal, username: 'principal');

      await tester.pumpWidget(createTestApp(const SubjectTeacherCohortsScreen(), authState: auth));
      await tester.pumpAndSettle();

      expect(find.text('Shubman Gill'), findsNothing);
    });
  });
}
