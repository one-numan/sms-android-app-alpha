# Phase 4.2 — Batch B Baseline Audit
**Target Area**: Student & Academic Infrastructure  
**Baseline Date**: 2026-09-23  

## 1. Executive Summary

- **Total Global Raw Grep Matches in `lib/`**: 88
- **Global MockData Definition Class (`lib/data/mock/mock_data.dart`)**: 26
- **Test-Guarded References (`auth_state.dart:68-70`)**: 3
- **Batch A Production-Reachable MockData**: **0** (Eliminated & Verified)
- **Batch B Production-Reachable MockData (Starting Count)**: **23**
- **Batch C Production-Reachable MockData**: 7
- **Batch D Production-Reachable MockData**: 17
- **Batch E Production-Reachable MockData**: 12
- **Total Production-Reachable MockData Remaining**: **59**

---

## 2. Batch B Target Files & Exact Occurrences

### File 1: `lib/screens/students/all_students_ledger_screen.dart` (2 occurrences)
- **Line 70**: `final matchingClasses = MockData.classes.where((c) => c.grade == grade).toList();`
  - Classification: **Production Reachable**
  - Lineage to replace: Live classes from `FacultyApiService.getClassSummary()` or section list.
- **Line 314**: `List<Student> list = List.from(MockData.students);`
  - Classification: **Production Reachable**
  - Lineage to replace: `StudentApiService.getStudents(page: page, search: search, grade: grade)`.

### File 2: `lib/screens/students/marks_entry_desk_screen.dart` (3 occurrences)
- **Line 38**: `for (final s in MockData.students) { ... }`
  - Classification: **Production Reachable**
  - Lineage to replace: Enrolled students from `FacultyApiService.getClassStudents(classId)`.
- **Line 165**: `itemCount: MockData.students.length,`
  - Classification: **Production Reachable**
  - Lineage to replace: Enrolled students list count.
- **Line 167**: `final student = MockData.students[index];`
  - Classification: **Production Reachable**
  - Lineage to replace: Student record from enrolled students list.

### File 3: `lib/screens/students/academic_report_card_screen.dart` (8 occurrences)
- **Line 41**: `: MockData.students.firstWhere(`
  - Classification: **Production Reachable**
  - Lineage to replace: Student details from `StudentApiService.getStudentDossier(id)` or live dossier.
- **Line 43**: `orElse: () => MockData.students.first,`
  - Classification: **Production Reachable** (Hardcoded fallback persona!)
  - Lineage to replace: Empty state / error display when student not found.
- **Line 47**: `final marksList = MockData.studentMarks.where(...)`
  - Classification: **Production Reachable**
  - Lineage to replace: Live report card endpoint `GET /api/v1/students/<id>/report-card/` via `StudentApiService`.
- **Line 52**: `final attendanceRecords = MockData.attendanceRecords.where(...)`
  - Classification: **Production Reachable**
  - Lineage to replace: Live attendance analytics from `AttendanceApiService`.
- **Line 74**: `final daySlots = MockData.timetable.where(...)`
  - Classification: **Production Reachable**
  - Lineage to replace: Live timetable from `FacultyApiService.getClassTimetable(...)`.
- **Line 80**: `final examEvents = MockData.events.where(...)`
  - Classification: **Production Reachable**
  - Lineage to replace: Live school events from announcement / events desk API.
- **Line 268**: `'Class $gradeName • ${MockData.session} • Roll #${student.rollNumber}',`
  - Classification: **Production Reachable**
  - Lineage to replace: `AppConfig.academicSession`.
- **Line 1225**: `MockData.session,`
  - Classification: **Production Reachable**
  - Lineage to replace: `AppConfig.academicSession`.

### File 4: `lib/screens/dashboards/class_teacher_dashboard_screen.dart` (6 occurrences)
- **Line 153**: `MockData.teachers.where((t) => t.name.toLowerCase() == resolvedName.toLowerCase() ...).firstOrNull ??`
  - Classification: **Production Reachable**
  - Lineage to replace: Live authenticated user profile / `AuthState.userProfile`.
- **Line 184**: `: MockData.classes.cast<SchoolClass?>().firstWhere(...)`
  - Classification: **Production Reachable**
  - Lineage to replace: Assigned class from teacher allocations or `FacultyApiService.getClassSummary()`.
- **Line 378**: `final classStudents = MockData.students;`
  - Classification: **Production Reachable**
  - Lineage to replace: `FacultyApiService.getClassStudents(assignedClassId)`.
- **Line 484**: `final int totalCount = MockData.students.length;`
  - Classification: **Production Reachable**
  - Lineage to replace: Real class students count.
- **Line 1104**: `'${MockData.students.firstOrNull?.fullName ?? "Student"} (Roll No. 14)',`
  - Classification: **Production Reachable**
  - Lineage to replace: Real student from enrolled list or "Student".
- **Line 1146**: `final notice = _liveAnnouncements.isNotEmpty ? _liveAnnouncements.first : MockData.announcements.first;`
  - Classification: **Production Reachable**
  - Lineage to replace: Live announcements or neutral "No active circulars".

### File 5: `lib/screens/dashboards/subject_teacher_cohorts_screen.dart` (1 occurrence)
- **Line 118**: `...MockData.classes.map((cls) {`
  - Classification: **Production Reachable**
  - Lineage to replace: Classes mapped from live allocations (`FacultyApiService.getFacultyAllocations()`).

### File 6: `lib/screens/dashboards/subject_teacher_dashboard_screen.dart` (1 occurrence)
- **Line 214**: `...MockData.classes.take(2).map((cls) {`
  - Classification: **Production Reachable**
  - Lineage to replace: Classes mapped from live allocations.

### File 7: `lib/screens/attendance/daily_roll_call_screen.dart` (2 occurrences)
- **Line 826**: `MockData.teachers.where((t) => ...).firstOrNull ??`
  - Classification: **Production Reachable**
  - Lineage to replace: Authenticated user name/profile from `AuthState`.
- **Line 845**: `MockData.classes.cast<SchoolClass?>().firstWhere(...)`
  - Classification: **Production Reachable**
  - Lineage to replace: Teacher's designated class or empty/selected class.

---

## 3. Batch B Elimination Strategy

1. **Target 1: All Students Ledger** (`lib/screens/students/all_students_ledger_screen.dart`):
   - Replace static `MockData.students` with live `StudentApiService().getStudents(page: 1, search: query, grade: grade)`.
   - Replace `MockData.classes` with unique classes derived from live student/class API responses.
2. **Target 2: Marks Entry Desk** (`lib/screens/students/marks_entry_desk_screen.dart`):
   - Replace `MockData.students` with live students for selected section via `FacultyApiService().getClassStudents(classId)`.
3. **Target 3: Academic Report Card** (`lib/screens/students/academic_report_card_screen.dart`):
   - Fetch live student dossier via `StudentApiService().getStudentDossier(studentId)`.
   - Fetch live marks/grade data or report card data via `StudentApiService().getStudentReportCard(studentId)` / `ApiServices.student.getStudentDossier(...)`.
   - Replace `MockData.session` with `AppConfig.academicSession`.
   - Remove fake persona `MockData.students.first` fallback.
4. **Target 4: Class Teacher Dashboard** (`lib/screens/dashboards/class_teacher_dashboard_screen.dart`):
   - Load teacher's assigned class from live `FacultyApiService.getClassSummary()` / live class student list.
   - Remove fallback to `MockData.students`, `MockData.classes`, `MockData.teachers`, and `MockData.announcements`.
5. **Target 5: Subject Teacher Cohorts & Dashboard** (`lib/screens/dashboards/subject_teacher_cohorts_screen.dart` & `subject_teacher_dashboard_screen.dart`):
   - Fetch cohorts from `FacultyApiService.getFacultyAllocations()` or timetable.
6. **Target 6: Daily Roll Call** (`lib/screens/attendance/daily_roll_call_screen.dart`):
   - Bind teacher to authenticated user state, remove `MockData.teachers` and `MockData.classes` fallbacks.
