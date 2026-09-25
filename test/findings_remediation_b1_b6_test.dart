// ==============================================================================
// One Numan Public School (ONPS) — Android ERP Mobile Application
// Automated Quality Verification: Findings Remediation B1–B6
// ==============================================================================

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:sms_android_app_alpha/core/api/api_config.dart';
import 'package:sms_android_app_alpha/core/api/token_storage.dart';
import 'package:sms_android_app_alpha/data/mock/auth_state.dart';
import 'package:sms_android_app_alpha/models/models.dart';
import 'package:sms_android_app_alpha/router.dart';
import 'package:sms_android_app_alpha/screens/attendance/student_attendance_screen.dart';
import 'package:sms_android_app_alpha/screens/dashboards/accountant_dashboard_screen.dart';
import 'package:sms_android_app_alpha/screens/fees/fee_ledger_screen.dart';
import 'package:sms_android_app_alpha/screens/students/academic_report_card_screen.dart';
import 'package:sms_android_app_alpha/screens/students/digital_student_id_card_screen.dart';

Widget createTestApp(Widget child, AuthState authState) {
  return ChangeNotifierProvider<AuthState>.value(
    value: authState,
    child: MaterialApp(
      home: child,
    ),
  );
}

void main() {
  group('Phase 4.2 Findings Remediation B1–B6 Tests', () {
    late AuthState authState;

    setUp(() {
      authState = AuthState();
    });

    testWidgets('B1: Route /dashboard/accounts is registered and routes to AccountantDashboardScreen', (tester) async {
      final router = createOnpsRouter(authState);
      await tester.pumpWidget(
        ChangeNotifierProvider<AuthState>.value(
          value: authState,
          child: MaterialApp.router(
            routerConfig: router,
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Navigate to /dashboard/accounts
      router.go('/dashboard/accounts');
      await tester.pumpAndSettle();

      expect(find.byType(AccountantDashboardScreen), findsOneWidget);
    });

    testWidgets('B2: Parent Attendance resolves selected child and switches cleanly without stale state', (tester) async {
      authState.setLinkedChildren([
        {'id': '1560', 'full_name': 'Bushra Malik', 'class_section': 'Nursery A'},
        {'id': '1561', 'full_name': 'Zaid Malik', 'class_section': 'Grade 1-B'},
      ]);
      authState.switchRole(UserRole.parent);

      await tester.pumpWidget(createTestApp(const StudentAttendanceScreen(), authState));
      await tester.pumpAndSettle();

      // Verify real linked children rendered in selector
      expect(find.text('Bushra Malik'), findsOneWidget);
      expect(find.text('Zaid Malik'), findsOneWidget);
      expect(authState.selectedChild.firstName, 'Bushra');

      // Tap on second child
      await tester.tap(find.text('Zaid Malik'));
      await tester.pumpAndSettle();

      expect(authState.selectedChildIndex, 1);
      expect(authState.selectedChild.firstName, 'Zaid');
      expect(authState.selectedLinkedChild?['id'], '1561');
    });

    testWidgets('B3: Parent Academic Report Card renders real linked children from AuthState without static mock tabs', (tester) async {
      authState.setLinkedChildren([
        {'id': '1560', 'full_name': 'Bushra Malik', 'class_section': 'Nursery A'},
      ]);
      authState.switchRole(UserRole.parent);

      await tester.pumpWidget(createTestApp(const AcademicReportCardScreen(studentId: ''), authState));
      await tester.pumpAndSettle();

      // Should display real child Bushra Malik
      expect(find.text('Bushra Malik'), findsWidgets);

      // Must NOT display hardcoded mock children
      expect(find.text('Diya Sharma'), findsNothing);
      expect(find.text('Aarav Sharma'), findsNothing);
    });

    testWidgets('B4: Fee Ledger Screen mounts cleanly for parent and staff personas without 404 crash', (tester) async {
      // 1. Parent context
      authState.setLinkedChildren([
        {'id': '1560', 'full_name': 'Bushra Malik', 'class_section': 'Nursery A'},
      ]);
      authState.switchRole(UserRole.parent);

      await tester.pumpWidget(createTestApp(const FeeLedgerScreen(), authState));
      await tester.pumpAndSettle();

      expect(find.byType(FeeLedgerScreen), findsOneWidget);
      expect(find.text('Fee Ledger & Dues'), findsOneWidget);
      expect(find.text('Bushra Malik'), findsOneWidget);

      // 2. Accountant context
      authState.switchRole(UserRole.accountant);
      await tester.pumpWidget(createTestApp(const FeeLedgerScreen(), authState));
      await tester.pumpAndSettle();

      expect(find.byType(FeeLedgerScreen), findsOneWidget);
      expect(find.text('Fee Ledger & Dues'), findsOneWidget);
    });

    testWidgets('B5: Digital Student ID screen supports self-access when no studentId is passed', (tester) async {
      authState.switchRole(UserRole.student);

      await tester.pumpWidget(createTestApp(const DigitalStudentIdCardScreen(), authState));
      await tester.pumpAndSettle();

      expect(find.byType(DigitalStudentIdCardScreen), findsOneWidget);
      expect(find.text('Digital Student ID'), findsOneWidget);
      expect(find.text('Verified Student Identity'), findsOneWidget);
    });

    test('B6: ApiConfig and default headers omit Authorization token when null or on login', () async {
      await TokenStorage.saveToken('stale_expired_token_12345');

      // Default headers without token parameter should omit Authorization
      final headersWithoutToken = ApiConfig.defaultHeaders(token: null);
      expect(headersWithoutToken.containsKey('Authorization'), isFalse);

      // Default headers with token parameter should include Bearer token
      final headersWithToken = ApiConfig.defaultHeaders(token: 'valid_token_abc');
      expect(headersWithToken['Authorization'], 'Bearer valid_token_abc');

      // Cleanup
      await TokenStorage.clearSession();
    });
  });
}
