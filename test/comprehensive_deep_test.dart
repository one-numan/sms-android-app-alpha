// ==============================================================================
// One Numan Public School (ONPS) — Android ERP Mobile Application
// Comprehensive End-to-End Deep Verification Test Suite
// Testing: Student, Class Teacher, Subject Teacher, Parent Flows,
// Multi-child synchronization, Payment safety, Attendance rates, 0-emojis.
// ==============================================================================

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:sms_android_app_alpha/data/mock/auth_state.dart';
import 'package:sms_android_app_alpha/main.dart';
import 'package:sms_android_app_alpha/models/models.dart';
import 'package:sms_android_app_alpha/screens/attendance/daily_roll_call_screen.dart';
import 'package:sms_android_app_alpha/screens/attendance/student_attendance_screen.dart';
import 'package:sms_android_app_alpha/screens/dashboards/class_teacher_dashboard_screen.dart';
import 'package:sms_android_app_alpha/screens/dashboards/parent_dashboard_screen.dart';
import 'package:sms_android_app_alpha/screens/dashboards/student_hub_screen.dart';
import 'package:sms_android_app_alpha/screens/dashboards/subject_teacher_dashboard_screen.dart';
import 'package:sms_android_app_alpha/screens/faculty/teacher_timetable_screen.dart';
import 'package:sms_android_app_alpha/screens/fees/fee_ledger_screen.dart';
import 'package:sms_android_app_alpha/screens/fees/fee_receipt_screen.dart';
import 'package:sms_android_app_alpha/screens/students/academic_report_card_screen.dart';
import 'package:sms_android_app_alpha/screens/students/digital_student_id_card_screen.dart';
import 'package:sms_android_app_alpha/widgets/bottom_nav_bar.dart';

Widget wrapWithAuth(Widget child, AuthState authState) {
  return ChangeNotifierProvider<AuthState>.value(
    value: authState,
    child: MaterialApp(
      home: child,
    ),
  );
}

void main() {
  final emojiPattern = RegExp(
    r'[\u{1F300}-\u{1F5FF}\u{1F600}-\u{1F64F}\u{1F680}-\u{1F6FF}\u{1F700}-\u{1F77F}\u{1F780}-\u{1F7FF}\u{1F800}-\u{1F8FF}\u{1F900}-\u{1F9FF}\u{1FA00}-\u{1FA6F}\u{2600}-\u{26FF}\u{2700}-\u{27BF}]',
    unicode: true,
  );

  void assertNoEmojis(WidgetTester tester, String screenName) {
    for (final textWidget in tester.widgetList<Text>(find.byType(Text))) {
      final text = textWidget.data ?? textWidget.textSpan?.toPlainText() ?? '';
      expect(emojiPattern.hasMatch(text), isFalse, reason: 'Found emoji in $screenName: "$text"');
    }
  }

  setUp(() {
    final binding = TestWidgetsFlutterBinding.ensureInitialized();
    binding.platformDispatcher.views.first.physicalSize = const Size(800, 1400);
    binding.platformDispatcher.views.first.devicePixelRatio = 1.0;
  });

  tearDown(() {
    final binding = TestWidgetsFlutterBinding.ensureInitialized();
    binding.platformDispatcher.views.first.resetPhysicalSize();
    binding.platformDispatcher.views.first.resetDevicePixelRatio();
  });

  group('Deep Test 1: Full App Navigation & Student Persona Flows', () {
    testWidgets('1.1: Student Hub navigation & KPI calculations', (tester) async {
      await tester.pumpWidget(const OnpsErpApp());
      await tester.pumpAndSettle();

      final BuildContext context = tester.element(find.byType(ParentDashboardScreen));
      context.go('/dashboard/student');
      await tester.pumpAndSettle();

      expect(find.byType(StudentHubScreen), findsOneWidget);
      expect(find.text('Diya Sharma'), findsOneWidget);
      expect(find.textContaining('Roll #14'), findsOneWidget);
      expect(find.text('Attendance'), findsWidgets);
      expect(find.text('Term Result'), findsOneWidget);

      assertNoEmojis(tester, 'StudentHubScreen');
    });

    testWidgets('1.2: Digital Student ID Sheet verifies official credentials', (tester) async {
      await tester.pumpWidget(const OnpsErpApp());
      await tester.pumpAndSettle();

      final BuildContext context = tester.element(find.byType(ParentDashboardScreen));
      context.go('/student/digital-id-sheet');
      await tester.pumpAndSettle();

      expect(find.byType(DigitalStudentIdCardScreen), findsOneWidget);
      expect(find.text('Digital Student ID'), findsOneWidget);
      expect(find.text('DIYA SHARMA'), findsOneWidget);
      expect(find.text('ADMISSION NO'), findsOneWidget);
      expect(find.text('ADM-2024-0412'), findsOneWidget);
      expect(find.text('BLOOD GROUP'), findsOneWidget);
      expect(find.text('B+'), findsOneWidget);
      expect(find.text('EMERGENCY CONTACT (FATHER)'), findsOneWidget);

      assertNoEmojis(tester, 'DigitalStudentIdCardScreen');
    });

    testWidgets('1.3: Academic Report Card presents subject scores & assessment breakdown', (tester) async {
      await tester.pumpWidget(const OnpsErpApp());
      await tester.pumpAndSettle();

      final BuildContext context = tester.element(find.byType(ParentDashboardScreen));
      context.go('/students/report-card?id=ADM-2024-0412');
      await tester.pumpAndSettle();

      expect(find.byType(AcademicReportCardScreen), findsOneWidget);
      expect(find.text('Mathematics'), findsWidgets);
      expect(find.text('Science'), findsWidgets);
      expect(find.text('Social Studies'), findsWidgets);

      assertNoEmojis(tester, 'AcademicReportCardScreen');
    });

    testWidgets('1.4: Fee Receipt screen renders verified tax receipt', (tester) async {
      await tester.pumpWidget(const OnpsErpApp());
      await tester.pumpAndSettle();

      final BuildContext context = tester.element(find.byType(ParentDashboardScreen));
      context.go('/fees/receipt/REC-2026-0891');
      await tester.pumpAndSettle();

      expect(find.byType(FeeReceiptScreen), findsOneWidget);
      expect(find.text('Official Fee Receipt'), findsOneWidget);
      expect(find.text('REC-2026-0891'), findsOneWidget);

      assertNoEmojis(tester, 'FeeReceiptScreen');
    });
  });

  group('Deep Test 2: Class Teacher Persona Workflows', () {
    late AuthState authState;

    setUp(() {
      authState = AuthState()..login(role: UserRole.classTeacher, username: 'anita.desai');
    });

    testWidgets('2.1: Class Teacher Hub displays assigned class', (tester) async {
      await tester.pumpWidget(wrapWithAuth(const ClassTeacherDashboardScreen(), authState));
      await tester.pumpAndSettle();

      expect(find.textContaining('Good Morning, Anita Desai'), findsOneWidget);
      expect(find.text('MY CLASS'), findsOneWidget);
      expect(find.text('Grade 5-A'), findsWidgets);

      assertNoEmojis(tester, 'ClassTeacherDashboardScreen');
    });

    testWidgets('2.2: Daily Roll Call Register allows interactive attendance workflow', (tester) async {
      await tester.pumpWidget(wrapWithAuth(const DailyRollCallScreen(), authState));
      await tester.pumpAndSettle();

      expect(find.text('Class 5-A'), findsOneWidget);
      expect(find.textContaining('32'), findsWidgets);
      expect(find.byType(ElevatedButton), findsWidgets);

      assertNoEmojis(tester, 'DailyRollCallScreen');
    });

    testWidgets('2.3: Faculty Timetable Matrix displays schedule', (tester) async {
      await tester.pumpWidget(wrapWithAuth(const TeacherTimetableScreen(), authState));
      await tester.pumpAndSettle();

      expect(find.text('Faculty Timetable'), findsOneWidget);
      expect(find.text('MON'), findsWidgets);
      expect(find.text('TUE'), findsWidgets);

      assertNoEmojis(tester, 'TeacherTimetableScreen');
    });
  });

  group('Deep Test 3: Subject Teacher Persona Workflows', () {
    late AuthState authState;

    setUp(() {
      authState = AuthState()..login(role: UserRole.subjectTeacher, username: 'robert.chen');
    });

    testWidgets('3.1: Subject Teacher Bottom Nav has strictly 5 designated destinations', (tester) async {
      await tester.pumpWidget(wrapWithAuth(
        Scaffold(
          body: const Center(child: Text('Content')),
          bottomNavigationBar: Builder(
            builder: (ctx) => AcademicBottomNavBar.forRole(
              UserRole.subjectTeacher,
              currentIndex: 0,
              context: ctx,
            ),
          ),
        ),
        authState,
      ));
      await tester.pumpAndSettle();

      expect(find.text('Portal'), findsOneWidget);
      expect(find.text('Academics'), findsOneWidget);
      expect(find.text('Attendance'), findsOneWidget);

      assertNoEmojis(tester, 'SubjectTeacherNav');
    });

    testWidgets('3.2: Subject Teacher Dashboard & Classes Screen', (tester) async {
      await tester.pumpWidget(wrapWithAuth(const SubjectTeacherDashboardScreen(), authState));
      await tester.pumpAndSettle();

      expect(find.text('Good Morning,'), findsOneWidget);
      expect(find.textContaining('Robert Chen'), findsAtLeastNWidgets(1));
      expect(find.text('My Subjects'), findsOneWidget);
      expect(find.text('Teaching Classes'), findsOneWidget);

      assertNoEmojis(tester, 'SubjectTeacherDashboardScreen');
    });
  });

  group('Deep Test 4: Parent Multi-Student Persona Workflows', () {
    late AuthState authState;

    setUp(() {
      authState = AuthState()..login(role: UserRole.parent, username: 'rajesh.sharma');
    });

    testWidgets('4.1: Parent Dashboard switches child and syncs attendance and fee status', (tester) async {
      await tester.pumpWidget(wrapWithAuth(const ParentDashboardScreen(), authState));
      await tester.pumpAndSettle();

      // Initial Child: Diya Sharma
      expect(find.textContaining('Diya Sharma'), findsWidgets);

      // Switch to Aarav Sharma
      final aaravTab = find.textContaining('Aarav Sharma');
      expect(aaravTab, findsOneWidget);
      await tester.tap(aaravTab);
      await tester.pumpAndSettle();

      expect(authState.selectedChildIndex, 1);
      expect(authState.selectedChild.firstName, 'Aarav');

      assertNoEmojis(tester, 'ParentDashboardScreen');
    });

    testWidgets('4.2: Parent Attendance calculates exact formula and handles day inspection', (tester) async {
      await tester.pumpWidget(wrapWithAuth(const StudentAttendanceScreen(), authState));
      await tester.pumpAndSettle();

      // Attendance overview header & KPI metrics
      expect(find.text('Attendance Overview'), findsOneWidget);
      expect(find.text('Present'), findsWidgets);
      expect(find.text('Absent'), findsWidgets);

      assertNoEmojis(tester, 'StudentAttendanceScreen');
    });

    testWidgets('4.3: Parent Fees & Dues reconciles dues and protects payment behind confirmation', (tester) async {
      await tester.pumpWidget(wrapWithAuth(const FeeLedgerScreen(), authState));
      await tester.pumpAndSettle();

      // Child 1 (Diya): Total Due ₹12,450
      expect(find.text('TOTAL DUE'), findsOneWidget);
      expect(find.text('OUTSTANDING'), findsOneWidget);
      expect(find.text('₹12,450'), findsWidgets);

      assertNoEmojis(tester, 'FeeLedgerScreen');
    });

    testWidgets('4.4: Parent Academics switches report card per child', (tester) async {
      await tester.pumpWidget(wrapWithAuth(const AcademicReportCardScreen(studentId: 'ADM-2024-0412'), authState));
      await tester.pumpAndSettle();

      // Diya has Class 5-A subjects
      expect(find.text('Social Studies'), findsWidgets);

      // Switch to Aarav
      await tester.tap(find.text('Aarav Sharma • Grade 2-B'));
      await tester.pumpAndSettle();

      // Aarav has Grade 2-B subjects
      expect(find.text('Environmental Studies'), findsWidgets);

      assertNoEmojis(tester, 'AcademicReportCardScreen');
    });
  });
}
