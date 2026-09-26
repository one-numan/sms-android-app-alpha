import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:sms_android_app_alpha/main.dart';
import 'package:sms_android_app_alpha/screens/dashboards/parent_dashboard_screen.dart';
import 'package:sms_android_app_alpha/screens/students/academic_report_card_screen.dart';
import 'package:sms_android_app_alpha/widgets/bottom_nav_bar.dart';

void main() {
  testWidgets('Test Student Academics Screen Architecture, Data Bindings & 0-Emojis', (WidgetTester tester) async {
    await tester.pumpWidget(const OnpsErpApp());
    await tester.pumpAndSettle();

    // Navigate to /students/report-card?id=ADM-2024-0412
    final BuildContext context = tester.element(find.byType(ParentDashboardScreen));
    context.go('/students/report-card?id=ADM-2024-0412');
    await tester.pumpAndSettle();

    expect(find.byType(AcademicReportCardScreen), findsOneWidget);

    // 1. Compact Academic Header (Student context)
    expect(find.text('Academics'), findsWidgets);
    expect(find.textContaining('Class 5-A'), findsWidgets);
    expect(find.textContaining('Roll #14'), findsWidgets);
    expect(find.text('Diya Sharma'), findsOneWidget);
    expect(find.text('Promoted'), findsOneWidget);

    // 2. Academic Summary KPIs (4 computed metrics)
    expect(find.text('88.0%'), findsWidgets); // Attendance
    expect(find.text('91.9%'), findsWidgets); // Latest Result (919/1000)
    expect(find.text('A1'), findsWidgets);     // Grade
    expect(find.text('5'), findsWidgets);      // Subjects count

    // 3. Academic Attention (Priority Alerts)
    expect(find.text('ACADEMIC ATTENTION'), findsOneWidget);
    expect(find.text('Second Assessment Commences 25 Nov 2026'), findsOneWidget);
    expect(find.textContaining('Attendance Compliance Advisory'), findsOneWidget);

    // 4. Subjects Section (Core list with teachers and marks)
    expect(find.text('ENROLLED SUBJECTS'), findsOneWidget);
    expect(find.text('Mathematics'), findsWidgets);
    expect(find.text('English'), findsWidgets);
    expect(find.text('Science'), findsWidgets);
    expect(find.text('Social Studies'), findsWidgets);
    expect(find.text('Hindi'), findsWidgets);
    expect(find.textContaining('Mathematics Faculty'), findsWidgets);
    expect(find.textContaining('Science Faculty'), findsWidgets);

    // 5. Timetable Section (Class 5-A routine preview)
    expect(find.text("TODAY'S TIMETABLE"), findsOneWidget);
    expect(find.text('View Full Weekly Timetable'), findsOneWidget);

    // 6. Attendance Breakdown Section
    expect(find.text('ATTENDANCE BREAKDOWN'), findsOneWidget);
    expect(find.text('20 Present'), findsOneWidget);
    expect(find.text('2 Late'), findsOneWidget);
    expect(find.text('3 Absent'), findsOneWidget);
    expect(find.text('View Complete Monthly Attendance Matrix'), findsOneWidget);

    // 7. Scholastic Results Ledger (CBSE 4-Term Model)
    expect(find.text('SCHOLASTIC RESULTS'), findsOneWidget);
    expect(find.text('CBSE Merit Scholar'), findsOneWidget);
    expect(find.text('919'), findsOneWidget);
    expect(find.text('Download Official CBSE Transcript (PDF)'), findsOneWidget);

    // 8. Upcoming Examinations Section
    expect(find.text('UPCOMING EXAMINATIONS'), findsOneWidget);
    expect(find.text('Terminal Exam'), findsOneWidget);
    expect(find.text('View Examination Schedule'), findsOneWidget);

    // 9. Assignments Section (Clean Empty State)
    expect(find.text('ASSIGNMENTS & COURSEWORK'), findsOneWidget);
    expect(find.text('No Pending Assignments'), findsOneWidget);
    expect(find.text('Up to date'), findsOneWidget);

    // 10. Bottom Navigation Dock
    expect(find.byType(AcademicBottomNavBar), findsOneWidget);
    expect(find.text('Portal'), findsOneWidget);
    expect(find.text('Academics'), findsWidgets);
    expect(find.text('Fees'), findsOneWidget);
    expect(find.text('Attendance'), findsWidgets);
    expect(find.text('More'), findsOneWidget);

    // 11. Strict Zero Emojis Verification
    final emojiRegex = RegExp(r'[\u{1F300}-\u{1F9FF}\u{2600}-\u{26FF}\u{2700}-\u{27BF}]', unicode: true);
    for (final textWidget in tester.widgetList<Text>(find.byType(Text))) {
      final text = textWidget.data ?? textWidget.textSpan?.toPlainText() ?? '';
      expect(emojiRegex.hasMatch(text), isFalse, reason: 'Found emoji in text: "$text"');
    }
  });
}
