import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sms_android_app_alpha/main.dart';
import 'package:sms_android_app_alpha/screens/dashboards/parent_dashboard_screen.dart';
import 'package:sms_android_app_alpha/screens/fees/fee_ledger_screen.dart';

void main() {
  testWidgets('Test back button on sub-screen returns to dashboard and does not close app', (WidgetTester tester) async {
    await tester.pumpWidget(const OnpsErpApp());
    await tester.pumpAndSettle();

    // Verify initially on ParentDashboardScreen
    expect(find.byType(ParentDashboardScreen), findsOneWidget);

    // Tap Fees in bottom nav bar
    final feesTab = find.text('Fees');
    expect(feesTab, findsOneWidget);
    await tester.tap(feesTab);
    await tester.pumpAndSettle();

    // Verify on FeeLedgerScreen
    expect(find.byType(FeeLedgerScreen), findsOneWidget);
    expect(find.text('Fees'), findsWidgets);

    // Verify back button is visible in AppTopBar
    final backButton = find.byIcon(Icons.arrow_back);
    expect(backButton, findsOneWidget);

    // Tap back button
    await tester.tap(backButton);
    await tester.pumpAndSettle();

    // Verify returned to ParentDashboardScreen
    expect(find.byType(ParentDashboardScreen), findsOneWidget);
  });
}
