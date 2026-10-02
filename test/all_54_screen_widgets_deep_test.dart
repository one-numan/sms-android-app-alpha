// ==============================================================================
// One Numan Public School (ONPS) — Android ERP Mobile Application
// Test Suite: 100% Comprehensive All-54-Screens Direct Unit & Widget Deep Test
// Tests each and every screen widget directly for instantiation, render safety,
// theme integration, and 0-unicode emoji compliance.
// ==============================================================================

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:sms_android_app_alpha/data/mock/auth_state.dart';
import 'package:sms_android_app_alpha/data/mock/mock_data.dart';
import 'package:sms_android_app_alpha/theme/app_theme.dart';

// Import all 54 screens
import 'package:sms_android_app_alpha/screens/account/account_profile_screen.dart';
import 'package:sms_android_app_alpha/screens/account/account_settings_screen.dart';
import 'package:sms_android_app_alpha/screens/admin/parents_directory_screen.dart';
import 'package:sms_android_app_alpha/screens/admin/school_setup_screen.dart';
import 'package:sms_android_app_alpha/screens/admin/unified_search_screen.dart';
import 'package:sms_android_app_alpha/screens/admissions/admissions_enquiry_screen.dart';
import 'package:sms_android_app_alpha/screens/admissions/applications_enrollment_screen.dart';
import 'package:sms_android_app_alpha/screens/attendance/attendance_matrix_screen.dart';
import 'package:sms_android_app_alpha/screens/attendance/daily_roll_call_screen.dart';
import 'package:sms_android_app_alpha/screens/attendance/faculty_leave_screen.dart';
import 'package:sms_android_app_alpha/screens/attendance/student_attendance_screen.dart';
import 'package:sms_android_app_alpha/screens/auth/device_management_screen.dart';
import 'package:sms_android_app_alpha/screens/auth/login_screen.dart';
import 'package:sms_android_app_alpha/screens/auth/morning_briefing_transition_screen.dart';
import 'package:sms_android_app_alpha/screens/auth/password_reset_screen.dart';
import 'package:sms_android_app_alpha/screens/auth/security_lockout_screen.dart';
import 'package:sms_android_app_alpha/screens/auth/two_factor_otp_screen.dart';
import 'package:sms_android_app_alpha/screens/calendar_announcements/academic_calendar_screen.dart';
import 'package:sms_android_app_alpha/screens/calendar_announcements/add_event_screen.dart';
import 'package:sms_android_app_alpha/screens/calendar_announcements/announcement_approval_screen.dart';
import 'package:sms_android_app_alpha/screens/calendar_announcements/announcement_authoring_screen.dart';
import 'package:sms_android_app_alpha/screens/calendar_announcements/events_desk_screen.dart';
import 'package:sms_android_app_alpha/screens/calendar_announcements/notice_board_screen.dart';
import 'package:sms_android_app_alpha/screens/calendar_announcements/notification_center_screen.dart';
import 'package:sms_android_app_alpha/screens/dashboards/accountant_dashboard_screen.dart';
import 'package:sms_android_app_alpha/screens/dashboards/class_teacher_dashboard_screen.dart';
import 'package:sms_android_app_alpha/screens/dashboards/librarian_dashboard_screen.dart';
import 'package:sms_android_app_alpha/screens/dashboards/parent_dashboard_screen.dart';
import 'package:sms_android_app_alpha/screens/dashboards/principal_dashboard_screen.dart';
import 'package:sms_android_app_alpha/screens/dashboards/student_hub_screen.dart';
import 'package:sms_android_app_alpha/screens/dashboards/subject_teacher_cohorts_screen.dart';
import 'package:sms_android_app_alpha/screens/dashboards/subject_teacher_dashboard_screen.dart';
import 'package:sms_android_app_alpha/screens/dashboards/super_admin_modules_screen.dart';
import 'package:sms_android_app_alpha/screens/dashboards/telemetry_dashboard_screen.dart';
import 'package:sms_android_app_alpha/screens/dashboards/front_desk_dashboard_screen.dart';
import 'package:sms_android_app_alpha/screens/faculty/class_info_screen.dart';
import 'package:sms_android_app_alpha/screens/faculty/class_student_directory_screen.dart';
import 'package:sms_android_app_alpha/screens/faculty/class_subjects_screen.dart';
import 'package:sms_android_app_alpha/screens/faculty/class_timetable_screen.dart';
import 'package:sms_android_app_alpha/screens/faculty/faculty_allocation_screen.dart';
import 'package:sms_android_app_alpha/screens/faculty/principal_section_detail_screen.dart';
import 'package:sms_android_app_alpha/screens/faculty/principal_teachers_screen.dart';
import 'package:sms_android_app_alpha/screens/faculty/staff_directory_screen.dart';
import 'package:sms_android_app_alpha/screens/faculty/subject_teacher_assignments_screen.dart';
import 'package:sms_android_app_alpha/screens/faculty/subject_teacher_classes_screen.dart';
import 'package:sms_android_app_alpha/screens/faculty/teacher_timetable_screen.dart';
import 'package:sms_android_app_alpha/screens/fees/fee_ledger_screen.dart';
import 'package:sms_android_app_alpha/screens/fees/fee_receipt_screen.dart';
import 'package:sms_android_app_alpha/screens/library_transport_inventory/bus_transit_screen.dart';
import 'package:sms_android_app_alpha/screens/library_transport_inventory/inventory_desk_screen.dart';
import 'package:sms_android_app_alpha/screens/not_found_screen.dart';
import 'package:sms_android_app_alpha/screens/students/academic_report_card_screen.dart';
import 'package:sms_android_app_alpha/screens/students/all_students_ledger_screen.dart';
import 'package:sms_android_app_alpha/screens/students/digital_student_id_card_screen.dart';
import 'package:sms_android_app_alpha/screens/students/marks_entry_desk_screen.dart';
import 'package:sms_android_app_alpha/screens/students/student_dossier_screen.dart';

import 'package:go_router/go_router.dart';

Widget wrapScreen(Widget screen, {AuthState? authState}) {
  final auth = authState ?? AuthState();
  final testRouter = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(path: '/', builder: (context, state) => Scaffold(body: screen)),
      GoRoute(path: '/dashboard/principal', builder: (context, state) => const Scaffold(body: Text('Principal Dashboard'))),
    ],
  );

  return ChangeNotifierProvider<AuthState>.value(
    value: auth,
    child: MaterialApp.router(
      theme: AcademicTheme.themeData,
      routerConfig: testRouter,
    ),
  );
}

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

  Future<void> testMount(WidgetTester tester, String screenName, Widget widget, {AuthState? auth}) async {
    await tester.pumpWidget(wrapScreen(widget, authState: auth));
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull, reason: '$screenName threw exception during mount');
    assertZeroEmojis(tester, screenName);
  }

  group('All 54 Screen Direct Mount & Zero-Emoji Tests', () {
    testWidgets('1. AccountProfileScreen', (tester) => testMount(tester, 'AccountProfileScreen', const AccountProfileScreen()));
    testWidgets('2. AccountSettingsScreen', (tester) => testMount(tester, 'AccountSettingsScreen', const AccountSettingsScreen()));
    testWidgets('3. ParentsDirectoryScreen', (tester) => testMount(tester, 'ParentsDirectoryScreen', const ParentsDirectoryScreen()));
    testWidgets('4. SchoolSetupScreen', (tester) => testMount(tester, 'SchoolSetupScreen', const SchoolSetupScreen()));
    testWidgets('5. UnifiedSearchScreen', (tester) => testMount(tester, 'UnifiedSearchScreen', const UnifiedSearchScreen()));
    testWidgets('6. AdmissionsEnquiryScreen', (tester) => testMount(tester, 'AdmissionsEnquiryScreen', const AdmissionsEnquiryScreen()));
    testWidgets('7. ApplicationsEnrollmentScreen', (tester) => testMount(tester, 'ApplicationsEnrollmentScreen', const ApplicationsEnrollmentScreen()));
    testWidgets('8. AttendanceMatrixScreen', (tester) => testMount(tester, 'AttendanceMatrixScreen', const AttendanceMatrixScreen()));
    testWidgets('9. DailyRollCallScreen', (tester) => testMount(tester, 'DailyRollCallScreen', const DailyRollCallScreen()));
    testWidgets('10. FacultyLeaveScreen', (tester) => testMount(tester, 'FacultyLeaveScreen', const FacultyLeaveScreen()));
    testWidgets('11. StudentAttendanceScreen', (tester) => testMount(tester, 'StudentAttendanceScreen', StudentAttendanceScreen(studentId: MockData.students.first.id)));
    testWidgets('12. DeviceManagementScreen', (tester) => testMount(tester, 'DeviceManagementScreen', const DeviceManagementScreen()));
    testWidgets('13. LoginScreen', (tester) => testMount(tester, 'LoginScreen', const LoginScreen()));
    testWidgets('14. MorningBriefingTransitionScreen', (tester) => testMount(tester, 'MorningBriefingTransitionScreen', const MorningBriefingTransitionScreen()));
    testWidgets('15. PasswordResetScreen', (tester) => testMount(tester, 'PasswordResetScreen', const PasswordResetScreen()));
    testWidgets('16. SecurityLockoutScreen', (tester) => testMount(tester, 'SecurityLockoutScreen', const SecurityLockoutScreen()));
    testWidgets('17. TwoFactorOtpScreen', (tester) => testMount(tester, 'TwoFactorOtpScreen', const TwoFactorOtpScreen()));
    testWidgets('18. AcademicCalendarScreen', (tester) => testMount(tester, 'AcademicCalendarScreen', const AcademicCalendarScreen()));
    testWidgets('19. AddEventScreen', (tester) => testMount(tester, 'AddEventScreen', const AddEventScreen()));
    testWidgets('20. AnnouncementApprovalScreen', (tester) => testMount(tester, 'AnnouncementApprovalScreen', const AnnouncementApprovalScreen()));
    testWidgets('21. AnnouncementAuthoringScreen', (tester) => testMount(tester, 'AnnouncementAuthoringScreen', const AnnouncementAuthoringScreen()));
    testWidgets('22. EventsDeskScreen', (tester) => testMount(tester, 'EventsDeskScreen', const EventsDeskScreen()));
    testWidgets('23. NoticeBoardScreen', (tester) => testMount(tester, 'NoticeBoardScreen', const NoticeBoardScreen()));
    testWidgets('24. NotificationCenterScreen', (tester) => testMount(tester, 'NotificationCenterScreen', const NotificationCenterScreen()));
    testWidgets('25. AccountantDashboardScreen', (tester) => testMount(tester, 'AccountantDashboardScreen', const AccountantDashboardScreen()));
    testWidgets('26. ClassTeacherDashboardScreen', (tester) => testMount(tester, 'ClassTeacherDashboardScreen', const ClassTeacherDashboardScreen()));
    testWidgets('27. LibrarianDashboardScreen', (tester) => testMount(tester, 'LibrarianDashboardScreen', const LibrarianDashboardScreen()));
    testWidgets('28. ParentDashboardScreen', (tester) => testMount(tester, 'ParentDashboardScreen', const ParentDashboardScreen()));
    testWidgets('29. PrincipalDashboardScreen', (tester) => testMount(tester, 'PrincipalDashboardScreen', const PrincipalDashboardScreen()));
    testWidgets('30. StudentHubScreen', (tester) => testMount(tester, 'StudentHubScreen', const StudentHubScreen()));
    testWidgets('31. SubjectTeacherCohortsScreen', (tester) => testMount(tester, 'SubjectTeacherCohortsScreen', const SubjectTeacherCohortsScreen()));
    testWidgets('32. SubjectTeacherDashboardScreen', (tester) => testMount(tester, 'SubjectTeacherDashboardScreen', const SubjectTeacherDashboardScreen()));
    testWidgets('33. SuperAdminModulesScreen', (tester) => testMount(tester, 'SuperAdminModulesScreen', const SuperAdminModulesScreen()));
    testWidgets('33b. TelemetryDashboardScreen', (tester) => testMount(tester, 'TelemetryDashboardScreen', const TelemetryDashboardScreen()));
    testWidgets('33c. FrontDeskDashboardScreen', (tester) => testMount(tester, 'FrontDeskDashboardScreen', const FrontDeskDashboardScreen()));
    testWidgets('34. ClassInfoScreen', (tester) => testMount(tester, 'ClassInfoScreen', const ClassInfoScreen()));
    testWidgets('35. ClassStudentDirectoryScreen', (tester) => testMount(tester, 'ClassStudentDirectoryScreen', const ClassStudentDirectoryScreen()));
    testWidgets('36. ClassSubjectsScreen', (tester) => testMount(tester, 'ClassSubjectsScreen', const ClassSubjectsScreen()));
    testWidgets('37. ClassTimetableScreen', (tester) => testMount(tester, 'ClassTimetableScreen', const ClassTimetableScreen()));
    testWidgets('38. FacultyAllocationScreen', (tester) => testMount(tester, 'FacultyAllocationScreen', const FacultyAllocationScreen()));
    testWidgets('39. PrincipalSectionDetailScreen', (tester) => testMount(tester, 'PrincipalSectionDetailScreen', const PrincipalSectionDetailScreen(initialGrade: '5', initialSection: 'A')));
    testWidgets('40. PrincipalTeachersScreen', (tester) => testMount(tester, 'PrincipalTeachersScreen', const PrincipalTeachersScreen()));
    testWidgets('41. StaffDirectoryScreen', (tester) => testMount(tester, 'StaffDirectoryScreen', const StaffDirectoryScreen()));
    testWidgets('42. SubjectTeacherAssignmentsScreen', (tester) => testMount(tester, 'SubjectTeacherAssignmentsScreen', const SubjectTeacherAssignmentsScreen()));
    testWidgets('43. SubjectTeacherClassesScreen', (tester) => testMount(tester, 'SubjectTeacherClassesScreen', const SubjectTeacherClassesScreen()));
    testWidgets('44. TeacherTimetableScreen', (tester) => testMount(tester, 'TeacherTimetableScreen', const TeacherTimetableScreen()));
    testWidgets('45. FeeLedgerScreen', (tester) => testMount(tester, 'FeeLedgerScreen', const FeeLedgerScreen()));
    testWidgets('46. FeeReceiptScreen', (tester) => testMount(tester, 'FeeReceiptScreen', const FeeReceiptScreen()));
    testWidgets('47. BusTransitScreen', (tester) => testMount(tester, 'BusTransitScreen', const BusTransitScreen()));
    testWidgets('48. InventoryDeskScreen', (tester) => testMount(tester, 'InventoryDeskScreen', const InventoryDeskScreen()));
    testWidgets('49. NotFoundScreen', (tester) => testMount(tester, 'NotFoundScreen', const NotFoundScreen()));
    testWidgets('50. AcademicReportCardScreen', (tester) => testMount(tester, 'AcademicReportCardScreen', AcademicReportCardScreen(studentId: MockData.students.first.id)));
    testWidgets('51. AllStudentsLedgerScreen', (tester) => testMount(tester, 'AllStudentsLedgerScreen', const AllStudentsLedgerScreen()));
    testWidgets('52. DigitalStudentIdCardScreen', (tester) => testMount(tester, 'DigitalStudentIdCardScreen', const DigitalStudentIdCardScreen()));
    testWidgets('53. MarksEntryDeskScreen', (tester) => testMount(tester, 'MarksEntryDeskScreen', const MarksEntryDeskScreen()));
    testWidgets('54. StudentDossierScreen', (tester) => testMount(tester, 'StudentDossierScreen', StudentDossierScreen(studentId: MockData.students.first.id)));
  });
}
