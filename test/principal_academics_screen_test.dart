import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:sms_android_app_alpha/data/mock/mock_data.dart';
import 'package:sms_android_app_alpha/main.dart';
import 'package:sms_android_app_alpha/screens/dashboards/parent_dashboard_screen.dart';
import 'package:sms_android_app_alpha/screens/faculty/faculty_allocation_screen.dart';
import 'package:sms_android_app_alpha/widgets/bottom_nav_bar.dart';

void main() {
  testWidgets('Principal Academics screen: Progressive navigation, K-12 support, section switching, and drilldowns', (WidgetTester tester) async {
    await tester.pumpWidget(const OnpsErpApp());
    await tester.pumpAndSettle();

    // Navigate to /login and login as Staff/Principal
    final BuildContext initialContext = tester.element(find.byType(ParentDashboardScreen));
    initialContext.go('/login');
    await tester.pumpAndSettle();

    await tester.tap(find.text('Staff'));
    await tester.pumpAndSettle();

    await tester.tap(find.textContaining('Sign in as Staff'));
    await tester.pump(const Duration(milliseconds: 1600));
    await tester.pumpAndSettle();

    // Tap Academics in bottom navigation
    final academicsTab = find.descendant(
      of: find.byType(AcademicBottomNavBar),
      matching: find.text('Academics'),
    );
    expect(academicsTab, findsOneWidget);
    await tester.tap(academicsTab);
    await tester.pumpAndSettle();

    // Verify FacultyAllocationScreen is active
    expect(find.byType(FacultyAllocationScreen), findsOneWidget);
    expect(find.text('Academics'), findsWidgets);
    expect(find.text('2026–27'), findsWidgets);

    // Verify Academic Overview KPIs
    final totalGrades = MockData.classes.map((c) => c.grade).toSet().length.toString();
    final totalSections = MockData.classes.length.toString();
    expect(find.text('Classes'), findsOneWidget);
    expect(find.text(totalGrades), findsOneWidget);
    expect(find.text('Sections'), findsOneWidget);
    expect(find.text(totalSections), findsOneWidget);

    // Verify Default Grade 5 is selected with Sections (5-A..5-E)
    expect(find.text('Grade 5'), findsOneWidget);
    expect(find.text('5-A'), findsWidgets);
    expect(find.text('5-B'), findsWidgets);
    expect(find.text('5-C'), findsWidgets);

    // Verify Section 5-A details
    expect(find.text('Section 5-A'), findsWidgets);
    expect(find.text('Class Teacher: Anita Desai'), findsOneWidget);
    expect(find.text('Mathematics'), findsOneWidget);
    expect(find.text('Science'), findsOneWidget);

    // Switch Section to 5-C
    await tester.tap(find.text('5-C').first);
    await tester.pumpAndSettle();

    // Verify Section 5-C is now active and updated
    expect(find.text('Section 5-C'), findsWidgets);
    expect(find.text('Class Teacher: Robert Chen'), findsOneWidget);

    // Tap a subject to verify Subject Details Modal
    final mathSubject = find.text('Mathematics').first;
    await tester.ensureVisible(mathSubject);
    await tester.pumpAndSettle();
    await tester.tap(mathSubject);
    await tester.pumpAndSettle();

    // Verify Subject Details modal content
    expect(find.text('Assigned Faculty: '), findsOneWidget);
    expect(find.text('Marks Ledger'), findsOneWidget);
    expect(find.text('View Results →'), findsOneWidget);

    // Close modal
    await tester.tap(find.byIcon(Icons.close));
    await tester.pumpAndSettle();

    // Test Search Functionality
    await tester.enterText(find.byType(TextField), 'Science');
    await tester.pumpAndSettle();
    expect(find.textContaining('SEARCH RESULTS'), findsOneWidget);

    // Clear search
    await tester.tap(find.text('Clear Search'));
    await tester.pumpAndSettle();

    // Switch Grade to Kindergarten (K)
    final kChip = find.text('K').first;
    await tester.ensureVisible(kChip);
    await tester.pumpAndSettle();
    await tester.tap(kChip);
    await tester.pumpAndSettle();

    // Verify Kindergarten sections (K-A..K-D) are displayed
    expect(find.text('Kindergarten'), findsOneWidget);
    expect(find.text('K-A'), findsWidgets);

    // Switch to All Classes View
    final listViewBtn = find.text('List View ▼');
    await tester.ensureVisible(listViewBtn);
    await tester.pumpAndSettle();
    await tester.tap(listViewBtn);
    await tester.pumpAndSettle();

    // Modal opens with All Classes
    expect(find.text('All Classes'), findsOneWidget);
    await tester.tap(find.text('All Classes'));
    await tester.pumpAndSettle();

    // Verify All Classes list
    expect(find.text('ALL CLASSES ($totalGrades GRADES)'), findsOneWidget);
  });

  testWidgets('Principal Academics screen: Year switching, empty states, responsiveness, and zero emojis', (WidgetTester tester) async {
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

    // Navigate to Academics
    final academicsTab = find.descendant(
      of: find.byType(AcademicBottomNavBar),
      matching: find.text('Academics'),
    );
    await tester.tap(academicsTab);
    await tester.pumpAndSettle();

    // Test on compact 320px viewport
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

    // Test Search Empty State
    await tester.enterText(find.byType(TextField), 'xyznonexistent');
    await tester.pumpAndSettle();
    expect(find.textContaining('No academic classes or teachers match'), findsOneWidget);

    // Clear search
    await tester.tap(find.byIcon(Icons.clear));
    await tester.pumpAndSettle();

    // Assert Zero Unicode Emojis across all text widgets
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
        reason: 'Found unexpected emoji in Principal Academics UI: "$text"',
      );
    }
  });
}
