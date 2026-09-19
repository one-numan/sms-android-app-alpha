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

    // 1. Attendance Overview Card
    expect(find.text('Attendance Overview'), findsOneWidget);
    expect(find.text('Present'), findsWidgets);
    expect(find.text('Absent'), findsWidgets);

    // 2. Monthly Register Matrix
    expect(find.textContaining('MONTHLY REGISTER MATRIX'), findsOneWidget);

    // 3. 5-Tab Bottom Navigation Dock
    expect(find.byType(AcademicBottomNavBar), findsOneWidget);
    expect(find.text('Portal'), findsOneWidget);

    // Strict Zero Emojis Assertion
    final emojiRegex = RegExp(r'[\u{1F300}-\u{1F9FF}\u{2600}-\u{26FF}\u{2700}-\u{27BF}]', unicode: true);
    for (final textWidget in tester.widgetList<Text>(find.byType(Text))) {
      final text = textWidget.data ?? textWidget.textSpan?.toPlainText() ?? '';
      expect(emojiRegex.hasMatch(text), isFalse, reason: 'Found emoji in text: "$text"');
    }
  });
}
