// ==============================================================================
// One Numan Public School (ONPS) — Android ERP Mobile Application
// Test Suite: 100% Comprehensive All-Screens Deep Mount & Zero-Emoji Verification
// Verifies all 53+ screens mount without crashing, render cleanly, and contain 0 emojis.
// ==============================================================================

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:sms_android_app_alpha/data/mock/auth_state.dart';
import 'package:sms_android_app_alpha/router.dart';
import 'package:sms_android_app_alpha/theme/app_theme.dart';

void main() {
  setUp(() {
    GoogleFonts.config.allowRuntimeFetching = false;
    final binding = TestWidgetsFlutterBinding.ensureInitialized();
    binding.platformDispatcher.views.first.physicalSize = const Size(800, 1400);
    binding.platformDispatcher.views.first.devicePixelRatio = 1.0;
  });

  tearDown(() {
    final binding = TestWidgetsFlutterBinding.ensureInitialized();
    binding.platformDispatcher.views.first.resetPhysicalSize();
    binding.platformDispatcher.views.first.resetDevicePixelRatio();
  });

  final emojiRegex = RegExp(
    r'[\u{1F300}-\u{1F9FF}\u{2600}-\u{26FF}\u{2700}-\u{27BF}\u{1F1E6}-\u{1F1FF}\u{1F600}-\u{1F64F}\u{1F680}-\u{1F6FF}]',
    unicode: true,
  );

  void assertZeroEmojis(WidgetTester tester, String route) {
    final allTextWidgets = tester.widgetList<Text>(find.byType(Text));
    for (final textWidget in allTextWidgets) {
      final text = textWidget.data ?? textWidget.textSpan?.toPlainText() ?? '';
      expect(
        emojiRegex.hasMatch(text),
        isFalse,
        reason: 'Zero Emoji Violation on route $route: Found emoji in "$text"',
      );
    }
  }

  testWidgets('Deep Test: Mount and verify all 50+ application routes & zero emojis', (WidgetTester tester) async {
    final authState = AuthState();
    final router = createOnpsRouter(authState);

    await tester.pumpWidget(
      ChangeNotifierProvider<AuthState>.value(
        value: authState,
        child: MaterialApp.router(
          routerConfig: router,
          theme: AcademicTheme.themeData,
        ),
      ),
    );
    await tester.pumpAndSettle();

    final routesToTest = [
      '/login',
      '/auth/2fa',
      '/auth/lockout',
      '/auth/password-reset',
      '/auth/morning-briefing',
      '/auth/device-management',
      '/account/profile',
      '/account/settings',
      '/dashboard/parent',
      '/dashboard/student',
      '/dashboard/class-teacher',
      '/dashboard/subject-teacher',
      '/dashboard/subject-teacher/cohorts',
      '/dashboard/principal',
      '/dashboard/accountant',
      '/dashboard/librarian',
      '/dashboard/modules',
      '/admissions/enquiry',
      '/admissions/applications',
      '/students/dossier',
      '/students/report-card',
      '/students/marks-entry',
      '/students/ledger',
      '/students/id-card',
      '/attendance',
      '/attendance/roll-call',
      '/attendance/matrix',
      '/attendance/faculty-leave',
      '/faculty/allocation',
      '/faculty/section-detail?grade=5&section=A',
      '/faculty/timetable/class',
      '/faculty/timetable',
      '/faculty/directory',
      '/faculty/teachers',
      '/teacher/class-info',
      '/teacher/class-students',
      '/teacher/class-subjects',
      '/teacher/my-classes',
      '/teacher/teaching-assignments',
      '/fees/ledger',
      '/fees/receipt',
      '/transit/bus',
      '/inventory/desk',
      '/calendar/academic',
      '/calendar/events',
      '/calendar/add-event',
      '/announcements',
      '/announcements/create',
      '/announcements/approval',
      '/notifications',
      '/search/cross-entity',
      '/admin/parents',
      '/admin/setup',
    ];

    for (final route in routesToTest) {
      router.go(route);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 200));
      await tester.pumpAndSettle();

      // Ensure no flutter framework assertion error or crash
      expect(tester.takeException(), isNull, reason: 'Route $route threw an unhandled exception');

      // Ensure zero emojis on this screen
      assertZeroEmojis(tester, route);
    }
  });
}

