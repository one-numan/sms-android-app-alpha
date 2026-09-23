# Phase 4.2 — Batch D Baseline Audit
Date: 2026-09-23
Domain: Admin / Operations MockData Elimination

## 1. Summary of Scan Results
- **Command Executed**: `grep -rn "MockData\." lib/`
- **Total Occurrences in Entire Codebase (`lib/`)**: 57 references
  - `lib/data/mock/mock_data.dart` (Internal `MockApiService` implementation): 25 references
  - `lib/data/mock/auth_state.dart` (Test runner bypass `if (isTest)`): 3 references
  - Batch E (Calendar / Transport / Inventory): 12 references
  - **Batch D (Admin / Operations)**: **17 references**

## 2. Batch D Production-Reachable Breakdown

| # | File | Line | Symbol | Role / Context | Classification |
|---|---|---|---|---|---|
| 1 | `lib/screens/faculty/principal_teachers_screen.dart` | 37 | `MockData.teachers` | Initial faculty roster list | Production Reachable |
| 2 | `lib/screens/faculty/principal_teachers_screen.dart` | 55 | `MockData.classes.where` | Class allocation lookup for teachers | Production Reachable |
| 3 | `lib/screens/faculty/principal_teachers_screen.dart` | 67 | `MockData.classes` | Section and grade filter generation | Production Reachable |
| 4 | `lib/screens/faculty/principal_section_detail_screen.dart` | 64 | `MockData.classes` | Section details & student count resolution | Production Reachable |
| 5 | `lib/screens/faculty/principal_section_detail_screen.dart` | 91 | `MockData.teachers.firstWhere` | Class teacher resolution | Production Reachable |
| 6 | `lib/screens/faculty/principal_section_detail_screen.dart` | 124 | `MockData.students.where` | Enrolled student roster resolution | Production Reachable |
| 7 | `lib/screens/faculty/principal_section_detail_screen.dart` | 222 | `MockData.timetable.where` | Section weekly timetable resolution | Production Reachable |
| 8 | `lib/screens/faculty/faculty_allocation_screen.dart` | 61 | `MockData.classes` | Available classes for allocation matrix | Production Reachable |
| 9 | `lib/screens/admin/school_setup_screen.dart` | 56 | `MockData.schoolAbbr` | Institutional header school abbreviation | Production Reachable |
| 10 | `lib/screens/admin/school_setup_screen.dart` | 69 | `MockData.schoolName` | Institutional header school name | Production Reachable |
| 11 | `lib/screens/admin/school_setup_screen.dart` | 78 | `MockData.campusAddress` | Institutional campus address | Production Reachable |
| 12 | `lib/screens/admin/school_setup_screen.dart` | 98 | `MockData.session` | Active academic session string | Production Reachable |
| 13 | `lib/screens/admin/unified_search_screen.dart` | 44 | `MockData.students.where` | Local student search filtering | Production Reachable |
| 14 | `lib/screens/admin/unified_search_screen.dart` | 53 | `MockData.teachers.where` | Local teacher search filtering | Production Reachable |
| 15 | `lib/screens/admin/unified_search_screen.dart` | 62 | `MockData.classes.where` | Local class search filtering | Production Reachable |
| 16 | `lib/screens/admin/unified_search_screen.dart` | 71 | `MockData.books.where` | Local library book search filtering | Production Reachable |
| 17 | `lib/screens/admin/unified_search_screen.dart` | 80 | `MockData.announcements.where` | Local announcement search filtering | Production Reachable |

## 3. Classification Summary
- **Total Admin/Operations Occurrences**: 17
- **Production Reachable**: 17
- **Test Only**: 0
- **Development Only**: 0
- **Dead / Unreachable Code**: 0

## 4. Affected Screens
1. **Principal Teachers Screen** (`lib/screens/faculty/principal_teachers_screen.dart`): 3 occurrences
2. **Principal Section Detail Screen** (`lib/screens/faculty/principal_section_detail_screen.dart`): 4 occurrences
3. **Faculty Allocation Screen** (`lib/screens/faculty/faculty_allocation_screen.dart`): 1 occurrence
4. **School Setup Screen** (`lib/screens/admin/school_setup_screen.dart`): 4 occurrences
5. **Unified Search Screen** (`lib/screens/admin/unified_search_screen.dart`): 5 occurrences

## 5. Existing Backend APIs Available for Reuse
1. `GET /api/v1/faculty/staff/` (`FacultyApiService.getStaffDirectory()`): Returns live faculty directory.
2. `GET /api/v1/classes/<id>/students/` (`FacultyApiService.getClassStudents(classId)`): Returns live enrolled students for section detail.
3. `GET /api/v1/classes/<id>/summary/` (`FacultyApiService.getClassSummary(classId)`): Returns live class metadata, enrollment counts, class teacher.
4. `GET /api/v1/classes/<id>/timetable/` (`FacultyApiService.getClassTimetable(classId)`): Returns class weekly timetable schedule.
5. `GET /api/v1/students/directory/` (`StudentApiService.getStudents()`): Returns 10,000 live student directory.
6. `GET /api/v1/classes/` / class listing APIs.
7. Centralized `AppConfig`: `schoolName`, `schoolAbbr`, `campusAddress`, `sessionYear`, `affiliation`.

## 6. Missing APIs / Backend Gaps
- Unified Multi-Entity Search (`/api/v1/search/`): Django provides distinct entity endpoints (`/students/directory/`, `/faculty/staff/`, etc.), but does not expose a single unified full-text index endpoint.
  - Mitigation: `UnifiedSearchScreen` will aggregate live API queries across `StudentApiService.getStudents()`, `FacultyApiService.getStaffDirectory()`, and class endpoints, rendering genuine live records and graceful empty states without falling back to `MockData`.

## 7. Batch D Final Target
**Production-Reachable Admin / Operations MockData = 0**
