import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:sms_android_app_alpha/main.dart';
import 'package:sms_android_app_alpha/screens/dashboards/parent_dashboard_screen.dart';
import 'package:sms_android_app_alpha/screens/fees/fee_ledger_screen.dart';
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

    // 1. Fee Summary & Headers
    expect(find.text('TOTAL DUE'), findsOneWidget);
    expect(find.text('OUTSTANDING'), findsOneWidget);
    expect(find.text('₹12,450'), findsWidgets);

    // 2. Transaction History
    expect(find.text('TRANSACTION HISTORY'), findsOneWidget);

    // 3. 5-Tab Persistent Bottom Navigation Dock
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
