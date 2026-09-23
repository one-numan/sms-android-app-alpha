import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:sms_android_app_alpha/main.dart';
import 'package:sms_android_app_alpha/screens/dashboards/parent_dashboard_screen.dart';
import 'package:sms_android_app_alpha/screens/dashboards/principal_dashboard_screen.dart';
import 'package:sms_android_app_alpha/screens/auth/morning_briefing_transition_screen.dart';

void main() {
  testWidgets('Test login as staff navigates through transition to principal dashboard', (WidgetTester tester) async {
    await tester.pumpWidget(const OnpsErpApp());
    await tester.pumpAndSettle();

    // Navigate to /login
    final BuildContext context = tester.element(find.byType(ParentDashboardScreen));
    context.go('/login');
    await tester.pumpAndSettle();

    // Tap Staff role tab
    final staffTab = find.text('Staff');
    expect(staffTab, findsOneWidget);
    await tester.tap(staffTab);
    await tester.pumpAndSettle();

    // Enter credentials
    await tester.enterText(find.byType(TextField).first, 'principal');
    await tester.enterText(find.byType(TextField).last, 'demo12345');

    // Tap Sign in as Staff
    final signInButton = find.textContaining('Sign in as Staff');
    expect(signInButton, findsOneWidget);
    await tester.tap(signInButton);
    
    // Pump frames to display transition screen
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));

    // Verify MorningBriefingTransitionScreen is displayed
    expect(find.byType(MorningBriefingTransitionScreen), findsOneWidget);
    expect(find.text('Signed in successfully'), findsOneWidget);
    expect(find.text('Principal'), findsOneWidget);
    expect(find.text('Preparing your Principal Portal...'), findsOneWidget);

    // Wait for transition timer to complete and advance to PrincipalDashboardScreen
    await tester.pump(const Duration(milliseconds: 1500));
    await tester.pump(const Duration(milliseconds: 100));

    // Verify PrincipalDashboardScreen is displayed
    expect(find.byType(PrincipalDashboardScreen), findsOneWidget);
    expect(find.text("TODAY'S OVERVIEW"), findsOneWidget);
    expect(find.text('QUICK ACCESS'), findsOneWidget);
  });
}
