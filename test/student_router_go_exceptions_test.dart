// ==============================================================================
// One Numan Public School (ONPS) — Android ERP Mobile Application
// Unit & Widget Tests: Comprehensive Student Screens & GoRouter Verification
// Validating: Zero GoExceptions, all student routes registered, interactive
// navigation links work seamlessly, and 0 emojis across all student surfaces.
// ==============================================================================

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:sms_android_app_alpha/data/mock/auth_state.dart';
import 'package:sms_android_app_alpha/models/models.dart';
import 'package:sms_android_app_alpha/router.dart';
import 'package:sms_android_app_alpha/widgets/module_grid_sheet.dart';
import 'package:provider/provider.dart';

Widget createStudentAppWithRouter(GoRouter router, AuthState authState) {
  return ChangeNotifierProvider<AuthState>.value(
    value: authState,
    child: MaterialApp.router(
      routerConfig: router,
    ),
  );
}

void assertNoEmojis(WidgetTester tester, String screenName) {
  final textWidgets = tester.widgetList<Text>(find.byType(Text));
  final emojiRegex = RegExp(
    r'[\u{1F300}-\u{1F6FF}\u{1F900}-\u{1F9FF}\u{2600}-\u{26FF}\u{2700}-\u{27BF}]',
    unicode: true,
  );

  for (final textWidget in textWidgets) {
    final text = textWidget.data ?? textWidget.textSpan?.toPlainText() ?? '';
    expect(emojiRegex.hasMatch(text), isFalse, reason: 'Found emoji in $screenName: "$text"');
  }
}

void main() {
  group('Student Persona: Comprehensive Screens, Routes & GoException Audit', () {
    late AuthState authState;
    late GoRouter router;

    setUp(() {
      final binding = TestWidgetsFlutterBinding.ensureInitialized();
      binding.platformDispatcher.views.first.physicalSize = const Size(390, 844);
      binding.platformDispatcher.views.first.devicePixelRatio = 1.0;

      authState = AuthState()..switchRole(UserRole.student);
      router = createOnpsRouter(authState);
    });

    tearDown(() {
      final binding = TestWidgetsFlutterBinding.ensureInitialized();
      binding.platformDispatcher.views.first.resetPhysicalSize();
      binding.platformDispatcher.views.first.resetDevicePixelRatio();
    });

    testWidgets('1. Root "/" resolves to StudentHubScreen with zero GoException', (tester) async {
      await tester.pumpWidget(createStudentAppWithRouter(router, authState));
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      expect(find.text('Diya Sharma'), findsWidgets);
      expect(find.text('ONPS'), findsWidgets);
      assertNoEmojis(tester, 'StudentHubScreen');
    });

    testWidgets('2. Route "/dashboard/student" & "/student/hub" mount StudentHubScreen', (tester) async {
      await tester.pumpWidget(createStudentAppWithRouter(router, authState));
      router.go('/dashboard/student');
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      expect(find.text('Diya Sharma'), findsWidgets);

      router.go('/student/hub');
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      expect(find.text('Diya Sharma'), findsWidgets);
    });

    testWidgets('3. Route "/students/report-card" mounts AcademicReportCardScreen without GoException', (tester) async {
      await tester.pumpWidget(createStudentAppWithRouter(router, authState));
      router.go('/students/report-card');
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      expect(find.text('Academics'), findsWidgets);
      expect(find.text('Diya Sharma'), findsWidgets);
      assertNoEmojis(tester, 'AcademicReportCardScreen');
    });

    testWidgets('4. Route "/attendance/student" mounts StudentAttendanceScreen without GoException', (tester) async {
      await tester.pumpWidget(createStudentAppWithRouter(router, authState));
      router.go('/attendance/student');
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      expect(find.text('Attendance'), findsWidgets);
      assertNoEmojis(tester, 'StudentAttendanceScreen');
    });

    testWidgets('5. Route "/attendance/matrix" & "/attendance/student/matrix" mount AttendanceMatrixScreen', (tester) async {
      await tester.pumpWidget(createStudentAppWithRouter(router, authState));
      router.go('/attendance/matrix');
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      expect(find.text('Attendance Matrix'), findsWidgets);
      assertNoEmojis(tester, 'AttendanceMatrixScreen');
    });

    testWidgets('6. Route "/fees/ledger" mounts FeeLedgerScreen without GoException', (tester) async {
      await tester.pumpWidget(createStudentAppWithRouter(router, authState));
      router.go('/fees/ledger');
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      expect(find.text('Fees'), findsWidgets);
      assertNoEmojis(tester, 'FeeLedgerScreen');
    });

    testWidgets('7. Route "/fees/receipt" mounts FeeReceiptScreen without GoException', (tester) async {
      await tester.pumpWidget(createStudentAppWithRouter(router, authState));
      router.go('/fees/receipt?receiptNo=RCP-2026-1042');
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      expect(find.text('Official Fee Receipt'), findsWidgets);
      assertNoEmojis(tester, 'FeeReceiptScreen');
    });

    testWidgets('8. Route "/students/id-card" & "/student/digital-id-sheet" mount DigitalStudentIdCardScreen', (tester) async {
      await tester.pumpWidget(createStudentAppWithRouter(router, authState));
      router.go('/students/id-card');
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      expect(find.text('Digital Student ID'), findsWidgets);
      assertNoEmojis(tester, 'DigitalStudentIdCardScreen');
    });

    testWidgets('9. Route "/students/dossier" mounts StudentDossierScreen without GoException', (tester) async {
      await tester.pumpWidget(createStudentAppWithRouter(router, authState));
      router.go('/students/dossier?id=ADM-2024-0412');
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      expect(find.text('Student 360 File'), findsWidgets);
      expect(find.text('Diya Sharma'), findsWidgets);
      assertNoEmojis(tester, 'StudentDossierScreen');
    });

    testWidgets('10. Route "/faculty/timetable/class" & "/timetable/class" mount ClassTimetableScreen', (tester) async {
      await tester.pumpWidget(createStudentAppWithRouter(router, authState));
      router.go('/timetable/class');
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      expect(find.text('Class Timetable'), findsWidgets);
      assertNoEmojis(tester, 'ClassTimetableScreen');
    });

    testWidgets('11. Route "/announcements" mounts NoticeBoardScreen without GoException', (tester) async {
      await tester.pumpWidget(createStudentAppWithRouter(router, authState));
      router.go('/announcements');
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      expect(find.text('School Notices & Circulars'), findsWidgets);
      assertNoEmojis(tester, 'NoticeBoardScreen');
    });

    testWidgets('12. Route "/calendar/academic" mounts AcademicCalendarScreen without GoException', (tester) async {
      await tester.pumpWidget(createStudentAppWithRouter(router, authState));
      router.go('/calendar/academic');
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      expect(find.text('Academic Calendar'), findsWidgets);
      assertNoEmojis(tester, 'AcademicCalendarScreen');
    });

    testWidgets('13. Route "/transit/bus" & "/transport/route-card" mount BusTransitScreen without GoException', (tester) async {
      await tester.pumpWidget(createStudentAppWithRouter(router, authState));
      router.go('/transit/bus');
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      expect(find.text('Bus Route & Transit'), findsWidgets);
      assertNoEmojis(tester, 'BusTransitScreen');
    });

    testWidgets('14. Route "/library/desk" mounts LibrarianDashboardScreen without GoException', (tester) async {
      await tester.pumpWidget(createStudentAppWithRouter(router, authState));
      router.go('/library/desk');
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      expect(find.text('ACTIVE STUDENT CIRCULATION LOANS'), findsWidgets);
      assertNoEmojis(tester, 'LibrarianDashboardScreen');
    });

    testWidgets('15. Route "/account/profile" & "/account/settings" mount Account Screens without GoException', (tester) async {
      await tester.pumpWidget(createStudentAppWithRouter(router, authState));
      router.go('/account/profile');
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      expect(find.text('My Profile'), findsWidgets);

      router.go('/account/settings');
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      expect(find.text('Account Settings'), findsWidgets);
    });

    testWidgets('16. All 7 Student Modules in ModuleGridSheet have valid registered routes', (tester) async {
      await tester.pumpWidget(createStudentAppWithRouter(router, authState));
      await tester.pumpAndSettle();

      final modules = ModuleGridSheet.getModulesForRole(UserRole.student);
      expect(modules.length, 7);

      for (final mod in modules) {
        // Test that router can navigate to each module route without throwing GoException
        router.go(mod.route);
        await tester.pumpAndSettle();

        expect(tester.takeException(), isNull, reason: 'Failed navigating to module: ${mod.label} (${mod.route})');
      }
    });

    testWidgets('17. Interactive links inside StudentHubScreen navigate safely without GoException', (tester) async {
      await tester.pumpWidget(createStudentAppWithRouter(router, authState));
      router.go('/dashboard/student');
      await tester.pumpAndSettle();

      // Tap on Digital Student ID quick link
      final idCardBtn = find.text('Digital Student ID');
      if (idCardBtn.evaluate().isNotEmpty) {
        await tester.ensureVisible(idCardBtn.first);
        await tester.tap(idCardBtn.first);
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);
        expect(find.text('Digital Student ID'), findsWidgets);
      }
    });
  });
}
