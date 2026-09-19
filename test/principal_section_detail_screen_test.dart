// ==============================================================================
// Principal Academics -> Section Detail Screen Comprehensive Test Suite
// Validates: Screen context, section switcher, class teacher, enrolled students,
// assigned subjects roster, academic records, operational summaries, 320px responsiveness,
// and zero unicode emojis.
// ==============================================================================

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:sms_android_app_alpha/main.dart';
import 'package:sms_android_app_alpha/screens/dashboards/parent_dashboard_screen.dart';
import 'package:sms_android_app_alpha/screens/faculty/principal_section_detail_screen.dart';
import 'package:sms_android_app_alpha/widgets/bottom_nav_bar.dart';

void main() {
  testWidgets('Principal Section Detail Screen: Context, hierarchy, roster, section switcher, and modal sheets', (WidgetTester tester) async {
    await tester.pumpWidget(const OnpsErpApp());
    await tester.pumpAndSettle();

    // 1. Authenticate as Staff/Principal
    final BuildContext initialContext = tester.element(find.byType(ParentDashboardScreen));
    initialContext.go('/login');
    await tester.pumpAndSettle();

    await tester.tap(find.text('Staff'));
    await tester.pumpAndSettle();

    final signInBtn = find.textContaining('Sign in as Staff');
    await tester.ensureVisible(signInBtn);
    await tester.pumpAndSettle();
    await tester.tap(signInBtn);
    await tester.pump(const Duration(milliseconds: 1600));
    await tester.pumpAndSettle();

    // 2. Navigate directly to /faculty/section-detail?grade=5&section=A
    final BuildContext authContext = tester.element(find.byType(AcademicBottomNavBar));
    authContext.go('/faculty/section-detail?grade=5&section=A');
    await tester.pumpAndSettle();

    // 3. Verify PrincipalSectionDetailScreen is active
    expect(find.byType(PrincipalSectionDetailScreen), findsOneWidget);
    expect(find.text('Section 5-A'), findsWidgets);
    expect(find.text('2026–27'), findsWidgets);

    // 4. Verify Academic Context & Section Switcher
    expect(find.text('ACADEMIC CONTEXT: CLASS 5'), findsOneWidget);
    expect(find.text('5-A'), findsWidgets);
    expect(find.text('5-B'), findsWidgets);
    expect(find.text('5-C'), findsWidgets);
    expect(find.text('5-D'), findsWidgets);
    expect(find.text('5-E'), findsWidgets);

    // 5. Verify Class Teacher Card
    expect(find.text('CLASS TEACHER'), findsOneWidget);
    expect(find.text('Anita Desai'), findsWidgets);
    expect(find.textContaining('Senior Faculty'), findsOneWidget);

    // 6. Verify Enrolled Students Preview
    expect(find.textContaining('STUDENTS (32)'), findsOneWidget);
    expect(find.text('View Students →'), findsOneWidget);
    expect(find.text('Diya Sharma'), findsOneWidget);

    // 7. Verify Assigned Subjects Roster
    expect(find.textContaining('ASSIGNED SUBJECTS'), findsOneWidget);
    expect(find.text('Mathematics'), findsWidgets);
    expect(find.text('Science'), findsWidgets);
    expect(find.text('English'), findsWidgets);

    // 8. Verify Academic Records & Operations
    expect(find.text('ACADEMIC RECORDS & RESULTS'), findsOneWidget);
    expect(find.text('Term 1 Published'), findsOneWidget);
    expect(find.text('Marks Ledger'), findsOneWidget);
    expect(find.text('View Results →'), findsOneWidget);

    // 9. Verify Operational Desks
    expect(find.text('OPERATIONAL DESKS'), findsOneWidget);
    expect(find.text('Daily Attendance'), findsOneWidget);
    expect(find.text('Weekly Timetable'), findsOneWidget);

    // 10. Test Section Switcher: Tap 5-C
    final secChip5C = find.text('5-C').first;
    await tester.ensureVisible(secChip5C);
    await tester.pumpAndSettle();
    await tester.tap(secChip5C);
    await tester.pumpAndSettle();

    // Verify Section 5-C is now active with Robert Chen as Class Teacher
    expect(find.text('Section 5-C'), findsWidgets);
    expect(find.text('Robert Chen'), findsWidgets);

    // 11. Test Subject Details Modal
    final scienceSubject = find.text('Science').first;
    await tester.ensureVisible(scienceSubject);
    await tester.pumpAndSettle();
    await tester.tap(scienceSubject);
    await tester.pumpAndSettle();

    expect(find.text('Assigned Faculty: '), findsOneWidget);
    expect(find.text('Course Structure: '), findsOneWidget);

    // Close Modal
    await tester.tap(find.byIcon(Icons.close));
    await tester.pumpAndSettle();
  });

  testWidgets('Principal Section Detail Screen: 320px responsiveness, Year switcher & Zero Emojis', (WidgetTester tester) async {
    await tester.pumpWidget(const OnpsErpApp());
    await tester.pumpAndSettle();

    final BuildContext initialContext = tester.element(find.byType(ParentDashboardScreen));
    initialContext.go('/login');
    await tester.pumpAndSettle();

    await tester.tap(find.text('Staff'));
    await tester.pumpAndSettle();

    final signInBtn = find.textContaining('Sign in as Staff');
    await tester.ensureVisible(signInBtn);
    await tester.pumpAndSettle();
    await tester.tap(signInBtn);
    await tester.pump(const Duration(milliseconds: 1600));
    await tester.pumpAndSettle();

    final BuildContext authContext = tester.element(find.byType(AcademicBottomNavBar));
    authContext.go('/faculty/section-detail?grade=5&section=A');
    await tester.pumpAndSettle();

    // Set 320px viewport
    tester.view.physicalSize = const Size(320 * 3, 640 * 3);
    tester.view.devicePixelRatio = 3.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });
    await tester.pumpAndSettle();

    // Switch Academic Year
    final yearDropdown = find.text('2026–27');
    expect(yearDropdown, findsWidgets);
    await tester.tap(yearDropdown.first);
    await tester.pumpAndSettle();

    expect(find.text('2025–26'), findsOneWidget);
    await tester.tap(find.text('2025–26'));
    await tester.pumpAndSettle();
    expect(find.text('2025–26'), findsWidgets);

    // Assert Zero Emojis
    final emojiRegex = RegExp(
      r'[\u{1F300}-\u{1F9FF}\u{2600}-\u{26FF}\u{2700}-\u{27BF}\u{1F1E6}-\u{1F1FF}\u{1F600}-\u{1F64F}\u{1F680}-\u{1F6FF}]',
      unicode: true,
    );
    final allTextWidgets = tester.widgetList<Text>(find.byType(Text));
    for (final textWidget in allTextWidgets) {
      final text = textWidget.data ?? textWidget.textSpan?.toPlainText() ?? '';
      expect(
        emojiRegex.hasMatch(text),
        isFalse,
        reason: 'Found unexpected emoji in Principal Section Detail UI: "$text"',
      );
    }
  });
}
