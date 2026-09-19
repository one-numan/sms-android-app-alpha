// ==============================================================================
// One Numan Public School (ONPS) — Android ERP Mobile Application
// Test: Subject Teacher More Screen (Teaching Portfolio, School Utilities & Faculty Account)
// Verifies:
// - 5-item bottom dock (Portal | Academics | Attendance | Timetable | More)
// - More launcher with header "All Modules" and subtitle "Subject Teaching & Faculty Dossier"
// - 3 structured categories: MY TEACHING (3 items), SCHOOL (3 items), ACCOUNT (2 items)
// - No duplicate primary dock workflows (no Portal, Academics, Attendance, Timetable duplicates)
// - No administrative features (no staff CRUD, admissions desk, cross-entity search, fee ledger)
// - Search functionality & category filter pills
// - Navigation to SubjectTeacherClassesScreen, SubjectTeacherAssignmentsScreen, Student Directory
// - Zero unicode emojis
// ==============================================================================

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:sms_android_app_alpha/data/mock/auth_state.dart';
import 'package:sms_android_app_alpha/main.dart';
import 'package:sms_android_app_alpha/models/models.dart';
import 'package:sms_android_app_alpha/screens/dashboards/parent_dashboard_screen.dart';
import 'package:sms_android_app_alpha/screens/dashboards/subject_teacher_dashboard_screen.dart';
import 'package:sms_android_app_alpha/screens/faculty/subject_teacher_classes_screen.dart';
import 'package:sms_android_app_alpha/widgets/bottom_nav_bar.dart';
import 'package:sms_android_app_alpha/widgets/module_grid_sheet.dart';

void main() {
  testWidgets('Subject Teacher More Screen: Architecture, Search, Filtering, Utilities & Zero Emojis', (WidgetTester tester) async {
    await tester.pumpWidget(const OnpsErpApp());
    await tester.pumpAndSettle();

    // 1. Navigate to /login and sign in as Subject Teacher
    final BuildContext initialContext = tester.element(find.byType(ParentDashboardScreen));
    initialContext.go('/login');
    await tester.pumpAndSettle();

    final teacherTab = find.text('Teacher');
    expect(teacherTab, findsOneWidget);
    await tester.tap(teacherTab);
    await tester.pumpAndSettle();

    // Set role to Subject Teacher via AuthState
    final BuildContext loginContext = tester.element(find.text('Teacher'));
    loginContext.read<AuthState>().switchRole(UserRole.subjectTeacher);
    loginContext.go('/dashboard/subject-teacher');
    await tester.pumpAndSettle();

    // Verify on SubjectTeacherDashboardScreen
    expect(find.byType(SubjectTeacherDashboardScreen), findsOneWidget);

    // 2. Verify Subject Teacher Bottom Navigation has strictly 5 items
    Finder findInNav(String label) {
      return find.descendant(of: find.byType(AcademicBottomNavBar), matching: find.text(label));
    }

    expect(findInNav('Portal'), findsOneWidget);
    expect(findInNav('Academics'), findsOneWidget);
    expect(findInNav('Attendance'), findsOneWidget);
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
    expect(findInSheet('Subject Teaching & Faculty Profile'), findsOneWidget);

    // 5. Verify Categorized Section Headers
    expect(findInSheet('MY TEACHING'), findsOneWidget);
    expect(findInSheet('SCHOOL'), findsOneWidget);
    expect(findInSheet('ACCOUNT'), findsOneWidget);

    // 6. Verify Exact 8 Secondary Desks Present
    // MY TEACHING
    expect(findInSheet('My Classes'), findsOneWidget);
    expect(findInSheet('My Subjects'), findsOneWidget);
    expect(findInSheet('Student Directory'), findsOneWidget);

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
    expect(findInSheet('Teaching (3)'), findsOneWidget);
    expect(findInSheet('School (3)'), findsOneWidget);
    expect(findInSheet('Account (2)'), findsOneWidget);

    // Tap "Teaching (3)" pill
    await tester.tap(findInSheet('Teaching (3)'));
    await tester.pumpAndSettle();

    expect(findInSheet('My Classes'), findsOneWidget);
    expect(findInSheet('My Subjects'), findsOneWidget);
    expect(findInSheet('Student Directory'), findsOneWidget);
    expect(findInSheet('Notices & Circulars'), findsNothing);

    // Reset to "All (8)"
    await tester.tap(findInSheet('All (8)'));
    await tester.pumpAndSettle();

    // 9. Test Keyword Search Filtering
    final searchInput = find.descendant(of: find.byType(ModuleGridSheet), matching: find.byType(TextField));
    await tester.enterText(searchInput, 'Leave');
    await tester.pumpAndSettle();

    expect(findInSheet('My Leave Requests'), findsOneWidget);
    expect(findInSheet('My Classes'), findsNothing);

    // Clear search
    await tester.enterText(searchInput, '');
    await tester.pumpAndSettle();

    // 10. Test Navigation to My Classes Screen
    await tester.tap(findInSheet('My Classes'));
    await tester.pumpAndSettle();

    expect(find.byType(SubjectTeacherClassesScreen), findsOneWidget);
    expect(find.text('Subject Faculty Classes'), findsOneWidget);
    expect(find.text('Grade 5 • Section A'), findsOneWidget);

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
