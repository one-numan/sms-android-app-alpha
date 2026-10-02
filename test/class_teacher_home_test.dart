// ==============================================================================
// One Numan Public School (ONPS) — Android ERP Mobile Application
// Unit & Widget Tests: Class Teacher Home Workspace Refinement
// Validating: Information Hierarchy, Data Representation, Privacy, 0-Emojis
// ==============================================================================

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sms_android_app_alpha/data/mock/auth_state.dart';
import 'package:sms_android_app_alpha/data/mock/mock_data.dart';
import 'package:sms_android_app_alpha/models/models.dart';
import 'package:sms_android_app_alpha/screens/dashboards/class_teacher_dashboard_screen.dart';
import 'package:provider/provider.dart';

Widget createTestWidget(Widget child) {
  final authState = AuthState()..switchRole(UserRole.classTeacher);
  return ChangeNotifierProvider<AuthState>.value(
    value: authState,
    child: MaterialApp(
      home: child,
    ),
  );
}

void main() {
  group('Class Teacher Home Screen — UX & Hierarchy Deep Verification', () {
    testWidgets('TEST 1: Assigned class and student count are visible and prominent', (tester) async {
      await tester.pumpWidget(createTestWidget(const ClassTeacherDashboardScreen(
        dashboardDataOverride: {'total_students': 40},
      )));
      await tester.pumpAndSettle();

      // Verify Teacher Context Greeting
      expect(find.textContaining('Good Morning, Anita Desai'), findsOneWidget);
      expect(find.textContaining('Class Teacher • Grade 5-A'), findsOneWidget);

      // Verify My Class Section
      expect(find.text('MY CLASS'), findsOneWidget);
      expect(find.text('Grade 5-A'), findsOneWidget);
      expect(find.textContaining('Students'), findsOneWidget);
    });

    testWidgets('TEST 2: Teacher with no assigned class shows clean unassigned state', (tester) async {
      const unassignedTeacher = Teacher(
        id: 'T-99',
        name: 'New Faculty Member',
        dateOfBirth: '01 Jan 1990',
        mobile: '+91 99999 00000',
        email: 'new@onps.edu.in',
        gender: 'Female',
        joinDate: '01 Jan 2026',
        address: Address(line1: 'Campus', city: 'Delhi', district: 'Central', state: 'Delhi', pincode: '110054'),
        subjectSpecialization: 'General',
      );

      await tester.pumpWidget(createTestWidget(const ClassTeacherDashboardScreen(
        teacherOverride: unassignedTeacher,
      )));
      await tester.pumpAndSettle();

      expect(find.text('No Class Assigned'), findsOneWidget);
      expect(find.text('Go to Subject Teacher Desk'), findsOneWidget);
    });

    testWidgets('TEST 3: Fully marked attendance displays present/total, calculated %, and View Attendance', (tester) async {
      await tester.pumpWidget(createTestWidget(const ClassTeacherDashboardScreen(
        attendanceStateOverride: AttendanceMarkingState.marked,
      )));
      await tester.pumpAndSettle();

      expect(find.text("TODAY'S ATTENDANCE"), findsOneWidget);
      expect(find.textContaining('Present'), findsOneWidget);
      expect(find.textContaining('% recorded'), findsOneWidget);
      expect(find.text('View Attendance'), findsOneWidget);
    });

    testWidgets('TEST 4: Attendance not marked shows "Attendance Not Marked" and NEVER displays 0%', (tester) async {
      await tester.pumpWidget(createTestWidget(const ClassTeacherDashboardScreen(
        attendanceStateOverride: AttendanceMarkingState.notMarked,
      )));
      await tester.pumpAndSettle();

      expect(find.text('Attendance Not Marked'), findsOneWidget);
      expect(find.text('Take Attendance'), findsWidgets);
      // Ensure 0% is NEVER displayed
      expect(find.text('0%'), findsNothing);
      expect(find.text('0.0%'), findsNothing);
      expect(find.text('0 / 32 Present'), findsNothing);
    });

    testWidgets('TEST 5: Partial attendance displays recorded progress and Continue Attendance', (tester) async {
      await tester.pumpWidget(createTestWidget(const ClassTeacherDashboardScreen(
        attendanceStateOverride: AttendanceMarkingState.partiallyRecorded,
      )));
      await tester.pumpAndSettle();

      expect(find.textContaining('Recorded'), findsOneWidget);
      expect(find.text('Continue Attendance'), findsOneWidget);
    });

    testWidgets('TEST 5b: Non-teaching day (Weekly Off / Holiday) displays not-applicable status and Timetable action', (tester) async {
      await tester.pumpWidget(createTestWidget(const ClassTeacherDashboardScreen(
        attendanceStateOverride: AttendanceMarkingState.notApplicable,
      )));
      await tester.pumpAndSettle();

      expect(find.textContaining('Weekly Off'), findsOneWidget);
      expect(find.textContaining('School is closed today'), findsOneWidget);
      expect(find.widgetWithText(ElevatedButton, 'Timetable'), findsOneWidget);
    });

    testWidgets('TEST 6 & 8: Current and next period schedule is displayed', (tester) async {
      await tester.pumpWidget(createTestWidget(const ClassTeacherDashboardScreen(
        timetableScheduleOverride: [
          {'period_number': 4, 'subject_name': 'Mathematics', 'room_number': 'Room 204', 'start_time': '11:05 AM', 'end_time': '11:45 AM'},
          {'period_number': 5, 'subject_name': 'Hindi', 'start_time': '12:30 PM'},
        ],
      )));
      await tester.pumpAndSettle();

      expect(find.text("TODAY'S TEACHING SCHEDULE"), findsOneWidget);
      expect(find.textContaining('PERIOD 4'), findsOneWidget);
      expect(find.textContaining('NEXT'), findsOneWidget);
    });

    testWidgets('TEST 10: Empty schedule state displays clean message', (tester) async {
      await tester.pumpWidget(createTestWidget(const ClassTeacherDashboardScreen(
        simulateEmptySchedule: true,
      )));
      await tester.pumpAndSettle();

      expect(find.text('No schedule available for today.'), findsOneWidget);
    });

    testWidgets('TEST 11 & 16: Pending work shows without exposing medical diagnoses (Privacy rule)', (tester) async {
      await tester.pumpWidget(createTestWidget(const ClassTeacherDashboardScreen(
        attentionItemsOverride: [
          {
            'title': 'Second Assessment Marks Pending',
            'subtitle': 'Mathematics • Grade 5-A • 4 unrecorded',
            'action_label': 'Enter',
            'action_route': '/students/marks-entry',
          },
          {
            'title': 'Pending Student Leave',
            'subtitle': 'Leave request awaiting faculty review',
            'action_label': 'Review',
            'action_route': '/attendance/student-leave',
          },
        ],
      )));
      await tester.pumpAndSettle();

      expect(find.text('NEEDS ATTENTION'), findsOneWidget);
      expect(find.text('Second Assessment Marks Pending'), findsOneWidget);
      expect(find.textContaining('Leave request'), findsWidgets);

      // Verify STRICT PRIVACY: Medical terms must NOT appear
      expect(find.textContaining('Viral'), findsNothing);
      expect(find.textContaining('Pyrexia'), findsNothing);
      expect(find.textContaining('Rx'), findsNothing);
    });

    testWidgets('TEST 12: Zero pending work hides the Needs Attention section', (tester) async {
      await tester.pumpWidget(createTestWidget(const ClassTeacherDashboardScreen(
        simulateZeroPending: true,
      )));
      await tester.pumpAndSettle();

      expect(find.text('NEEDS ATTENTION'), findsNothing);
    });

    testWidgets('TEST 13: Important notices section is present and formatted', (tester) async {
      await tester.pumpWidget(createTestWidget(const ClassTeacherDashboardScreen()));
      await tester.pumpAndSettle();

      expect(find.text('IMPORTANT NOTICES'), findsOneWidget);
      expect(find.text(MockData.announcements.first.title), findsOneWidget);
    });

    testWidgets('TEST 19: Error state allows retry', (tester) async {
      await tester.pumpWidget(createTestWidget(const ClassTeacherDashboardScreen(
        simulateError: true,
      )));
      await tester.pumpAndSettle();

      expect(find.text('Unable to load class information.'), findsOneWidget);
      expect(find.text('Retry'), findsOneWidget);
    });

    testWidgets('TEST 23: Long teacher and class names do not cause layout overflow', (tester) async {
      const longTeacher = Teacher(
        id: 'T-LONG',
        name: 'Dr. Prof. Anita Radhakrishnan Krishnamurthy-Chatterjee',
        dateOfBirth: '12 Jun 1980',
        mobile: '+91 98222 33445',
        email: 'anita.long@onps.edu.in',
        gender: 'Female',
        joinDate: '15 Jul 2015',
        address: Address(line1: 'Campus', city: 'Delhi', district: 'Central', state: 'Delhi', pincode: '110054'),
        subjectSpecialization: 'Advanced Theoretical Mathematics & Statistics',
      );

      const longClass = SchoolClass(
        id: 'C-LONG',
        grade: '5',
        section: 'A-International-Baccalaureate',
        className: '5-A-International-Baccalaureate',
        classTeacherName: 'Dr. Prof. Anita Radhakrishnan Krishnamurthy-Chatterjee',
      );

      await tester.pumpWidget(createTestWidget(const ClassTeacherDashboardScreen(
        teacherOverride: longTeacher,
        classOverride: longClass,
      )));
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
    });

    testWidgets('ICON RULE: Zero unicode emojis used in Class Teacher Home', (tester) async {
      await tester.pumpWidget(createTestWidget(const ClassTeacherDashboardScreen()));
      await tester.pumpAndSettle();

      final textWidgets = tester.widgetList<Text>(find.byType(Text));
      final emojiRegex = RegExp(
        r'[\u{1F300}-\u{1F6FF}\u{1F900}-\u{1F9FF}\u{2600}-\u{26FF}\u{2700}-\u{27BF}]',
        unicode: true,
      );

      for (final textWidget in textWidgets) {
        final text = textWidget.data ?? textWidget.textSpan?.toPlainText() ?? '';
        expect(emojiRegex.hasMatch(text), isFalse, reason: 'Found emoji in: "$text"');
      }
    });
  });
}
