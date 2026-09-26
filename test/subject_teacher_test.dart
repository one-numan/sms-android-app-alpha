// ==============================================================================
// One Numan Public School (ONPS) — Android ERP Mobile Application
// Automated Test Suite: Subject Teacher Deep Verification
// Bottom Navigation (Portal | Academics | Attendance | Timetable | More),
// Cohort cards, role isolation, and 0-emojis.
// ==============================================================================

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:sms_android_app_alpha/data/mock/auth_state.dart';
import 'package:sms_android_app_alpha/models/models.dart';
import 'package:sms_android_app_alpha/screens/dashboards/subject_teacher_cohorts_screen.dart';
import 'package:sms_android_app_alpha/screens/dashboards/subject_teacher_dashboard_screen.dart';
import 'package:sms_android_app_alpha/widgets/bottom_nav_bar.dart';
import 'package:sms_android_app_alpha/widgets/onps_verified_badge.dart';

Widget createTestApp(Widget child, AuthState authState) {
  return ChangeNotifierProvider<AuthState>.value(
    value: authState,
    child: MaterialApp(
      home: child,
    ),
  );
}

void main() {
  group('Subject Teacher — Navigation & Screen Verification', () {
    late AuthState authState;

    setUp(() {
      authState = AuthState();
      authState.login(role: UserRole.subjectTeacher, username: 'robert.chen');
    });

    testWidgets('TEST 1: Subject Teacher Bottom Navigation has exactly 5 destinations', (tester) async {
      await tester.pumpWidget(
        createTestApp(
          Scaffold(
            body: const Text('Test Body'),
            bottomNavigationBar: Builder(
              builder: (ctx) => AcademicBottomNavBar.forRole(
                UserRole.subjectTeacher,
                currentIndex: 0,
                context: ctx,
              ),
            ),
          ),
          authState,
        ),
      );
      await tester.pumpAndSettle();

      // Check the 5 labels: Portal, Academics, Attendance, Timetable, More
      expect(find.text('Portal'), findsOneWidget);
      expect(find.text('Academics'), findsOneWidget);
      expect(find.text('Attendance'), findsOneWidget);
      expect(find.text('Timetable'), findsOneWidget);
      expect(find.text('More'), findsOneWidget);
    });

    testWidgets('TEST 2: Subject Teacher Dashboard displays teacher identity and schedule', (tester) async {
      await tester.pumpWidget(createTestApp(const SubjectTeacherDashboardScreen(), authState));
      await tester.pumpAndSettle();

      expect(find.text('Good Morning, Robert Chen'), findsOneWidget);
      expect(find.textContaining('Faculty'), findsWidgets);
      expect(find.byType(OnpsVerifiedBadge), findsWidgets);
    });

    testWidgets('TEST 3: Subject Teacher Cohorts screen shows assigned classes and enter marks CTA', (tester) async {
      await tester.pumpWidget(createTestApp(const SubjectTeacherCohortsScreen(), authState));
      await tester.pumpAndSettle();

      expect(find.text('Robert Chen'), findsOneWidget);
      expect(find.text('Enter Marks →'), findsWidgets);
    });

    testWidgets('ICON RULE: Zero unicode emojis used in Subject Teacher screens', (tester) async {
      final emojiPattern = RegExp(
        r'[\u{1F300}-\u{1F5FF}\u{1F600}-\u{1F64F}\u{1F680}-\u{1F6FF}\u{1F700}-\u{1F77F}\u{1F780}-\u{1F7FF}\u{1F800}-\u{1F8FF}\u{1F900}-\u{1F9FF}\u{1FA00}-\u{1FA6F}\u{2600}-\u{26FF}\u{2700}-\u{27BF}]',
        unicode: true,
      );

      await tester.pumpWidget(createTestApp(const SubjectTeacherDashboardScreen(), authState));
      await tester.pumpAndSettle();
      for (final textWidget in tester.widgetList<Text>(find.byType(Text))) {
        final text = textWidget.data ?? '';
        expect(emojiPattern.hasMatch(text), isFalse, reason: 'Found emoji in SubjectTeacherDashboard: "$text"');
      }

      await tester.pumpWidget(createTestApp(const SubjectTeacherCohortsScreen(), authState));
      await tester.pumpAndSettle();
      for (final textWidget in tester.widgetList<Text>(find.byType(Text))) {
        final text = textWidget.data ?? '';
        expect(emojiPattern.hasMatch(text), isFalse, reason: 'Found emoji in SubjectTeacherCohorts: "$text"');
      }
    });
  });
}
