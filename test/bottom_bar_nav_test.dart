import 'package:flutter_test/flutter_test.dart';
import 'package:sms_android_app_alpha/main.dart';
import 'package:sms_android_app_alpha/screens/dashboards/parent_dashboard_screen.dart';
import 'package:sms_android_app_alpha/screens/fees/fee_ledger_screen.dart';
import 'package:sms_android_app_alpha/screens/students/academic_report_card_screen.dart';
import 'package:sms_android_app_alpha/widgets/bottom_nav_bar.dart';

void main() {
  testWidgets('Test clicking Academics and Fees in bottom nav bar retains navigation bar', (WidgetTester tester) async {
    await tester.pumpWidget(const OnpsErpApp());
    await tester.pumpAndSettle();

    expect(find.byType(ParentDashboardScreen), findsOneWidget);
    expect(find.byType(AcademicBottomNavBar), findsOneWidget);

    // Tap Academics in bottom nav bar
    final academicsInNav = find.descendant(
      of: find.byType(AcademicBottomNavBar),
      matching: find.text('Academics'),
    );
    expect(academicsInNav, findsOneWidget);
    await tester.tap(academicsInNav);
    await tester.pumpAndSettle();

    // Verify AcademicReportCardScreen is displayed with bottom nav bar
    expect(find.byType(AcademicReportCardScreen), findsOneWidget);
    expect(find.byType(AcademicBottomNavBar), findsOneWidget);

    // Tap Fees in bottom nav bar
    final feesInNav = find.descendant(
      of: find.byType(AcademicBottomNavBar),
      matching: find.text('Fees'),
    );
    expect(feesInNav, findsOneWidget);
    await tester.tap(feesInNav);
    await tester.pumpAndSettle();

    // Verify FeeLedgerScreen is displayed with bottom nav bar
    expect(find.byType(FeeLedgerScreen), findsOneWidget);
    expect(find.byType(AcademicBottomNavBar), findsOneWidget);

    // Tap Portal in bottom nav bar to return to ParentDashboardScreen
    final portalInNav = find.descendant(
      of: find.byType(AcademicBottomNavBar),
      matching: find.text('Portal'),
    );
    expect(portalInNav, findsOneWidget);
    await tester.tap(portalInNav);
    await tester.pumpAndSettle();

    expect(find.byType(ParentDashboardScreen), findsOneWidget);
    expect(find.byType(AcademicBottomNavBar), findsOneWidget);
  });
}
