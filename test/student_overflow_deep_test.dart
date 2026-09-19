// ==============================================================================
// One Numan Public School (ONPS) — Android ERP Mobile Application
// Test Suite: Student Screens Deep Layout & Zero Overflow Verification
// Tests all student-facing screens across narrow viewports (320px, 360px, 390px, 412px)
// with complete vertical scrolling to ensure ZERO RenderFlex overflows.
// ==============================================================================

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:sms_android_app_alpha/data/mock/auth_state.dart';
import 'package:sms_android_app_alpha/data/mock/mock_data.dart';
import 'package:sms_android_app_alpha/models/models.dart';
import 'package:sms_android_app_alpha/screens/attendance/attendance_matrix_screen.dart';
import 'package:sms_android_app_alpha/screens/attendance/student_attendance_screen.dart';
import 'package:sms_android_app_alpha/screens/dashboards/student_hub_screen.dart';
import 'package:sms_android_app_alpha/screens/fees/fee_ledger_screen.dart';
import 'package:sms_android_app_alpha/screens/fees/fee_receipt_screen.dart';
import 'package:sms_android_app_alpha/screens/students/academic_report_card_screen.dart';
import 'package:sms_android_app_alpha/screens/students/digital_student_id_card_screen.dart';
import 'package:sms_android_app_alpha/screens/students/student_dossier_screen.dart';
import 'package:sms_android_app_alpha/theme/app_theme.dart';
import 'package:sms_android_app_alpha/widgets/module_grid_sheet.dart';

Widget wrapStudentWidget(Widget child, {AuthState? authState, double width = 360, double height = 800}) {
  final auth = authState ?? (AuthState()..switchRole(UserRole.student));
  return ChangeNotifierProvider<AuthState>.value(
    value: auth,
    child: MaterialApp(
      theme: AcademicTheme.themeData,
      home: child,
    ),
  );
}

void main() {
  setUp(() {
    GoogleFonts.config.allowRuntimeFetching = false;
  });

  final viewports = [
    const Size(320, 640),  // Ultra-narrow 320px
    const Size(360, 800),  // Compact 360px
    const Size(390, 844),  // iPhone / Modern 390px
    const Size(412, 915),  // Modern Android 412px
  ];

  final emojiRegex = RegExp(
    r'[\u{1F300}-\u{1F9FF}\u{2600}-\u{26FF}\u{2700}-\u{27BF}\u{1F1E6}-\u{1F1FF}\u{1F600}-\u{1F64F}\u{1F680}-\u{1F6FF}]',
    unicode: true,
  );

  void assertZeroEmojis(WidgetTester tester, String screenName) {
    final allTextWidgets = tester.widgetList<Text>(find.byType(Text));
    for (final textWidget in allTextWidgets) {
      final text = textWidget.data ?? textWidget.textSpan?.toPlainText() ?? '';
      expect(
        emojiRegex.hasMatch(text),
        isFalse,
        reason: 'Zero Emoji Violation on $screenName: Found emoji in "$text"',
      );
    }
  }

  Future<void> testScreenAtSize(WidgetTester tester, String name, Widget screen, Size size) async {
    final binding = TestWidgetsFlutterBinding.ensureInitialized();
    binding.platformDispatcher.views.first.physicalSize = size;
    binding.platformDispatcher.views.first.devicePixelRatio = 1.0;

    final oldHandler = FlutterError.onError;
    FlutterError.onError = (details) {
      // ignore: avoid_print
      print('FULL_DETAILS:\n${details.toString()}');
      oldHandler?.call(details);
    };

    try {
      await tester.pumpWidget(wrapStudentWidget(screen, width: size.width, height: size.height));
      await tester.pumpAndSettle();
    } finally {
      FlutterError.onError = oldHandler;
    }

    // Verify initial render has no exceptions
    final exc1 = tester.takeException();
    if (exc1 != null) {
      // ignore: avoid_print
      print('EXC1: $exc1');
    }
    expect(exc1, isNull, reason: '$name threw exception at size $size');
    assertZeroEmojis(tester, name);

    // Scroll down to test all bottom elements
    final scrollable = find.byType(Scrollable);
    if (scrollable.evaluate().isNotEmpty) {
      await tester.drag(scrollable.first, const Offset(0, -500));
      await tester.pumpAndSettle();
      final exc2 = tester.takeException();
      if (exc2 != null) debugPrint('TEST ERROR on $name (scroll 1): $exc2');
      expect(exc2, isNull, reason: '$name threw exception after scroll at size $size');

      await tester.drag(scrollable.first, const Offset(0, -500));
      await tester.pumpAndSettle();
      final exc3 = tester.takeException();
      if (exc3 != null) debugPrint('TEST ERROR on $name (scroll 2): $exc3');
      expect(exc3, isNull, reason: '$name threw exception after deep scroll at size $size');
    }
  }

  group('Student Functionality & Layout Deep Tests Across All Viewports', () {
    for (final size in viewports) {
      final width = size.width.toInt();

      testWidgets('Student Hub Screen (${width}px)', (tester) async {
        await testScreenAtSize(tester, 'StudentHubScreen_${width}px', const StudentHubScreen(), size);
      });

      testWidgets('Student Attendance Screen (${width}px)', (tester) async {
        await testScreenAtSize(tester, 'StudentAttendanceScreen_${width}px', StudentAttendanceScreen(studentId: MockData.students.first.id), size);
      });

      testWidgets('Student Attendance Matrix Screen (${width}px)', (tester) async {
        await testScreenAtSize(tester, 'AttendanceMatrixScreen_${width}px', const AttendanceMatrixScreen(), size);
      });

      testWidgets('Student Academic Report Card Screen (${width}px)', (tester) async {
        await testScreenAtSize(tester, 'AcademicReportCardScreen_${width}px', AcademicReportCardScreen(studentId: MockData.students.first.id), size);
      });

      testWidgets('Student Digital ID Card Screen (${width}px)', (tester) async {
        await testScreenAtSize(tester, 'DigitalStudentIdCardScreen_${width}px', const DigitalStudentIdCardScreen(), size);
      });

      testWidgets('Student Dossier 360 Screen (${width}px)', (tester) async {
        await testScreenAtSize(tester, 'StudentDossierScreen_${width}px', StudentDossierScreen(studentId: MockData.students.first.id), size);
      });

      testWidgets('Student Fee Ledger Screen (${width}px)', (tester) async {
        await testScreenAtSize(tester, 'FeeLedgerScreen_${width}px', const FeeLedgerScreen(), size);
      });

      testWidgets('Student Fee Receipt Screen (${width}px)', (tester) async {
        await testScreenAtSize(tester, 'FeeReceiptScreen_${width}px', const FeeReceiptScreen(), size);
      });

      testWidgets('Student More Screen Module Grid Sheet (${width}px)', (tester) async {
        await testScreenAtSize(tester, 'StudentMoreGridSheet_${width}px', const Scaffold(body: ModuleGridSheet()), size);
      });
    }
  });
}
