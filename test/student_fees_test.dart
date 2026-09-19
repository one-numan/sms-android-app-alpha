import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:sms_android_app_alpha/main.dart';
import 'package:sms_android_app_alpha/screens/dashboards/parent_dashboard_screen.dart';
import 'package:sms_android_app_alpha/screens/fees/fee_ledger_screen.dart';
import 'package:sms_android_app_alpha/screens/fees/fee_receipt_screen.dart';
import 'package:sms_android_app_alpha/widgets/bottom_nav_bar.dart';

void main() {
  testWidgets('Test Student Fees Screen Architecture, Calculations, Navigation & 0-Emojis', (WidgetTester tester) async {
    await tester.pumpWidget(const OnpsErpApp());
    await tester.pumpAndSettle();

    // Navigate to /fees/ledger
    final BuildContext context = tester.element(find.byType(ParentDashboardScreen));
    context.go('/fees/ledger');
    await tester.pumpAndSettle();

    expect(find.byType(FeeLedgerScreen), findsOneWidget);

    // 1. Compact Header
    expect(find.text('Fees'), findsWidgets);
    expect(find.text('Diya Sharma • Grade 5-A'), findsOneWidget);

    // 2. Fee Summary Card
    expect(find.text('TOTAL DUE'), findsOneWidget);
    expect(find.text('₹12,450'), findsWidgets);
    expect(find.text('Due by 15 Nov 2026'), findsOneWidget);
    expect(find.textContaining('Session Total: ₹26,650'), findsOneWidget);
    expect(find.textContaining('Paid: ₹14,200'), findsOneWidget);

    // 3. Outstanding Dues Itemization
    expect(find.text('OUTSTANDING DUES'), findsOneWidget);
    expect(find.text('Tuition Fee'), findsWidgets);
    expect(find.text('Transport Fee (Route 12)'), findsWidgets);
    expect(find.text('Laboratory Fee'), findsWidgets);
    expect(find.text('Annual Activity Fund'), findsWidgets);
    expect(find.text('Total Outstanding'), findsOneWidget);
    expect(find.text('Pay ₹12,450'), findsOneWidget);

    // 4. Fee Structure Breakdown
    expect(find.text('FEE STRUCTURE (SESSION 2026–27)'), findsOneWidget);
    expect(find.text('Total Term Rate'), findsOneWidget);

    // 5. Payment Receipt History
    expect(find.text('PAYMENT HISTORY'), findsOneWidget);
    expect(find.text('REC-2026-0891'), findsOneWidget);
    expect(find.text('REC-2025-0422'), findsOneWidget);

    // 6. Test Receipt Navigation via icon
    final receiptBtn = find.byIcon(Icons.receipt_outlined).first;
    await tester.ensureVisible(receiptBtn);
    await tester.pumpAndSettle();
    await tester.tap(receiptBtn);
    await tester.pumpAndSettle();

    expect(find.byType(FeeReceiptScreen), findsOneWidget);
    expect(find.text('Official Fee Receipt'), findsOneWidget);
    expect(find.text('REC-2026-0891'), findsOneWidget);

    // Navigate back to FeeLedgerScreen
    final backBtn = find.byIcon(Icons.arrow_back);
    await tester.tap(backBtn);
    await tester.pumpAndSettle();

    expect(find.byType(FeeLedgerScreen), findsOneWidget);

    // 7. 5-Tab Persistent Bottom Navigation Dock
    expect(find.byType(AcademicBottomNavBar), findsOneWidget);
    expect(find.text('Portal'), findsOneWidget);
    expect(find.text('Academics'), findsOneWidget);
    expect(find.text('Attendance'), findsOneWidget);
    expect(find.text('More'), findsOneWidget);

    // 8. Strict Zero Emojis Assertion
    final emojiRegex = RegExp(r'[\u{1F300}-\u{1F9FF}\u{2600}-\u{26FF}\u{2700}-\u{27BF}]', unicode: true);
    for (final textWidget in tester.widgetList<Text>(find.byType(Text))) {
      final text = textWidget.data ?? textWidget.textSpan?.toPlainText() ?? '';
      expect(emojiRegex.hasMatch(text), isFalse, reason: 'Found emoji in text: "$text"');
    }
  });
}
