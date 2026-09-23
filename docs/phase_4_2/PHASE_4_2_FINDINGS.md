# Phase 4.2 Audit Findings & Baseline

## Baseline Summary

- Total Raw Grep Matches across `lib/`: 88 lines
- MockData Definition Repository (`lib/data/mock/mock_data.dart`): 26 lines
- Test-guarded references (`lib/data/mock/auth_state.dart:68-70`): 3 lines
- **Total Production-Reachable MockData References at Phase 4.2 Start**: **59**

## Breakdown by Batch

### Batch A: Shared Core / Auth / Profile / Settings
- **Target Files**:
  1. `lib/data/mock/auth_state.dart`
  2. `lib/screens/account/account_profile_screen.dart`
  3. `lib/screens/account/account_settings_screen.dart`
  4. `lib/widgets/account_profile_sheet.dart`
  5. `lib/widgets/account_settings_sheet.dart`
  6. `lib/screens/auth/login_screen.dart`
  7. `lib/screens/auth/morning_briefing_transition_screen.dart`
- **Initial Count**: 7
- **Post-Batch A Count**: **0**
- **Status**: **PASSED (0 production-reachable MockData)**

### Batch B: Student / Academic (23 occurrences)
- **Target Files**:
  1. `lib/screens/students/all_students_ledger_screen.dart`
  2. `lib/screens/students/marks_entry_desk_screen.dart`
  3. `lib/screens/students/academic_report_card_screen.dart`
  4. `lib/screens/attendance/daily_roll_call_screen.dart`
  5. `lib/screens/dashboards/class_teacher_dashboard_screen.dart`
  6. `lib/screens/dashboards/subject_teacher_dashboard_screen.dart`
  7. `lib/screens/dashboards/subject_teacher_cohorts_screen.dart`
- **Initial Count**: 23
- **Post-Batch B Count**: **0**
- **Status**: **PASSED (0 production-reachable MockData)**

### Batch C: Finance / Fees (7 occurrences)
1. `lib/router.dart:534` — `MockData.feePayments` route parameter lookup
2. `lib/screens/fees/fee_receipt_screen.dart:21` — `MockData.feePayments` lookup
3. `lib/screens/fees/fee_receipt_screen.dart:50` — `MockData.students.where`
4. `lib/screens/fees/fee_receipt_screen.dart:52` — `MockData.students.first`
5. `lib/screens/fees/fee_receipt_screen.dart:142` — `MockData.schoolName`
6. `lib/screens/fees/fee_receipt_screen.dart:151` — `MockData.campusAddress`
7. `lib/screens/dashboards/accountant_dashboard_screen.dart:231` — `MockData.feePayments.map`

### Batch D: Admin / Operations (17 occurrences)
1. `lib/screens/faculty/principal_teachers_screen.dart:37` — `MockData.teachers`
2. `lib/screens/faculty/principal_teachers_screen.dart:55` — `MockData.classes.where`
3. `lib/screens/faculty/principal_teachers_screen.dart:67` — `MockData.classes`
4. `lib/screens/faculty/principal_section_detail_screen.dart:64` — `MockData.classes`
5. `lib/screens/faculty/principal_section_detail_screen.dart:91` — `MockData.teachers.firstWhere`
6. `lib/screens/faculty/principal_section_detail_screen.dart:124` — `MockData.students.where`
7. `lib/screens/faculty/principal_section_detail_screen.dart:222` — `MockData.timetable.where`
8. `lib/screens/faculty/faculty_allocation_screen.dart:61` — `MockData.classes`
9. `lib/screens/admin/school_setup_screen.dart:56` — `MockData.schoolAbbr`
10. `lib/screens/admin/school_setup_screen.dart:69` — `MockData.schoolName`
11. `lib/screens/admin/school_setup_screen.dart:78` — `MockData.campusAddress`
12. `lib/screens/admin/school_setup_screen.dart:98` — `MockData.session`
13. `lib/screens/admin/unified_search_screen.dart:44` — `MockData.students.where`
14. `lib/screens/admin/unified_search_screen.dart:53` — `MockData.teachers.where`
15. `lib/screens/admin/unified_search_screen.dart:62` — `MockData.classes.where`
16. `lib/screens/admin/unified_search_screen.dart:71` — `MockData.books.where`
17. `lib/screens/admin/unified_search_screen.dart:80` — `MockData.announcements.where`

### Batch E: Calendar / Transport / Inventory (12 occurrences)
1. `lib/screens/library_transport_inventory/inventory_desk_screen.dart:39` — `MockData.inventory`
2. `lib/screens/library_transport_inventory/bus_transit_screen.dart:33` — `MockData.routes`
3. `lib/screens/library_transport_inventory/bus_transit_screen.dart:34` — `MockData.routes.first`
4. `lib/screens/library_transport_inventory/bus_transit_screen.dart:48` — `MockData.students.firstWhere`
5. `lib/screens/library_transport_inventory/bus_transit_screen.dart:50` — `MockData.students.first`
6. `lib/screens/library_transport_inventory/bus_transit_screen.dart:355` — `MockData.routes.length`
7. `lib/screens/library_transport_inventory/bus_transit_screen.dart:376` — `MockData.routes.map`
8. `lib/screens/calendar_announcements/notice_board_screen.dart:53` — `MockData.announcements`
9. `lib/screens/calendar_announcements/notice_board_screen.dart:107` — `MockData.announcements`
10. `lib/screens/calendar_announcements/events_desk_screen.dart:33` — `MockData.events`
11. `lib/screens/calendar_announcements/academic_calendar_screen.dart:28` — `MockData.holidays`
12. `lib/screens/calendar_announcements/academic_calendar_screen.dart:29` — `MockData.events`
