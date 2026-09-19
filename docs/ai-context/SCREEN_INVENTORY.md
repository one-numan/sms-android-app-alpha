# ONPS School ERP — Screen Inventory (`SCREEN_INVENTORY.md`)

> **Total Implemented Screens**: 53 unique Dart screen widgets verified in `lib/screens/` and registered in `lib/router.dart`.

---

## 1. Auth & Session Management Screens (6)
1. **Login Gateway**: `lib/screens/auth/login_screen.dart` | Route: `/login` | Role: All | Status: Implemented
2. **2FA OTP & Device Eviction**: `lib/screens/auth/otp_eviction_screen.dart` | Route: `/auth/otp-eviction` | Role: All | Status: Implemented
3. **Cooldown Lockout**: `lib/screens/auth/cooldown_lockout_screen.dart` | Route: `/auth/cooldown` | Role: All | Status: Implemented
4. **Morning Briefing Sequence**: `lib/screens/auth/morning_briefing_screen.dart` | Route: `/auth/morning-briefing` | Role: Teacher, Principal | Status: Implemented
5. **Password Reset Recovery**: `lib/screens/auth/password_reset_screen.dart` | Route: `/auth/password-reset` | Role: All | Status: Implemented
6. **Multi-Device Session Revocation**: `lib/screens/auth/device_management_screen.dart` | Route: `/account/devices` | Role: All | Status: Implemented

---

## 2. Dashboard Screens (9)
7. **Parent Dashboard**: `lib/screens/dashboards/parent_dashboard_screen.dart` | Route: `/dashboard/parent` | Role: Parent | Status: Implemented
8. **Student Self-Service Hub**: `lib/screens/dashboards/student_hub_screen.dart` | Route: `/dashboard/student` | Role: Student | Status: Implemented
9. **Class Teacher Operations**: `lib/screens/dashboards/class_teacher_dashboard_screen.dart` | Route: `/dashboard/class-teacher` | Role: Class Teacher | Status: Implemented
10. **Subject Teacher Assessment**: `lib/screens/dashboards/subject_teacher_dashboard_screen.dart` | Route: `/dashboard/subject-teacher` | Role: Subject Teacher | Status: Implemented
11. **Subject Teacher Cohorts**: `lib/screens/dashboards/subject_teacher_cohorts_screen.dart` | Route: `/teacher/my-classes` | Role: Subject Teacher | Status: Implemented
12. **Principal Executive Hub**: `lib/screens/dashboards/principal_dashboard_screen.dart` | Route: `/dashboard/principal` | Role: Principal | Status: Implemented
13. **Accounts & Fee Collection**: `lib/screens/dashboards/accounts_dashboard_screen.dart` | Route: `/dashboard/accounts` | Role: Accountant | Status: Implemented
14. **Library Circulation**: `lib/screens/dashboards/librarian_dashboard_screen.dart` | Route: `/dashboard/library` | Role: Librarian | Status: Implemented
15. **Super Admin ERP Directory**: `lib/screens/dashboards/admin_dashboard_screen.dart` | Route: `/dashboard/admin` | Role: Super Admin | Status: Implemented

---

## 3. Student & Academic Management Screens (5)
16. **Student 360 Dossier**: `lib/screens/students/student_dossier_screen.dart` | Route: `/students/dossier` | Role: All | Status: Implemented (7 Tabs)
17. **CBSE 4-Term Report Card**: `lib/screens/students/report_card_screen.dart` | Route: `/students/report-card` | Role: Student, Parent, Teacher, Principal | Status: Implemented
18. **Teacher Assessment Marks Entry Desk**: `lib/screens/academics/marks_entry_screen.dart` | Route: `/academics/marks-entry` | Role: Subject Teacher | Status: Implemented
19. **All Students Directory Ledger**: `lib/screens/students/students_directory_screen.dart` | Route: `/students/directory` | Role: All Staff | Status: Implemented
20. **Digital Student ID Card**: `lib/screens/students/digital_student_id_card_screen.dart` | Route: `/students/id-card` | Role: Student, Parent | Status: Implemented

---

## 4. Attendance, Timetable & Faculty Management Screens (7)
21. **Daily Roll Call Register**: `lib/screens/attendance/roll_call_screen.dart` | Route: `/attendance/roll-call` | Role: Class Teacher | Status: Implemented
22. **Student Monthly Attendance Matrix**: `lib/screens/attendance/student_attendance_screen.dart` | Route: `/attendance/student` | Role: Student, Parent, Teacher | Status: Implemented
23. **Faculty Leave Tracker**: `lib/screens/attendance/faculty_leave_screen.dart` | Route: `/attendance/faculty-leave` | Role: Teacher, Principal | Status: Implemented
24. **Class Timetable Screen**: `lib/screens/faculty/class_timetable_screen.dart` | Route: `/faculty/timetable/class` | Role: Student, Parent, Teacher | Status: Implemented
25. **Faculty Timetable Grid**: `lib/screens/faculty/faculty_timetable_screen.dart` | Route: `/faculty/timetable` | Role: Teacher, Principal | Status: Implemented
26. **Staff Directory**: `lib/screens/faculty/staff_directory_screen.dart` | Route: `/faculty/staff-directory` | Role: Principal, Admin | Status: Implemented
27. **Faculty Allocation Matrix / Principal Academics**: `lib/screens/faculty/faculty_allocation_screen.dart` | Route: `/faculty/allocation` | Role: Principal | Status: Implemented

---

## 5. Admissions, Fees & Operations Screens (7)
28. **Admissions Enquiry Desk**: `lib/screens/admissions/admissions_enquiry_screen.dart` | Route: `/admissions/enquiries` | Role: Admin, Principal | Status: Implemented
29. **Principal Admissions & Enrollment**: `lib/screens/admissions/applications_enrollment_screen.dart` | Route: `/admissions/enrollment` | Route: Principal | Status: Implemented
30. **Fee Ledger & Dues Summary**: `lib/screens/fees/fee_ledger_screen.dart` | Route: `/fees/ledger` | Role: Student, Parent, Accountant | Status: Implemented
31. **Official Fee Receipt Voucher**: `lib/screens/fees/fee_receipt_screen.dart` | Route: `/fees/receipt` | Role: Student, Parent, Accountant | Status: Implemented
32. **Bus Transit & Stop Timeline**: `lib/screens/transit/bus_transit_screen.dart` | Route: `/transit/bus` | Role: Student, Parent, Transport Officer | Status: Implemented
33. **Inventory Supplies & Low Stock Desk**: `lib/screens/inventory/inventory_desk_screen.dart` | Route: `/inventory/desk` | Role: Admin, Principal | Status: Implemented
34. **FAQ Knowledge Base**: `lib/screens/help/faq_screen.dart` | Route: `/help/faqs` | Role: All | Status: Implemented

---

## 6. Calendar, Notices & Principal Desks Screens (9)
35. **Gazetted Holidays Calendar**: `lib/screens/calendar/gazetted_holidays_screen.dart` | Route: `/calendar/holidays` | Role: All | Status: Implemented
36. **Institutional Events Desk**: `lib/screens/calendar/events_screen.dart` | Route: `/calendar/events` | Role: All | Status: Implemented
37. **Schedule Event Form**: `lib/screens/calendar/schedule_event_form_screen.dart` | Route: `/calendar/events/create` | Role: Admin, Principal | Status: Implemented
38. **Moderated Notice Board**: `lib/screens/announcements/notice_board_screen.dart` | Route: `/announcements` | Role: All | Status: Implemented
39. **Compose Circular Form**: `lib/screens/announcements/compose_circular_screen.dart` | Route: `/announcements/compose` | Role: Teacher, Principal | Status: Implemented
40. **Principal Moderation Queue**: `lib/screens/announcements/principal_moderation_screen.dart` | Route: `/principal/moderation` | Role: Principal | Status: Implemented
41. **Push Notification Center**: `lib/screens/notifications/notification_center_screen.dart` | Route: `/notifications` | Role: All | Status: Implemented
42. **Principal Section Detail**: `lib/screens/faculty/principal_section_detail_screen.dart` | Route: `/faculty/section-detail` | Role: Principal | Status: Implemented
43. **Principal Teachers Management**: `lib/screens/faculty/principal_teachers_screen.dart` | Route: `/principal/teachers` | Role: Principal | Status: Implemented

---

## 7. Secondary / Helper / More Desks Screens (10)
44. **Student More Hub**: `lib/screens/more/student_more_screen.dart` | Route: `/more/student` | Role: Student | Status: Implemented
45. **Parent More Hub**: `lib/screens/more/parent_more_screen.dart` | Route: `/more/parent` | Role: Parent | Status: Implemented
46. **Class Teacher More Hub**: `lib/screens/more/class_teacher_more_screen.dart` | Route: `/more/class-teacher` | Role: Class Teacher | Status: Implemented
47. **Subject Teacher More Hub**: `lib/screens/more/subject_teacher_more_screen.dart` | Route: `/more/subject-teacher` | Role: Subject Teacher | Status: Implemented
48. **Principal More Hub**: `lib/screens/more/principal_more_screen.dart` | Route: `/more/principal` | Role: Principal | Status: Implemented
49. **Parents Directory**: `lib/screens/directory/parents_directory_screen.dart` | Route: `/directory/parents` | Role: Staff | Status: Implemented
50. **Institutional Setup**: `lib/screens/admin/school_setup_screen.dart` | Route: `/admin/school-setup` | Role: Super Admin | Status: Implemented
51. **Cross-Entity Search**: `lib/screens/search/global_search_screen.dart` | Route: `/search` | Role: Staff | Status: Implemented
52. **Academic Calendar**: `lib/screens/calendar/academic_calendar_screen.dart` | Route: `/calendar/academic` | Role: All | Status: Implemented
53. **App Settings**: `lib/screens/settings/app_settings_screen.dart` | Route: `/account/settings` | Role: All | Status: Implemented
