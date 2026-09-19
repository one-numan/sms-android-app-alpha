# ONPS School ERP — Canonical Route Map (`ROUTE_MAP.md`)

> **Router Specification**: Maintained in `lib/router.dart`. Route audit reveals 53 active canonical routes, 5 explicit route aliases, 4 missing/exception routes, and 2 misdirection dead ends.

---

## 1. Canonical Routes Table

| Route Path | Destination Screen Widget | Source File | Target Persona | Status |
| :--- | :--- | :--- | :--- | :--- |
| `/login` | `LoginScreen` | `lib/screens/auth/login_screen.dart` | All | **Canonical** |
| `/auth/otp-eviction` | `OtpEvictionScreen` | `lib/screens/auth/otp_eviction_screen.dart` | All | **Canonical** |
| `/auth/cooldown` | `CooldownLockoutScreen` | `lib/screens/auth/cooldown_lockout_screen.dart` | All | **Canonical** |
| `/auth/morning-briefing` | `MorningBriefingScreen` | `lib/screens/auth/morning_briefing_screen.dart` | Faculty | **Canonical** |
| `/auth/password-reset` | `PasswordResetScreen` | `lib/screens/auth/password_reset_screen.dart` | All | **Canonical** |
| `/dashboard/parent` | `ParentDashboardScreen` | `lib/screens/dashboards/parent_dashboard_screen.dart` | Parent | **Canonical** |
| `/dashboard/student` | `StudentHubScreen` | `lib/screens/dashboards/student_hub_screen.dart` | Student | **Canonical** |
| `/dashboard/class-teacher` | `ClassTeacherDashboardScreen` | `lib/screens/dashboards/class_teacher_dashboard_screen.dart` | Class Teacher | **Canonical** |
| `/dashboard/subject-teacher`| `SubjectTeacherDashboardScreen`| `lib/screens/dashboards/subject_teacher_dashboard_screen.dart`| Subject Teacher | **Canonical** |
| `/dashboard/principal` | `PrincipalDashboardScreen` | `lib/screens/dashboards/principal_dashboard_screen.dart` | Principal | **Canonical** |
| `/dashboard/accounts` | `AccountsDashboardScreen` | `lib/screens/dashboards/accounts_dashboard_screen.dart` | Accountant | **Canonical** |
| `/dashboard/library` | `LibrarianDashboardScreen` | `lib/screens/dashboards/librarian_dashboard_screen.dart` | Librarian | **Canonical** |
| `/dashboard/admin` | `AdminDashboardScreen` | `lib/screens/dashboards/admin_dashboard_screen.dart` | Super Admin | **Canonical** |
| `/students/dossier` | `StudentDossierScreen` | `lib/screens/students/student_dossier_screen.dart` | All | **Canonical** |
| `/students/report-card` | `ReportCardScreen` | `lib/screens/students/report_card_screen.dart` | Student/Parent | **Canonical** |
| `/academics/marks-entry` | `MarksEntryScreen` | `lib/screens/academics/marks_entry_screen.dart` | Teacher | **Canonical** |
| `/students/directory` | `StudentsDirectoryScreen` | `lib/screens/students/students_directory_screen.dart` | Staff | **Canonical** |
| `/students/id-card` | `DigitalStudentIdCardScreen` | `lib/screens/students/digital_student_id_card_screen.dart` | Student/Parent | **Canonical** |
| `/attendance/roll-call` | `RollCallScreen` | `lib/screens/attendance/roll_call_screen.dart` | Class Teacher | **Canonical** |
| `/attendance/student` | `StudentAttendanceScreen` | `lib/screens/attendance/student_attendance_screen.dart` | Student/Parent | **Canonical** |
| `/attendance/faculty-leave`| `FacultyLeaveScreen` | `lib/screens/attendance/faculty_leave_screen.dart` | Teacher/Principal | **Canonical** |
| `/faculty/timetable/class` | `ClassTimetableScreen` | `lib/screens/faculty/class_timetable_screen.dart` | All | **Canonical** |
| `/faculty/timetable` | `FacultyTimetableScreen` | `lib/screens/faculty/faculty_timetable_screen.dart` | Faculty | **Canonical** |
| `/faculty/staff-directory` | `StaffDirectoryScreen` | `lib/screens/faculty/staff_directory_screen.dart` | Principal/Admin | **Canonical** |
| `/faculty/allocation` | `FacultyAllocationScreen` | `lib/screens/faculty/faculty_allocation_screen.dart` | Principal | **Canonical** |
| `/faculty/section-detail` | `PrincipalSectionDetailScreen` | `lib/screens/faculty/principal_section_detail_screen.dart` | Principal | **Canonical** |
| `/principal/teachers` | `PrincipalTeachersScreen` | `lib/screens/faculty/principal_teachers_screen.dart` | Principal | **Canonical** |
| `/admissions/enquiries` | `AdmissionsEnquiryScreen` | `lib/screens/admissions/admissions_enquiry_screen.dart` | Staff | **Canonical** |
| `/admissions/enrollment` | `ApplicationsEnrollmentScreen` | `lib/screens/admissions/applications_enrollment_screen.dart` | Principal | **Canonical** |
| `/fees/ledger` | `FeeLedgerScreen` | `lib/screens/fees/fee_ledger_screen.dart` | Student/Parent/Acct| **Canonical** |
| `/fees/receipt` | `FeeReceiptScreen` | `lib/screens/fees/fee_receipt_screen.dart` | Student/Parent/Acct| **Canonical** |
| `/transit/bus` | `BusTransitScreen` | `lib/screens/transit/bus_transit_screen.dart` | Student/Parent | **Canonical** |
| `/inventory/desk` | `InventoryDeskScreen` | `lib/screens/inventory/inventory_desk_screen.dart` | Admin/Principal | **Canonical** |
| `/help/faqs` | `FaqScreen` | `lib/screens/help/faq_screen.dart` | All | **Canonical** |
| `/announcements` | `NoticeBoardScreen` | `lib/screens/announcements/notice_board_screen.dart` | All | **Canonical** |
| `/announcements/compose` | `ComposeCircularScreen` | `lib/screens/announcements/compose_circular_screen.dart` | Staff | **Canonical** |
| `/principal/moderation` | `PrincipalModerationScreen` | `lib/screens/announcements/principal_moderation_screen.dart` | Principal | **Canonical** |
| `/notifications` | `NotificationCenterScreen` | `lib/screens/notifications/notification_center_screen.dart` | All | **Canonical** |

---

## 2. Active Route Aliases (DO NOT REMOVE)
- `/faqs` $\rightarrow$ `/help/faqs` (Used in legacy bottom sheets)
- `/help` $\rightarrow$ `/help/faqs` (Alias for help desk)
- `/dossier` $\rightarrow$ `/students/dossier` (Alias for student profile file)
- `/report-card` $\rightarrow$ `/students/report-card` (Alias for report card)
- `/fee-ledger` $\rightarrow$ `/fees/ledger` (Alias for fee ledger)

---

## 3. Route Audit: Missing Routes & Exceptions (GO EXCEPTIONS)

| Referenced Route | Source UI Element | Problem Description | Recommended Resolution |
| :--- | :--- | :--- | :--- |
| `/notices` | `ParentDashboardScreen` action chip | Target route absent in `router.dart`. Throws GoRouter exception. | Register alias `/notices` $\rightarrow$ `/announcements` in `router.dart`. |
| `/students/digital-id` | `StudentHubScreen` card link | Target route absent in `router.dart`. | Register alias `/students/digital-id` $\rightarrow$ `/students/id-card`. |
| `/attendance/student-leave`| `ParentDashboardScreen` leave button| Target route absent in `router.dart`. | Register route or alias to leave application sheet/screen. |
| `/principal/announcements/approval`| `PrincipalDashboardScreen` card | Target route absent in `router.dart`. | Register alias `/principal/announcements/approval` $\rightarrow$ `/principal/moderation`. |

---

## 4. Route Audit: Dead Ends & Misdirections

| Source Route | Trigger Element | Destination Route | Issue Description | Correct Expected Behavior |
| :--- | :--- | :--- | :--- | :--- |
| `/fees/ledger` | `Pay Fee Now` button | `/fees/ledger` | Self-loop back to the same ledger screen. | Open receipt voucher or simulated clearance modal sheet. |
| `/dashboard/student` | `Library Desk` item | `/dashboard/library` | Routes student to Librarian Circulation Desk. | Route to Student Library Book Search modal or screen. |
