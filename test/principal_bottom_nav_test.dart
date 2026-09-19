import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:sms_android_app_alpha/main.dart';
import 'package:sms_android_app_alpha/screens/dashboards/principal_dashboard_screen.dart';
import 'package:sms_android_app_alpha/screens/dashboards/parent_dashboard_screen.dart';
import 'package:sms_android_app_alpha/screens/students/all_students_ledger_screen.dart';
import 'package:sms_android_app_alpha/screens/calendar_announcements/notice_board_screen.dart';
import 'package:sms_android_app_alpha/screens/faculty/faculty_allocation_screen.dart';
import 'package:sms_android_app_alpha/widgets/bottom_nav_bar.dart';

void main() {
  testWidgets('Test Principal bottom navigation has exactly 5 clear items: Portal, Academics, Students, Notices, More', (WidgetTester tester) async {
    await tester.pumpWidget(const OnpsErpApp());
    await tester.pumpAndSettle();

    // Navigate to /login and sign in as Principal/Staff
    final BuildContext initialContext = tester.element(find.byType(ParentDashboardScreen));
    initialContext.go('/login');
    await tester.pumpAndSettle();

    final staffTab = find.text('Staff');
    expect(staffTab, findsOneWidget);
    await tester.tap(staffTab);
    await tester.pumpAndSettle();

    final signInButton = find.textContaining('Sign in as Staff');
    expect(signInButton, findsOneWidget);
    await tester.tap(signInButton);

    // Settle transition
    await tester.pump(const Duration(milliseconds: 1600));
    await tester.pumpAndSettle();

    // Verify we are on PrincipalDashboardScreen
    expect(find.byType(PrincipalDashboardScreen), findsOneWidget);

    // Verify AcademicBottomNavBar is rendered
    final navBarFinder = find.byType(AcademicBottomNavBar);
    expect(navBarFinder, findsOneWidget);

    Finder findInNav(String label) {
      return find.descendant(of: find.byType(AcademicBottomNavBar), matching: find.text(label));
    }

    // Check exactly 5 items in bottom navigation
    expect(findInNav('Portal'), findsOneWidget);
    expect(findInNav('Academics'), findsOneWidget);
    expect(findInNav('Students'), findsOneWidget);
    expect(findInNav('Notices'), findsOneWidget);
    expect(findInNav('More'), findsOneWidget);

    // Verify removed items are NOT present in bottom nav
    expect(findInNav('Command'), findsNothing);
    expect(findInNav('Roster'), findsNothing);
    expect(findInNav('Directory'), findsNothing);
    expect(findInNav('Directories'), findsNothing);

    // Test Navigation: Tap Academics
    await tester.tap(findInNav('Academics'));
    await tester.pumpAndSettle();
    expect(find.byType(FacultyAllocationScreen), findsOneWidget);

    // Return to Principal Portal
    tester.element(find.byType(FacultyAllocationScreen)).go('/dashboard/principal');
    await tester.pumpAndSettle();
    expect(find.byType(PrincipalDashboardScreen), findsOneWidget);

    // Test Navigation: Tap Students
    await tester.tap(findInNav('Students'));
    await tester.pumpAndSettle();
    expect(find.byType(AllStudentsLedgerScreen), findsOneWidget);

    // Return to Principal Portal
    tester.element(find.byType(AllStudentsLedgerScreen)).go('/dashboard/principal');
    await tester.pumpAndSettle();
    expect(find.byType(PrincipalDashboardScreen), findsOneWidget);

    // Test Navigation: Tap Notices
    await tester.tap(findInNav('Notices'));
    await tester.pumpAndSettle();
    expect(find.byType(NoticeBoardScreen), findsOneWidget);

    // Return to Principal Portal
    tester.element(find.byType(NoticeBoardScreen)).go('/dashboard/principal');
    await tester.pumpAndSettle();
    expect(find.byType(PrincipalDashboardScreen), findsOneWidget);

    // Test Navigation: Tap More opens ModuleGridSheet
    await tester.tap(findInNav('More'));
    await tester.pumpAndSettle();
    expect(find.text('All Modules'), findsOneWidget);
  });
}
