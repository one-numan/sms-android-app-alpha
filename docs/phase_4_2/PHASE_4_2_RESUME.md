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
- **Batch B (Student / Academic) is 100% completed and verified**:
  1. `AllStudentsLedgerScreen`: Binds to `StudentApiService.getStudents()`, live search, grade/section filtering, error handling, 0 MockData.
  2. `MarksEntryDeskScreen`: Binds to `StudentApiService.getStudents(classId: '1')`, dynamic score controllers, 0 MockData.
  3. `AcademicReportCardScreen`: Purged 8 MockData references; binds to `StudentApiService.getReportCard()`, dynamic session, empty states, 0 MockData.
  4. `DailyRollCallScreen`: Teacher identity and class assignment resolved from authenticated `AuthState.userProfile`, 0 MockData.
  5. `ClassTeacherDashboardScreen`: Student count, attendance calculations, announcements bound to live API / dashboard summary, 0 MockData.
  6. `SubjectTeacherDashboardScreen`: Dynamic class allocations, 0 MockData.
  7. `SubjectTeacherCohortsScreen`: Dynamic class cohorts roster, 0 MockData.
  - Zero production-reachable MockData in Batch B.
  - Quality gates: `flutter analyze` (0 issues), `flutter test` (217/217 passed), `flutter build apk --debug` (success).

## 2. What files were changed in Batch B?
- `lib/models/models.dart`: Added `Student.fromJson` factory for DRF `/students/directory/` and `/classes/<id>/students/` JSON schemas.
- `lib/data/services/student_api_service.dart`: Enhanced `getStudents()` and `getReportCard()` to query live Django endpoints.
- `lib/screens/students/all_students_ledger_screen.dart`
- `lib/screens/students/marks_entry_desk_screen.dart`
- `lib/screens/students/academic_report_card_screen.dart`
- `lib/screens/attendance/daily_roll_call_screen.dart`
- `lib/screens/dashboards/class_teacher_dashboard_screen.dart`
- `lib/screens/dashboards/subject_teacher_dashboard_screen.dart`
- `lib/screens/dashboards/subject_teacher_cohorts_screen.dart`

## 3. What APIs were used in Batch B?
- `GET /api/v1/students/directory/` (10,000 active students, verified 200 OK)
- `GET /api/v1/classes/<id>/students/` (roster by class, verified 200 OK)
- `GET /api/v1/academics/report-card/?student_id=<id>` (report card by student, verified 200 OK)
- `GET /api/v1/classes/<id>/summary/` (class statistics, verified 200 OK)

## 4. What remains?
- **Batch C**: Finance / Fees (7 production MockData references across 3 files)
  - `lib/router.dart:534` — `MockData.feePayments` route lookup
  - `lib/screens/fees/fee_receipt_screen.dart:21, 50, 52, 142, 151`
  - `lib/screens/dashboards/accountant_dashboard_screen.dart:231`
- **Batch D**: Admin / Operations (17 production MockData references across 5 files)
- **Batch E**: Calendar / Transport / Inventory (12 production MockData references across 5 files)
- **Final Batch**: Global verification & `docs/phase_4_2/PHASE_4_2_FINAL_REPORT.md`

## 5. What is currently broken?
Nothing. The app compiles cleanly, all 217 tests pass, and zero analyzer issues exist.

## 6. What tests passed?
217/217 tests in `flutter test` passed (including `test/principal_students_screen_test.dart`, `test/daily_roll_call_test.dart`, `test/student_academics_test.dart`, `test/class_teacher_home_test.dart`, `test/subject_teacher_test.dart`, `test/parent_experience_test.dart`).

## 7. What tests failed?
0 tests failed.

## 8. What should NOT be changed?
- Batch A files (Auth, Profile, Settings, Login, Briefing)
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
- The 7 Batch B screens now completed.

## 9. Exact command to continue
When starting Batch C:
```bash
# Verify baseline before touching code
flutter analyze
flutter test
```

## 10. Rules to remember
- Target production-reachable MockData = 0.
- Never replace MockData with another hardcoded object.
- Keep test-only fixtures strictly inside test environments.
- Verify analyzer and test suite before checkpointing.
