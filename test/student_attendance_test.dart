import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:sms_android_app_alpha/main.dart';
import 'package:sms_android_app_alpha/screens/attendance/student_attendance_screen.dart';
import 'package:sms_android_app_alpha/screens/dashboards/parent_dashboard_screen.dart';
import 'package:sms_android_app_alpha/widgets/bottom_nav_bar.dart';

void main() {
  testWidgets('Test Student Attendance Screen Architecture, Data Bindings, Schedule & 0-Emojis', (WidgetTester tester) async {
    await tester.pumpWidget(const OnpsErpApp());
    await tester.pumpAndSettle();

    // Verify initially on ParentDashboardScreen
    expect(find.byType(ParentDashboardScreen), findsOneWidget);

    // Navigate to /attendance/student
    final BuildContext context = tester.element(find.byType(ParentDashboardScreen));
    context.go('/attendance/student');
    await tester.pumpAndSettle();

    expect(find.byType(StudentAttendanceScreen), findsOneWidget);

    // 1. Compact Page Header
    expect(find.text('Attendance'), findsWidgets);
    expect(find.text('Diya Sharma • Grade 5-A'), findsOneWidget);

    // 2. Attendance Overview Card
    expect(find.text('Attendance Overview'), findsOneWidget);
    expect(find.text('80%'), findsOneWidget);
    expect(find.text('25 recorded days'), findsOneWidget);
    expect(find.text('20'), findsWidgets); // 20 Present

    // 3. Today's Status
    expect(find.text('TODAY'), findsOneWidget);
    expect(find.text('Present'), findsWidgets);

    // 4. Monthly 7-Column Calendar
    expect(find.text('OCTOBER 2026'), findsOneWidget);
    expect(find.text('M'), findsWidgets);
    expect(find.text('F'), findsWidgets);

    // 5. Selected Date Detail
    expect(find.text('25 October 2026'), findsOneWidget);

    // 6. Chronological Attendance History
    expect(find.text('ATTENDANCE HISTORY'), findsOneWidget);
    expect(find.text('All'), findsOneWidget);
    expect(find.text('Late'), findsWidgets);

    // 7. Subject Attendance
    expect(find.text('SUBJECT ATTENDANCE'), findsOneWidget);
    expect(find.text('Mathematics'), findsOneWidget);
    expect(find.text('96.0%'), findsOneWidget);

    // 8. 5-Tab Bottom Navigation Dock
    expect(find.byType(AcademicBottomNavBar), findsOneWidget);
    expect(find.text('Portal'), findsOneWidget);
    expect(find.text('Academics'), findsOneWidget);
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
