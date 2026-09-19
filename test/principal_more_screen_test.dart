// ==============================================================================
// One Numan Public School (ONPS) — Android ERP Mobile Application
// Test: Principal More Screen (School Administration & Operational Hub)
// Verifies categorized architecture, real backend capabilities, search,
// category filtering, navigation, and zero unicode emojis.
// ==============================================================================

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:sms_android_app_alpha/main.dart';
import 'package:sms_android_app_alpha/screens/dashboards/principal_dashboard_screen.dart';
import 'package:sms_android_app_alpha/screens/dashboards/parent_dashboard_screen.dart';
import 'package:sms_android_app_alpha/screens/admin/parents_directory_screen.dart';
import 'package:sms_android_app_alpha/widgets/bottom_nav_bar.dart';

void main() {
  testWidgets('Principal More Screen: Architecture, Search, Filtering, Desks & Zero Emojis', (WidgetTester tester) async {
    await tester.pumpWidget(const OnpsErpApp());
    await tester.pumpAndSettle();

    // 1. Navigate to /login and sign in as Staff (Principal)
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

    // Verify on PrincipalDashboardScreen
    expect(find.byType(PrincipalDashboardScreen), findsOneWidget);

    // 2. Open More Sheet via 5th tab 'More'
    Finder findInNav(String label) {
      return find.descendant(of: find.byType(AcademicBottomNavBar), matching: find.text(label));
    }

    expect(findInNav('More'), findsOneWidget);
    await tester.tap(findInNav('More'));
    await tester.pumpAndSettle();

    // 3. Verify Sheet Header & Subtitle
    expect(find.text('All Modules'), findsOneWidget);
    expect(find.text('Institutional Administration & Operational Suites'), findsOneWidget);

    // 4. Verify Categorized Section Headers
    expect(find.text('ADMINISTRATION'), findsOneWidget);
    expect(find.text('SCHOOL OPERATIONS'), findsOneWidget);
    expect(find.text('ACCOUNT & GOVERNANCE'), findsOneWidget);

    // 5. Verify Genuine Administrative Capabilities
    expect(find.text('Staff & Leadership'), findsOneWidget);
    expect(find.text('Faculty & Teaching'), findsOneWidget);
    expect(find.text('Classes & Sections'), findsOneWidget);
    expect(find.text('Subjects & Teaching'), findsOneWidget);
    expect(find.text('Parents & Guardians'), findsOneWidget);
    expect(find.text('Admissions Desk'), findsOneWidget);
    expect(find.text('Cross-Entity Search'), findsOneWidget);

    // 6. Verify Genuine Operational Desks
    expect(find.text('Attendance Matrix'), findsOneWidget);
    expect(find.text('Accounts & Fee Ledger'), findsOneWidget);
    expect(find.text('Master Timetables'), findsOneWidget);
    expect(find.text('Transport & Transit'), findsOneWidget);
    expect(find.text('Academic Calendar'), findsOneWidget);
    expect(find.text('Announcement Moderation Queue'), findsOneWidget);
    expect(find.text('Central Library'), findsOneWidget);
    expect(find.text('Inventory & Supplies'), findsOneWidget);
    expect(find.text('Notification Center'), findsOneWidget);

    // 7. Verify Account & Institutional Footer Actions
    expect(find.text('Executive Profile'), findsOneWidget);
    expect(find.text('System Settings'), findsOneWidget);
    expect(find.text('Switch Role'), findsOneWidget);
    expect(find.text('Sign Out'), findsOneWidget);

    // 8. Verify NO duplicate primary navigation items
    // (Notice Board is in 4th tab 'Notices', Executive Dashboard is 1st tab 'Portal')
    expect(find.text('Notice Board'), findsNothing);
    expect(find.text('Executive Dashboard'), findsNothing);

    // 9. Test Search Filtering
    final searchInput = find.byType(TextField);
    expect(searchInput, findsOneWidget);

    await tester.enterText(searchInput, 'Parents');
    await tester.pumpAndSettle();

    expect(find.text('Parents & Guardians'), findsOneWidget);
    expect(find.text('Transport & Transit'), findsNothing);
    expect(find.text('Attendance Matrix'), findsNothing);

    // Clear search
    final clearBtn = find.byIcon(Icons.cancel);
    expect(clearBtn, findsOneWidget);
    await tester.tap(clearBtn);
    await tester.pumpAndSettle();

    // Verify all desks restored
    expect(find.text('Parents & Guardians'), findsOneWidget);
    expect(find.text('Transport & Transit'), findsOneWidget);

    // 10. Test Category Filtering: Tap 'Operations'
    final opsPill = find.textContaining('Operations (');
    expect(opsPill, findsOneWidget);
    await tester.tap(opsPill);
    await tester.pumpAndSettle();

    expect(find.text('SCHOOL OPERATIONS'), findsOneWidget);
    expect(find.text('Attendance Matrix'), findsOneWidget);
    expect(find.text('ADMINISTRATION'), findsNothing);

    // Switch back to 'All'
    final allPill = find.textContaining('All (');
    expect(allPill, findsOneWidget);
    await tester.tap(allPill);
    await tester.pumpAndSettle();

    expect(find.text('ADMINISTRATION'), findsOneWidget);
    expect(find.text('SCHOOL OPERATIONS'), findsOneWidget);

    // 11. Test Navigation: Tap 'Parents & Guardians'
    await tester.ensureVisible(find.text('Parents & Guardians'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Parents & Guardians'));
    await tester.pumpAndSettle();

    // Verify navigated to ParentsDirectoryScreen
    expect(find.byType(ParentsDirectoryScreen), findsOneWidget);

    // 12. Verify Zero Unicode Emojis
    final emojiRegex = RegExp(r'[\u{1F300}-\u{1F6FF}\u{1F900}-\u{1F9FF}\u{2600}-\u{26FF}\u{2700}-\u{27BF}]', unicode: true);
    for (final element in find.byType(Text).evaluate()) {
      final widget = element.widget as Text;
      final text = widget.data ?? widget.textSpan?.toPlainText() ?? '';
      expect(emojiRegex.hasMatch(text), isFalse, reason: 'Found emoji in text: "$text"');
    }
  });
}
