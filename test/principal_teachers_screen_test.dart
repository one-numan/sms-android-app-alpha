// ==============================================================================
// One Numan Public School (ONPS) — Android ERP Mobile Application
// Test Suite: Principal More → Teachers Management Screen Verification
// Tests: Search, Filter, Assignments, Profile Modal, CRUD Workflows, Responsiveness & 0-Emojis
// ==============================================================================

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sms_android_app_alpha/main.dart';
import 'package:sms_android_app_alpha/screens/dashboards/parent_dashboard_screen.dart';
import 'package:sms_android_app_alpha/screens/faculty/principal_teachers_screen.dart';
import 'package:sms_android_app_alpha/widgets/bottom_nav_bar.dart';

void main() {
  setUp(() {
    GoogleFonts.config.allowRuntimeFetching = false;
  });

  testWidgets(
      'Principal Teachers Screen: Architecture, Search, Filters, Assignments, Profile & CRUD Verification',
      (WidgetTester tester) async {
    // 1. Launch App & Sign In as Principal
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
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 2000));
    await tester.pumpAndSettle();

    // 2. Navigate to Principal More tab and open Faculty & Teaching (/faculty/teachers)
    final BuildContext authContext = tester.element(find.byType(AcademicBottomNavBar));
    authContext.go('/faculty/teachers');
    await tester.pumpAndSettle();

    // 3. Verify Screen Header & Supporting Text
    expect(find.byType(PrincipalTeachersScreen), findsOneWidget);
    expect(find.text('Teachers'), findsOneWidget);
    expect(find.text('Teaching staff and assignments'), findsOneWidget);
    expect(find.textContaining('Faculty'), findsWidgets);

    // 4. Verify Teacher Cards & Class Teacher Badges
    expect(find.text('Anita Desai'), findsWidgets);
    expect(find.text('Robert Chen'), findsWidgets);
    expect(find.text('David Miller'), findsWidgets);
    expect(find.textContaining('5-A · Class Teacher'), findsOneWidget);

    // 5. Test Live Search Filtering
    await tester.enterText(find.byType(TextField).first, 'Anita');
    await tester.pumpAndSettle();

    expect(find.text('Anita Desai'), findsWidgets);
    expect(find.text('Robert Chen'), findsNothing);

    // Clear Search
    await tester.tap(find.byIcon(Icons.clear));
    await tester.pumpAndSettle();
    expect(find.text('Robert Chen'), findsWidgets);

    // 6. Test Subject Filter Pill
    final mathFilter = find.text('Mathematics');
    expect(mathFilter, findsWidgets);
    await tester.tap(mathFilter.first);
    await tester.pumpAndSettle();

    expect(find.text('Anita Desai'), findsWidgets);
    expect(find.text('Robert Chen'), findsNothing);

    // Reset filter to All
    await tester.tap(find.textContaining('All (').first);
    await tester.pumpAndSettle();
    expect(find.text('Robert Chen'), findsWidgets);

    // 7. Open Teacher Profile Modal (Anita Desai)
    await tester.tap(find.text('Anita Desai').first);
    await tester.pumpAndSettle();

    expect(find.text('Teacher Profile'), findsOneWidget);
    expect(find.text('CONTACT DETAILS'), findsOneWidget);
    expect(find.text('CLASS TEACHER ASSIGNMENT'), findsOneWidget);
    expect(find.text('SUBJECT TEACHING ASSIGNMENTS'), findsOneWidget);
    expect(find.text('Section 5-A'), findsOneWidget);
    expect(find.text('+91 98222 33445'), findsOneWidget);
    expect(find.text('anita.desai@onps.edu.in'), findsOneWidget);

    // Close Modal
    await tester.tap(find.byIcon(Icons.close));
    await tester.pumpAndSettle();

    // 8. Test Add Teacher Flow
    await tester.tap(find.byIcon(Icons.person_add_alt_1_outlined));
    await tester.pumpAndSettle();

    expect(find.text('Add New Teacher'), findsOneWidget);
    final formFields = find.byType(TextField);
    await tester.enterText(formFields.at(1), 'Dr. Rajesh Khanna'); // Full Name
    await tester.enterText(formFields.at(3), '+91 98123 45678'); // Mobile
    await tester.enterText(formFields.at(4), 'rajesh.k@onps.edu.in'); // Email

    final saveBtn = find.text('Save Teacher Profile');
    await tester.ensureVisible(saveBtn);
    await tester.tap(saveBtn);
    await tester.pumpAndSettle();

    // Verify newly added teacher appears in list
    expect(find.text('Dr. Rajesh Khanna'), findsWidgets);
  });

  testWidgets(
      'Principal Teachers Screen: Delete Protection, 320px Responsiveness & Zero Emojis',
      (WidgetTester tester) async {
    // 1. Launch & Navigate to /login and sign in as Staff (Principal)
    await tester.pumpWidget(const OnpsErpApp());
    await tester.pumpAndSettle();

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
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 2000));
    await tester.pumpAndSettle();

    // Navigate to Teachers
    final BuildContext authContext = tester.element(find.byType(AcademicBottomNavBar));
    authContext.go('/faculty/teachers');
    await tester.pumpAndSettle();

    // 2. Test on 320px viewport
    tester.view.physicalSize = const Size(320 * 3, 640 * 3);
    tester.view.devicePixelRatio = 3.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });
    await tester.pumpAndSettle();

    // 3. Test Delete Active Assignment Warning (Anita Desai)
    await tester.tap(find.text('Anita Desai').first);
    await tester.pumpAndSettle();

    final deleteBtn = find.text('Delete Teacher');
    expect(deleteBtn, findsOneWidget);
    await tester.ensureVisible(deleteBtn);
    await tester.pumpAndSettle();
    await tester.tap(deleteBtn);
    await tester.pumpAndSettle();

    // Active assignment warning dialog should be displayed
    expect(find.text('Cannot Delete Teacher'), findsOneWidget);
    expect(
      find.textContaining('Cannot delete teacher with active assignments'),
      findsOneWidget,
    );

    // Dismiss dialog
    await tester.tap(find.text('Dismiss'));
    await tester.pumpAndSettle();

    // 4. Assert Zero Unicode Emojis across all rendered text widgets
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
        reason: 'Zero Emoji Rule Violation: Found emoji in "$text"',
      );
    }
  });
}
