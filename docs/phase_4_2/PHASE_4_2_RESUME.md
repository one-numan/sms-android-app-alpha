# Phase 4.2 Resume Instructions

## 1. What has already been completed?
- Baseline audit across the entire codebase (`lib/`).
- Initialized persistent tracking architecture in `docs/phase_4_2/`.
- **Batch A (Shared Authentication / Profile / Settings / Login / Briefing) is 100% completed and verified**:
  - `AuthState`: Default persona removed; unauthenticated by default; sign-out purges all state; 401 cleared.
  - `AccountProfileScreen` & `AccountProfileSheet`: All `fallbackProfile` objects purged; dynamically binds to backend `/api/v1/account/profile/`; neutral "Not available" for unpopulated fields.
  - `AccountSettingsScreen` & `AccountSettingsSheet`: MockData session/school replaced with centralized `AppConfig`.
  - `LoginScreen` & `MorningBriefingTransitionScreen`: Replaced MockData with `AppConfig` and live user greeting.
  - Zero production-reachable MockData in Batch A.
  - 217/217 Flutter tests passing; 0 analyzer issues; APK built and verified on Realme RMX5004 over Wireless ADB.

## 2. What files were changed?
- `lib/core/config/app_config.dart` (NEW)
- `lib/data/mock/auth_state.dart`
- `lib/screens/account/account_profile_screen.dart`
- `lib/screens/account/account_settings_screen.dart`
- `lib/widgets/account_profile_sheet.dart`
- `lib/widgets/account_settings_sheet.dart`
- `lib/screens/auth/login_screen.dart`
- `lib/screens/auth/morning_briefing_transition_screen.dart`
- `lib/widgets/app_top_bar.dart`
- `lib/screens/help/faq_screen.dart`
- `test/staff_login_test.dart`
- `test/batch_a_mockdata_elimination_test.dart` (NEW)

## 3. What APIs were used?
- `POST /api/v1/auth/login/`
- `GET /api/v1/account/profile/`
- `POST /api/v1/auth/logout/`

## 4. What remains?
- **Batch B**: Student / Academic (23 production MockData references across 7 files)
- **Batch C**: Finance / Fees (7 production MockData references across 3 files)
- **Batch D**: Admin / Operations (17 production MockData references across 5 files)
- **Batch E**: Calendar / Transport / Inventory (12 production MockData references across 5 files)
- **Final Batch**: Global verification & `docs/phase_4_2/PHASE_4_2_FINAL_REPORT.md`

## 5. What is currently broken?
Nothing. The app compiles cleanly, all 217 tests pass, and zero analyzer issues exist.

## 6. What tests passed?
217/217 tests in `flutter test` passed (including 10 dedicated tests in `test/batch_a_mockdata_elimination_test.dart`).

## 7. What tests failed?
0 tests failed.

## 8. What should NOT be changed?
- The 14 previously migrated screens:
  1. Teacher Timetable
  2. Class Timetable
  3. Faculty Allocation
  4. Staff Directory
  5. Class Info
  6. Class Student Directory
  7. Student Dossier
  8. Digital Student ID Card
  9. Faculty Leave
  10. Announcement Approval
  11. Admissions Enquiry
  12. Applications & Enrollment
  13. Librarian Dashboard
  14. Parents Directory
- Do not create fake APIs or modify backend contracts.
- Do not introduce fake fallback personas.

## 9. What should be done next?
Proceed immediately to **Batch B: Student / Academic**:
Step B.1: `lib/screens/students/all_students_ledger_screen.dart`
- Replace `MockData.students` with live `StudentApiService.getStudents()`.
- Replace `MockData.classes` with live `FacultyApiService.getClassSummary()`.
Step B.2: `lib/screens/students/marks_entry_desk_screen.dart`
- Replace `MockData.students` with section-enrolled student list from API.
Step B.3: `lib/screens/students/academic_report_card_screen.dart`
- Connect to live student report card endpoint and `AppConfig`.
Step B.4: `lib/screens/dashboards/class_teacher_dashboard_screen.dart`
- Eliminate remaining 6 MockData fallback lookups.
Step B.5: `lib/screens/dashboards/subject_teacher_dashboard_screen.dart` & `subject_teacher_cohorts_screen.dart`
- Bind classes to live timetable / allocation API.
Step B.6: `lib/screens/attendance/daily_roll_call_screen.dart`
- Clean up teacher/class fallback lookups.

## 10. What exact command should be run next?
```bash
flutter analyze && flutter test
```
Then begin editing `lib/screens/students/all_students_ledger_screen.dart`.
