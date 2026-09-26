// ==============================================================================
// One Numan Public School (ONPS) — Android ERP Mobile Application
// Automated Testing: Verification of All PDF Buttons Across App Screens
// ==============================================================================

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:sms_android_app_alpha/data/mock/auth_state.dart';
import 'package:sms_android_app_alpha/screens/calendar_announcements/academic_calendar_screen.dart';
import 'package:sms_android_app_alpha/screens/calendar_announcements/notice_board_screen.dart';
import 'package:sms_android_app_alpha/screens/faculty/teacher_timetable_screen.dart';
import 'package:sms_android_app_alpha/screens/fees/fee_receipt_screen.dart';
import 'package:sms_android_app_alpha/screens/students/academic_report_card_screen.dart';
import 'package:sms_android_app_alpha/screens/students/digital_student_id_card_screen.dart';

Widget _createTestApp(Widget child) {
  return ChangeNotifierProvider<AuthState>(
    create: (_) => AuthState(),
    child: MaterialApp(
      home: child,
    ),
  );
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('All Application PDF Buttons Regression Suite', () {
    testWidgets('1. Digital Student ID Card Screen - PDF Download Button', (WidgetTester tester) async {
      await tester.pumpWidget(_createTestApp(const DigitalStudentIdCardScreen()));
      await tester.pumpAndSettle();

      final pdfButton = find.text('PDF');
      expect(pdfButton, findsOneWidget);

      await tester.tap(pdfButton);
      await tester.pump();

      expect(find.textContaining('Downloading Student ID PDF'), findsOneWidget);
    });

    testWidgets('2. Academic Report Card Screen - CBSE Transcript PDF Button', (WidgetTester tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(_createTestApp(const AcademicReportCardScreen(studentId: '1')));
      await tester.pumpAndSettle();

      final pdfButton = find.text('Download Official CBSE Transcript (PDF)');
      expect(pdfButton, findsOneWidget);

      await tester.ensureVisible(pdfButton);
      await tester.pumpAndSettle();
      await tester.tap(pdfButton);
      await tester.pump();

      expect(find.text('Saving Official Stamped CBSE Transcript PDF...'), findsOneWidget);
    });

    testWidgets('3. Academic Calendar Screen - Export Calendar PDF Button', (WidgetTester tester) async {
      await tester.pumpWidget(_createTestApp(const AcademicCalendarScreen()));
      await tester.pumpAndSettle();

      final pdfIconButton = find.byTooltip('Export Calendar PDF');
      expect(pdfIconButton, findsOneWidget);

      await tester.tap(pdfIconButton);
      await tester.pump();

      expect(find.text('Academic Calendar 2026-27 PDF downloaded.'), findsOneWidget);
    });

    testWidgets('4. Fee Receipt Screen - Download Receipt PDF Button', (WidgetTester tester) async {
      await tester.pumpWidget(_createTestApp(const FeeReceiptScreen(receiptNo: 'ONPS-REC-2026-8899')));
      await tester.pumpAndSettle();

      final pdfReceiptButton = find.byTooltip('Download Receipt PDF');
      expect(pdfReceiptButton, findsOneWidget);

      await tester.tap(pdfReceiptButton);
      await tester.pump();

      expect(find.textContaining('PDF downloaded'), findsOneWidget);
    });

    testWidgets('5. Teacher Timetable Screen - Export Timetable PDF Button', (WidgetTester tester) async {
      await tester.pumpWidget(_createTestApp(const TeacherTimetableScreen()));
      await tester.pumpAndSettle();

      final pdfTimetableButton = find.byTooltip('Export Schedule PDF');
      expect(pdfTimetableButton, findsOneWidget);

      await tester.tap(pdfTimetableButton);
      await tester.pump();

      expect(find.textContaining('Timetable PDF exported successfully.'), findsOneWidget);
    });

    testWidgets('6. Notice Board Screen - Notice PDF Attachment Download Button', (WidgetTester tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(_createTestApp(const NoticeBoardScreen()));
      await tester.pumpAndSettle();

      // Tap the first notice item to open the details bottom sheet
      final firstNotice = find.text('Revised Morning Assembly Schedule');
      expect(firstNotice, findsOneWidget);
      await tester.tap(firstNotice);
      await tester.pumpAndSettle();

      // Find the PDF download icon and tap it
      final downloadIcon = find.byIcon(Icons.download_rounded);
      expect(downloadIcon, findsOneWidget);

      await tester.ensureVisible(downloadIcon);
      await tester.pumpAndSettle();
      await tester.tap(downloadIcon);
      await tester.pump();

      expect(find.textContaining('Downloading winter_timing_schedule_2026.pdf...'), findsOneWidget);
    });
  });
}
