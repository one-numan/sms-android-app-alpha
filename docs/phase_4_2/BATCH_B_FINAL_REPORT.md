# Phase 4.2 — Batch B Final Report
## Student / Academic MockData Elimination

**Date:** 2026-09-23  
**Status:** COMPLETE & VERIFIED  
**Target:** Batch B — Student / Academic  
**Production-Reachable Batch B MockData:** **0 (TARGET ACHIEVED)**  

---

### 1. Baseline Count
- **Initial Global Production MockData (Start of Phase 4.2)**: 59
- **Batch B Initial Count**: 23 occurrences across 7 target files:
  1. `lib/screens/students/all_students_ledger_screen.dart` (2 occurrences: lines 70, 314)
  2. `lib/screens/students/marks_entry_desk_screen.dart` (3 occurrences: lines 38, 165, 167)
  3. `lib/screens/students/academic_report_card_screen.dart` (8 occurrences: lines 41, 43, 47, 52, 74, 80, 268, 1225)
  4. `lib/screens/attendance/daily_roll_call_screen.dart` (2 occurrences: lines 826, 845)
  5. `lib/screens/dashboards/class_teacher_dashboard_screen.dart` (6 occurrences: lines 153, 184, 378, 484, 1104, 1146)
  6. `lib/screens/dashboards/subject_teacher_dashboard_screen.dart` (1 occurrence: line 214)
  7. `lib/screens/dashboards/subject_teacher_cohorts_screen.dart` (1 occurrence: line 118)

---

### 2. Final Batch B Count
- **Batch B Production-Reachable MockData**: **0**
- **Batch B Files with `MockData`**: **0**
- **Batch B Files importing `mock_data.dart`**: **0**

---

### 3. Files Changed
1. `lib/models/models.dart`: Added versatile `factory Student.fromJson(Map<String, dynamic> json)` supporting `/students/directory/` (10k directory) and `/classes/<id>/students/` JSON schemas.
2. `lib/data/services/student_api_service.dart`: Enhanced `getStudents()` to fetch from `/classes/$classId/students/` and `/students/directory/`, and normalized `getReportCard()`.
3. `lib/screens/students/all_students_ledger_screen.dart`: Removed `MockData.classes` and `MockData.students`; integrated `StudentApiService.getStudents()`, live search, pagination/filter, loading, empty, and retry states.
4. `lib/screens/students/marks_entry_desk_screen.dart`: Removed `MockData.students`; connected to `StudentApiService().getStudents(classId: '1')`; dynamic score controllers and retryable error state.
5. `lib/screens/students/academic_report_card_screen.dart`: Removed 8 MockData references; integrated `StudentApiService().getReportCard()`; dynamic academic session; empty states for marks, timetable, and exams.
6. `lib/screens/attendance/daily_roll_call_screen.dart`: Removed `MockData.teachers` and `MockData.classes` fallback lookups; bound to authenticated `AuthState.userProfile`.
7. `lib/screens/dashboards/class_teacher_dashboard_screen.dart`: Removed 6 MockData occurrences; dynamic student totals and gender breakdown from backend class summary; live announcements with clean empty state.
8. `lib/screens/dashboards/subject_teacher_dashboard_screen.dart`: Removed `MockData.classes`; bound to domain-typed class allocations.
9. `lib/screens/dashboards/subject_teacher_cohorts_screen.dart`: Removed `MockData.classes`; bound to domain-typed teaching cohorts.

---

### 4. APIs Used
- `GET /api/v1/students/directory/`: Active directory of 10,000 real enrolled students in Django database. (200 OK)
- `GET /api/v1/classes/<id>/students/`: Class roster query returning active students enrolled in class. (200 OK)
- `GET /api/v1/classes/<id>/summary/`: Class summary returning boys/girls count and enrollment metrics. (200 OK)
- `GET /api/v1/academics/report-card/?student_id=<id>`: Student scholastic performance and exam results. (200 OK)
- `GET /api/v1/faculty/allocations/`: Teacher allocations and class assignments. (200 OK)

---

### 5. API → UI Lineage
```
PostgreSQL / SQLite Database
    ↓
Django REST Framework Endpoints (/api/v1/...)
    ↓
Flutter ApiClient (JWT Bearer Auth Header)
    ↓
Flutter Service Layer (StudentApiService, FacultyApiService, AttendanceApiService)
    ↓
Domain Data Models (Student, SchoolClass, StudentMarks, Teacher)
    ↓
State Management (AuthState / Screen State)
    ↓
UI Screens (All Students Ledger, Marks Entry Desk, Report Card, Roll Call, Dashboards)
```

---

### 6. Authentication Verification
- All academic APIs strictly enforce JWT authentication. Unauthenticated requests receive HTTP 401.
- `AuthState` maintains real JWT tokens in secure token storage.
- Session sign-out clears token, user profile, role, and cached roster.

---

### 7. Authorization Verification
- Role-based data isolation:
  - Class Teacher operates only on assigned class.
  - Subject Teacher accesses only allocated cohorts and subject assessments.
  - Students and Parents only receive their permitted report card data.
  - Report card endpoint rejects unauthorized cross-student queries.

---

### 8. Empty-State Verification
- **All Students Ledger**: Renders `No students found.` with clear search button when search matches 0 records.
- **Marks Entry Desk**: Renders `No students enrolled in this class.` when roster is empty.
- **Academic Report Card**: Renders `No examination marks recorded for this session.`, `No classes scheduled for today.`, and `No upcoming examinations scheduled.` when records are absent.
- **Class Teacher Dashboard**: Renders `No new announcements for this class.` and clean unassigned state for new faculty without a class.
- **Daily Roll Call**: Displays clean non-working day banner on holidays and unassigned notice for teachers without a class.

---

### 9. Error-State Verification
- Network timeout or server error triggers dedicated error UI with `Retry` action across all screens.
- Zero fallback to demo personas under network failure or 500 error conditions.

---

### 10. Physical Device Verification
- **Target Device**: Realme RMX5004 (`realme P1 Speed 5G`)
- **Android Version**: Android 16 / SDK 36
- **Test Credentials Verified**:
  - `principal.numan` (ID #256, Mohd Numan)
  - Faculty credentials (`washisundar` / Washington Sundar)
- **Active Endpoints Verified**:
  - `/api/v1/students/directory/` (10,000 students verified)
  - `/api/v1/classes/1/students/` (40 students roster verified)
  - `/api/v1/classes/1/summary/` (Class Nursery A, 19 boys, 21 girls verified)
  - `/api/v1/academics/report-card/?student_id=14` (Kinza Rehman verified)

---

### 11. Test Results
- **Command**: `flutter test`
- **Result**: `All tests passed! (00:38 +217)`
- **Total Tests**: 217
- **Passed**: 217
- **Failed**: 0
- **Pass Rate**: **100.0%**

---

### 12. Build Result
- **Command**: `flutter build apk --debug`
- **Output**: `build/app/outputs/flutter-apk/app-debug.apk` (85.2 MB)
- **Gradle Task Execution**: 20.4s
- **Status**: **SUCCESS**

---

### 13. Remaining MockData Outside Batch B
- **Batch C (Finance / Fees)**: 7 references across `router.dart`, `fee_receipt_screen.dart`, `accountant_dashboard_screen.dart`
- **Batch D (Admin / Operations)**: 17 references
- **Batch E (Calendar / Transport / Inventory)**: 12 references
- **Total Remaining Global Production MockData**: **36** (down from 59)

---

### 14. Backend Gaps
- `/academics/report-card/` accepts integer database PKs (e.g. `14`), whereas admission numbers are strings (e.g. `ADM-2024-0014`). Client-side service layer handles normalization seamlessly.

---

### 15. Known Limitations
- Wireless ADB direct connection is paused while device mobile hotspot is active. Hotspot uses gateway subnet `10.82.189.201`.

---

### 16. Final Status
**BATCH B IS 100% COMPLETE.**  
All 7 target screens are completely free of production MockData, analyzer clean, fully tested, and verified.
