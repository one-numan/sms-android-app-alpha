import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:sms_android_app_alpha/main.dart';
import 'package:sms_android_app_alpha/screens/calendar_announcements/notice_board_screen.dart';
import 'package:sms_android_app_alpha/screens/dashboards/parent_dashboard_screen.dart';
import 'package:sms_android_app_alpha/widgets/bottom_nav_bar.dart';

void main() {
  testWidgets('Principal Notices screen: Search, category filtering, notice details, attachments, and zero emojis', (WidgetTester tester) async {
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

    // Tap Notices in bottom navigation
    final noticesTab = find.descendant(
      of: find.byType(AcademicBottomNavBar),
      matching: find.text('Notices'),
    );
    expect(noticesTab, findsOneWidget);
    await tester.tap(noticesTab);
    await tester.pumpAndSettle();

    // 1. Verify NoticeBoardScreen is active with Header & Subtitle
    expect(find.byType(NoticeBoardScreen), findsOneWidget);
    expect(find.text('Notices'), findsWidgets);
    expect(find.text('School Notices & Circulars'), findsOneWidget);

    // 2. Verify Search Bar & Category Filter Chips
    expect(find.byType(TextField), findsOneWidget);
    expect(find.text('Search notices...'), findsOneWidget);
    expect(find.text('All'), findsOneWidget);
    expect(find.text('Academic'), findsOneWidget);
    expect(find.text('Examination'), findsOneWidget);
    expect(find.text('Event'), findsOneWidget);
    expect(find.text('Holiday'), findsOneWidget);

    // 3. Verify Initial Notices Feed
    expect(find.text('Revised Morning Assembly Schedule'), findsOneWidget);
    expect(find.text('Second Assessment Schedule Published'), findsOneWidget);

    // 4. Test Live Search Filtering
    await tester.enterText(find.byType(TextField), 'Sports');
    await tester.pumpAndSettle();

    expect(find.text('Annual Sports Day 2026 Schedule & House Heats'), findsOneWidget);
    expect(find.text('Revised Morning Assembly Schedule'), findsNothing);

    // Clear search using close icon button
    await tester.tap(find.byIcon(Icons.close));
    await tester.pumpAndSettle();
    expect(find.text('Revised Morning Assembly Schedule'), findsOneWidget);

    // 5. Test Category Filter Selection (Examination)
    await tester.tap(find.text('Examination'));
    await tester.pumpAndSettle();

    expect(find.text('Half-Yearly Examination Guidelines & Admit Cards'), findsOneWidget);
    expect(find.text('Revised Morning Assembly Schedule'), findsNothing);

    // 6. Test Notice Detail Modal Drilldown
    await tester.tap(find.text('Half-Yearly Examination Guidelines & Admit Cards'));
    await tester.pumpAndSettle();

    // Verify modal content
    expect(find.text('Issued By: Controller of Examinations'), findsOneWidget);
    expect(find.text('Audience: Classes 9–12'), findsOneWidget);
    expect(find.text('Attached Document'), findsOneWidget);
    expect(find.text('exam_hall_guidelines.pdf'), findsOneWidget);

    // Close modal sheet
    await tester.tap(find.byIcon(Icons.close));
    await tester.pumpAndSettle();

    // 7. Reset to All Category
    await tester.tap(find.text('All'));
    await tester.pumpAndSettle();
    expect(find.text('Revised Morning Assembly Schedule'), findsOneWidget);

    // 8. Test Empty State on unmatched search
    await tester.enterText(find.byType(TextField), 'NonExistentCircularQuery999');
    await tester.pumpAndSettle();

    expect(find.text('No notices match your search'), findsOneWidget);
    expect(find.text('Reset Filters'), findsOneWidget);

    // Reset filters action
    await tester.tap(find.text('Reset Filters'));
    await tester.pumpAndSettle();
    expect(find.text('Revised Morning Assembly Schedule'), findsOneWidget);

    // 9. Verify 5-item Bottom Navigation Bar
    expect(find.byType(AcademicBottomNavBar), findsOneWidget);
    expect(find.text('Portal'), findsOneWidget);
    expect(find.text('Academics'), findsOneWidget);
    expect(find.text('Students'), findsOneWidget);
    expect(find.text('Notices'), findsWidgets);
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
