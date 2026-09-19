import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:sms_android_app_alpha/main.dart';
import 'package:sms_android_app_alpha/screens/account/account_profile_screen.dart';
import 'package:sms_android_app_alpha/screens/account/account_settings_screen.dart';
import 'package:sms_android_app_alpha/widgets/account_settings_sheet.dart';

void main() {
  testWidgets('Test top bar has Search, Bell, and 3-dots menu with Profile and Settings', (WidgetTester tester) async {
    await tester.pumpWidget(const OnpsErpApp());
    await tester.pumpAndSettle();

    // Verify Search icon exists in top bar
    expect(find.byIcon(Icons.search), findsOneWidget);

    // Verify Notification bell exists in top bar
    expect(find.byIcon(Icons.notifications_outlined), findsOneWidget);

    // Verify 3-dots icon exists in top bar (replaces top 9-dots)
    expect(find.byIcon(Icons.more_vert), findsOneWidget);

    // Verify bottom nav bar still has 9-dots (Icons.apps_outlined) for More
    expect(find.byIcon(Icons.apps_outlined), findsOneWidget);

    // Tap 3-dots icon
    await tester.tap(find.byIcon(Icons.more_vert));
    await tester.pumpAndSettle();

    // Verify menu items appear
    expect(find.text('My Profile'), findsOneWidget);
    expect(find.text('Settings'), findsOneWidget);
    expect(find.text('Active Devices'), findsOneWidget);
    expect(find.text('Switch Role'), findsOneWidget);
    expect(find.text('Help & FAQ'), findsOneWidget);
    expect(find.text('Sign Out'), findsOneWidget);

    // Tap 'Settings'
    await tester.tap(find.text('Settings'));
    await tester.pumpAndSettle();

    // Verify AccountSettingsSheet opens
    expect(find.byType(AccountSettingsSheet), findsOneWidget);
    expect(find.text('SECURITY & AUTHENTICATION'), findsOneWidget);
    expect(find.text('Two-Factor Authentication (OTP)'), findsOneWidget);
  });

  testWidgets('Test direct navigation to /account/profile and /account/settings', (WidgetTester tester) async {
    await tester.pumpWidget(const OnpsErpApp());
    await tester.pumpAndSettle();

    final BuildContext context = tester.element(find.byType(Scaffold).first);

    // Navigate to /account/profile
    GoRouter.of(context).go('/account/profile');
    await tester.pumpAndSettle();

    expect(find.byType(AccountProfileScreen), findsOneWidget);
    expect(find.text('My Profile'), findsOneWidget);
    expect(find.text('OFFICIAL CREDENTIALS & AFFILIATION'), findsOneWidget);

    // Navigate to /account/settings
    final BuildContext profileContext = tester.element(find.byType(AccountProfileScreen));
    GoRouter.of(profileContext).go('/account/settings');
    await tester.pumpAndSettle();

    expect(find.byType(AccountSettingsScreen), findsOneWidget);
    expect(find.text('Account Settings'), findsOneWidget);
    expect(find.text('CBSE High-Contrast'), findsOneWidget);
  });
}
