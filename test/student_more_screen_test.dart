// ==============================================================================
// One Numan Public School (ONPS) — Android ERP Mobile Application
// Test: Student More Screen (Secondary Utilities & Profile Hub)
// Verifies student categorization (MY SCHOOL, SERVICES, ACCOUNT),
// no duplication of primary nav, real backend capabilities, search,
// filtering, navigation, and zero unicode emojis.
// ==============================================================================

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:sms_android_app_alpha/main.dart';
import 'package:sms_android_app_alpha/screens/dashboards/student_hub_screen.dart';
import 'package:sms_android_app_alpha/screens/dashboards/parent_dashboard_screen.dart';
import 'package:sms_android_app_alpha/screens/students/digital_student_id_card_screen.dart';
import 'package:sms_android_app_alpha/widgets/bottom_nav_bar.dart';
import 'package:sms_android_app_alpha/widgets/module_grid_sheet.dart';

void main() {
  testWidgets('Student More Screen: Architecture, Search, Filtering, Utilities & Zero Emojis', (WidgetTester tester) async {
    await tester.pumpWidget(const OnpsErpApp());
    await tester.pumpAndSettle();

    // 1. Navigate to /login and sign in as Student
    final BuildContext initialContext = tester.element(find.byType(ParentDashboardScreen));
    initialContext.go('/login');
    await tester.pumpAndSettle();

    final studentTab = find.text('Student');
    expect(studentTab, findsOneWidget);
    await tester.tap(studentTab);
    await tester.pumpAndSettle();

    final signInButton = find.textContaining('Sign in as Student');
    expect(signInButton, findsOneWidget);
    await tester.tap(signInButton);
    await tester.pumpAndSettle();

    // Verify on StudentHubScreen
    expect(find.byType(StudentHubScreen), findsOneWidget);

    // 2. Verify Student Bottom Navigation has strictly 5 items
    Finder findInNav(String label) {
      return find.descendant(of: find.byType(AcademicBottomNavBar), matching: find.text(label));
    }

    expect(findInNav('Portal'), findsOneWidget);
    expect(findInNav('Academics'), findsOneWidget);
    expect(findInNav('Attendance'), findsOneWidget);
    expect(findInNav('Fees'), findsOneWidget);
    expect(findInNav('More'), findsOneWidget);

    // 3. Open More Sheet via 5th tab 'More'
    await tester.tap(findInNav('More'));
    await tester.pumpAndSettle();

    Finder findInSheet(String label) {
      return find.descendant(of: find.byType(ModuleGridSheet), matching: find.text(label));
    }

    // 4. Verify Sheet Header & Subtitle
    expect(findInSheet('All Modules'), findsOneWidget);
    expect(findInSheet('Student Utilities & Personal Profile'), findsOneWidget);

    // 5. Verify Categorized Section Headers for Student
    expect(findInSheet('MY SCHOOL'), findsOneWidget);
    expect(findInSheet('SERVICES'), findsOneWidget);
    expect(findInSheet('ACCOUNT'), findsOneWidget);

    // 6. Verify Genuine Secondary Student Capabilities
    expect(findInSheet('Digital Student ID'), findsOneWidget);
    expect(findInSheet('Class Timetable'), findsOneWidget);
    expect(findInSheet('School Notices'), findsOneWidget);
    expect(findInSheet('Academic Calendar'), findsOneWidget);
    expect(findInSheet('Bus Transit'), findsOneWidget);
    expect(findInSheet('Student Profile'), findsOneWidget);
    expect(findInSheet('App Settings'), findsOneWidget);

    // 7. Verify Institutional Footer Actions
    expect(findInSheet('Switch Role'), findsOneWidget);
    expect(findInSheet('Sign Out'), findsOneWidget);

    // 8. Verify NO duplicate primary navigation items
    // (Portal, Report Card/Academics, Attendance, Fees are already on the bottom bar)
    expect(findInSheet('My Dashboard'), findsNothing);
    expect(findInSheet('Report Card'), findsNothing);
    expect(findInSheet('Daily Roll-Call'), findsNothing);

    // 9. Verify NO staff/admin capabilities are exposed to student
    expect(findInSheet('Staff & Leadership'), findsNothing);
    expect(findInSheet('Marks Entry'), findsNothing);
    expect(findInSheet('Admissions Desk'), findsNothing);
    expect(findInSheet('Attendance Matrix'), findsNothing);
    expect(findInSheet('Cross-Entity Search'), findsNothing);

    // 10. Test Search Filtering
    final searchInput = find.descendant(of: find.byType(ModuleGridSheet), matching: find.byType(TextField));
    expect(searchInput, findsOneWidget);

    await tester.enterText(searchInput, 'Timetable');
    await tester.pumpAndSettle();

    expect(findInSheet('Class Timetable'), findsOneWidget);
    expect(findInSheet('Bus Transit'), findsNothing);
    expect(findInSheet('Student Profile'), findsNothing);

    // Clear search
    final clearBtn = find.descendant(of: find.byType(ModuleGridSheet), matching: find.byIcon(Icons.cancel));
    expect(clearBtn, findsOneWidget);
    await tester.tap(clearBtn);
    await tester.pumpAndSettle();

    // Verify all restored
    expect(findInSheet('Class Timetable'), findsOneWidget);
    expect(findInSheet('Bus Transit'), findsOneWidget);

    // 11. Test Category Filtering: Tap 'My School'
    final schoolPill = find.descendant(of: find.byType(ModuleGridSheet), matching: find.textContaining('My School ('));
    expect(schoolPill, findsOneWidget);
    await tester.tap(schoolPill);
    await tester.pumpAndSettle();

    expect(findInSheet('MY SCHOOL'), findsOneWidget);
    expect(findInSheet('Class Timetable'), findsOneWidget);
    expect(findInSheet('SERVICES'), findsNothing);
    expect(findInSheet('ACCOUNT'), findsNothing);

    // Switch back to 'All'
    final allPill = find.descendant(of: find.byType(ModuleGridSheet), matching: find.textContaining('All ('));
    expect(allPill, findsOneWidget);
    await tester.tap(allPill);
    await tester.pumpAndSettle();

    expect(findInSheet('MY SCHOOL'), findsOneWidget);
    expect(findInSheet('SERVICES'), findsOneWidget);
    expect(findInSheet('ACCOUNT'), findsOneWidget);

    // 12. Test Navigation: Tap 'Digital Student ID'
    await tester.ensureVisible(findInSheet('Digital Student ID'));
    await tester.pumpAndSettle();
    await tester.tap(findInSheet('Digital Student ID'));
    await tester.pumpAndSettle();

    // Verify navigated to DigitalStudentIdCardScreen
    expect(find.byType(DigitalStudentIdCardScreen), findsOneWidget);

    // 13. Verify Zero Unicode Emojis
    final emojiRegex = RegExp(r'[\u{1F300}-\u{1F6FF}\u{1F900}-\u{1F9FF}\u{2600}-\u{26FF}\u{2700}-\u{27BF}]', unicode: true);
    for (final element in find.byType(Text).evaluate()) {
      final widget = element.widget as Text;
      final text = widget.data ?? widget.textSpan?.toPlainText() ?? '';
      expect(emojiRegex.hasMatch(text), isFalse, reason: 'Found emoji in text: "$text"');
    }
  });
}
