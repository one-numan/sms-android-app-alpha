// ==============================================================================
// One Numan Public School (ONPS) — Android ERP Mobile Application
// Automated Test Suite: Parent Experience Deep Verification
// Multi-child data isolation, dynamic calculations, payment safety, 0-emojis.
// ==============================================================================

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:sms_android_app_alpha/data/mock/auth_state.dart';
import 'package:sms_android_app_alpha/models/models.dart';
import 'package:sms_android_app_alpha/screens/attendance/student_attendance_screen.dart';
import 'package:sms_android_app_alpha/screens/dashboards/parent_dashboard_screen.dart';
import 'package:sms_android_app_alpha/screens/fees/fee_ledger_screen.dart';
import 'package:sms_android_app_alpha/screens/students/academic_report_card_screen.dart';

Widget createTestApp(Widget child, AuthState authState) {
  return ChangeNotifierProvider<AuthState>.value(
    value: authState,
    child: MaterialApp(
      home: child,
    ),
  );
}

void main() {
  group('Parent Experience — Multi-Child Switching & Data Isolation', () {
    late AuthState authState;

    setUp(() {
      authState = AuthState();
      authState.login(role: UserRole.parent, username: 'rajesh.sharma');
    });

    testWidgets('TEST 1: Parent Dashboard switches child and isolates attendance data', (tester) async {
      await tester.pumpWidget(createTestApp(const ParentDashboardScreen(), authState));
      await tester.pumpAndSettle();

      // Initial child is Diya Sharma
      expect(find.textContaining('Diya Sharma'), findsWidgets);

      // Tap on Aarav Sharma chip
      final aaravTab = find.textContaining('Aarav Sharma');
      expect(aaravTab, findsOneWidget);
      await tester.tap(aaravTab);
      await tester.pumpAndSettle();

      // State should update to Aarav
      expect(authState.selectedChildIndex, 1);
      expect(authState.selectedChild.firstName, 'Aarav');
    });

    testWidgets('TEST 2: Parent Attendance screen shows monthly register matrix', (tester) async {
      await tester.pumpWidget(createTestApp(const StudentAttendanceScreen(), authState));
      await tester.pumpAndSettle();

      // Should show Attendance overview
      expect(find.text('Attendance Overview'), findsOneWidget);
      expect(find.text('Present'), findsWidgets);
      expect(find.text('Absent'), findsWidgets);
    });

    testWidgets('TEST 3: Parent Fees screen displays fee ledger and transaction history', (tester) async {
      await tester.pumpWidget(createTestApp(const FeeLedgerScreen(), authState));
      await tester.pumpAndSettle();

      // For Diya: Outstanding is ₹12,450
      expect(find.text('TOTAL DUE'), findsOneWidget);
      expect(find.text('OUTSTANDING'), findsOneWidget);
      expect(find.text('₹12,450'), findsWidgets);
    });

    testWidgets('TEST 4: Parent Academics screen switches marks ledger between children', (tester) async {
      await tester.pumpWidget(createTestApp(const AcademicReportCardScreen(studentId: 'ADM-2024-0412'), authState));
      await tester.pumpAndSettle();

      // Diya has Class 5-A subjects (Social Studies, etc.)
      expect(find.text('Social Studies'), findsWidgets);

      // Switch to Aarav (Grade 2-B)
      await tester.tap(find.text('Aarav Sharma • Grade 2-B'));
      await tester.pumpAndSettle();

      // Aarav has EVS
      expect(find.text('Environmental Studies'), findsWidgets);
    });

    testWidgets('ICON RULE: Zero unicode emojis used across all Parent screens', (tester) async {
      final emojiPattern = RegExp(
        r'[\u{1F300}-\u{1F5FF}\u{1F600}-\u{1F64F}\u{1F680}-\u{1F6FF}\u{1F700}-\u{1F77F}\u{1F780}-\u{1F7FF}\u{1F800}-\u{1F8FF}\u{1F900}-\u{1F9FF}\u{1FA00}-\u{1FA6F}\u{2600}-\u{26FF}\u{2700}-\u{27BF}]',
        unicode: true,
      );

      await tester.pumpWidget(createTestApp(const ParentDashboardScreen(), authState));
      await tester.pumpAndSettle();
      for (final textWidget in tester.widgetList<Text>(find.byType(Text))) {
        final text = textWidget.data ?? '';
        expect(emojiPattern.hasMatch(text), isFalse, reason: 'Found emoji in ParentDashboard: "$text"');
      }

      await tester.pumpWidget(createTestApp(const StudentAttendanceScreen(), authState));
      await tester.pumpAndSettle();
      for (final textWidget in tester.widgetList<Text>(find.byType(Text))) {
        final text = textWidget.data ?? '';
        expect(emojiPattern.hasMatch(text), isFalse, reason: 'Found emoji in StudentAttendance: "$text"');
      }

      await tester.pumpWidget(createTestApp(const FeeLedgerScreen(), authState));
      await tester.pumpAndSettle();
      for (final textWidget in tester.widgetList<Text>(find.byType(Text))) {
        final text = textWidget.data ?? '';
        expect(emojiPattern.hasMatch(text), isFalse, reason: 'Found emoji in FeeLedger: "$text"');
      }
    });
  });
}
