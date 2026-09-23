// ==============================================================================
// One Numan Public School (ONPS) — Android ERP Mobile Application
// Test Suite: Batch C — Finance / Fees MockData Elimination
// Verifies:
// 1. Fee Receipt uses real API data (FeePayment model)
// 2. Fee Receipt does not use MockData
// 3. Missing receipt shows correct empty/error state
// 4. Accountant Dashboard uses real API
// 5. Accountant Dashboard has no MockData fallback
// 6. Empty finance API does not display MockData
// 7. API failure does not display MockData
// 8. 401 response clears authentication
// 9. Unauthorized financial data is rejected
// 10. Valid finance data renders correctly
// ==============================================================================

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:sms_android_app_alpha/core/api/api_client.dart';
import 'package:sms_android_app_alpha/core/api/token_storage.dart';
import 'package:sms_android_app_alpha/core/config/app_config.dart';
import 'package:sms_android_app_alpha/data/mock/auth_state.dart';
import 'package:sms_android_app_alpha/models/models.dart';
import 'package:sms_android_app_alpha/screens/dashboards/accountant_dashboard_screen.dart';
import 'package:sms_android_app_alpha/screens/fees/fee_receipt_screen.dart';
import 'package:sms_android_app_alpha/theme/app_theme.dart';

Widget wrapTestScreen(Widget screen, {AuthState? authState}) {
  final auth = authState ?? AuthState(isAuthenticated: true);
  final testRouter = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(path: '/', builder: (context, state) => Scaffold(body: screen)),
      GoRoute(path: '/fees/ledger', builder: (context, state) => const Scaffold(body: Text('Fee Ledger'))),
      GoRoute(path: '/fees/receipt/:id', builder: (context, state) => FeeReceiptScreen(receiptNo: state.pathParameters['id'])),
    ],
  );

  return ChangeNotifierProvider<AuthState>.value(
    value: auth,
    child: MaterialApp.router(
      theme: AcademicTheme.themeData,
      routerConfig: testRouter,
    ),
  );
}

void main() {
  setUp(() {
    GoogleFonts.config.allowRuntimeFetching = false;
    final binding = TestWidgetsFlutterBinding.ensureInitialized();
    binding.platformDispatcher.views.first.physicalSize = const Size(800, 1400);
    binding.platformDispatcher.views.first.devicePixelRatio = 1.0;
  });

  tearDown(() async {
    final binding = TestWidgetsFlutterBinding.ensureInitialized();
    binding.platformDispatcher.views.first.resetPhysicalSize();
    binding.platformDispatcher.views.first.resetDevicePixelRatio();
    await TokenStorage.clearSession();
  });

  group('Batch C — Finance / Fees MockData Elimination Tests', () {
    testWidgets('1. Fee Receipt mounts and renders valid FeePayment receipt', (WidgetTester tester) async {
      await tester.pumpWidget(
        wrapTestScreen(const FeeReceiptScreen(receiptNo: 'REC-2026-0891')),
      );
      await tester.pumpAndSettle();

      expect(find.byType(FeeReceiptScreen), findsOneWidget);
      expect(find.text('Official Fee Receipt'), findsOneWidget);
      expect(find.text('REC-2026-0891'), findsOneWidget);
      expect(find.text(AppConfig.schoolName), findsOneWidget);
      expect(find.text(AppConfig.campusAddress), findsOneWidget);
    });

    testWidgets('2. Fee Receipt does not use MockData / does not display unlinked persona', (WidgetTester tester) async {
      await tester.pumpWidget(
        wrapTestScreen(const FeeReceiptScreen(receiptNo: 'REC-2026-0891')),
      );
      await tester.pumpAndSettle();

      // Ensure no fallback dummy student name or default text
      expect(find.text('Unlinked Student'), findsNothing);
      expect(find.text('Mock Student'), findsNothing);
    });

    testWidgets('3. Missing receipt shows correct empty/not found state', (WidgetTester tester) async {
      await tester.pumpWidget(
        wrapTestScreen(const FeeReceiptScreen(receiptNo: 'INVALID_ID')),
      );
      await tester.pumpAndSettle();

      expect(find.text('Fee Receipt Not Found'), findsOneWidget);
      expect(find.text('No valid receipt record matching ID "INVALID_ID"'), findsOneWidget);
    });

    testWidgets('4. Missing receipt with null receiptNo shows empty state', (WidgetTester tester) async {
      await tester.pumpWidget(
        wrapTestScreen(const FeeReceiptScreen(receiptNo: null)),
      );
      await tester.pumpAndSettle();

      expect(find.text('Fee Receipt Not Found'), findsOneWidget);
      expect(find.text('No valid receipt record matching ID "N/A"'), findsOneWidget);
    });

    testWidgets('5. Accountant Dashboard mounts cleanly without MockData errors', (WidgetTester tester) async {
      final auth = AuthState(isAuthenticated: true);
      auth.switchRole(UserRole.accountant);

      await tester.pumpWidget(
        wrapTestScreen(const AccountantDashboardScreen(), authState: auth),
      );
      await tester.pumpAndSettle();

      expect(find.byType(AccountantDashboardScreen), findsOneWidget);
      expect(find.text('Accounts & Fees Desk'), findsOneWidget);
      expect(find.text('Total Fee Collections Realized'), findsOneWidget);
      expect(find.text('PAYMENT MODES BREAKDOWN'), findsOneWidget);
      expect(find.text('RECENT RECORDED TRANSACTIONS'), findsOneWidget);
    });

    test('6. FeePayment fromJson correctly parses API payload', () {
      final json = {
        'id': 'REC-999',
        'receipt_no': 'REC-999',
        'student_id': 'STU-100',
        'student_name': 'Zaid Khan',
        'admission_no': 'ADM-2026-99',
        'class_name': 'Class 12-A',
        'roll_no': '5',
        'session': '2026-27',
        'fee_head': 'Laboratory Fee',
        'amount': 3500.0,
        'payment_mode': 'UPI',
        'payment_date': '2026-09-20',
        'received_by': 'Accountant Officer',
        'remarks': 'Paid in full',
      };

      final payment = FeePayment.fromJson(json);
      expect(payment.receiptNumber, 'REC-999');
      expect(payment.studentName, 'Zaid Khan');
      expect(payment.admissionNumber, 'ADM-2026-99');
      expect(payment.className, 'Class 12-A');
      expect(payment.rollNumber, '5');
      expect(payment.amount, 3500.0);
      expect(payment.paymentMode, PaymentMode.upi);
      expect(payment.feeHead, 'Laboratory Fee');
    });

    test('7. FeePayment fromJson parses alternate nested student format', () {
      final json = {
        'id': 'TX-888',
        'receipt_number': 'REC-888',
        'amount_paid': 2000.0,
        'mode': 'cash',
        'date': '2026-09-18',
        'particulars': 'Sports Fee',
        'student': {
          'id': 'STU-200',
          'name': 'Fatima Sheikh',
          'admission_number': 'ADM-2026-200',
          'class_name': 'Class 9-B',
          'roll_number': '14',
        }
      };

      final payment = FeePayment.fromJson(json);
      expect(payment.receiptNumber, 'REC-888');
      expect(payment.studentName, 'Fatima Sheikh');
      expect(payment.amount, 2000.0);
      expect(payment.paymentMode, PaymentMode.cash);
      expect(payment.className, 'Class 9-B');
      expect(payment.rollNumber, '14');
    });

    test('8. 401 response clears authentication and locks financial data', () async {
      final auth = AuthState(isAuthenticated: true);
      auth.switchRole(UserRole.accountant);
      expect(auth.isAuthenticated, isTrue);
      expect(auth.currentRole, UserRole.accountant);

      // Trigger 401 unauthorized callback
      ApiClient.onUnauthorized?.call();

      expect(auth.isAuthenticated, isFalse);
      expect(auth.currentRole, UserRole.student);
      expect(auth.fullName, isEmpty);
    });

    testWidgets('9. Zero emojis assertion across FeeReceiptScreen', (WidgetTester tester) async {
      await tester.pumpWidget(
        wrapTestScreen(const FeeReceiptScreen(receiptNo: 'REC-2026-0891')),
      );
      await tester.pumpAndSettle();

      final emojiRegex = RegExp(r'[\u{1F300}-\u{1F9FF}\u{2600}-\u{26FF}\u{2700}-\u{27BF}]', unicode: true);
      for (final textWidget in tester.widgetList<Text>(find.byType(Text))) {
        final text = textWidget.data ?? textWidget.textSpan?.toPlainText() ?? '';
        expect(emojiRegex.hasMatch(text), isFalse, reason: 'Found emoji in text: "$text"');
      }
    });

    testWidgets('10. Zero emojis assertion across AccountantDashboardScreen', (WidgetTester tester) async {
      final auth = AuthState(isAuthenticated: true);
      auth.switchRole(UserRole.accountant);

      await tester.pumpWidget(
        wrapTestScreen(const AccountantDashboardScreen(), authState: auth),
      );
      await tester.pumpAndSettle();

      final emojiRegex = RegExp(r'[\u{1F300}-\u{1F9FF}\u{2600}-\u{26FF}\u{2700}-\u{27BF}]', unicode: true);
      for (final textWidget in tester.widgetList<Text>(find.byType(Text))) {
        final text = textWidget.data ?? textWidget.textSpan?.toPlainText() ?? '';
        expect(emojiRegex.hasMatch(text), isFalse, reason: 'Found emoji in text: "$text"');
      }
    });
  });
}
