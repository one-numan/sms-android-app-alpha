import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:sms_android_app_alpha/main.dart';
import 'package:sms_android_app_alpha/screens/dashboards/parent_dashboard_screen.dart';
import 'package:sms_android_app_alpha/screens/students/all_students_ledger_screen.dart';
import 'package:sms_android_app_alpha/widgets/bottom_nav_bar.dart';

void main() {
  testWidgets('Principal Students screen: Search, progressive Grade & Section filters, student cards, and zero emojis', (WidgetTester tester) async {
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

    // Tap Students in bottom navigation
    final studentsTab = find.descendant(
      of: find.byType(AcademicBottomNavBar),
      matching: find.text('Students'),
    );
    expect(studentsTab, findsOneWidget);
    await tester.tap(studentsTab);
    await tester.pumpAndSettle();

    // 1. Verify AllStudentsLedgerScreen is active with Header & Subtitle
    expect(find.byType(AllStudentsLedgerScreen), findsOneWidget);
    expect(find.text('Students'), findsWidgets);
    expect(find.text('Student Directory'), findsOneWidget);

    // 2. Verify Search Bar
    expect(find.byType(TextField), findsOneWidget);
    expect(find.text('Search student...'), findsOneWidget);

    // 3. Verify Grade & Section Filter Buttons
    expect(find.text('All Classes'), findsWidgets);

    // 4. Verify Student Cards are rendered
    expect(find.text('Diya Sharma'), findsOneWidget);
    expect(find.text('Roll No. 14 • Grade 5-A'), findsOneWidget);

    // 5. Test Live Search Filtering
    await tester.enterText(find.byType(TextField), 'Ananya');
    await tester.pumpAndSettle();

    expect(find.text('Ananya Sharma'), findsOneWidget);
    expect(find.text('Roll No. 14 • Grade 5-C'), findsOneWidget);
    expect(find.text('Diya Sharma'), findsNothing);

    // Clear search using the close icon button
    await tester.tap(find.byIcon(Icons.close));
    await tester.pumpAndSettle();
    expect(find.text('Diya Sharma'), findsOneWidget);

    // 6. Test Grade Picker Bottom Sheet
    await tester.tap(find.text('All Classes').first);
    await tester.pumpAndSettle();

    expect(find.text('Select Class'), findsOneWidget);
    expect(find.text('Kindergarten'), findsOneWidget);

    // Scroll to and select Grade 5 in the modal sheet
    await tester.scrollUntilVisible(
      find.text('Grade 5'),
      50,
      scrollable: find.byType(Scrollable).last,
    );
    await tester.pumpAndSettle();
    expect(find.text('Grade 5'), findsOneWidget);
    await tester.tap(find.text('Grade 5'));
    await tester.pumpAndSettle();

    expect(find.text('Grade 5'), findsWidgets);

    // 7. Test Section Picker Bottom Sheet
    await tester.tap(find.text('All Sections'));
    await tester.pumpAndSettle();

    expect(find.text('Select Section (Grade 5)'), findsOneWidget);
    expect(find.text('Section 5-C'), findsOneWidget);

    // Select Section 5-C
    await tester.tap(find.text('Section 5-C'));
    await tester.pumpAndSettle();

    // Verify 5-C students are shown
    expect(find.text('Ananya Sharma'), findsOneWidget);
    expect(find.text('Vihaan Gupta'), findsOneWidget);
    expect(find.text('Myra Kapoor'), findsOneWidget);
    expect(find.text('Diya Sharma'), findsNothing); // 5-A student not shown in 5-C

    // 8. Test Empty State on unmatched search
    await tester.enterText(find.byType(TextField), 'NonExistentStudent12345');
    await tester.pumpAndSettle();

    expect(find.text('No students found.'), findsOneWidget);
    expect(find.text('Reset Filters'), findsOneWidget);

    // Reset filters
    await tester.tap(find.text('Reset Filters'));
    await tester.pumpAndSettle();
    expect(find.text('Diya Sharma'), findsOneWidget);

    // 9. Verify 5-item Bottom Navigation Bar
    expect(find.byType(AcademicBottomNavBar), findsOneWidget);
    expect(find.text('Portal'), findsOneWidget);
    expect(find.text('Academics'), findsOneWidget);
    expect(find.text('Students'), findsWidgets);
    expect(find.text('Notices'), findsOneWidget);
    expect(find.text('More'), findsOneWidget);

    // 10. ICON RULE: Strictly zero unicode emojis
    final allTextWidgets = tester.widgetList<Text>(find.byType(Text));
    final emojiRegex = RegExp(
      r'[\u{1F300}-\u{1F9FF}]|[\u{2600}-\u{26FF}]|[\u{2700}-\u{27BF}]|[\u{1F600}-\u{1F64F}]|[\u{1F680}-\u{1F6FF}]',
      unicode: true,
    );
    for (final textWidget in allTextWidgets) {
      final text = textWidget.data ?? textWidget.textSpan?.toPlainText() ?? '';
      expect(
        emojiRegex.hasMatch(text),
        isFalse,
        reason: 'Text "$text" contains an emoji which violates the zero-emoji rule.',
      );
    }
  });
}
