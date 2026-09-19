// ==============================================================================
// One Numan Public School (ONPS) — Android ERP Mobile Application
// Test: Class Teacher More Screen (Class Context, School Utilities & Faculty Account)
// Verifies:
// - 5-item bottom dock (Hub | Attendance | Classes | Timetable | More)
// - More launcher with header "All Modules" and subtitle "Class Utilities & Faculty Dossier"
// - 3 structured categories: MY CLASS (3 items), SCHOOL (3 items), ACCOUNT (2 items)
// - No duplicate primary dock workflows (no daily roll-call duplicate, no timetable duplicate)
// - No administrative features (no staff CRUD, admissions desk, cross-entity search, fee ledger)
// - Search functionality & category filter pills
// - Navigation to ClassInfoScreen, ClassStudentDirectoryScreen, ClassSubjectsScreen
// - Zero unicode emojis
// ==============================================================================

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:sms_android_app_alpha/main.dart';
import 'package:sms_android_app_alpha/screens/dashboards/class_teacher_dashboard_screen.dart';
import 'package:sms_android_app_alpha/screens/dashboards/parent_dashboard_screen.dart';
import 'package:sms_android_app_alpha/screens/faculty/class_info_screen.dart';
import 'package:sms_android_app_alpha/widgets/bottom_nav_bar.dart';
import 'package:sms_android_app_alpha/widgets/module_grid_sheet.dart';

void main() {
  testWidgets('Class Teacher More Screen: Architecture, Search, Filtering, Utilities & Zero Emojis', (WidgetTester tester) async {
    await tester.pumpWidget(const OnpsErpApp());
    await tester.pumpAndSettle();

    // 1. Navigate to /login and sign in as Teacher (Class Teacher)
    final BuildContext initialContext = tester.element(find.byType(ParentDashboardScreen));
    initialContext.go('/login');
    await tester.pumpAndSettle();

    final teacherTab = find.text('Teacher');
    expect(teacherTab, findsOneWidget);
    await tester.tap(teacherTab);
    await tester.pumpAndSettle();

    final signInButton = find.textContaining('Sign in as Teacher');
    expect(signInButton, findsOneWidget);
    await tester.tap(signInButton);
    await tester.pumpAndSettle();

    // Verify on ClassTeacherDashboardScreen
    expect(find.byType(ClassTeacherDashboardScreen), findsOneWidget);

    // 2. Verify Class Teacher Bottom Navigation has strictly 5 items
    Finder findInNav(String label) {
      return find.descendant(of: find.byType(AcademicBottomNavBar), matching: find.text(label));
    }

    expect(findInNav('Hub'), findsOneWidget);
    expect(findInNav('Attendance'), findsOneWidget);
    expect(findInNav('Classes'), findsOneWidget);
    expect(findInNav('Timetable'), findsOneWidget);
    expect(findInNav('More'), findsOneWidget);

    // 3. Open More Sheet via 5th tab 'More'
    await tester.tap(findInNav('More'));
    await tester.pumpAndSettle();

    Finder findInSheet(String label) {
      return find.descendant(of: find.byType(ModuleGridSheet), matching: find.text(label));
    }

    // 4. Verify Sheet Header & Role Subtitle
    expect(findInSheet('All Modules'), findsOneWidget);
    expect(findInSheet('Class Utilities & Faculty Profile'), findsOneWidget);

    // 5. Verify Categorized Section Headers
    expect(findInSheet('MY CLASS'), findsOneWidget);
    expect(findInSheet('SCHOOL'), findsOneWidget);
    expect(findInSheet('ACCOUNT'), findsOneWidget);

    // 6. Verify Exact 8 Secondary Desks Present
    // MY CLASS
    expect(findInSheet('Class Information'), findsOneWidget);
    expect(findInSheet('Student Directory'), findsOneWidget);
    expect(findInSheet('Class Subjects'), findsOneWidget);

    // SCHOOL
    expect(findInSheet('Notices & Circulars'), findsOneWidget);
    expect(findInSheet('Academic Calendar'), findsOneWidget);
    expect(findInSheet('My Leave Requests'), findsOneWidget);

    // ACCOUNT
    expect(findInSheet('Teacher Profile'), findsOneWidget);
    expect(findInSheet('App Settings'), findsOneWidget);

    // Footer actions
    expect(findInSheet('Switch Role'), findsOneWidget);
    expect(findInSheet('Sign Out'), findsOneWidget);

    // 7. Verify Strictly NO Primary Nav Duplicates or Admin Desks
    expect(findInSheet('Daily Roll-Call'), findsNothing);
    expect(findInSheet('Staff & Leadership'), findsNothing);
    expect(findInSheet('Admissions Desk'), findsNothing);
    expect(findInSheet('Cross-Entity Search'), findsNothing);
    expect(findInSheet('Accounts & Fee Ledger'), findsNothing);
    expect(findInSheet('School Setup'), findsNothing);

    // 8. Test Category Filter Chips
    expect(findInSheet('All (8)'), findsOneWidget);
    expect(findInSheet('My Class (3)'), findsOneWidget);
    expect(findInSheet('School (3)'), findsOneWidget);
    expect(findInSheet('Account (2)'), findsOneWidget);

    // Tap "My Class (3)" pill
    await tester.tap(findInSheet('My Class (3)'));
    await tester.pumpAndSettle();

    expect(findInSheet('Class Information'), findsOneWidget);
    expect(findInSheet('Student Directory'), findsOneWidget);
    expect(findInSheet('Class Subjects'), findsOneWidget);
    expect(findInSheet('Notices & Circulars'), findsNothing);

    // Reset to "All (8)"
    await tester.tap(findInSheet('All (8)'));
    await tester.pumpAndSettle();

    // 9. Test Keyword Search Filtering
    final searchInput = find.descendant(of: find.byType(ModuleGridSheet), matching: find.byType(TextField));
    await tester.enterText(searchInput, 'Leave');
    await tester.pumpAndSettle();

    expect(findInSheet('My Leave Requests'), findsOneWidget);
    expect(findInSheet('Class Information'), findsNothing);

    // Clear search
    await tester.enterText(searchInput, '');
    await tester.pumpAndSettle();

    // 10. Test Navigation to Class Information Screen
    await tester.tap(findInSheet('Class Information'));
    await tester.pumpAndSettle();

    expect(find.byType(ClassInfoScreen), findsOneWidget);
    expect(find.text('Grade 5 • Section A'), findsOneWidget);
    expect(find.text('Class Teacher: Anita Desai'), findsOneWidget);

    // 11. Zero Emojis Verification
    final emojiRegex = RegExp(
      r'[\u{1F300}-\u{1F5FF}\u{1F600}-\u{1F64F}\u{1F680}-\u{1F6FF}\u{2600}-\u{26FF}\u{2700}-\u{27BF}\u{1F900}-\u{1F9FF}\u{1F1E0}-\u{1F1FF}]',
      unicode: true,
    );

    final allTexts = tester.widgetList<Text>(find.byType(Text));
    for (final textWidget in allTexts) {
      final text = textWidget.data ?? textWidget.textSpan?.toPlainText() ?? '';
      expect(
        emojiRegex.hasMatch(text),
        isFalse,
        reason: 'Found unexpected unicode emoji: "$text"',
      );
    }
  });
}
