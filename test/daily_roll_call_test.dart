// ==============================================================================
// One Numan Public School (ONPS) — Android ERP Mobile Application
// Unit & Widget Tests: Class Teacher Attendance 5-A Register
// Validating: Operational UX, 4-State Toggles, Unknown vs Absent, Holiday/Future,
// Safe Mark All, Student Profile Popup, Preview Flow, Single Father Name & 0-Emojis
// ==============================================================================

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sms_android_app_alpha/data/mock/auth_state.dart';
import 'package:sms_android_app_alpha/models/models.dart';
import 'package:sms_android_app_alpha/screens/attendance/daily_roll_call_screen.dart';
import 'package:provider/provider.dart';

Widget createRollCallTestWidget(Widget child) {
  final authState = AuthState()..switchRole(UserRole.classTeacher);
  return ChangeNotifierProvider<AuthState>.value(
    value: authState,
    child: MaterialApp(
      home: child,
    ),
  );
}

void main() {
  group('Class Teacher Attendance 5-A Register — Deep UX & Hierarchy Verification', () {
    setUp(() {
      final binding = TestWidgetsFlutterBinding.ensureInitialized();
      binding.platformDispatcher.views.first.physicalSize = const Size(800, 1200);
      binding.platformDispatcher.views.first.devicePixelRatio = 1.0;
    });

    tearDown(() {
      final binding = TestWidgetsFlutterBinding.ensureInitialized();
      binding.platformDispatcher.views.first.resetPhysicalSize();
      binding.platformDispatcher.views.first.resetDevicePixelRatio();
    });

    testWidgets('TEST 1: Incomplete register with Not Marked students disables submit', (tester) async {
      // Provide an attendance map where at least one student is unrecorded (null)
      final initialMap = <String, AttendanceStatus?>{
        'ADM-2024-0890': null,
      };

      await tester.pumpWidget(createRollCallTestWidget(DailyRollCallScreen(
        initialAttendanceMap: initialMap,
      )));
      await tester.pumpAndSettle();

      expect(find.textContaining('students not marked'), findsWidgets);
      expect(find.text('Complete All Attendance First'), findsOneWidget);

      // Verify submit button is disabled
      final submitBtn = tester.widget<ElevatedButton>(find.byType(ElevatedButton).last);
      expect(submitBtn.onPressed, isNull);
    });

    testWidgets('TEST 2: Complete register with all Present allows submit', (tester) async {
      await tester.pumpWidget(createRollCallTestWidget(const DailyRollCallScreen()));
      await tester.pumpAndSettle();

      // Tap Mark All Present in header
      await tester.tap(find.text('Mark All Present'));
      await tester.pumpAndSettle();

      // Tap Continue on exceptions warning dialog
      if (find.text('Continue').evaluate().isNotEmpty) {
        await tester.tap(find.text('Continue'));
        await tester.pumpAndSettle();
      }

      expect(find.text('Submit Attendance'), findsOneWidget);
      expect(find.text('All 32 Counted'), findsOneWidget);

      final submitBtn = tester.widget<ElevatedButton>(find.byType(ElevatedButton).last);
      expect(submitBtn.onPressed, isNotNull);
    });

    testWidgets('TEST 3: Summary counters accurately match roster count without artificial math', (tester) async {
      await tester.pumpWidget(createRollCallTestWidget(const DailyRollCallScreen()));
      await tester.pumpAndSettle();

      // Default roster is 32 students
      expect(find.textContaining('All (32)'), findsOneWidget);
      expect(find.textContaining('Present (29)'), findsOneWidget);
      expect(find.textContaining('Absent (2)'), findsOneWidget);
      expect(find.textContaining('Late (1)'), findsOneWidget);
      expect(find.text('All 32 Counted'), findsOneWidget);
    });

    testWidgets('TEST 4: Changing student status updates counters dynamically', (tester) async {
      await tester.pumpWidget(createRollCallTestWidget(const DailyRollCallScreen()));
      await tester.pumpAndSettle();

      // Find roll #02 Ananya Dixit who is initially Absent (A)
      // Toggle her to Present (P)
      final pBtn = find.byKey(const ValueKey('btn_ADM-2024-0891_P'));
      expect(pBtn, findsOneWidget);
      await tester.ensureVisible(pBtn);
      await tester.tap(pBtn);
      await tester.pumpAndSettle();

      // Present count should increase to 30, absent should decrease to 1
      expect(find.textContaining('Present (30)'), findsOneWidget);
      expect(find.textContaining('Absent (1)'), findsOneWidget);
    });

    testWidgets('TEST 5: Single guardian name formatting on secondary line without duplication', (tester) async {
      await tester.pumpWidget(createRollCallTestWidget(const DailyRollCallScreen()));
      await tester.pumpAndSettle();

      // No backend guardian_name is present on the generated test roster, so the UI must
      // fall back to an honest, non-fabricated label — never a synthetic person's name.
      expect(find.text('Roll No. 01 · S/o Agarwal Family'), findsOneWidget);
      expect(find.text('Roll No. 02 · D/o Dixit Family'), findsOneWidget);
      expect(find.text('Roll No. 03 · S/o Sharma Family'), findsOneWidget);
    });

    testWidgets('TEST 6: Tapping roll number opens clean student profile bottom sheet', (tester) async {
      await tester.pumpWidget(createRollCallTestWidget(const DailyRollCallScreen()));
      await tester.pumpAndSettle();

      // Tap roll circle for student 1 (Aarav Agarwal)
      final rollBadge = find.byKey(const ValueKey('roll_badge_ADM-2024-0890'));
      expect(rollBadge, findsOneWidget);
      await tester.tap(rollBadge);
      await tester.pumpAndSettle();

      // Verify profile popup contents
      expect(find.text('Student Name'), findsOneWidget);
      expect(find.text("Father's Name"), findsOneWidget);
      expect(find.text('Agarwal Family'), findsOneWidget);
      expect(find.text('Admission No.'), findsOneWidget);
      expect(find.text('ADM-2024-0890'), findsOneWidget);
      expect(find.text('Date of Birth'), findsOneWidget);
      expect(find.text('14 Aug 2015'), findsOneWidget);
      expect(find.text('Gender'), findsOneWidget);
      expect(find.text('Male'), findsOneWidget);
      expect(find.text('Class'), findsOneWidget);
      expect(find.text('Grade 5'), findsOneWidget);
      expect(find.text('Section'), findsOneWidget);
      expect(find.text('Section A'), findsOneWidget);
      expect(find.text('Close'), findsOneWidget);

      // Close the sheet
      await tester.tap(find.text('Close'));
      await tester.pumpAndSettle();

      expect(find.text('Close'), findsNothing);
    });

    testWidgets('TEST 7: Mark All Present warns before overwriting exceptions and shows feedback', (tester) async {
      await tester.pumpWidget(createRollCallTestWidget(const DailyRollCallScreen()));
      await tester.pumpAndSettle();

      // Tap Mark All Present when exceptions (Absent, Late) exist
      await tester.tap(find.text('Mark All Present'));
      await tester.pumpAndSettle();

      expect(find.text('Mark All Students Present?'), findsOneWidget);
      expect(find.textContaining('recorded exceptions'), findsOneWidget);
      expect(find.text('Cancel'), findsOneWidget);
      expect(find.text('Continue'), findsOneWidget);

      await tester.tap(find.text('Continue'));
      await tester.pumpAndSettle();

      expect(find.text('All Present'), findsWidgets);
    });

    testWidgets('TEST 8 & 9: Search by student name, parent and roll number', (tester) async {
      await tester.pumpWidget(createRollCallTestWidget(const DailyRollCallScreen()));
      await tester.pumpAndSettle();

      // Search by Name "Diya"
      await tester.enterText(find.byType(TextField), 'Diya');
      await tester.pumpAndSettle();

      expect(find.text('Diya Sharma'), findsOneWidget);
      expect(find.text('Aarav Agarwal'), findsNothing);

      // Search by Roll "01"
      await tester.enterText(find.byType(TextField), '01');
      await tester.pumpAndSettle();

      expect(find.text('Aarav Agarwal'), findsOneWidget);
      expect(find.text('Diya Sharma'), findsNothing);

      // Search by the honest guardian fallback label ("<lastName> Family" — no fabricated
      // guardian_name is supplied by this test fixture). "Dixit Family" is unique to Ananya
      // Dixit's row and does not appear in any student's own full name, so a match here proves
      // the search index also checks the parent/guardian field, not just the student name.
      await tester.enterText(find.byType(TextField), 'Dixit Family');
      await tester.pumpAndSettle();

      expect(find.text('Ananya Dixit'), findsOneWidget);
    });

    testWidgets('TEST 11: Search returns empty state with clear search button', (tester) async {
      await tester.pumpWidget(createRollCallTestWidget(const DailyRollCallScreen()));
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextField), 'NonExistentStudentNameXYZ');
      await tester.pumpAndSettle();

      expect(find.text('No students found.'), findsOneWidget);
      expect(find.text('Clear search'), findsOneWidget);

      final clearBtn = find.text('Clear search');
      await tester.ensureVisible(clearBtn);
      await tester.tap(clearBtn);
      await tester.pumpAndSettle();

      expect(find.text('Aarav Agarwal'), findsOneWidget);
    });

    testWidgets('TEST 12 & 15: Status filters and search work simultaneously', (tester) async {
      await tester.pumpWidget(createRollCallTestWidget(const DailyRollCallScreen()));
      await tester.pumpAndSettle();

      // Tap Absent (A) filter
      await tester.tap(find.textContaining('Absent (2)'));
      await tester.pumpAndSettle();

      expect(find.text('Ananya Dixit'), findsOneWidget);
      expect(find.text('Aarav Agarwal'), findsNothing); // Present, so hidden

      // Now search within Absent for "Ananya"
      await tester.enterText(find.byType(TextField), 'Ananya');
      await tester.pumpAndSettle();

      expect(find.text('Ananya Dixit'), findsOneWidget);

      // Search for someone who is NOT absent
      await tester.enterText(find.byType(TextField), 'Diya');
      await tester.pumpAndSettle();

      expect(find.text('No students found.'), findsOneWidget);
    });

    testWidgets('TEST 16: School Holiday selected displays clean non-working day banner', (tester) async {
      await tester.pumpWidget(createRollCallTestWidget(const DailyRollCallScreen(
        isHolidayOverride: true,
        holidayNameOverride: 'Diwali Break',
      )));
      await tester.pumpAndSettle();

      expect(find.text('School Holiday'), findsOneWidget);
      expect(find.text('Diwali Break'), findsOneWidget);
      expect(find.text('No attendance is required for this date.'), findsOneWidget);
      expect(find.text('SNAPSHOT'), findsNothing);
    });

    testWidgets('TEST 17: Future date selected restricts attendance marking', (tester) async {
      await tester.pumpWidget(createRollCallTestWidget(const DailyRollCallScreen(
        isFutureDateOverride: true,
      )));
      await tester.pumpAndSettle();

      expect(find.text('Future Date Selected'), findsOneWidget);
      expect(find.text('Attendance is not available for future dates.'), findsOneWidget);
    });

    testWidgets('TEST 20: Teacher with no assigned class shows clean unassigned state', (tester) async {
      const unassignedTeacher = Teacher(
        id: 'T-999',
        name: 'Unassigned Staff',
        dateOfBirth: '01 Jan 1990',
        mobile: '+91 99999 00000',
        email: 'unassigned@onps.edu.in',
        gender: 'Male',
        joinDate: '01 Jan 2026',
        address: Address(line1: 'Campus', city: 'Delhi', district: 'Central', state: 'Delhi', pincode: '110054'),
        subjectSpecialization: 'General',
      );

      await tester.pumpWidget(createRollCallTestWidget(const DailyRollCallScreen(
        teacherOverride: unassignedTeacher,
      )));
      await tester.pumpAndSettle();

      expect(find.text('No Class Assigned'), findsOneWidget);
    });

    testWidgets('TEST 23 & 24: Submit Attendance opens Attendance Preview sheet and transitions upon confirmation', (tester) async {
      await tester.pumpWidget(createRollCallTestWidget(const DailyRollCallScreen()));
      await tester.pumpAndSettle();

      // Tap Submit Attendance
      await tester.tap(find.text('Submit Attendance'));
      await tester.pumpAndSettle();

      // Attendance Preview should be displayed
      expect(find.text('Attendance 5-A'), findsWidgets);
      expect(find.text('Back to Attendance'), findsOneWidget);
      expect(find.text('Confirm & Submit'), findsOneWidget);

      // Confirm Submit
      await tester.tap(find.text('Confirm & Submit'));
      await tester.pumpAndSettle();

      expect(find.text('Attendance Officially Recorded'), findsOneWidget);
    });

    testWidgets('TEST 32: Long student names do not cause layout overflow', (tester) async {
      const longStudent = Student(
        id: 'ADM-LONG-99999',
        firstName: 'Anantaramakrishnan',
        lastName: 'Venkatasubramanian-Krishnamurthy',
        dateOfBirth: '14 Aug 2015',
        mobile: '+91 98000 00000',
        email: 'long.name@example.com',
        gender: 'Male',
        admissionDate: '01 Apr 2024',
        rollNumber: 99,
        dwellingType: 'House/Apartment',
        address: Address(line1: 'Campus', city: 'Delhi', district: 'Central', state: 'Delhi', pincode: '110054'),
      );

      await tester.pumpWidget(createRollCallTestWidget(const DailyRollCallScreen(
        studentOverrides: [longStudent],
      )));
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      expect(find.textContaining('Anantaramakrishnan'), findsOneWidget);
    });

    testWidgets('RESPONSIVENESS: Attendance 5-A mounts with zero overflow across all mobile viewports (320px - 480px)', (tester) async {
      final widths = [320.0, 360.0, 375.0, 390.0, 412.0, 430.0, 480.0];

      final oldHandler = FlutterError.onError;
      FlutterError.onError = (details) {
        // ignore: avoid_print
        print('OVERFLOW_ERROR_DETAILS:\n${details.toString()}');
        oldHandler?.call(details);
      };

      try {
        for (final w in widths) {
          final binding = TestWidgetsFlutterBinding.ensureInitialized();
          binding.platformDispatcher.views.first.physicalSize = Size(w, 800);
          binding.platformDispatcher.views.first.devicePixelRatio = 1.0;

          await tester.pumpWidget(createRollCallTestWidget(const DailyRollCallScreen()));
          await tester.pumpAndSettle();

          expect(tester.takeException(), isNull, reason: 'Failed at width $w');
          expect(find.text('Class 5-A'), findsOneWidget);
          expect(find.text('Mark All Present'), findsOneWidget);
          expect(find.text('Submit Attendance'), findsOneWidget);
        }
      } finally {
        FlutterError.onError = oldHandler;
      }
    });

    testWidgets('ICON RULE: Zero unicode emojis used in Daily Roll Call Register', (tester) async {
      await tester.pumpWidget(createRollCallTestWidget(const DailyRollCallScreen()));
      await tester.pumpAndSettle();

      final textWidgets = tester.widgetList<Text>(find.byType(Text));
      final emojiRegex = RegExp(
        r'[\u{1F300}-\u{1F6FF}\u{1F900}-\u{1F9FF}\u{2600}-\u{26FF}\u{2700}-\u{27BF}]',
        unicode: true,
      );

      for (final textWidget in textWidgets) {
        final text = textWidget.data ?? textWidget.textSpan?.toPlainText() ?? '';
        expect(emojiRegex.hasMatch(text), isFalse, reason: 'Found emoji in: "$text"');
      }
    });
  });
}
