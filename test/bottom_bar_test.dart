import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:sms_android_app_alpha/main.dart';
import 'package:sms_android_app_alpha/screens/dashboards/parent_dashboard_screen.dart';

void main() {
  testWidgets('Test clicking 9 dots bottom bar as teacher opens modules and navigates', (WidgetTester tester) async {
    await tester.pumpWidget(const OnpsErpApp());
    await tester.pumpAndSettle();

    // Navigate to /login
    final BuildContext context = tester.element(find.byType(ParentDashboardScreen));
    context.go('/login');
    await tester.pumpAndSettle();

    // Tap Teacher role tab
    final teacherTab = find.text('Teacher');
    expect(teacherTab, findsOneWidget);
    await tester.tap(teacherTab);
    await tester.pumpAndSettle();

    // Enter credentials
    await tester.enterText(find.byType(TextField).first, 'anita.desai');
    await tester.enterText(find.byType(TextField).last, 'demo12345');

    // Tap Sign in
    final signInButton = find.textContaining('Sign in as Teacher');
    expect(signInButton, findsOneWidget);
    await tester.tap(signInButton);
    await tester.pumpAndSettle();

    // Verify we are on ClassTeacherDashboardScreen
    expect(find.text('Good Morning, Anita Desai'), findsOneWidget);

    // Find the 'More' 9-dots button in the bottom navigation bar
    final moreTab = find.text('More');
    expect(moreTab, findsOneWidget);

    // Tap 'More' (9 dots)
    await tester.tap(moreTab);
    await tester.pumpAndSettle();

    // Verify ModuleGridSheet opens with 'All Modules'
    expect(find.text('All Modules'), findsOneWidget);
    expect(find.text('Class Information'), findsOneWidget);
    expect(find.text('Student Directory'), findsOneWidget);
    expect(find.text('Class Subjects'), findsOneWidget);
    expect(find.text('Switch Role'), findsOneWidget);
    expect(find.text('Sign Out'), findsOneWidget);

    // Tap 'Class Information' in the module grid
    await tester.tap(find.text('Class Information'));
    await tester.pumpAndSettle();

    // Verify we navigated to Class Information screen
    expect(find.text('Grade 5 • Section A'), findsOneWidget);
  });
}
