import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:sms_android_app_alpha/main.dart';
import 'package:sms_android_app_alpha/screens/dashboards/parent_dashboard_screen.dart';
import 'package:sms_android_app_alpha/screens/dashboards/student_hub_screen.dart';
import 'package:sms_android_app_alpha/widgets/bottom_nav_bar.dart';

void main() {
  testWidgets('Test Student Portal Data-Backed Architecture and Navigation', (WidgetTester tester) async {
    await tester.pumpWidget(const OnpsErpApp());
    await tester.pumpAndSettle();

    // Navigate to /dashboard/student
    final BuildContext context = tester.element(find.byType(ParentDashboardScreen));
    context.go('/dashboard/student');
    await tester.pumpAndSettle();

    expect(find.byType(StudentHubScreen), findsOneWidget);

    // 1. Identity Card (Real student data)
    expect(find.text('Diya Sharma'), findsOneWidget);
    expect(find.textContaining('Roll #14'), findsOneWidget);
    expect(find.text('ID CARD'), findsOneWidget);

    // 2. Computed Summary Cards
    expect(find.text('Attendance'), findsWidgets);
    expect(find.text('88.0%'), findsWidgets); // 22 attended / 25 total records
    expect(find.text('Term Result'), findsOneWidget);
    expect(find.text('Grade A1'), findsOneWidget);
    expect(find.text('Outstanding'), findsOneWidget);
    expect(find.text('₹12,450'), findsOneWidget);
    expect(find.text('Books on Loan'), findsOneWidget);
    expect(find.text('2'), findsOneWidget);

    // 3. Schedule (Dynamic - computed from today's timetable + current time)
    expect(find.text("TODAY'S SCHEDULE"), findsOneWidget);
    expect(find.textContaining('Timetable'), findsWidgets);

    // 4. Upcoming (Real Events & Holidays, Chronologically Sorted)
    expect(find.text('UPCOMING'), findsOneWidget);
    expect(find.text('Mahatma Gandhi Jayanti'), findsOneWidget);

    // 5. Needs Your Attention (Real surfaced actions)
    expect(find.text('NEEDS YOUR ATTENTION'), findsOneWidget);
    expect(find.textContaining('Fee balance outstanding'), findsOneWidget);
    expect(find.text('Urgent Advisory: Revised Morning Assembly Schedule'), findsOneWidget);

    // 6. Real Announcements
    expect(find.text('IMPORTANT ANNOUNCEMENTS'), findsOneWidget);

    // 7. Quick Actions
    expect(find.text('QUICK ACTIONS'), findsOneWidget);
    expect(find.text('Report Card'), findsOneWidget);
    expect(find.text('Digital ID'), findsOneWidget);
    expect(find.text('Student Profile'), findsOneWidget);
    expect(find.text('Timetable'), findsOneWidget);

    // 8. Bottom Navigation Items
    expect(find.byType(AcademicBottomNavBar), findsOneWidget);
    expect(find.text('Portal'), findsOneWidget);
    expect(find.text('Academics'), findsOneWidget);
    expect(find.text('Attendance'), findsWidgets);
    expect(find.text('Fees'), findsOneWidget);
    expect(find.text('More'), findsOneWidget);

    // 9. Strict Zero Emojis Assertion
    final emojiRegex = RegExp(r'[\u{1F300}-\u{1F9FF}\u{2600}-\u{26FF}\u{2700}-\u{27BF}]', unicode: true);
    for (final textWidget in tester.widgetList<Text>(find.byType(Text))) {
      final text = textWidget.data ?? textWidget.textSpan?.toPlainText() ?? '';
      expect(emojiRegex.hasMatch(text), isFalse, reason: 'Found emoji in text: "$text"');
    }
  });
}
