// ==============================================================================
// One Numan Public School (ONPS) — Android ERP Mobile Application
// Central Application Router (go_router)
// Design System: Espresso Heritage Academic
// Supports 43 Screens across 9 Institutional Roles
// ==============================================================================

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'data/mock/auth_state.dart';
import 'models/models.dart';

// Screens — Auth
import 'screens/auth/login_screen.dart';
import 'screens/auth/two_factor_otp_screen.dart';
import 'screens/auth/security_lockout_screen.dart';
import 'screens/auth/password_reset_screen.dart';
import 'screens/auth/morning_briefing_transition_screen.dart';
import 'screens/auth/device_management_screen.dart';
import 'screens/account/account_profile_screen.dart';
import 'screens/account/account_settings_screen.dart';

// Screens — Dashboards
import 'screens/dashboards/parent_dashboard_screen.dart';
import 'screens/dashboards/student_hub_screen.dart';
import 'screens/dashboards/class_teacher_dashboard_screen.dart';
import 'screens/dashboards/subject_teacher_dashboard_screen.dart';
import 'screens/dashboards/subject_teacher_cohorts_screen.dart';
import 'screens/dashboards/principal_dashboard_screen.dart';
import 'screens/dashboards/accountant_dashboard_screen.dart';
import 'screens/dashboards/librarian_dashboard_screen.dart';
import 'screens/dashboards/super_admin_modules_screen.dart';

// Screens — Students
import 'screens/students/student_dossier_screen.dart';
import 'screens/students/academic_report_card_screen.dart';
import 'screens/students/marks_entry_desk_screen.dart';
import 'screens/students/all_students_ledger_screen.dart';
import 'screens/students/digital_student_id_card_screen.dart';

// Screens — Attendance
import 'screens/attendance/daily_roll_call_screen.dart';
import 'screens/attendance/attendance_matrix_screen.dart';
import 'screens/attendance/student_attendance_screen.dart';
import 'screens/attendance/faculty_leave_screen.dart';

// Screens — Faculty
import 'screens/faculty/faculty_allocation_screen.dart';
import 'screens/faculty/class_timetable_screen.dart';
import 'screens/faculty/teacher_timetable_screen.dart';
import 'screens/faculty/staff_directory_screen.dart';
import 'screens/faculty/class_info_screen.dart';
import 'screens/faculty/class_student_directory_screen.dart';
import 'screens/faculty/class_subjects_screen.dart';
import 'screens/faculty/subject_teacher_classes_screen.dart';
import 'screens/faculty/subject_teacher_assignments_screen.dart';
import 'screens/faculty/principal_section_detail_screen.dart';
import 'screens/faculty/principal_teachers_screen.dart';

// Screens — Admissions
import 'screens/admissions/admissions_enquiry_screen.dart';
import 'screens/admissions/applications_enrollment_screen.dart';

// Screens — Fees
import 'screens/fees/fee_ledger_screen.dart';
import 'screens/fees/fee_receipt_screen.dart';

// Screens — Library, Transport, Inventory
import 'screens/library_transport_inventory/bus_transit_screen.dart';
import 'screens/library_transport_inventory/inventory_desk_screen.dart';

// Screens — Calendar, Notices & Announcements
import 'screens/calendar_announcements/academic_calendar_screen.dart';
import 'screens/calendar_announcements/events_desk_screen.dart';
import 'screens/calendar_announcements/add_event_screen.dart';
import 'screens/calendar_announcements/notice_board_screen.dart';
import 'screens/calendar_announcements/announcement_authoring_screen.dart';
import 'screens/calendar_announcements/announcement_approval_screen.dart';
import 'screens/calendar_announcements/notification_center_screen.dart';

// Screens — Admin
import 'screens/admin/unified_search_screen.dart';
import 'screens/admin/parents_directory_screen.dart';
import 'screens/admin/school_setup_screen.dart';
import 'screens/splash/splash_screen.dart';
import 'screens/help/faq_screen.dart';

GoRouter createOnpsRouter(AuthState authState) {
  return GoRouter(
    initialLocation: '/splash',
    refreshListenable: authState,
    redirect: (context, state) {
      final isAuth = authState.isAuthenticated;
      final loc = state.matchedLocation;
      final isPublicRoute = loc == '/login' ||
          loc == '/splash' ||
          loc == '/security-lockout' ||
          loc == '/password-reset' ||
          loc == '/2fa-otp';

      if (!isAuth && !isPublicRoute) {
        return '/login';
      }
      return null;
    },
    routes: [
      // AI Enabled Brand Splash Screen
      GoRoute(
        path: '/splash',
        pageBuilder: (context, state) => CustomTransitionPage(
          key: state.pageKey,
          child: const SplashScreen(),
          transitionDuration: const Duration(milliseconds: 300),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
        ),
      ),

      // Root Dynamic Entry: Resolves to active persona's dashboard with smooth cross-dissolve
      GoRoute(
        path: '/',
        pageBuilder: (context, state) {
          Widget child;
          switch (authState.currentRole) {
            case UserRole.parent:
              child = const ParentDashboardScreen();
              break;
            case UserRole.student:
              child = const StudentHubScreen();
              break;
            case UserRole.classTeacher:
              child = const ClassTeacherDashboardScreen();
              break;
            case UserRole.subjectTeacher:
              child = const SubjectTeacherDashboardScreen();
              break;
            case UserRole.principal:
            case UserRole.vicePrincipal:
              child = const PrincipalDashboardScreen();
              break;
            case UserRole.accountant:
              child = const AccountantDashboardScreen();
              break;
            case UserRole.librarian:
              child = const LibrarianDashboardScreen();
              break;
            case UserRole.receptionist:
              child = const AdmissionsEnquiryScreen();
              break;
            case UserRole.superAdmin:
              child = const SuperAdminModulesScreen();
              break;
          }
          return CustomTransitionPage(
            key: state.pageKey,
            child: child,
            transitionDuration: const Duration(milliseconds: 400),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              return FadeTransition(
                opacity: CurvedAnimation(
                  parent: animation,
                  curve: Curves.easeInOut,
                ),
                child: child,
              );
            },
          );
        },
      ),

      // Auth & Governance
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/auth/2fa',
        builder: (context, state) => const TwoFactorOtpScreen(),
      ),
      GoRoute(
        path: '/auth/lockout',
        builder: (context, state) => const SecurityLockoutScreen(),
      ),
      GoRoute(
        path: '/auth/password-reset',
        builder: (context, state) => const PasswordResetScreen(),
      ),
      GoRoute(
        path: '/auth/briefing',
        builder: (context, state) => const MorningBriefingTransitionScreen(),
      ),
      GoRoute(
        path: '/principal/briefing',
        builder: (context, state) => const MorningBriefingTransitionScreen(),
      ),
      GoRoute(
        path: '/auth/devices',
        builder: (context, state) => const DeviceManagementScreen(),
      ),
      GoRoute(
        path: '/account/profile',
        builder: (context, state) => const AccountProfileScreen(),
      ),
      GoRoute(
        path: '/account/settings',
        builder: (context, state) => const AccountSettingsScreen(),
      ),

      // Help & Knowledge Base
      GoRoute(
        path: '/help/faqs',
        builder: (context, state) => const FaqScreen(),
      ),
      GoRoute(
        path: '/faqs',
        builder: (context, state) => const FaqScreen(),
      ),
      GoRoute(
        path: '/help',
        builder: (context, state) => const FaqScreen(),
      ),

      // Resolved Route Aliases
      GoRoute(
        path: '/notices',
        builder: (context, state) => const NoticeBoardScreen(),
      ),
      GoRoute(
        path: '/students/digital-id',
        builder: (context, state) => const DigitalStudentIdCardScreen(),
      ),
      GoRoute(
        path: '/principal/announcements/approval',
        builder: (context, state) => const AnnouncementApprovalScreen(),
      ),
      GoRoute(
        path: '/attendance/student-leave',
        builder: (context, state) => const FacultyLeaveScreen(),
      ),

      // Dashboards Explicit
      GoRoute(
        path: '/dashboard/parent',
        builder: (context, state) => const ParentDashboardScreen(),
      ),
      GoRoute(
        path: '/parent/dashboard',
        builder: (context, state) => const ParentDashboardScreen(),
      ),
      GoRoute(
        path: '/dashboard/student',
        builder: (context, state) => const StudentHubScreen(),
      ),
      GoRoute(
        path: '/student/hub',
        builder: (context, state) => const StudentHubScreen(),
      ),
      GoRoute(
        path: '/dashboard/class-teacher',
        builder: (context, state) => const ClassTeacherDashboardScreen(),
      ),
      GoRoute(
        path: '/teacher/class-dashboard',
        builder: (context, state) => const ClassTeacherDashboardScreen(),
      ),
      GoRoute(
        path: '/dashboard/subject-teacher',
        builder: (context, state) => const SubjectTeacherDashboardScreen(),
      ),
      GoRoute(
        path: '/teacher/subject-dashboard',
        builder: (context, state) => const SubjectTeacherDashboardScreen(),
      ),
      GoRoute(
        path: '/dashboard/subject-teacher/cohorts',
        builder: (context, state) => const SubjectTeacherCohortsScreen(),
      ),
      GoRoute(
        path: '/dashboard/subject-teacher/classes',
        builder: (context, state) => const SubjectTeacherCohortsScreen(),
      ),
      GoRoute(
        path: '/dashboard/principal',
        builder: (context, state) => const PrincipalDashboardScreen(),
      ),
      GoRoute(
        path: '/principal/command',
        builder: (context, state) => const PrincipalDashboardScreen(),
      ),
      GoRoute(
        path: '/principal/dashboard',
        builder: (context, state) => const PrincipalDashboardScreen(),
      ),
      GoRoute(
        path: '/dashboard/accountant',
        builder: (context, state) => const AccountantDashboardScreen(),
      ),
      GoRoute(
        path: '/dashboard/accounts',
        builder: (context, state) => const AccountantDashboardScreen(),
      ),
      GoRoute(
        path: '/accounts/dashboard',
        builder: (context, state) => const AccountantDashboardScreen(),
      ),
      GoRoute(
        path: '/dashboard/librarian',
        builder: (context, state) => const LibrarianDashboardScreen(),
      ),
      GoRoute(
        path: '/dashboard/library',
        builder: (context, state) => const LibrarianDashboardScreen(),
      ),
      GoRoute(
        path: '/library/desk',
        builder: (context, state) => const LibrarianDashboardScreen(),
      ),
      GoRoute(
        path: '/dashboard/modules',
        builder: (context, state) => const SuperAdminModulesScreen(),
      ),
      GoRoute(
        path: '/dashboard/admin',
        builder: (context, state) => const SuperAdminModulesScreen(),
      ),
      GoRoute(
        path: '/admin/modules',
        builder: (context, state) => const SuperAdminModulesScreen(),
      ),
      GoRoute(
        path: '/admissions/enquiries',
        builder: (context, state) => const AdmissionsEnquiryScreen(),
      ),

      // Students
      GoRoute(
        path: '/students/dossier',
        builder: (context, state) {
          final studentId = (state.extra as String?) ?? state.uri.queryParameters['id'] ?? '1';
          return StudentDossierScreen(studentId: studentId);
        },
      ),
      GoRoute(
        path: '/students/report-card',
        builder: (context, state) {
          final studentId = (state.extra as String?) ?? state.uri.queryParameters['id'] ?? '1';
          return AcademicReportCardScreen(studentId: studentId);
        },
      ),
      GoRoute(
        path: '/students/marks-entry',
        builder: (context, state) => const MarksEntryDeskScreen(),
      ),
      GoRoute(
        path: '/students/ledger',
        builder: (context, state) => const AllStudentsLedgerScreen(),
      ),
      GoRoute(
        path: '/students/id-card',
        builder: (context, state) {
          final studentId = (state.extra as String?) ?? state.uri.queryParameters['id'] ?? '1';
          return DigitalStudentIdCardScreen(studentId: studentId);
        },
      ),

      // Attendance
      GoRoute(
        path: '/attendance',
        builder: (context, state) {
          final studentId = state.uri.queryParameters['id'];
          return StudentAttendanceScreen(studentId: studentId);
        },
      ),
      GoRoute(
        path: '/attendance/student',
        builder: (context, state) {
          final studentId = state.uri.queryParameters['id'];
          return StudentAttendanceScreen(studentId: studentId);
        },
      ),
      GoRoute(
        path: '/attendance/student/matrix',
        builder: (context, state) {
          final studentId = state.uri.queryParameters['id'];
          return StudentAttendanceScreen(studentId: studentId);
        },
      ),
      GoRoute(
        path: '/attendance/roll-call',
        builder: (context, state) => const DailyRollCallScreen(),
      ),
      GoRoute(
        path: '/attendance/matrix',
        builder: (context, state) => const AttendanceMatrixScreen(),
      ),
      GoRoute(
        path: '/attendance/faculty-leave',
        builder: (context, state) => const FacultyLeaveScreen(),
      ),

      // Faculty & Timetable
      GoRoute(
        path: '/faculty/allocation',
        builder: (context, state) => const FacultyAllocationScreen(),
      ),
      GoRoute(
        path: '/faculty/section-detail',
        builder: (context, state) {
          final grade = state.uri.queryParameters['grade'];
          final section = state.uri.queryParameters['section'];
          final cls = state.uri.queryParameters['class'];
          return PrincipalSectionDetailScreen(
            initialGrade: grade,
            initialSection: section,
            initialClassName: cls,
          );
        },
      ),
      GoRoute(
        path: '/academics/section-detail',
        builder: (context, state) {
          final grade = state.uri.queryParameters['grade'];
          final section = state.uri.queryParameters['section'];
          final cls = state.uri.queryParameters['class'];
          return PrincipalSectionDetailScreen(
            initialGrade: grade,
            initialSection: section,
            initialClassName: cls,
          );
        },
      ),
      GoRoute(
        path: '/faculty/timetable/class',
        builder: (context, state) {
          final cls = state.uri.queryParameters['class'];
          return ClassTimetableScreen(initialClass: cls);
        },
      ),
      GoRoute(
        path: '/timetable/class',
        builder: (context, state) {
          final cls = state.uri.queryParameters['class'];
          return ClassTimetableScreen(initialClass: cls);
        },
      ),
      GoRoute(
        path: '/faculty/timetable',
        builder: (context, state) {
          final teacher = state.uri.queryParameters['teacher'];
          return TeacherTimetableScreen(teacherName: teacher);
        },
      ),
      GoRoute(
        path: '/faculty/directory',
        builder: (context, state) => const StaffDirectoryScreen(),
      ),
      GoRoute(
        path: '/faculty/teachers',
        builder: (context, state) => const PrincipalTeachersScreen(),
      ),
      GoRoute(
        path: '/teachers',
        builder: (context, state) => const PrincipalTeachersScreen(),
      ),
      GoRoute(
        path: '/principal/teachers',
        builder: (context, state) => const PrincipalTeachersScreen(),
      ),
      GoRoute(
        path: '/more/teachers',
        builder: (context, state) => const PrincipalTeachersScreen(),
      ),
      GoRoute(
        path: '/teacher/class-info',
        builder: (context, state) {
          final cls = state.uri.queryParameters['class'];
          return ClassInfoScreen(classNameOverride: cls);
        },
      ),
      GoRoute(
        path: '/teacher/class-students',
        builder: (context, state) {
          final cls = state.uri.queryParameters['class'];
          return ClassStudentDirectoryScreen(initialClass: cls);
        },
      ),
      GoRoute(
        path: '/teacher/student-directory',
        builder: (context, state) {
          final cls = state.uri.queryParameters['class'];
          return ClassStudentDirectoryScreen(initialClass: cls);
        },
      ),
      GoRoute(
        path: '/teacher/class-subjects',
        builder: (context, state) {
          final cls = state.uri.queryParameters['class'];
          return ClassSubjectsScreen(initialClass: cls);
        },
      ),
      GoRoute(
        path: '/teacher/my-classes',
        builder: (context, state) => const SubjectTeacherClassesScreen(),
      ),
      GoRoute(
        path: '/teacher/teaching-assignments',
        builder: (context, state) => const SubjectTeacherAssignmentsScreen(),
      ),
      GoRoute(
        path: '/teacher/my-subjects',
        builder: (context, state) => const SubjectTeacherAssignmentsScreen(),
      ),

      // Admissions
      GoRoute(
        path: '/admissions/enquiry',
        builder: (context, state) => const AdmissionsEnquiryScreen(),
      ),
      GoRoute(
        path: '/admissions/applications',
        builder: (context, state) => const ApplicationsEnrollmentScreen(),
      ),

      // Fees
      GoRoute(
        path: '/fees/ledger',
        builder: (context, state) {
          final studentId = state.uri.queryParameters['id'];
          return FeeLedgerScreen(studentId: studentId);
        },
      ),
      GoRoute(
        path: '/fees/receipt',
        builder: (context, state) {
          final receiptNo = state.uri.queryParameters['receiptNo'];
          return FeeReceiptScreen(receiptNo: receiptNo);
        },
      ),
      GoRoute(
        path: '/fees/receipt/:id',
        builder: (context, state) {
          final id = state.pathParameters['id'];
          return FeeReceiptScreen(receiptNo: id);
        },
      ),

      // Library, Transport, Inventory
      GoRoute(
        path: '/transit/bus',
        builder: (context, state) {
          final studentId = state.uri.queryParameters['id'];
          return BusTransitScreen(studentId: studentId);
        },
      ),
      GoRoute(
        path: '/inventory/desk',
        builder: (context, state) => const InventoryDeskScreen(),
      ),

      // Calendar & Notices
      GoRoute(
        path: '/calendar/academic',
        builder: (context, state) => const AcademicCalendarScreen(),
      ),
      GoRoute(
        path: '/calendar/events',
        builder: (context, state) => const EventsDeskScreen(),
      ),
      GoRoute(
        path: '/calendar/add-event',
        builder: (context, state) => const AddEventScreen(),
      ),
      GoRoute(
        path: '/announcements',
        builder: (context, state) => const NoticeBoardScreen(),
      ),
      GoRoute(
        path: '/announcements/create',
        builder: (context, state) => const AnnouncementAuthoringScreen(),
      ),
      GoRoute(
        path: '/announcements/approval',
        builder: (context, state) => const AnnouncementApprovalScreen(),
      ),
      GoRoute(
        path: '/notifications',
        builder: (context, state) => const NotificationCenterScreen(),
      ),

      // Admin & Setup
      GoRoute(
        path: '/search/cross-entity',
        builder: (context, state) => const UnifiedSearchScreen(),
      ),
      GoRoute(
        path: '/admin/parents',
        builder: (context, state) => const ParentsDirectoryScreen(),
      ),
      GoRoute(
        path: '/admin/setup',
        builder: (context, state) => const SchoolSetupScreen(),
      ),

      // Route aliases for faculty and teacher desks
      GoRoute(
        path: '/attendance/teacher/roll-call',
        builder: (context, state) => const DailyRollCallScreen(),
      ),
      GoRoute(
        path: '/academics/marks/entry-desk',
        builder: (context, state) => const MarksEntryDeskScreen(),
      ),
      GoRoute(
        path: '/academics/marks-entry',
        builder: (context, state) => const MarksEntryDeskScreen(),
      ),
      GoRoute(
        path: '/teacher/timetable-grid',
        builder: (context, state) {
          final teacher = state.uri.queryParameters['teacher'];
          return TeacherTimetableScreen(teacherName: teacher);
        },
      ),
      GoRoute(
        path: '/teacher/leave-management',
        builder: (context, state) => const FacultyLeaveScreen(),
      ),
      GoRoute(
        path: '/announcements/compose',
        builder: (context, state) => const AnnouncementAuthoringScreen(),
      ),
      GoRoute(
        path: '/teacher/cohorts',
        builder: (context, state) => const SubjectTeacherCohortsScreen(),
      ),
      GoRoute(
        path: '/teacher/classes',
        builder: (context, state) => const SubjectTeacherCohortsScreen(),
      ),

      // Route aliases for student, faculty, staff and admin desks
      GoRoute(
        path: '/principal/calendar/events',
        builder: (context, state) => const EventsDeskScreen(),
      ),
      GoRoute(
        path: '/announcements/approval-queue',
        builder: (context, state) => const AnnouncementApprovalScreen(),
      ),
      GoRoute(
        path: '/announcements/approval',
        builder: (context, state) => const AnnouncementApprovalScreen(),
      ),
      GoRoute(
        path: '/attendance/student/matrix',
        builder: (context, state) => const AttendanceMatrixScreen(),
      ),
      GoRoute(
        path: '/directory/staff',
        builder: (context, state) => const StaffDirectoryScreen(),
      ),
      GoRoute(
        path: '/parents/directory',
        builder: (context, state) => const ParentsDirectoryScreen(),
      ),
      GoRoute(
        path: '/admin/parents',
        builder: (context, state) => const ParentsDirectoryScreen(),
      ),
      GoRoute(
        path: '/students/all-students',
        builder: (context, state) => const AllStudentsLedgerScreen(),
      ),
      GoRoute(
        path: '/transport/route-card',
        builder: (context, state) {
          final studentId = state.uri.queryParameters['id'];
          return BusTransitScreen(studentId: studentId);
        },
      ),
      GoRoute(
        path: '/student/digital-id-sheet',
        builder: (context, state) => const DigitalStudentIdCardScreen(),
      ),
      GoRoute(
        path: '/fees/receipt/:receiptNo',
        builder: (context, state) {
          final receiptNo = state.pathParameters['receiptNo'] ?? state.uri.queryParameters['receiptNo'];
          return FeeReceiptScreen(receiptNo: receiptNo);
        },
      ),
      GoRoute(
        path: '/student/:id/report-card',
        builder: (context, state) {
          final studentId = state.pathParameters['id'] ?? state.uri.queryParameters['id'] ?? 'ADM-2024-0412';
          return AcademicReportCardScreen(studentId: studentId);
        },
      ),
      GoRoute(
        path: '/student/:id/timetable',
        builder: (context, state) {
          return const ClassTimetableScreen(initialClass: 'Class X-A');
        },
      ),
    ],
  );
}
