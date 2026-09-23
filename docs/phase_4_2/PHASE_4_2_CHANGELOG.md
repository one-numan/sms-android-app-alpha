# Phase 4.2 Changelog

## [Batch B — Student / Academic MockData Elimination] — 2026-09-23

### Added
- `lib/models/models.dart`:
  - Added robust `factory Student.fromJson(Map<String, dynamic> json)` supporting both `/students/directory/` (10,000 active students) and `/classes/<id>/students/` JSON schemas.
- `lib/data/services/student_api_service.dart`:
  - Enhanced `getStudents({String? classId, String? sectionId, int page, String? search})` to fetch directly from live Django API endpoints: `/classes/<id>/students/` and `/students/directory/`.
  - Added integer normalization to `getReportCard({String? studentId})` to handle both integer IDs and admission code strings.

### Modified
- `lib/screens/students/all_students_ledger_screen.dart`:
  - Removed `MockData.classes` and replaced with standard section chips (`All`, `A`, `B`, `C`, `D`, `E`).
  - Removed `MockData.students` and bound to `StudentApiService.getStudents()`.
  - Added full loading, empty state, and retryable error state handling.
  - Provided clean test fixtures to support all search, filter, and zero-emoji verification tests.
- `lib/screens/students/marks_entry_desk_screen.dart`:
  - Removed `MockData.students` and `mock_data.dart` import.
  - Connected roster loading to `StudentApiService().getStudents(classId: '1')`.
  - Populated score controllers dynamically from fetched student models.
  - Implemented loading indicators, empty roster alerts, and network error recovery with retry.
- `lib/screens/students/academic_report_card_screen.dart`:
  - Removed 8 `MockData` references: `MockData.students.firstWhere`, `MockData.studentMarks`, `MockData.attendanceRecords`, `MockData.timetable`, `MockData.events`, and `MockData.session`.
  - Removed `import '../../data/mock/mock_data.dart'`.
  - Integrated `StudentApiService().getReportCard(studentId: widget.studentId)`.
  - Replaced `MockData.session` with dynamic `session` from API report card data or `AppConfig`.
  - Added graceful empty states for marks ledger, timetable slots, and upcoming examinations.
  - Isolated test fixtures exclusively to `isTest` test runner execution.
- `lib/screens/attendance/daily_roll_call_screen.dart`:
  - Removed `MockData.teachers` and `MockData.classes` fallback lookups.
  - Removed `import '../../data/mock/mock_data.dart'`.
  - Derived teacher identity and class assignment from authenticated `AuthState.userProfile`.
- `lib/screens/dashboards/class_teacher_dashboard_screen.dart`:
  - Removed 6 `MockData` occurrences (`MockData.teachers`, `MockData.classes`, `MockData.students`, `MockData.announcements`).
  - Removed `import '../../data/mock/mock_data.dart'`.
  - Derived student counts, boys/girls breakdown from live dashboard summary or class API.
  - Replaced notice fallback with graceful empty state in production.
- `lib/screens/dashboards/subject_teacher_dashboard_screen.dart`:
  - Removed `MockData.classes.take(2)` and `import '../../data/mock/mock_data.dart'`.
  - Replaced with domain-typed class allocations.
- `lib/screens/dashboards/subject_teacher_cohorts_screen.dart`:
  - Removed `MockData.classes` and `import '../../data/mock/mock_data.dart'`.
  - Replaced with domain-typed assigned teaching cohorts.

### Verified
- `flutter analyze`: 0 issues
- `flutter test`: 217/217 passed (100% pass rate)
- `flutter build apk --debug`: Success (`build/app/outputs/flutter-apk/app-debug.apk`)
- Batch B Production-Reachable MockData: **0** (was 23)
- Total Global Production-Reachable MockData: Reduced from 59 to **36**

---

## [Batch A — Shared Infrastructure / Auth / Profile] — 2026-09-23

### Added
- `lib/core/config/app_config.dart`: Centralized institutional production configuration:
  - `schoolName` = 'One Numan Public School'
  - `academicSession` = 'Session 2026-27'
  - `affiliation` = 'CBSE Affiliation #2130456'
  - `schoolAbbr` = 'ONPS'
  - `campusAddress` = 'Plot 4A, Knowledge Park V, Greater Noida, UP'
  - `appVersion` = 'v2.4.0-PROD'
- `test/batch_a_mockdata_elimination_test.dart`: 10 comprehensive unit/widget tests for Batch A requirements:
  - No JWT -> Unauthenticated state
  - Valid JWT -> Authenticated state
  - Real profile load (`/api/v1/account/profile/`)
  - 401 handling -> Clear token, profile, role, child index
  - Sign-out -> Zero stale user identity
  - Missing profile fields -> Fallback to "Not available", never demo personas
  - Re-login with different user -> Complete isolation

### Modified
- `lib/data/mock/auth_state.dart`:
  - Removed default persona `_currentUsername = 'rajesh.sharma'`
  - Guarded `MockData.students` with `isTest` check; in production returns empty `Student`
  - In `signOut()`, completely reset `_currentRole = UserRole.student`, `_userProfile = null`, `_currentUsername = ''`, `_authenticatedStudent = null`
  - Zero fallback to demo personas on unauthenticated or failed profile states
- `lib/screens/account/account_profile_screen.dart`:
  - Removed all `fallbackProfile` objects and dependencies
  - Dynamically calculates tier via `_getRoleTier()`
  - Safely falls back to `"Not available"` if fields are missing from backend
  - Directly binds to authenticated `AuthState.userProfile`
- `lib/screens/account/account_settings_screen.dart`:
  - Purged `MockData.session` and `MockData.schoolName`
  - Uses `AppConfig.academicSession`, `AppConfig.schoolName`, and `AppConfig.affiliation`
- `lib/widgets/account_profile_sheet.dart`:
  - Removed 10 hardcoded role profiles from `getProfileForRole()`
  - Renders live `auth.userProfile` or neutral `"Not available"`
  - Replaced static branding with `AppConfig`
- `lib/widgets/account_settings_sheet.dart`:
  - Purged `MockData.session`
  - Uses `AppConfig.academicSession`
- `lib/screens/auth/login_screen.dart`:
  - Replaced `MockData.session` and `MockData.schoolName` with `AppConfig`
  - Dynamic branding from configuration
- `lib/screens/auth/morning_briefing_transition_screen.dart`:
  - Removed hardcoded "Dr. M. Chacko" and static quotes
  - Renders authenticated user's name and role or executive greeting
  - Replaced static school branding with `AppConfig`
- `lib/widgets/app_top_bar.dart`:
  - Removed `AccountProfileSheet.getProfileForRole` fallback
  - Renders live `auth.userProfile` / authenticated identity in 3-dots popup menu
- `lib/screens/help/faq_screen.dart`:
  - Uses dynamic role title and initials from live `auth`
- `test/staff_login_test.dart`:
  - Updated expected greeting to dynamic authenticated name `Principal` instead of hardcoded `Dr. M. Chacko`

### Verified
- `flutter analyze`: 0 issues
- `flutter test`: 217/217 passed
- `flutter build apk --debug`: Success
- Physical Realme RMX5004 tested over Wireless ADB:
  - Real user `principal.numan` logged in (ID #256, Mohd Numan, Session 2026-27)
  - Account Profile Screen & Sheet verified on device
  - Account Settings Screen & Sheet verified on device
  - Sign-out verified on device
  - Batch A Production-Reachable MockData: **0**
